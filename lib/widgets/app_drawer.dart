import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../screens/order_screen.dart';
import '../screens/user_products_screen.dart';
import '../providers/auth.dart';
class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {    
    return Drawer(
      child: Column(
        children: <Widget>[
       AppBar(title:Text("Hello"),automaticallyImplyLeading: false,),
       Divider(),
       ListTile(
        leading: Icon(Icons.shop),
        title:Text("Categories"),
        onTap: (){
          Navigator.of(context).pushReplacementNamed('/');
        },
       ),
       ListTile(
        leading: Icon(Icons.payment),
        title:Text("Orders"),
        onTap: (){
          Navigator.of(context).pushReplacementNamed(OrderScreen.routeName);
        },
       ),
       ListTile(
        leading: Icon(Icons.edit),
        title:Text("Manage"),
        onTap: (){
          Navigator.of(context).pushReplacementNamed(UserProductsScreen.routeName);
        },
       ),
       ListTile(
        leading: Icon(Icons.exit_to_app),
        title:Text("Logout"),
        onTap: (){
          Navigator.pushNamedAndRemoveUntil(context,'/', (route) => false);
          Provider.of<Auth>(context,listen: false).logout();
        },
       )
        ],
      ),
    );
  }
}