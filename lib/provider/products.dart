import 'package:http/http.dart' as https;
import 'dart:convert';
import 'package:flutter/material.dart';

import '../provider/product.dart';
import '../models/exceptions.dart';

class Products with ChangeNotifier {
  List<Product> _item = [];

  List<Product> get item {
    return [..._item];
  }

  Future<void> fetchData(String userId, [bool filterByUser = false]) async {
    final filterString =
        filterByUser ? 'orderBy="creatorId"&equalTo="$userId"' : '';
    var url = Uri.parse(
        'https://my-shop-8ed5f-default-rtdb.firebaseio.com/products.json?$filterString');
    try {
      final response = await https.get(url);
      final extractedData = json.decode(response.body);
      print("$extractedData extractedData");
      if (extractedData != null && extractedData is Map<String, dynamic>) {
        url = Uri.parse(
            'https://my-shop-8ed5f-default-rtdb.firebaseio.com/userFavourites/$userId.json');
        final favoriteResponse = await https.get(url);
        final favoriteData =
            json.decode(favoriteResponse.body) as Map<String, dynamic>;
        final List<Product> loadedProducts = [];
        extractedData.forEach((prodId, prodData) {
          loadedProducts.add(Product(
            id: prodId,
            title: prodData['title'],
            description: prodData['description'],
            price: prodData['price'],
            isFavourite: favoriteData[prodId]?['isFavourite'] ?? false,
            imageUrl: prodData['imageUrl'],
          ));
        });
        _item = loadedProducts;
        notifyListeners();
      }
      return;
    } catch (error) {
      print(error);
    }
  }

  Future<void> addProduct(Product product, String userId) async {
    const url =
        'https://my-shop-8ed5f-default-rtdb.firebaseio.com/products.json';
    final favUrl =
        'https://my-shop-8ed5f-default-rtdb.firebaseio.com/userFavourites/$userId/${product.id}.json';
    try {
      final responce = await https.post(Uri.parse(url),
          body: json.encode({
            'title': product.title,
            'price': product.price,
            'description': product.description,
            'imageUrl': product.imageUrl,
            'creatorId': userId,
          }));
      print("${responce.body} Responce after adding product");
      await https.post(Uri.parse(favUrl),
          body: json.encode({
            'isFavourite': product.isFavourite,
          }));
      final productItem = Product(
          id: json.decode(responce.body)['name'],
          title: product.title,
          price: product.price,
          description: product.description,
          imageUrl: product.imageUrl,
          isFavourite: product.isFavourite);
      _item.insert(0, productItem);
      notifyListeners();
      await https.post(Uri.parse(favUrl),
          body: json.encode(
            product.isFavourite,
          ));
    } catch (error) {
      throw error;
    }
  }

  Future<void> removeProduct(String id) async {
    final url =
        'https://my-shop-8ed5f-default-rtdb.firebaseio.com/products/$id.json';
    final existingIndex = _item.indexWhere((element) => element.id == id);
    Product existingProduct = _item[existingIndex];
    _item.removeAt(existingIndex);
    notifyListeners();
    final responce = await https.delete(Uri.parse(url));
    if (responce.statusCode >= 400) {
      // _item[existingIndex] = existingProduct;
      _item.insert(existingIndex, existingProduct);
      throw HttpExceptions('Could not delete product');
    }
  }

  Future<void> updateProduct(Product product, String id) async {
    final productIndex = _item.indexWhere((prod) {
      return prod.id == id;
    });
    if (productIndex >= 0) {
      final url =
          'https://my-shop-8ed5f-default-rtdb.firebaseio.com/products/$id.json';
      await https.patch(Uri.parse(url),
          body: json.encode({
            'title': product.title,
            'description': product.description,
            'price': product.price,
            'imageUrl': product.imageUrl,
          }));

      _item[productIndex] = product;
      notifyListeners();
    }
  }

  List<Product> get favItems {
    return item.where((element) => element.isFavourite).toList();
  }

  Product findProduct(String id) {
    return item.firstWhere((element) => element.id == id);
  }
}
