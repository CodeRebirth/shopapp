import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
class Product with ChangeNotifier
{
  final String id;
  final String name;
  final String description;
  final double price;
  final String imgUrl;
  bool isFav;
  Product({this.id, this.name, this.description, this.price, this.imgUrl,this.isFav=false});
  void _setFav(bool newValue){
    isFav = newValue;
  }
  Future<void> isFavToggle(String tokenId, String userId)async{
    final url='https://shopapp-6b58c.firebaseio.com/userFavorites/$userId/$id.json?auth=$tokenId';
    final oldStatus = isFav;
    isFav = !isFav;
    notifyListeners();
    try{
    final response = await http.put(url,
    body: json.encode(isFav)
    );
    if(response.statusCode >= 400){
      _setFav(oldStatus);
      notifyListeners();
    }
    }catch(error){
      _setFav(oldStatus);
      notifyListeners();
    }
  }
}