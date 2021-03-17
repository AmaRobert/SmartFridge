import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:smart_fridge/utils/AppColors.dart';

class RecipesPage extends StatefulWidget {
  @override
  _RecipesPageState createState() => _RecipesPageState();
}

class _RecipesPageState extends State<RecipesPage> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: Colors.red,
      appBar: new AppBar(
        title: new Text("Recipes Page"),
        backgroundColor: AppColors().navy,
      ),
      body: new Center(
        child: new Text("This is the recipes page bitch"),
      ),
    );
  }
}
