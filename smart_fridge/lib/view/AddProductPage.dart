import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:smart_fridge/models/Product.dart';
import 'package:smart_fridge/utils/AppColors.dart';
import 'package:smart_fridge/view_models/RepositoryServer.dart';

class AddProductPage extends StatefulWidget{

  int index;
  bool action;
  RepositoryServer serverRepository;

  AddProductPage({this.index, this.serverRepository, this.action});
  State<StatefulWidget> createState() => _AddProductPage();
}

class _AddProductPage extends State<AddProductPage>{
  String barCode = "Unknown";
  TextEditingController _productNameController = TextEditingController();
  TextEditingController _expirationDateController = TextEditingController();
  TextEditingController _quantityController = TextEditingController();
  TextEditingController _priceController = TextEditingController();
  FocusNode _productNameFocus;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

  }
  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors().navy,
        centerTitle: true,
        title: Text("Add Product",style: TextStyle(color: AppColors().ligh_grey)),
      ),
      body: Container(
        decoration: BoxDecoration(
            color: AppColors().burnt_sienna
        ),
        child: ListView(
          children: [
            Padding(
              padding: EdgeInsets.all(20),
              child: TextField(
                controller: _productNameController..text = widget.index != null ? widget.serverRepository.getProduct(widget.index).name : "",
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
                controller: _expirationDateController..text = widget.index != null ? widget.serverRepository.getProduct(widget.index).expirationDate : "",
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
                controller: _quantityController..text = widget.index != null ? widget.serverRepository.getProduct(widget.index).quantity : "",
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
                controller: _priceController..text = widget.index != null ? widget.serverRepository.getProduct(widget.index).price : "",
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
            Align(
              alignment: Alignment.bottomCenter,
              child: FlatButton(
                minWidth: 100 ,
                color: AppColors().navy,
                textColor: AppColors().ligh_grey,
                padding: EdgeInsets.all(16),
                onPressed: () {
                    scanBarCode();
                },
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25.0),
                ),
                child: Text("Scan Barcode",
                  style: TextStyle(
                    color: AppColors().ligh_grey,
                    fontSize: 15.0,
                  ),
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
                onPressed: () {

                  Navigator.pop(context,save(serverRepository: widget.serverRepository,
                      action: widget.action));
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

  Future<void> scanBarCode() async{
    try{
      final barCode = await FlutterBarcodeScanner.scanBarcode('#ff6666',
          "Cancel",
          true,
          ScanMode.BARCODE);

      if(!mounted) return;
      setState(() {
        this.barCode = barCode;
        print(barCode);
      });
    } on PlatformException{
      barCode = 'Failed to get platform version.';
    }
  }

  Product save({RepositoryServer serverRepository, bool action, int index}) {
    Product product = Product(
        name: _productNameController.text,
        price: _priceController.text,
        expirationDate: _expirationDateController.text,
        quantity: _quantityController.text
    );
    if(action == true)
      product.id = widget.serverRepository.getProduct(widget.index).id;
    return product;
  }

}