import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../provider/order.dart';

class OrderItem extends StatefulWidget {
  final Order products;

  OrderItem(this.products);

  @override
  State<OrderItem> createState() => _OrderItemState();
}

class _OrderItemState extends State<OrderItem> {
  bool expanded = false;
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(left: 10, right: 10, top: 10),
      elevation: 5,
      child: Column(
        children: [
          ListTile(
              title: Text(
                '\$${widget.products.price.toString()}',
              ),
              subtitle: Text(
                DateFormat.yMMMMd().format(widget.products.date),
                style: const TextStyle(color: Colors.grey),
              ),
              trailing: IconButton(
                  onPressed: (() {
                    setState(() {
                      expanded = !expanded;
                    });
                  }),
                  icon:
                      Icon(expanded ? Icons.expand_less : Icons.expand_more))),
          AnimatedContainer(
            duration: const Duration(milliseconds: 400),
            curve: Curves.easeIn,
            margin: const EdgeInsets.all(10),
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 4),
            height:
                expanded ? min(widget.products.products.length * 30.0, 100) : 0,
            child: ListView(
              children: widget.products.products.map((prod) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      prod.title,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    Text(
                      '${prod.quantity} x ${prod.price}',
                      style: const TextStyle(fontSize: 14, color: Colors.grey),
                    )
                  ],
                );
              }).toList(),
            ),
          )
        ],
      ),
    );
  }
}
