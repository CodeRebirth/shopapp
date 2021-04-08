import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/orders.dart' show Orders;
import '../widgets/order_item.dart';
import '../widgets/app_drawer.dart';
class OrderScreen extends StatefulWidget {
  static const routeName = '/order-screen';

  @override
  _OrderScreenState createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  var _isInit = true;
  var _isLoading = true;
  @override
  void initState() {
    super.initState();
  }
  @override
  void didChangeDependencies(){
    if(_isInit){
     Provider.of<Orders>(context,listen: false).fetchAndSetOrders().then((_){
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
    final orderData = Provider.of<Orders>(context);
    return Scaffold(
      drawer: AppDrawer(),
      appBar: AppBar(
        title: Text("Orders"),
      ),
      body:_isLoading?Center(child:CircularProgressIndicator()):ListView.builder(itemBuilder:(ctx,i)=>OrderItem(orderData.orders[i]) ,itemCount:orderData.orders.length)
    );
  }
}