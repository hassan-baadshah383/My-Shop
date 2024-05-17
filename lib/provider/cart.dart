import 'package:flutter/material.dart';

class Cart {
  final DateTime id;
  final String title;
  final double price;
  final int quantity;

  Cart(
      {required this.id,
      required this.title,
      required this.price,
      required this.quantity});
}

class CartN with ChangeNotifier {
  Map<String, Cart> _cartItems = {};

  Map<String, Cart> get cartItems {
    return {..._cartItems};
  }

  void addCartItem(String productId, String title, double price) {
    if (cartItems.containsKey(productId)) {
      _cartItems.update(
          productId,
          (value) => Cart(
              id: value.id,
              title: value.title,
              price: value.price,
              quantity: value.quantity + 1));
    } else {
      _cartItems.putIfAbsent(
          productId,
          () => Cart(
              id: DateTime.now(), title: title, price: price, quantity: 1));
    }
  }

  double get totalSum {
    var amt = 0.0;
    _cartItems.forEach((key, Cart) {
      amt += Cart.quantity * Cart.price;
    });
    return amt;
  }

  void removeSingleItem(String pId) {
    if (!_cartItems.containsKey(pId)) {
      return;
    }
    if (_cartItems[pId]!.quantity > 1) {
      _cartItems.update(
          pId,
          (existingProduct) => Cart(
              id: existingProduct.id,
              title: existingProduct.title,
              price: existingProduct.price,
              quantity: existingProduct.quantity - 1));
    } else {
      _cartItems.remove(pId);
    }
  }

  void removeItem(String id) {
    _cartItems.remove(id);
    notifyListeners();
  }

  void clear() {
    _cartItems = {};
    notifyListeners();
  }
}
