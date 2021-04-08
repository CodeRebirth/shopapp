import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart.dart';
class CartItem extends StatelessWidget {
  final String id;
  final String productId;
  final double price;
  final int quantity;
  final String name;
  CartItem({this.id,this.name,this.price,this.quantity,this.productId});
  @override
  Widget build(BuildContext context) {
    return Dismissible(
        key: UniqueKey(),
        direction: DismissDirection.endToStart,
        onDismissed: (direction){
          Provider.of<Cart>(context,listen: false).removeSingleItem(productId);
        },
        background: Container(
          color: Colors.red,
          child:Icon(Icons.delete,
          color: Colors.white,
          size: 40,
          ),
          alignment: Alignment.centerRight,
          padding: EdgeInsets.only(right:20),
          margin: EdgeInsets.symmetric(horizontal:15,vertical:15),
        ),
        child: Card(
        margin: EdgeInsets.symmetric(horizontal:15,vertical:15),
        child: Padding(
          padding: EdgeInsets.all(10),
          child: ListTile(
            leading: CircleAvatar(
              child:Padding(
                padding: EdgeInsets.all(5),
                child: FittedBox(
                child: Text("\$${price.toStringAsFixed(2)}")),
              ),
              ),
            title: Text(name),
            subtitle: Text('Total: \$${(price*quantity)}'),
            trailing: Text(quantity.toString()),
            ),
          ),
        ),
        confirmDismiss:(direction){
          return showDialog(context: context,builder: (_)=>AlertDialog(
            title:Text("Are you sure?"),
            content: Text("Do you want to remove?"),
            actions: <Widget>[
            FlatButton(child:Text("No") ,onPressed: (){
              Navigator.of(_).pop(false);
            },),
            FlatButton(child:Text("Yes"),onPressed:(){
              Navigator.of(_).pop(true);
            })
          ],
          ));
        }
    );
  }
}