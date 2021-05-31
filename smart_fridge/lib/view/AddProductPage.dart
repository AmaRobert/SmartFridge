import 'package:camera/camera.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:smart_fridge/models/Product.dart';
import 'package:smart_fridge/utils/AppColors.dart';
import 'package:smart_fridge/utils/flutterfire.dart';
import 'package:smart_fridge/utils/ScannerUtils.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import 'package:path/path.dart';

class AddProductPage extends StatefulWidget {
  Product product;
  bool action;
  String url;
  String id;

  AddProductPage({this.product, this.action, this.url, this.id});
  State<StatefulWidget> createState() => _AddProductPage();
}

class _AddProductPage extends State<AddProductPage> {
  TextEditingController _productNameController = TextEditingController();
  TextEditingController _expirationDateController = TextEditingController();
  TextEditingController _quantityController = TextEditingController();
  TextEditingController _priceController = TextEditingController();
  FocusNode _productNameFocus;
  File _image;
  File _imageRecognition;
  ImagePicker imagePicker;

  @override
  void initState() {
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    Future getImage() async {
      var image = await ImagePicker.pickImage(source: ImageSource.camera);

      setState(() {
        _image = image;

        widget.url = null;
        print('Image Path $_image');
      });
    }


    Future performLabeling() async{
      final FirebaseVisionImage firebaseVisionImage = FirebaseVisionImage.fromFile(_imageRecognition);
      final TextRecognizer recognizer = FirebaseVision.instance.textRecognizer();
      VisionText visionText = await recognizer.processImage(firebaseVisionImage);
      var regExp1 = RegExp(r"(0[1-9]|[12][0-9]|3[01])[- /.](0[1-9]|1[012])[- /.](19|20)\d\d");
      String result = "";
      setState(() {
        for(TextBlock block in visionText.blocks){
          final String txt = block.text;
          for(TextLine line in block.lines){
            for(TextElement element in line.elements){
              result += element.text + "";
            }
          }
          result += "\n\n";
        }
        String match = regExp1.stringMatch(result);
        print(match);
        _expirationDateController.text = match;
      });
    }

    Future getImageRecognition() async {
      var image = await ImagePicker.pickImage(source: ImageSource.camera);
      _imageRecognition = File(image.path);
      setState(() {
        _imageRecognition;

        performLabeling();
        widget.url = null;
        print('Image Path $_imageRecognition');
      });
    }


    Future<void> uploadFile(id) async {
      try {
        await FirebaseStorage.instance.ref(id).putFile(_image);
      } on FirebaseException catch (e) {
        // e.g, e.code == 'canceled'
      }
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors().navy,
        centerTitle: true,
        title:
            Text("Add Product", style: TextStyle(color: AppColors().ligh_grey)),
      ),
      body: Container(
        decoration: BoxDecoration(color: AppColors().burnt_sienna),
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
                        child: (_image != null)
                            ? Image.file(
                                _image,
                                fit: BoxFit.fill,
                              )
                            : (widget.url != null)
                                ? Image.network(
                                    widget.url,
                                    fit: BoxFit.fill,
                                  )
                                : Image.network(
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
                controller: _productNameController
                  ..text = widget.action != false ? widget.product.name : "",
                focusNode: _productNameFocus,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.all(10),
                  labelText: "Product Name",
                  labelStyle: TextStyle(color: Colors.black),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                ),
              ),
            ),
            SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(children: <Widget>[
                Expanded(
                  child: TextField(
                    textAlign: TextAlign.center,
                    controller: _expirationDateController
                      ..text = widget.action != false
                          ? widget.product.expirationDate
                          : _expirationDateController.text,
                    focusNode: _productNameFocus,
                    decoration: InputDecoration(
                      prefixIcon: IconButton(
                        icon: Icon(
                          Icons.calendar_today,
                          color: AppColors().dark_grey,
                        ),
                        onPressed: () {
                            // showCupertinoModalPopup is a built-in function of the cupertino library
                            showCupertinoModalPopup(
                                context: context,
                                builder: (_) => Container(
                                      height: 200,
                                      color: Color.fromARGB(255, 255, 255, 255),
                                      child: Column(
                                        children: [
                                          Container(
                                            height: 100,
                                            child: CupertinoDatePicker(
                                              mode: CupertinoDatePickerMode.date,
                                                initialDateTime: DateTime.now(),
                                                onDateTimeChanged: (val) {
                                                  setState(() {
                                                    _expirationDateController.text = val.day.toString() + "/" + val.month.toString() + "/" + val.year.toString();
                                                  });
                                                }),
                                          ),

                                          // Close the modal
                                          CupertinoButton(
                                            child: Text('OK'),
                                            onPressed: (){
                                              Navigator.of(context).pop();
                                              setState(() {

                                              });
                                            }
                                          )
                                        ],
                                      ),
                                    ));

                        },
                      ),
                      border: InputBorder.none,
                      suffixIcon: IconButton(
                        icon: Icon(
                          Icons.camera_alt,
                          color: AppColors().dark_grey,
                        ),
                        onPressed: () {
                          // Update the state i.e. toogle the state of passwordVisible variable
                          print("pressed");
                          getImageRecognition();
                          // showCupertinoModalPopup is a built-in function of the cupertino library
                        },
                      ),
                      labelText: "Expiration Date",
                      labelStyle: TextStyle(color: Colors.black),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey),
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey),
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                    ),
                  ),
                ),
              ]),
            ),
            SizedBox(height: 10),
            Padding(
              padding: EdgeInsets.all(20),
              child: TextField(
                controller: _quantityController
                  ..text =
                      widget.action != false ? widget.product.quantity : "",
                focusNode: _productNameFocus,
                decoration: InputDecoration(
                  labelText: "Quantity",
                  labelStyle: TextStyle(color: Colors.black),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                ),
              ),
            ),
            SizedBox(height: 10),
            Padding(
              padding: EdgeInsets.all(20),
              child: TextField(
                controller: _priceController
                  ..text = widget.action != false ? widget.product.price : "",
                focusNode: _productNameFocus,
                decoration: InputDecoration(
                  labelText: "Price",
                  labelStyle: TextStyle(color: Colors.black),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                ),
              ),
            ),
            SizedBox(height: 10),
            Align(
              alignment: Alignment.bottomCenter,
              child: FlatButton(
                minWidth: 100,
                color: AppColors().navy,
                textColor: AppColors().ligh_grey,
                padding: EdgeInsets.all(16),
                onPressed: () async {
                  if (widget.action) {
                    await addProduct(
                        widget.product.id,
                        _productNameController.text,
                        _quantityController.text,
                        _priceController.text,
                        _expirationDateController.text,
                        widget.url);
                  } else {
                    // change product widget.url
                    await uploadFile(widget.id);
                    String url = await getImageUrl(widget.id);
                    await addProductByBarcode(
                        widget.id,
                        _productNameController.text,
                        _quantityController.text,
                        _priceController.text,
                        _expirationDateController.text,
                        url);
                    await addProduct(
                        widget.id,
                        _productNameController.text,
                        _quantityController.text,
                        _priceController.text,
                        _expirationDateController.text,
                        url);
                  }
                  Navigator.pop(context);
                },
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25.0),
                ),
                child: Text(
                  "Save",
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
