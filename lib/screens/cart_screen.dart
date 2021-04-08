import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart.dart';
import '../widgets/cart_item.dart' as ci;
import '../providers/orders.dart';
import '../screens/order_screen.dart';
class CartScreen extends StatefulWidget {
  static const routeName = '/cart-screen';

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  var isLoading = false;
  @override
  Widget build(BuildContext context) {
    final cart=Provider.of<Cart>(context);
    return Scaffold(
      appBar: AppBar(title:Text("Cart items")),
      body: Column(
        children: <Widget>[
          Card(
            margin:EdgeInsets.all(10),
            child: Padding(
              padding: EdgeInsets.all(8),
              child:Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                  "Total",
                  style: TextStyle(fontSize: 20,fontWeight:FontWeight.bold),
                  ),
                  Spacer(),
                  Chip(
                    label: Text("\$${cart.totalAmount.toStringAsFixed(2)}"),
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
                  SizedBox(width: 5,),
                  FlatButton(
                    child: isLoading?CircularProgressIndicator():Text("Place Order",style:TextStyle(fontWeight: FontWeight.bold,color: Colors.green)),
                    onPressed: (cart.totalAmount<=0 || isLoading)?null:()async{
                    setState(() {
                      isLoading = true;
                    });
                    await Provider.of<Orders>(context,listen: false).addOrder(
                      cart.items.values.toList(),
                      cart.totalAmount
                      );
                    setState(() {
                      isLoading = false;
                    });
                    Navigator.of(context).pushReplacementNamed(OrderScreen.routeName);
                    cart.clear();                    
                    },               
                    )
                ],
              )
            ),
          ),
          SizedBox(height: 10,),
          Expanded(child: ListView.builder(
            itemBuilder: (ctx,i)=>ci.CartItem(id:cart.items.values.toList()[i].id,
            productId: cart.items.keys.toList()[i],
            name:cart.items.values.toList()[i].name,
            price:cart.items.values.toList()[i].price,
            quantity:cart.items.values.toList()[i].quantity
            ),
            itemCount:cart.items.length
            ))
        ],
      ),
    );
  }
}