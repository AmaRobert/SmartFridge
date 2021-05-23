import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:smart_fridge/models/Product.dart';
import 'package:smart_fridge/utils/AppColors.dart';
import 'package:smart_fridge/utils/ServerProvider.dart';
import 'package:smart_fridge/view_models/IconsList.dart';
import 'package:smart_fridge/view_models/RepositoryServer.dart';
import 'package:smart_fridge/view/AddProductPage.dart';

import 'FunkyDialog.dart';

class FridgePage extends StatefulWidget{
  State<StatefulWidget> createState() => _FridgePage();
  RepositoryServer serverRepository = RepositoryServer();
}

class _FridgePage extends State<FridgePage>{

  @override
  void initState(){
    super.initState();
    widget.serverRepository.init();

  }
  Future<List<Product>> _getData() async {
    return await ServerProvider.server.fetchProducts();
  }

  Widget createGridView(BuildContext context, AsyncSnapshot snapshot) {
    List<Product> productList = snapshot.data;
    widget.serverRepository.productList = productList;
    return new Container(
      child: GridView.count(
        crossAxisCount: 4,
        children: List.generate(widget.serverRepository.size(), (index){
          return Center(
            child: productCard(productList[index], context),
          );
        }),
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    var futureBuilder = new FutureBuilder(
      future: _getData(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
          case ConnectionState.waiting:
            return Center(child: CircularProgressIndicator());
          default:
            if(snapshot.hasError)
              return Center(child: new Text('Error :${snapshot.error}'));
            else
              return createGridView(context, snapshot);
        }
      }
    );
    return Scaffold(
      backgroundColor: AppColors().ochre,
      appBar: AppBar(
        backgroundColor: AppColors().navy,
        title: Text("My Fridge",
          style: TextStyle(
            fontSize: 25,
            color: AppColors().ligh_grey
          ),
        ),
        actions: <Widget>[
          IconButton(
            iconSize: 40,
            icon: Icon(
              Icons.search,
              color: AppColors().ligh_grey,
            ),
            onPressed: () async  {
              // search product name
            },
          ),
          IconButton(
            iconSize: 40,
            icon: Icon(
              Icons.filter_alt,
              color: AppColors().ligh_grey,
            ),
            onPressed: () {
              // do something
            },
          ),
          IconButton(
            iconSize: 40,
            icon: Icon(
              Icons.account_circle,
              color: AppColors().ligh_grey,
            ),
            onPressed: () {
              // do something
            },
          ),

        ],
      ),
      body: futureBuilder,
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
           final result = await Navigator.of(context).push(
            CupertinoPageRoute<Product>(
              fullscreenDialog: false,
              builder: (BuildContext context) => AddProductPage(serverRepository: widget.serverRepository, action: false),
            ),
          );
           Product product = result;
           widget.serverRepository.addProduct(product.name, product.expirationDate, product.quantity, product.price);
           setState(() {
            });
        },
        child: Icon(Icons.add,size: 40,color: AppColors().ligh_grey),
        backgroundColor: AppColors().navy,
      ),
    );
  }
}

Widget productCard(Product product, context){
    return GridTile(
      child: Container(
        decoration: BoxDecoration(border: Border(bottom : BorderSide(color: Colors.black, width: 0.5)), ),
        child: Padding(
          padding: EdgeInsets.all(20),
          child: FlatButton(
            onPressed: () {
              showDialog(
              context: context,
              builder: (_) => FunkyOverlay(product: product),
            );},
            padding: EdgeInsets.all(0.0),
            child: Image.asset("assets/${product.name}.png"),
          ),
        ),
      )
    );
}