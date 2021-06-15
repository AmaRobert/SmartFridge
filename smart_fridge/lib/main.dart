import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:smart_fridge/fridge/FridgePage.dart';
import 'package:smart_fridge/recipe/RecipesPage.dart';
import 'package:smart_fridge/shop/ShoppingPage.dart';
import 'package:smart_fridge/utils/AppColors.dart';
import 'package:smart_fridge/utils/flutterfire.dart';
import 'package:smart_fridge/welcome/WelcomePage.dart';
import 'package:smart_fridge/authenticate/LogoutPage.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false,
      home: FutureBuilder(
          future: getCurrentUser(),
          builder: (context, AsyncSnapshot<dynamic> snapshot) {
            if(snapshot.hasData) {
              return MyBottomNavigationBar();
            }else{
              return WelcomePage();
            }
          }
      ),
    );
  }
}

class MyBottomNavigationBar extends StatefulWidget {
  @override
  _MyBottomNavigationBarState createState() => _MyBottomNavigationBarState();
}

class _MyBottomNavigationBarState extends State<MyBottomNavigationBar> {
  int _currentIndex = 0;
  final List<Widget> _children = [
    FridgePage(),
    ShoppingPage(),
    RecipesPage(),
    LogoutPage()
  ];

  void onTappedBar(int index){
    setState((){
      _currentIndex = index;
    });
  }
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: _children[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        onTap: onTappedBar,
        currentIndex: _currentIndex,
        selectedItemColor: AppColors().ligh_grey,
        unselectedItemColor: AppColors().dark_grey,

        items: [
          BottomNavigationBarItem(
            icon: new Icon(Icons.home),
            backgroundColor: AppColors().navy,
            label:  "Home"
          ),
          BottomNavigationBarItem(
            icon: new Icon(Icons.shopping_cart),
            backgroundColor: AppColors().navy,
            label:  "Shopping"
          ),
          BottomNavigationBarItem(
            icon: new Icon(Icons.fastfood),
            backgroundColor: AppColors().navy,
            label:  "Recipes"
          ),
          BottomNavigationBarItem(
            icon: new Icon(Icons.account_circle),
            backgroundColor: AppColors().navy,
            label:  "Profile"
          ),
        ],
      ),
    );
  }
}


