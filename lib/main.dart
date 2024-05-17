import 'package:flutter/material.dart';
import 'package:my_shop/provider/cart.dart';
import 'package:my_shop/provider/product.dart';
import 'package:provider/provider.dart';

import './screens/product_detail_screen.dart';
import './provider/products.dart';
import './screens/order_screen.dart';
import './screens/cart_screen.dart';
import './provider/order.dart';
import './screens/user_products.dart';
import './screens/edit_product_screen.dart';
import './screens/auth_screen.dart';
import './provider/auth.dart';
import './screens/products_overview_screen.dart';
import './screens/splash_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(
              create: ((context) => Product(
                  id: '',
                  description: '',
                  imageUrl: '',
                  price: 0.0,
                  title: ''))),
          ChangeNotifierProvider(
            create: (context) => Auth(),
          ),
          ChangeNotifierProvider(
            create: (context) => Products(),
          ),
          ChangeNotifierProvider(
            create: (context) => CartN(),
          ),
          ChangeNotifierProvider(create: (context) => OrderN()),
        ],
        child: Consumer<Auth>(
          builder: (context, auth, _) => MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              appBarTheme: const AppBarTheme(
                titleTextStyle: TextStyle(color: Colors.white),
                backgroundColor: Colors.blue,
                iconTheme: IconThemeData(
                  color: Colors.white,
                ),
              ),
              elevatedButtonTheme: ElevatedButtonThemeData(
                  style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
              )),
            ),
            title: 'My Shop',
            home: auth.isAuth
                ? ProductOverviewScreen()
                : FutureBuilder(
                    future: auth.autoLogin(),
                    builder: (context, snapshot) =>
                        snapshot.connectionState == ConnectionState.waiting
                            ? SplashScreen()
                            : AuthenticationScreen()),
            routes: {
              ProductDetailScreen.routeName: (context) => ProductDetailScreen(),
              CartScreen.routeName: (context) => CartScreen(),
              OrderScreen.routeName: (context) => OrderScreen(),
              UserProducts.routeName: (context) => UserProducts(),
              EditProductScreen.routeName: (context) => EditProductScreen(),
              ProductOverviewScreen.routeName: (context) =>
                  ProductOverviewScreen(),
            },
          ),
        ));
  }
}
