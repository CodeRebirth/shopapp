import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../screens/product_detail_screen.dart';
import '../providers/product.dart';
import '../providers/cart.dart';
import '../providers/auth.dart';
class ProductItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Product>(context,listen: false);
    final productCart = Provider.of<Cart>(context,listen:false);
    final authData = Provider.of<Auth>(context,listen:false);
    return ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: GestureDetector(
          onTap: (){
            Navigator.of(context).pushNamed(ProductDetailScreen.routeName,arguments: product.id);
          },
          child: GridTile(
          child: Hero(
            tag: product.id,
            child: FadeInImage(
            fit: BoxFit.cover,
            placeholder: AssetImage('assets/images/product-placeholder.png'),
            image:NetworkImage(product.imgUrl)
            ),
          ),
          footer: GridTileBar(
            backgroundColor: Colors.black54,
            leading:Consumer<Product>(
               builder:(ctx,product,child)=>IconButton( 
              icon: Icon(product.isFav?Icons.favorite:Icons.favorite_border ,color: Colors.red[800]), 
              onPressed: (){
                if(product.isFav!=true){
                  product.isFavToggle(authData.token,authData.userId);
                  Scaffold.of(context).showSnackBar(
                   SnackBar(content:Text("Added to favorite"),duration: Duration(seconds: 0),)
                   );
                }
                else{
                  product.isFavToggle(authData.token,authData.userId);
                  Scaffold.of(context).showSnackBar(SnackBar(content:Text("Remove from favorite"),duration: Duration(seconds: 0),)
                  );
                }
                }
              ),
            ),
            trailing: IconButton(icon: Icon(Icons.shopping_cart,color: Colors.green), onPressed:(){
            productCart.addItem(product.id,product.price,product.name);
            Scaffold.of(context).hideCurrentSnackBar();
            Scaffold.of(context).showSnackBar(SnackBar(
            content: Text("Added to Cart"),
            duration: Duration(seconds: 2),
            action: SnackBarAction(label: 'UNDO', onPressed: (){
              productCart.removeSingleItem(product.id);
            }),)
            );
            }),
            title: Text(product.name,textAlign: TextAlign.center,),
            ),
      ),
        ),
    );
  }
}