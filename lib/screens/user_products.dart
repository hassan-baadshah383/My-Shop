import 'package:flutter/material.dart';
import 'package:my_shop/provider/auth.dart';
import 'package:provider/provider.dart';

import '../provider/products.dart';
import '../widgets/user_products_item.dart';
import '../widgets/drawer.dart';
import '../screens/edit_product_screen.dart';

class UserProducts extends StatelessWidget {
  static const routeName = '/userProducts';

  Future<void> _refreshProducts(BuildContext context) async {
    final authtData = Provider.of<Auth>(context, listen: false);
    print("${authtData.userId} USER ID");
    //final prodData = Provider.of<Product>(context, listen: false);
    if (authtData.userId != null) {
      await Provider.of<Products>(context, listen: false)
          .fetchData(authtData.userId!, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    //final productData = Provider.of<Products>(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Your Products'), actions: [
        IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed(EditProductScreen.routeName);
            },
            icon: const Icon(Icons.add))
      ]),
      drawer: AppDrawer(),
      body: FutureBuilder(
        future: _refreshProducts(context),
        builder: (context, snapshot) => snapshot.connectionState ==
                ConnectionState.waiting
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : RefreshIndicator(
                backgroundColor: Colors.purple,
                onRefresh: () => _refreshProducts(context),
                child: Consumer<Products>(builder: ((context, productData, _) {
                  if (productData.item.isEmpty) {
                    return const Center(
                      child: Text('No any product. Add some!'),
                    );
                  } else {
                    return ListView.builder(
                      itemBuilder: ((context, index) {
                        return Column(
                          children: [
                            UserProductsItem(
                              productData.item[index].id,
                              productData.item[index].title,
                              productData.item[index].imageUrl,
                            ),
                            const Divider(),
                          ],
                        );
                      }),
                      itemCount: productData.item.length,
                    );
                  }
                })),
              ),
      ),
    );
  }
}
