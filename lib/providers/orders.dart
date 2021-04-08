import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import './cart.dart';
class OrderItem{
 final String id;
 final double amount;
 final List<CartItem> products;
 final DateTime dateTime;
 OrderItem({this.id,this.amount,this.products,this.dateTime});
}

class Orders with ChangeNotifier{

List<OrderItem> _orders=[];
List<OrderItem> get orders{
    return [..._orders];
  }
final String userId;
final String tokenId;
Orders(this.tokenId,this.userId,this._orders);

Future<void> fetchAndSetOrders()async{
final url='https://shopapp-6b58c.firebaseio.com/orders/$userId/.json?auth=$tokenId';
final response = await http.get(url);
final List<OrderItem> loadedOrders=[];
final extractedData = json.decode(response.body) as Map<String,dynamic>;
if (extractedData==null){
return ;
}
extractedData.forEach((key,value){
loadedOrders.add(
  OrderItem(
    id:key,
    amount:value['amount'],
    dateTime:DateTime.parse(value['dateTime']),
    products:(value['products'] as List<dynamic>).map((item)=>CartItem(
      id:item['id'],
      price: item['price'],
      quantity: item['quantity'],
      name: item['name'],
      ))
  .toList()
  )
);
});
_orders = loadedOrders;
notifyListeners();
}

  Future<void> addOrder(List<CartItem> cartProducts,double total) async{
    final url = 'https://shopapp-6b58c.firebaseio.com/orders/$userId.json?auth=$tokenId';
    final timeStamp = DateTime.now();
    print(timeStamp);
    final response = await http.post(url,body: json.encode({
      'amount':total,
      'dateTime':timeStamp.toIso8601String(),
      'products':cartProducts.map((cp)=>{
        'id':cp.id,
        'name':cp.name,
        'price':cp.price,
        'quantity':cp.quantity
      }).toList()
    })
    );
    _orders.insert(
      0,
      OrderItem(
        id: json.decode(response.body)['name'],
        amount:total,
        dateTime:DateTime.now(),
        products:cartProducts
        ));
    notifyListeners();
  }
}