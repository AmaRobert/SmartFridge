import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:smart_fridge/models/Product.dart';
import 'package:smart_fridge/utils/AppColors.dart';
import 'package:smart_fridge/utils/flutterfire.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import 'package:path/path.dart';


class AddByBarcodePage extends StatefulWidget{
  String barcode;
  AddByBarcodePage({this.barcode});
  State<StatefulWidget> createState() => _AddByBarcodePage();
}

class _AddByBarcodePage extends State<AddByBarcodePage>{
  TextEditingController _productNameController = TextEditingController();
  TextEditingController _expirationDateController = TextEditingController();
  TextEditingController _quantityController = TextEditingController();
  TextEditingController _priceController = TextEditingController();
  FocusNode _productNameFocus;
  File _image;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

  }
  @override
  Widget build(BuildContext context){
    Future getImage() async {
      var image = await ImagePicker.pickImage(source: ImageSource.camera);

      setState(() {
        _image = image;
        print('Image Path $_image');
      });
    }

    Future<void> uploadFile() async {
      try {
        await FirebaseStorage.instance
            .ref(widget.barcode)
            .putFile(_image);
      } on FirebaseException catch (e) {
        // e.g, e.code == 'canceled'
      }
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors().navy,
        centerTitle: true,
        title: Text("Add Product in database",style: TextStyle(color: AppColors().ligh_grey)),
      ),
      body: Container(
        decoration: BoxDecoration(
            color: AppColors().burnt_sienna
        ),
        child: ListView(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Align(
                  alignment: Alignment.center,
                  child: CircleAvatar(
                    radius: 100,
                    backgroundColor: AppColors().ochre,
                    child: ClipOval(
                      child: new SizedBox(
                        width: 180.0,
                        height: 180.0,
                        child: (_image!=null)?Image.file(
                          _image,
                          fit: BoxFit.fill,
                        ):Image.network(
                          "https://socialistmodernism.com/wp-content/uploads/2017/07/placeholder-image.png",
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 60.0),
                  child: IconButton(
                    icon: Icon(
                      FontAwesomeIcons.camera,
                      size: 30.0,
                    ),
                    onPressed: () {
                      getImage();
                    },
                  ),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.all(20),
              child: TextField(
                controller: _productNameController,
                focusNode: _productNameFocus,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.all(10),
                  labelText: "Product Name",
                  labelStyle: TextStyle(color: Colors.black),focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color:Colors.grey),
                  borderRadius: BorderRadius.circular(5.0),

                ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                    borderRadius: BorderRadius.circular(5.0),),
                ),
              ),
            ),
            SizedBox(height: 10),
            Padding(
              padding: EdgeInsets.all(20),
              child: TextField(
                controller: _expirationDateController,
                focusNode: _productNameFocus,
                decoration: InputDecoration(
                  labelText: "Expiration Date",
                  labelStyle: TextStyle(color: Colors.black),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color:Colors.grey),
                    borderRadius: BorderRadius.circular(5.0),

                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                    borderRadius: BorderRadius.circular(5.0),),
                ),
              ),
            ),
            SizedBox(height: 10),
            Padding(
              padding: EdgeInsets.all(20),
              child: TextField(
                controller: _quantityController,
                focusNode: _productNameFocus,
                decoration: InputDecoration(
                  labelText: "Quantity",
                  labelStyle: TextStyle(color: Colors.black),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color:Colors.grey),
                    borderRadius: BorderRadius.circular(5.0),

                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                    borderRadius: BorderRadius.circular(5.0),),
                ),
              ),
            ),
            SizedBox(height: 10),
            Padding(
              padding: EdgeInsets.all(20),
              child: TextField(
                controller: _priceController,
                focusNode: _productNameFocus,
                decoration: InputDecoration(
                  labelText: "Price",
                  labelStyle: TextStyle(color: Colors.black),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color:Colors.grey),
                    borderRadius: BorderRadius.circular(5.0),

                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                    borderRadius: BorderRadius.circular(5.0),),
                ),
              ),
            ),
            SizedBox(height: 10),
            Align(
              alignment: Alignment.bottomCenter,
              child: FlatButton(
                minWidth: 100 ,
                color: AppColors().navy,
                textColor: AppColors().ligh_grey,
                padding: EdgeInsets.all(16),
                onPressed: () async {
                  await uploadFile().then((value) async {
                    String url = await getImageUrl(widget.barcode);
                    await addProductByBarcode(widget.barcode, _productNameController.text, _quantityController.text, _priceController.text, _expirationDateController.text, url);
                    await addProduct(widget.barcode, _productNameController.text, _quantityController.text, _priceController.text, _expirationDateController.text, url);
                    Navigator.pop(context);
                  });
                },
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25.0),
                ),
                child: Text("Save",
                  style: TextStyle(
                    color: AppColors().ligh_grey,
                    fontSize: 15.0,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  goBack(BuildContext context) {
    Navigator.pop(context);
  }

}