import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as https;

import '../provider/cart.dart';

class Order {
  final String id;
  final double price;
  final List<Cart> products;
  final DateTime date;

  Order(
      {required this.id,
      required this.price,
      required this.products,
      required this.date});
}

class OrderN with ChangeNotifier {
  List<Order> _orderList = [];

  List<Order> get orderList {
    return [..._orderList];
  }

  Future<void> fetchData(String userId) async {
    final url =
        'https://my-shop-8ed5f-default-rtdb.firebaseio.com/orders/$userId.json';
    final responce = await https.get(Uri.parse(url));
    final extractedData = json.decode(responce.body);
    final List<Order> loadedOrders = [];
    if (extractedData != null && extractedData is Map<String, dynamic>) {
      extractedData.forEach((orderId, orderData) {
        loadedOrders.add(Order(
            id: orderId,
            date: DateTime.parse(orderData['date']),
            price: orderData['price'],
            products: (orderData['cartItems'] as List<dynamic>)
                .map((items) => Cart(
                      id: items['id'],
                      price: items['price'],
                      quantity: items['quantity'],
                      title: items['title'],
                    ))
                .toList()));
      });
      _orderList = loadedOrders.reversed.toList();
      notifyListeners();
    }
    return;
  }

  Future<void> addOrder(
      List<Cart> cartItems, double total, String userId) async {
    final url =
        'https://my-shop-8ed5f-default-rtdb.firebaseio.com/orders/$userId.json';
    final date = DateTime.now();
    final responce = await https.post(Uri.parse(url),
        body: json.encode({
          'price': total,
          'date': date.toIso8601String(),
          'cartItems': cartItems
              .map(
                (item) => {
                  'title': item.title,
                  'price': item.price,
                  'quantity': item.quantity,
                },
              )
              .toList()
        }));
    _orderList.insert(
        0,
        Order(
            id: json.decode(responce.body)['name'],
            price: total,
            products: cartItems,
            date: DateTime.now()));
    notifyListeners();
  }
}
