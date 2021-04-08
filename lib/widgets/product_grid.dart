import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './product_item.dart';
import '../providers/products.dart';
class ProductGrid extends StatelessWidget {
  final bool showFav;
  ProductGrid(this.showFav);
  @override
  Widget build(BuildContext context) {
    final products = Provider.of<Products>(context);
    final productItems = showFav ? products.favoriteItems:products.items;
    return GridView.builder(
      padding: EdgeInsets.all(10.0),
      itemCount:productItems.length,
      itemBuilder: (ctx,index)=> ChangeNotifierProvider.value(
        value:productItems[index],
        child: ProductItem(
        // productItems[index].id,
        // productItems[index].name,
        // productItems[index].imgUrl
        ),
      ),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 2/2,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        ),
    );
  }
}