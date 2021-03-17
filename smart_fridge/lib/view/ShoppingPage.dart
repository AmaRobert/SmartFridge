import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:smart_fridge/utils/AppColors.dart';

class ShoppingPage extends StatefulWidget {
  @override
  _ShoppingPageState createState() => _ShoppingPageState();
}

class _ShoppingPageState extends State<ShoppingPage> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: Colors.green,
      appBar: new AppBar(
        title: new Text("Shopping Page"),
        backgroundColor: AppColors().navy,
      ),
      body: new Center(
        child: new Text("This is the shopping page bitch"),
      ),
    );
  }
}
