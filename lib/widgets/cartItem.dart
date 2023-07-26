import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../provider/cart.dart';

class CartItem extends StatelessWidget {
  final DateTime id;
  final String productId;
  final String title;
  final int quantity;
  final double price;

  CartItem(this.id, this.productId, this.title, this.quantity, this.price);
  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(id),
      background: Container(
        color: Colors.red,
        alignment: Alignment.centerRight,
        child: const Icon(
          Icons.delete,
          color: Colors.white,
          size: 40,
        ),
      ),
      direction: DismissDirection.endToStart,
      confirmDismiss: (direction) {
        return showDialog(
            context: context,
            builder: ((context) {
              return AlertDialog(
                title: const Text('Are you sure?'),
                content: const Text('Do you want to remove this from cart?'),
                actions: [
                  TextButton(
                      onPressed: (() {
                        Navigator.of(context).pop(false);
                      }),
                      child: const Text('No')),
                  TextButton(
                      onPressed: (() {
                        Navigator.of(context).pop(true);
                      }),
                      child: const Text('Yes'))
                ],
              );
            }));
      },
      onDismissed: (direction) =>
          Provider.of<CartN>(context, listen: false).removeItem(productId),
      child: Container(
        margin: const EdgeInsets.all(7),
        child: Card(
          elevation: 3,
          child: Container(
            margin: const EdgeInsets.only(bottom: 7),
            width: double.infinity,
            height: 60,
            child: ListTile(
              leading: CircleAvatar(
                radius: 25,
                backgroundColor: Colors.purple,
                child: Padding(
                  padding: const EdgeInsets.all(5),
                  child: FittedBox(
                    child: Text(
                      '\$$price'.toString(),
                    ),
                  ),
                ),
              ),
              title: Text(title),
              subtitle: Text(
                DateFormat.yMMMd().format(id),
                style: const TextStyle(color: Colors.grey),
              ),
              trailing: Text('$quantity x'),
            ),
          ),
        ),
      ),
    );
  }
}
