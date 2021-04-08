import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopapp/screens/auth_screen.dart';
import './screens/product_overview_screen.dart';
import './screens/product_detail_screen.dart';
import './screens/auth_screen.dart';
import './providers/products.dart';
import './providers/cart.dart';
import './providers/orders.dart';
import './providers/auth.dart';
import './screens/cart_screen.dart';
import './screens/order_screen.dart';
import './screens/user_products_screen.dart';
import './screens/edit_product.dart';
void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(providers: [
      ChangeNotifierProvider(
        create:(ctx)=>Auth(),
        ),
      ChangeNotifierProxyProvider<Auth,Products>
      (
        create:(ctx)=>Products(null,null,[]),
        update:(ctx,auth,prevproducts)=>Products(auth.token,auth.userId,prevproducts==null?[]:prevproducts.items),
      ),
      ChangeNotifierProvider(
        create: (ctx)=>Cart(),
      ),
      ChangeNotifierProxyProvider<Auth,Orders>(
        create: (ctx)=>Orders(null,null,[]),
        update:(ctx,auth,prevOrders)=>Orders(auth.token,auth.userId,prevOrders==null?[]:prevOrders.orders),
      )
    ],
        child: Consumer<Auth>(builder: (ctx, auth,_)=>MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'MyShop',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          accentColor: Colors.deepOrange,
        ),
        home: auth.isAuth?ProductScreenOverview():AuthScreen(),
        routes: {
        ProductDetailScreen.routeName:(ctx)=>ProductDetailScreen(),
        CartScreen.routeName:(ctx)=>CartScreen(),
        OrderScreen.routeName:(ctx)=>OrderScreen(),
        UserProductsScreen.routeName:(ctx)=>UserProductsScreen(),
        EditProductScreen.routeName:(ctx)=>EditProductScreen(),
        },
      ))
    );
  }
}