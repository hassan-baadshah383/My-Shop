import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../screens/order_screen.dart';
import '../screens/user_products.dart';
import '../provider/auth.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: 270,
      child: ListView(children: [
        DrawerHeader(
            decoration: const BoxDecoration(
              color: Colors.blue,
            ),
            child: Container(
              alignment: Alignment.center,
              child: const Text(
                'Hi Friend!',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 30,
                ),
              ),
            )),
        ListTile(
          onTap: () {
            Navigator.of(context).pushReplacementNamed('/');
          },
          leading: const Icon(
            Icons.shop,
          ),
          title: const Text('Shop'),
        ),
        const Divider(),
        ListTile(
          onTap: () {
            Navigator.of(context).pushReplacementNamed(OrderScreen.routeName);
          },
          leading: const Icon(
            (Icons.payment),
          ),
          title: const Text('Orders'),
        ),
        const Divider(),
        ListTile(
          onTap: () {
            Navigator.of(context).pushReplacementNamed(UserProducts.routeName);
          },
          leading: const Icon(
            (Icons.edit),
          ),
          title: const Text('Manage Products'),
        ),
        const Divider(),
        ListTile(
          onTap: () {
            Provider.of<Auth>(context, listen: false).logout();
            Navigator.of(context).pop();
            Navigator.of(context).pushReplacementNamed('/');
          },
          leading: const Icon(
            (Icons.exit_to_app),
          ),
          title: const Text('Logout'),
        ),
        const Divider(),
      ]),
    );
  }
}
