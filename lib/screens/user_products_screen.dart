import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/products.dart';
import '../widgets/user_product_item.dart';
import '../widgets/app_drawer.dart';
import './edit_product.dart';
class UserProductsScreen extends StatefulWidget {
  static const routeName = '/user-products-screen';

  @override
  _UserProductsScreenState createState() => _UserProductsScreenState();
}

class _UserProductsScreenState extends State<UserProductsScreen> {
  var _isInit = true;
  var _isLoading = true;
  @override
  void initState() {
    super.initState();
  }
  @override
  void didChangeDependencies(){
    if(_isInit){
     Provider.of<Products>(context,listen: false).fetchAndSetProduct(true).then((_){
        setState(() {
       _isLoading = false;
     });
     });
    } 
    _isInit = false;
    super.didChangeDependencies();
  }

  Future<void> _onRefresh(BuildContext context)async{
      await Provider.of<Products>(context,listen: false).fetchAndSetProduct(true);
  }

  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<Products>(context);
    return Scaffold(
      drawer: AppDrawer(),
      appBar: AppBar(title: Text("User Products"),
      actions: <Widget>[
        IconButton(icon: Icon(Icons.add),onPressed: (){
          Navigator.of(context).pushNamed(EditProductScreen.routeName);
        },)
      ],
      ),
      body: _isLoading?Center(child: CircularProgressIndicator(valueColor: new AlwaysStoppedAnimation<Color>(Colors.blue),)) :RefreshIndicator(
        onRefresh: ()=>_onRefresh(context),
        child: Padding(padding: EdgeInsets.all(10),
        child:ListView.builder(itemBuilder: (ctx,i)=>UserProductItem(
          id:productsData.items[i].id,
          title:productsData.items[i].name, 
          imgUrl:productsData.items[i].imgUrl),
          itemCount: productsData.items.length,
          )
        ),
      ),
    );
  }
}