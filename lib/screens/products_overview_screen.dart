import 'package:flutter/material.dart';
import 'package:my_shop/provider/auth.dart';
import 'package:provider/provider.dart';
import '../screens/cart_screen.dart';
import '../widgets/products_grid.dart';
import '../provider/products.dart';
import '../widgets/drawer.dart';

class ProductOverviewScreen extends StatefulWidget {
  static const routeName = '/productOverviewScreen';
  @override
  State<ProductOverviewScreen> createState() => _ProductOverviewScreenState();
}

enum MenuButtons {
  favourites,
  allItems,
}

class _ProductOverviewScreenState extends State<ProductOverviewScreen> {
  bool _isLoading = false;
  var _isInit = true;
  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      final authData = Provider.of<Auth>(context, listen: false);
      Provider.of<Products>(context).fetchData(authData.userId).then((_) {
        _isLoading = false;
      });
      super.didChangeDependencies();
    }
    _isInit = false;
  }

  bool isFav = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Shop'),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () {
              Navigator.of(context).pushNamed(CartScreen.routeName);
            },
          ),
          PopupMenuButton(
            onSelected: (MenuButtons filters) {
              setState(() {
                if (filters == MenuButtons.favourites) {
                  isFav = true;
                } else {
                  isFav = false;
                }
              });
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                  value: MenuButtons.favourites, child: Text('My Favourites')),
              const PopupMenuItem(
                  value: MenuButtons.allItems, child: Text('All Items')),
            ],
          ),
        ],
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : ProductGrid(isFav),
      drawer: AppDrawer(),
    );
  }
}
