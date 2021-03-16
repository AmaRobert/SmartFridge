import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:smart_fridge/models/Product.dart';
import 'package:smart_fridge/utils/AppColors.dart';
import 'package:smart_fridge/view_models/IconsList.dart';

class FridgePage extends StatefulWidget{
  State<StatefulWidget> createState() => _FridgePage();
}

class _FridgePage extends State<FridgePage>{
  List<String> iconsList = [
    "apple-1", "asparagus", "aubergine", "avocado",
    "banana", "carrot", "broccoli", "blueberries",
    "cheese", "cheese-1", "boiled", "eggs",
    "bacon", "ham", "hamburguer", "hot-dog",
    "meat", "meat-1", "meat-2", "pizza",
    "salmon", "salami", "shrimp", "sausage",
    "steak", "sushi", "sushi-1", "sushi-2",
    "strawberry", "tomato"
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors().ochre,
      appBar: AppBar(
        backgroundColor: AppColors().navy,
        title: Text("My Fridge",
          style: TextStyle(
            color: AppColors().ligh_grey
          ),
        ),
      ),
      body: Container(
        child: GridView.count(
            crossAxisCount: 4,
            children: List.generate(iconsList.length, (index){
              return Center(
                child: productCard(iconsList[index]),
              );
            }),
          ),
      ),
    );
  }
}

Widget productCard(String product){
    return GridTile(
      child: Container(
        decoration: BoxDecoration(border: Border(bottom : BorderSide(color: Colors.black, width: 0.5)), ),
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Image.asset("assets/$product.png",),
        ),
      )
    );
}