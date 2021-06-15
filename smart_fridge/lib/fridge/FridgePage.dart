import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:smart_fridge/models/Product.dart';
import 'package:smart_fridge/utils/AppColors.dart';
import 'file:///D:/Facultate/Facultate%20Semestrul%206/PBT/SmartFridge/smart_fridge/lib/add_product/AddProductPage.dart';
import 'file:///D:/Facultate/Facultate%20Semestrul%206/PBT/SmartFridge/smart_fridge/lib/add_product/AddByBarcodePage.dart';

import 'package:uuid/uuid.dart';
import 'package:smart_fridge/utils/flutterfire.dart';
import '../view/FunkyDialog.dart';

class FridgePage extends StatefulWidget {
  State<StatefulWidget> createState() => _FridgePage();
}

class _FridgePage extends State<FridgePage> {
  String barCode = "Unknown";
  bool isSearching = false;
  String searchValue = "";
  List<Product> products = List();
  List<DocumentSnapshot> productList;
  @override
  void initState() {
    super.initState();
  }

  Future<void> scanBarCode() async {
    try {
      final barCode = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', "Cancel", true, ScanMode.BARCODE);
      //initChaptersTitleScrap(barCode);
      if (!mounted) return;
      setState(() {
        this.barCode = barCode;
        print(barCode);
      });
    } on PlatformException {
      barCode = 'Failed to get platform version.';
    }
  }

  Widget createGridView(BuildContext context, AsyncSnapshot snapshot) {
    productList = snapshot.data.docs;
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



    print(productList.length);
    print(searchValue);
    return new Container(
      child: GridView.count(
        crossAxisCount: 4,
        children: List.generate(products.length, (index) {
          return Center(
            child: productCard(
                products.elementAt(index),
                context),
          );
        }),
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    var futureBuilder = new StreamBuilder(
        stream:  FirebaseFirestore.instance
            .collection('Users')
            .doc(FirebaseAuth.instance.currentUser.uid)
            .collection('Products').snapshots()
        ,
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
          title:
          !isSearching
              ? Text(
            "My Fridge",
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
        floatingActionButton:
            Column(mainAxisAlignment: MainAxisAlignment.end, children: [
          FloatingActionButton(
            child:
                Icon(Icons.camera_alt, size: 30, color: AppColors().ligh_grey),
            backgroundColor: AppColors().navy,
            onPressed: () async {
              await scanBarCode();
              bool ceva = await barcodeExists(barCode);
              // barcode exists
              if (ceva) {
                Product product = await getProductByBarcode(barCode);
                final result = await Navigator.of(context).push(
                  CupertinoPageRoute<Product>(
                    fullscreenDialog: false,
                    builder: (BuildContext context) => AddProductPage(
                        product: product, action: true, url: product.imageUrl),
                  ),
                );
                setState(() {

                });
              } else {
                // barcode doesn't exist
                final result = await Navigator.of(context).push(
                  CupertinoPageRoute<Product>(
                    fullscreenDialog: false,
                    builder: (BuildContext context) => AddByBarcodePage(
                      barcode: this.barCode,
                    ),
                  ),
                );
                setState(() {

                });
              }
            },
            heroTag: null,
          ),
          SizedBox(
            height: 10,
          ),
          FloatingActionButton(
            key: Key("addProductButton"),
            onPressed: () async {
              String id = Uuid().v4();
              final result = await Navigator.of(context).push(
                CupertinoPageRoute<Product>(
                  fullscreenDialog: false,
                  builder: (BuildContext context) =>
                      AddProductPage(action: false, id: id),
                ),
              );
              Product product = result;
              setState(() {});
            },
            child: Icon(Icons.add, size: 40, color: AppColors().ligh_grey),
            backgroundColor: AppColors().navy,
          ),
        ]));
  }
}

Widget productCard(Product product, context) {
  return GridTile(
      child: Container(
    decoration: BoxDecoration(
      border: Border(bottom: BorderSide(color: Colors.black, width: 0.5)),
    ),
    child: Padding(
      padding: EdgeInsets.all(20),
      child: FlatButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (_) => FunkyOverlay(product: product),
          );

        },
        padding: EdgeInsets.all(0.0),
        child: new Container(
            width: 190.0,
            height: 190.0,
            decoration: new BoxDecoration(
                shape: BoxShape.circle,
                image: new DecorationImage(
                    fit: BoxFit.fill,
                    image: new NetworkImage(product.imageUrl)))),
      ),
    ),
  ));
}
