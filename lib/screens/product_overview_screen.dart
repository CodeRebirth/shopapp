import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/product_grid.dart';
import '../providers/cart.dart';
import '../widgets/badge.dart';
import '../screens/cart_screen.dart';
import '../widgets/app_drawer.dart';
import '../providers/products.dart';
enum FilterOptions{
  Favorite,
  All
}
class ProductScreenOverview extends StatefulWidget {
  @override
  _ProductScreenOverviewState createState() => _ProductScreenOverviewState();
}

class _ProductScreenOverviewState extends State<ProductScreenOverview> {
  var _showOnlyFavorites = false;
  var _isInit = true;
  var _isLoading = true;
  @override
  void initState(){
    super.initState();
  }
  @override
  void didChangeDependencies() {
    if(_isInit){
      Provider.of<Products>(context).fetchAndSetProduct().then((_){
        setState(() {
          _isLoading = false;
        });
      });
    }
    _isInit = false;
    super.didChangeDependencies();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: AppDrawer(),
      appBar: AppBar(
      title:Text("Product Screen"),
      actions: <Widget>[
      PopupMenuButton(
        onSelected: (FilterOptions selectedValue){
          setState(() {
            if(selectedValue == FilterOptions.Favorite){
            _showOnlyFavorites = true;
          }
          else{
            _showOnlyFavorites = false;
          }
          });
        },
        icon: Icon(Icons.more_vert),
        itemBuilder: (_)=>[
          PopupMenuItem(child: Text("Only Favorite"),value: FilterOptions.Favorite,),
          PopupMenuItem(child: Text("All"),value: FilterOptions.All,),
        ]
        ),
        Consumer<Cart>(builder:(_,cartData,_two)=>Badge(
            child:_two,
            value: cartData.itemCount.toString(),
            ),
            child:IconButton(icon: Icon(Icons.shopping_cart), onPressed: (){
              Navigator.of(context).pushNamed(CartScreen.routeName);
            })
        ) 
      ],
      ),
      body:_isLoading?Center(child: CircularProgressIndicator(valueColor: new AlwaysStoppedAnimation<Color>(Colors.blue),)):ProductGrid(_showOnlyFavorites), 
      );
  }
}
