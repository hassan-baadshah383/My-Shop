import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/order.dart';
import '../widgets/orderItem.dart';
import '../widgets/drawer.dart';
import '../provider/auth.dart';

class OrderScreen extends StatefulWidget {
  static const routeName = '/orderScreen';

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  bool _isLoading = false;

  @override
  void initState() {
    setState(() {
      _isLoading = true;
    });
    final Auth authData = Provider.of<Auth>(context, listen: false);
    Provider.of<OrderN>(context, listen: false)
        .fetchData(authData.userId!)
        .then((_) {
      setState(() {
        _isLoading = false;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final orderData = Provider.of<OrderN>(context);
    return Scaffold(
        appBar: AppBar(
          title: const Text('Orders'),
        ),
        drawer: AppDrawer(),
        body: _isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : orderData.orderList.isEmpty
                ? const Center(
                    child: Text('No any order yet!'),
                  )
                : ListView.builder(
                    itemBuilder: ((context, index) {
                      return OrderItem(orderData.orderList[index]);
                    }),
                    itemCount: orderData.orderList.length,
                  ));
  }
}
