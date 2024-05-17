import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

import '../provider/products.dart';
import '../widgets/product_item.dart';

class ProductGrid extends StatelessWidget {
  final bool isFav;

  ProductGrid(this.isFav);

  @override
  Widget build(BuildContext context) {
    final productData = Provider.of<Products>(context, listen: false);
    final products = isFav ? productData.favItems : productData.item;
    // if (products.isEmpty) {
    //   return const Center(
    //     child: Text('No any item yet. Add some!'),
    //   );
    // } else {
    return GridView.builder(
      itemCount: products.length,
      itemBuilder: (context, index) => ChangeNotifierProvider.value(
        value: products[index],
        child: Product_Item(
            //   products[index].id,
            //   products[index].title,
            //   products[index].price,
            //   products[index].imageUrl,
            ),
      ),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 4 / 3,
          crossAxisSpacing: 5,
          mainAxisSpacing: 10),
    );
  }
}
// }