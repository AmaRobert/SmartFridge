import 'package:flutter/material.dart';
import 'package:smart_fridge/view/FridgePage.dart';

void main() => runApp(MaterialApp(
  title: "Smart Fridge",
  home: MyApp(),
));

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Main Page"),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              child: Text("Home Section"),
              onPressed: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => FridgePage()));
              },
            )
          ],
        )
      ),
    );
  }
}



