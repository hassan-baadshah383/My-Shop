import 'package:flutter/material.dart';

class ProductDetailScreen extends StatelessWidget {
  static const routeName = '/detailScreen';

  @override
  Widget build(BuildContext context) {
    final routeArgs =
        ModalRoute.of(context)!.settings.arguments as Map<String, Object>;
    final routeId = routeArgs['id'];
    final routeDescription = routeArgs['description'];
    final routeImage = routeArgs['image'];
    final routePrice = routeArgs['price'];
    final routeTitle = routeArgs['title'];
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: Colors.blue,
            expandedHeight: 300,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                routeTitle as String,
                style: const TextStyle(color: Colors.white),
              ),
              background: Hero(
                  tag: routeId!,
                  child:
                      Image.network(routeImage.toString(), fit: BoxFit.cover)),
            ),
          ),
          SliverList(
              delegate: SliverChildListDelegate([
            const SizedBox(
              height: 25,
            ),
            Text(
              '\$${routePrice.toString()}',
              style: const TextStyle(fontSize: 22, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: 10,
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Text(
                routeDescription.toString(),
                style: const TextStyle(fontSize: 14),
                textAlign: TextAlign.center,
                softWrap: true,
              ),
            ),
            const SizedBox(
              height: 1000,
            )
          ]))
        ],
      ),
    );
  }
}
