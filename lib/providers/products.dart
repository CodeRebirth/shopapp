import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/http_exception.dart';
import  './product.dart';

class Products with ChangeNotifier{
  final String tokenId;
  final String userId;
  List<Product> _items =[
    // Product(
    //   id: 'p1',
    //   name: 'Red Shirt',
    //   description: 'A red shirt - it is pretty red!',
    //   price: 29.99,
    //   imgUrl:
    //       'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    // ),
    // Product(
    //   id: 'p2',
    //   name: 'Trousers',
    //   description: 'A nice pair of trousers.',
    //   price: 59.99,
    //   imgUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    // ),
    // Product(
    //   id: 'p3',
    //   name: 'Yellow Scarf',
    //   description: 'Warm and cozy - exactly what you need for the winter.',
    //   price: 19.99,
    //   imgUrl:
    //       'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    // ),
    // Product(
    //   id: 'p4',
    //   name: 'A Pan',
    //   description: 'Prepare any meal you want.',
    //   price: 49.99,
    //   imgUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    // ),
  ];

  String get id{
    return userId;
  }

  Products(this.tokenId,this.userId,this._items);

  List<Product> get items{
    return [..._items];
  }
  List<Product> get favoriteItems{
    return _items.where((element) => element.isFav).toList();
  }
  
  Future<void> fetchAndSetProduct([bool filterByUser = false]) async{
  final filterString = filterByUser ? 'orderBy="userId"&equalTo="$userId"':'';
  var url = 'https://shopapp-6b58c.firebaseio.com/products.json?auth=$tokenId&$filterString';
  try{
    final response = await http.get(url); 
    final extracted = json.decode(response.body) as Map<String, dynamic>;
    if(extracted==null){
      return null;
    }
    final urlFav = 'https://shopapp-6b58c.firebaseio.com/userFavorites/$userId.json?auth=$tokenId';
    final favoriteRes = await http.get(urlFav);
    final favBody = json.decode(favoriteRes.body);
    final List<Product> loadedProducts = [];
    extracted.forEach((key, value) {
      loadedProducts.add(
        Product(
          id: key,
          name:value['name'],
          description: value['description'],
          price: value['price'],
          imgUrl: value['imgUrl'],
          isFav: favBody==null?false:favBody[key]??false
        )
      );
    });
    _items = loadedProducts;
    notifyListeners();
  }catch(error){
    throw(error);
  }
  }

  Future<void> addProduct(Product product) async {
    final url = 'https://shopapp-6b58c.firebaseio.com/products.json?auth=$tokenId';
    try{
      final response = await http.post(url,body: json.encode({
      'name':product.name,
      'price':product.price,
      'description':product.description,
      'imgUrl':product.imgUrl,
      'userId':userId,
    }
    ));
      final newProduct = Product(
      name:product.name,
      price:product.price,
      description:product.description,
      imgUrl: product.imgUrl,
      id: json.decode(response.body)['name']);
      _items.add(newProduct);
      notifyListeners();
    }catch(error){
      throw error;
    }
  }
  Future<void> updateProduct(String id,Product newProduct)async{
    final url = 'https://shopapp-6b58c.firebaseio.com/products/$id.json?auth=$tokenId';
    final prodIndex =_items.indexWhere((element) => element.id == id);
    if(prodIndex>=0){
      await http.patch(url,body:json.encode({
        'name':newProduct.name,
        'description':newProduct.description,
        'imgUrl':newProduct.imgUrl,
        'price':newProduct.price
      }));
     _items[prodIndex]=newProduct;
    notifyListeners();
    }
    else{
      print('...');
    }
    }
  Future<void> removeProduct(String id)async{
      final url = 'https://shopapp-6b58c.firebaseio.com/products/$id.json?auth=$tokenId';
      final existingProductIndex =  _items.indexWhere((element) => element.id==id);
      var existingProduct = _items[existingProductIndex];
      _items.removeAt(existingProductIndex);
      notifyListeners();
      final response=await http.delete(url);
        if(response.statusCode>=400){
        _items.insert(existingProductIndex,existingProduct);
        notifyListeners();
        throw HttpException("Error could not delete product");
        }
        existingProduct=null;
    }

  Product findById(String id){
    return _items.firstWhere((element) => element.id==id);
  }
}