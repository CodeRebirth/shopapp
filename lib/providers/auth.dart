import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import '../models/http_exception.dart';
import 'dart:convert';
class Auth with ChangeNotifier{
  String _token;
  DateTime _expiryDate;
  String _userId;

  bool get isAuth{
    return token != null;
  }
  String get token{
    if(_expiryDate!=null && _expiryDate.isAfter(DateTime.now())&& _token!=null ){
      return _token;
    }
    return null;
  }
  String get userId{
    return _userId;
  }
  Future<void> _authenticate(String email,String password,String urlI)async{
    final url = "https://identitytoolkit.googleapis.com/v1/accounts:$urlI?key=AIzaSyATXWkxLaMCOj_eyy2WSUU9gPTcF17e5mg";
    try{
      final response = await http.post(url,body:json.encode({
        'email': email,
        'password': password,
        'returnSecureToken':true
      })
      );
      final responseBody = json.decode(response.body);
      if(responseBody['error']!=null){
        throw HttpException(responseBody['error']['message']);
      }
      _token = responseBody['idToken'];
      _expiryDate=DateTime.now().add(Duration(
        seconds: int.parse(
         responseBody['expiresIn'], 
        )
       )
      );
      _userId = responseBody['localId'];
      notifyListeners();
    }catch(error){
      throw(error);
    }
  }
  Future<void> signup(String email, String password)async{
  return _authenticate(email, password,"signUp");
  }
  
  Future<void> login(String email,String password) async{
   return _authenticate(email, password,"signInWithPassword");
}
  void logout (){
    _token = null;
    _expiryDate = null;
    _userId = null;
    notifyListeners();
  }
}