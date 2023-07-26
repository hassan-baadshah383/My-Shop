import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/cart.dart';
import '../widgets/cartItem.dart';
import '../provider/order.dart';
import '../provider/auth.dart';

class CartScreen extends StatefulWidget {
  static const routeName = '/cartScreen';

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  bool _isloading = false;

  @override
  Widget build(BuildContext context) {
    final cartData = Provider.of<CartN>(context);
    final orderData = Provider.of<OrderN>(context);
    final authData = Provider.of<Auth>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cart Items'),
      ),
      body: Column(children: [
        Card(
          elevation: 5,
          margin: const EdgeInsets.all(10),
          child: Container(
              padding: const EdgeInsets.all(10),
              width: double.infinity,
              height: 60,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Total',
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                  const Spacer(),
                  Chip(
                    label: Text(
                      '\$ ${cartData.totalSum.toStringAsFixed(2)}',
                      style: const TextStyle(color: Colors.white),
                    ),
                    backgroundColor: Colors.purple,
                  ),
                  TextButton(
                    onPressed: (cartData.totalSum <= 0 || _isloading)
                        ? null
                        : () async {
                            setState(() {
                              _isloading = true;
                            });
                            await orderData.addOrder(
                                cartData.cartItems.values.toList(),
                                cartData.totalSum,
                                authData.userId);
                            setState(() {
                              _isloading = false;
                            });
                            cartData.clear();
                          },
                    child: _isloading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator())
                        : const Text(
                            'Order now',
                            style: TextStyle(color: Colors.orange),
                          ),
                  )
                ],
              )),
        ),
        const SizedBox(
          height: 25,
        ),
        Expanded(
            child: ListView.builder(
          itemCount: cartData.cartItems.length,
          itemBuilder: ((context, index) => CartItem(
                cartData.cartItems.values.toList()[index].id,
                cartData.cartItems.keys.toList()[index],
                cartData.cartItems.values.toList()[index].title,
                cartData.cartItems.values.toList()[index].quantity,
                cartData.cartItems.values.toList()[index].price,
              )),
        ))
      ]),
    );
  }
}
