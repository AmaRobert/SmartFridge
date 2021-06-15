import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:smart_fridge/models/Product.dart';
import 'package:smart_fridge/utils/AppColors.dart';
import 'package:smart_fridge/utils/flutterfire.dart';

import '../authenticate/LogoutPage.dart';

class ShoppingPage extends StatefulWidget {
  @override
  _ShoppingPageState createState() => _ShoppingPageState();
}

class _ShoppingPageState extends State<ShoppingPage> {
  List<Product> products = List();
  bool isSearching = false;
  String searchValue = "";
  Widget createGridView(BuildContext context, AsyncSnapshot snapshot) {
    List<DocumentSnapshot> productList = snapshot.data.docs;
    if(products.isNotEmpty)
      products.clear();

    if(!isSearching){
      for(int index = 0; index < productList.length; index++){
        products.add(Product(
            id: productList.elementAt(index).id,
            name: productList.elementAt(index).data()['Name'],
            generalName: productList.elementAt(index).data()['GeneralName'],
            quantity: productList.elementAt(index).data()['Quantity'],
            price: productList.elementAt(index).data()['Price'],
            expirationDate: productList.elementAt(index).data()['ExpirationDate'],
            imageUrl: productList.elementAt(index).data()['ImageUrl']));
      }
    }else{
      for(int index = 0; index < productList.length; index++){
        if(productList.elementAt(index).data()['Name'].toString().toLowerCase().contains(searchValue.toLowerCase()) == true){
          products.add(Product(
              id: productList.elementAt(index).id,
              name: productList.elementAt(index).data()['Name'],
              generalName: productList.elementAt(index).data()['GeneralName'],
              quantity: productList.elementAt(index).data()['Quantity'],
              price: productList.elementAt(index).data()['Price'],
              expirationDate: productList.elementAt(index).data()['ExpirationDate'],
              imageUrl: productList.elementAt(index).data()['ImageUrl']));
        }
      }
    }
    return new Container(
      child:  ListView.builder(
        itemCount: products.length,
        itemBuilder: (context, index) => Padding(
          padding: EdgeInsets.symmetric(vertical: 10),
          child: Dismissible(
            key: Key(products[index].id.toString()),
            direction: DismissDirection.endToStart,
            onDismissed: (direction) async {
              await removeProductShopping(products.elementAt(index).id);
            },
            background: Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                color: Color(0xFFFFE6E6),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Row(
                children: [
                  Spacer(),
                  Icon(Icons.delete),
                ],
              ),
            ),
            child: productCard(
                products.elementAt(index),
                context),
          ),
        ),
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    var futureBuilder = new StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('Users')
            .doc(FirebaseAuth.instance.currentUser.uid)
            .collection('Shop').snapshots(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
              return Center(child: CircularProgressIndicator());
            default:
              if (snapshot.hasError)
                return Center(child: new Text('Error :${snapshot.error}'));
              else
                return createGridView(context, snapshot);
          }
        });
    return Scaffold(
        backgroundColor: AppColors().ochre,
        appBar: AppBar(
          backgroundColor: AppColors().navy,
          title: !isSearching
              ? Text(
            "Shopping List",
            style: TextStyle(fontSize: 25, color: AppColors().ligh_grey),
          )
              : TextField(
            onChanged: (value) async {
              searchValue = value;
              setState(() {

              });
            },
            style: TextStyle(color: Colors.white),
            decoration: InputDecoration(
                icon: Icon(
                  Icons.search,
                  color: Colors.white,
                ),
                hintText: "Search Products Here",
                hintStyle: TextStyle(color: Colors.white)),
          ),
          actions: <Widget>[
            isSearching
                ? IconButton(
              icon: Icon(Icons.cancel),
              onPressed: () {
                setState(() {
                  this.isSearching = false;
                  searchValue = "";
                });
              },
            )
                : IconButton(
              iconSize: 40,
              icon: Icon(Icons.search),
              onPressed: () {
                setState(() {
                  this.isSearching = true;

                });
              },
            ),
          ],
        ),
        body: futureBuilder,
        );
  }
}

Widget productCard(Product product, context) {
  return Row(
    children: [
      SizedBox(
        width: 88,
        child: AspectRatio(
          aspectRatio: 0.88,
          child: Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Color(0xFFF5F6F9),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Image.network(product.imageUrl),
          ),
        ),
      ),
      SizedBox(width: 20),
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            product.name,
            style: TextStyle(color: Colors.black, fontSize: 16),
            maxLines: 2,
          ),
          SizedBox(height: 10),
          Text.rich(
            TextSpan(
              text: "\$${product.price}",
              style: TextStyle(
                  fontWeight: FontWeight.w600, color: AppColors().ligh_grey),
              children: [
                TextSpan(
                    text: " - ${product.quantity}",
                    style: Theme.of(context).textTheme.bodyText1),
              ],
            ),
          )
        ],
      )
    ],
  );
}
