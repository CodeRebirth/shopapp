import 'package:flutter/material.dart';
class CartItem{
  final String id;
  final String name;
  final int quantity;
  final double price;
  CartItem({this.id,this.name,this.quantity,this.price});
}

class Cart with ChangeNotifier{
Map<String,CartItem> _items={};

Map<String,CartItem> get items{
return {..._items};
}

int get itemCount{
return _items.length;
}
double get totalAmount{
  var total=0.0;
  _items.forEach((key, cartItem) {
    total += cartItem.price * cartItem.quantity;
   });
  return total;
}
void removeItem(String productId){
  _items.remove(productId);
  notifyListeners();
}
void addItem(String productId,double price,String name){
if (_items.containsKey(productId)){
  _items.update(productId, (value) => CartItem(id:value.id,name:value.name,quantity:value.quantity + 1,price: value.price));
}
else{
  _items.putIfAbsent(
    productId, () => CartItem
    (
    id: DateTime.now().toString(),
    price: price,
    name: name,
    quantity:1
    )
);
}
notifyListeners();
}
void clear(){
  _items={};
  notifyListeners();
}
void removeSingleItem(String productId){
  if(!_items.containsKey(productId)){
    return;
  }
  if(_items[productId].quantity>1){
    _items.update(productId, (value) => CartItem(id: value.id,name:value.name,price:value.price,quantity:value.quantity-1));
    notifyListeners();
  }
  else{
    _items.remove(productId);
    notifyListeners();
  }
}
}