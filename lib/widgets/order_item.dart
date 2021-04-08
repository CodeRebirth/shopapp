import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../providers/orders.dart' as ord;
import 'dart:math';

class OrderItem extends StatefulWidget {
  final ord.OrderItem order;
  OrderItem(this.order);
  @override
  _OrderItemState createState() => _OrderItemState();
}

class _OrderItemState extends State<OrderItem> {
  var _expanded = false;
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(10),
      child: Column(
        children: <Widget>[
          ListTile(
            title: Text("\$${widget.order.amount}",),
            subtitle: Text(DateFormat.yMd().format(widget.order.dateTime)),
            trailing: IconButton(icon:Icon(_expanded?Icons.expand_less:Icons.expand_more),onPressed: (){
              setState(() {
                _expanded = !_expanded;
              });
            },),
          ),
          if(_expanded) Container(
            height:min(widget.order.products.length * 20.0+20,160),
            child: ListView.builder(itemBuilder: (ctx,i)=>Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround, 
            children: <Widget>[
            Text(widget.order.products[i].name,style: TextStyle(fontWeight: FontWeight.bold,color: Colors.green),),
            Text(widget.order.products[i].quantity.toString())],),
            itemCount:widget.order.products.length),
            )
        ],
      ),
    );
  }
}