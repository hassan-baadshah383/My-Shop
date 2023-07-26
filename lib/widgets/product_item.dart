import 'package:my_shop/provider/auth.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

import '../screens/product_detail_screen.dart';
import '../provider/product.dart';
import '../provider/cart.dart';

class Product_Item extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final authData = Provider.of<Auth>(context);
    final product = Provider.of<Product>(context);
    final cartData = Provider.of<CartN>(context);
    return ClipRRect(
      borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(10), bottomRight: Radius.circular(10)),
      child: GestureDetector(
        onTap: () {
          Navigator.of(context)
              .pushNamed(ProductDetailScreen.routeName, arguments: {
            'id': product.id,
            'description': product.description,
            'price': product.price,
            'image': product.imageUrl,
            'title': product.title
          });
        },
        child: GridTile(
            footer: GridTileBar(
              backgroundColor: Colors.black45,
              leading: Consumer<Product>(
                builder: (context, product, _) => IconButton(
                  //color: Colors.red,
                  icon: Icon(product.isFavourite
                      ? Icons.favorite
                      : Icons.favorite_border),
                  onPressed: () {
                    product.toggle(authData.userId, product.id);
                  },
                ),
              ),
              title: Text(
                product.title,
                style: const TextStyle(fontSize: 12),
                textAlign: TextAlign.center,
              ),
              trailing: IconButton(
                //color: Colors.red,
                icon: const Icon(Icons.shopping_cart),
                onPressed: () {
                  cartData.addCartItem(
                      product.id, product.title, product.price);
                  ScaffoldMessenger.of(context).hideCurrentSnackBar();
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: const Text('Added item to cart!'),
                    action: SnackBarAction(
                        label: 'UNDO',
                        onPressed: (() =>
                            cartData.removeSingleItem(product.id))),
                  ));
                },
              ),
            ),
            child: Hero(
              tag: product.id,
              child: FadeInImage(
                placeholder: const AssetImage(
                    'assets/images/285 product-placeholder.png'),
                image: NetworkImage(product.imageUrl),
                fit: BoxFit.cover,
                placeholderFit: BoxFit.cover,
              ),
            )),
      ),
    );
  }
}
