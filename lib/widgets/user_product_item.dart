import 'package:flutter/material.dart';
import '../screens/edit_product.dart';
import '../providers/products.dart';
import 'package:provider/provider.dart';

class UserProductItem extends StatelessWidget {
  final String id;
  final String title;
  final String imgUrl;
  UserProductItem({this.id,this.title,this.imgUrl});
  @override
  Widget build(BuildContext context) {
    final scaffold = Scaffold.of(context);
    return ListTile(
        title: Text(title),
        leading: CircleAvatar(backgroundImage: NetworkImage(imgUrl),),
        trailing: Container(
            width: 100,
            child: Row(children: <Widget>[
            IconButton(icon: Icon(Icons.edit),onPressed: (){
              Navigator.of(context).pushNamed(EditProductScreen.routeName,arguments: id);
            },color: Colors.blue,),
            IconButton(icon: Icon(Icons.delete),onPressed: ()async{
              try{
                await Provider.of<Products>(context,listen: false).removeProduct(id);
              }catch(error){
                scaffold.showSnackBar(SnackBar(content: Text("Delete fail"),));
              }
            },color:Colors.blue),
          ],),
        ),
    );
  }
}