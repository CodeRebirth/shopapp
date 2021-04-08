import 'package:flutter/material.dart';
import '../providers/product.dart';
import 'package:provider/provider.dart';
import '../providers/products.dart';
class EditProductScreen extends StatefulWidget {
  static const routeName='/edit-product-screen';
  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _imgUrlController = TextEditingController();
  final _imgUrlFocusNode = FocusNode();
  final _form = GlobalKey<FormState>();
  var _editedProduct = Product(id: null,name:'',price:0,description:'',imgUrl:'');
  var _isInit = true;
  var _isLoading = false;
  var _initValues={
    'name':'',
    'description':'',
    'price':'',
    'imgUrl':''
  };
  @override
  void initState(){
    _imgUrlFocusNode.addListener(_updateImageUrl);
    super.initState();
  }
 @override
  void didChangeDependencies() {
    if(_isInit){
      final productId = ModalRoute.of(context).settings.arguments as String;
      if(productId!=null){
      _editedProduct=Provider.of<Products>(context,listen:false).findById(productId);
      _initValues={
        'name':_editedProduct.name,
        'description':_editedProduct.description,
        // 'imgUrl':_editedProduct.imgUrl,
        'price':_editedProduct.price.toString(),
        'imgUrl':''
      };
      _imgUrlController.text=_editedProduct.imgUrl;     
     }
    }
    _isInit = false;
    super.didChangeDependencies();
  }
  @override
  void dispose() {
    _imgUrlFocusNode.removeListener(_updateImageUrl);
    _priceFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _imgUrlController.dispose();
    _imgUrlFocusNode.dispose();  
    super.dispose();
  }

  void _updateImageUrl(){
 if(!_imgUrlFocusNode.hasFocus){
   setState(() {  
   });
 }
}
Future<void> _saveForm() async {
  final isValid = _form.currentState.validate();
  if(!isValid){
  return;
  }
  _form.currentState.save();
  setState(() {
    _isLoading=true;
  });
  if(_editedProduct.id!=null){
    await Provider.of<Products>(context,listen:false).updateProduct(_editedProduct.id, _editedProduct);
  }else{
    try{
     await Provider.of<Products>(context,listen:false).addProduct(_editedProduct);
    }catch(error){
        await showDialog(context:context,builder: (ctx)=>AlertDialog(title: Text("Error Occured"),
        content: Text("Something went wrong."),
        actions: <Widget>[
          FlatButton(child:Text("Okay"),onPressed:(){Navigator.of(ctx).pop();} )
        ],
        ));
    }   
  }
  setState(() {
    _isLoading=false;
    });
    Navigator.of(context).pop();
}
   
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Product"),
        actions: <Widget>[
          IconButton(icon: Icon(Icons.save),onPressed: _saveForm,)
        ],
      ),
      body: _isLoading?Center(child: CircularProgressIndicator(),):Padding(
        padding: EdgeInsets.all(10),
          child: Form(
          key: _form,
          child: ListView(
            children: <Widget>[
              TextFormField(
                initialValue: _initValues['name'],
                decoration:InputDecoration(labelText: "Title"),
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (_){
                  FocusScope.of(context).requestFocus(_priceFocusNode);
                },
                onSaved: (value){
                  _editedProduct=Product(name:value,price:_editedProduct.price,description: _editedProduct.description,imgUrl: _editedProduct.imgUrl,id:_editedProduct.id,isFav:_editedProduct.isFav);
                },
                validator: (value){
                 if(value.isEmpty){
                   return 'Please Provide a name';                 
                   }
                   return null;
                },
                ),
                TextFormField(
                initialValue: _initValues['price'],
                decoration:InputDecoration(labelText: "Price"),
                focusNode: _priceFocusNode,
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.number,
                onFieldSubmitted:(_){
                  FocusScope.of(context).requestFocus(_descriptionFocusNode);
                },
                onSaved: (value){
                  _editedProduct=Product(name:_editedProduct.name,price:double.parse(value),description: _editedProduct.description,imgUrl: _editedProduct.imgUrl,id:_editedProduct.id,isFav:_editedProduct.isFav);
                },
                validator:(value){
                  if(value.isEmpty){
                    return "Please provide a price";
                  }
                  if(double.tryParse(value)==null){
                    return "Please provide a valid number";
                  }
                  if(double.parse(value)<=0){
                    return "please enter a price greater then 0";
                  }
                    return null;
                }
                ),
                TextFormField(
                initialValue: _initValues['description'],
                decoration:InputDecoration(labelText: "Description"),
                maxLines: 3,
                textInputAction: TextInputAction.next,
                keyboardType:TextInputType.multiline,
                focusNode: _descriptionFocusNode,
                onSaved: (value){
                  _editedProduct=Product(name:_editedProduct.name,price:_editedProduct.price,description:value,imgUrl: _editedProduct.imgUrl,id:_editedProduct.id,isFav:_editedProduct.isFav);
                },
                validator:(value){
                  if(value.isEmpty){
                    return "Please provide a description";
                  }
                  if(value.length<10){
                    return "Should be at least 10 characters";
                  }
                  return null;
                }
                ),
                Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                Container(
                  decoration: BoxDecoration(border:Border.all(width:1,color:Colors.grey)),
                  width: 100,
                  height: 100,
                  margin: EdgeInsets.all(10),
                  child:_imgUrlController.text.isEmpty?Text("Empty"):FittedBox(child:Image.network(_imgUrlController.text,fit: BoxFit.cover,))
                ),
                Expanded(
                    child: TextFormField(
                    decoration:InputDecoration(labelText:"Img url"),
                    keyboardType: TextInputType.url,
                    textInputAction: TextInputAction.done,
                    controller: _imgUrlController,
                    focusNode:_imgUrlFocusNode,
                    onFieldSubmitted: (_){
                     _saveForm(); 
                    },
                    onSaved: (value){
                  _editedProduct=Product(name:_editedProduct.name,price:_editedProduct.price,description: _editedProduct.description,imgUrl: value,id:_editedProduct.id,isFav:_editedProduct.isFav);
                },
                validator:(value){
                  if(value.isEmpty){
                    return "Enter a valid url";
                  }
                  if(!value.startsWith('http')&&!value.startsWith('https')){
                    return "Please provide valid url";
                  }
                  return null;
                }
                  ),
                )
                ],)
            ],
          ),
          ),
      ),
    );
  }
}