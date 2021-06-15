import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:smart_fridge/models/Product.dart';
import 'package:smart_fridge/models/Recipe.dart';
import 'package:smart_fridge/utils/AppColors.dart';
import 'package:smart_fridge/utils/RecipeApiProvider.dart';
import 'package:smart_fridge/utils/flutterfire.dart';
import 'file:///D:/Facultate/Facultate%20Semestrul%206/PBT/SmartFridge/smart_fridge/lib/recipe/SavedRecipePage.dart';
import 'file:///D:/Facultate/Facultate%20Semestrul%206/PBT/SmartFridge/smart_fridge/lib/statisctics/StatisticsPage.dart';
import 'package:translator/translator.dart';

import 'RecipePage.dart';
import '../authenticate/LogoutPage.dart';

class RecipesPage extends StatefulWidget {
  //It returns a final mealPlan variable
  RecipesPage();
  @override
  _RecipesPageState createState() => _RecipesPageState();
}
class _RecipesPageState extends State<RecipesPage> with SingleTickerProviderStateMixin{
  TabController controller;

  @override
  void initState(){
    super.initState();
    controller = new TabController(vsync: this,length: 2);
  }

  @override
  void dispose(){
    controller.dispose();
    super.dispose();
  }
  Widget createGridView(BuildContext context, AsyncSnapshot snapshot) {
    List<Recipe> productList = snapshot.data;
    return new Container(
      child:  ListView.builder(
        itemCount: productList.length,
        itemBuilder: (context, index) => Padding(
          padding: EdgeInsets.symmetric(vertical: 10),
          child: Dismissible(
            key: Key(productList[index].id.toString()),
            direction: DismissDirection.endToStart,
            onDismissed: (direction) async {
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
            child: _buildMealCard(productList.elementAt(index)),
          ),
        ),
      ),
    );
  }

  Widget createGridViewSaved(BuildContext context, AsyncSnapshot snapshot) {
    List<DocumentSnapshot> productList = snapshot.data.docs;
    List<String> steps = List();
    return new Container(
      child:  ListView.builder(
        itemCount: productList.length,
        itemBuilder: (context, index) => Padding(
          padding: EdgeInsets.symmetric(vertical: 10),
          child: Dismissible(
            key: Key(productList[index].id.toString()),
            direction: DismissDirection.endToStart,
            onDismissed: (direction) async {
              removeRecipe(productList[index].id.toString());
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
            child: _buildMealCardSaved(Recipe(
              id: productList.elementAt(index).id,
              title: productList.elementAt(index).data()['title'],
              missedIngredients: productList.elementAt(index).data()['missedIngredients'],
              usedIngredients: productList.elementAt(index).data()['usedIngredients'],
              imageUrl: productList.elementAt(index).data()['ImageUrl']
            ), productList.elementAt(index).data()['steps']),
          ),
        ),
      ),
    );
  }

//This method below takes in parameters meal and index
  _buildMealCard(Recipe recipe) {
    //We return stack widget with center alignment
    return GestureDetector(
      onTap: () async{
        List<String> steps = await RecipeApiProvider.instance.getRecipeInstructions(recipe.id);
        print(steps);
        Navigator.push(context, MaterialPageRoute(builder: (_) => RecipeScreen(recipe: recipe,steps: steps)));
      },
      child: Container(
        child: Stack(
            alignment: Alignment.center,
            children: <Widget>[
              //First widget is a container that loads decoration image
              Container(
                height: 220,
                width: double.infinity,
                margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                decoration: BoxDecoration(
                    color: Colors.white,
                    image: DecorationImage(
                      image: NetworkImage(recipe.imageUrl),
                      fit: BoxFit.cover,
                    ),
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black12, offset: Offset(0, 2), blurRadius: 6)
                    ]),
              ),
              //Second widget is a Container that has 2 text widgets 
              Container(
                margin: EdgeInsets.all(60),
                padding: EdgeInsets.all(10),
                color: Colors.white70,
                child: Column(
                  children: <Widget>[
                    Text(
                      //mealtype
                      recipe.title,
                      style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.5
                      ),
                    ),
                    Text(
                      //mealtitle
                      "Used Ingredients:" + recipe.usedIngredients.length.toString(),
                      style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w600
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      //mealtitle
                      "Missed Ingredients:" + recipe.missedIngredients.length.toString(),
                      style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w600
                      ),
                      overflow: TextOverflow.ellipsis,
                    )
                  ],
                ),
              )
            ]
        ),
      ),
    );
  }

  _buildMealCardSaved(Recipe recipe, List<dynamic> stepsDyn) {
    //We return stack widget with center alignment
    List<String> steps = List();
    for(int index=0; index < stepsDyn.length; index++){
      steps.add(stepsDyn[index]);
    }
    return GestureDetector(
      onTap: () async{
        Navigator.push(context, MaterialPageRoute(builder: (_) => SavedRecipeScreen(recipe: recipe,steps: steps)));
      },
      child: Container(
        child: Stack(
            alignment: Alignment.center,
            children: <Widget>[
              //First widget is a container that loads decoration image
              Container(
                height: 220,
                width: double.infinity,
                margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                decoration: BoxDecoration(
                    color: Colors.white,
                    image: DecorationImage(
                      image: NetworkImage(recipe.imageUrl),
                      fit: BoxFit.cover,
                    ),
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black12, offset: Offset(0, 2), blurRadius: 6)
                    ]),
              ),
              //Second widget is a Container that has 2 text widgets
              Container(
                margin: EdgeInsets.all(60),
                padding: EdgeInsets.all(10),
                color: Colors.white70,
                child: Column(
                  children: <Widget>[
                    Text(
                      //mealtype
                      recipe.title,
                      style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.5
                      ),
                    ),
                    Text(
                      //mealtitle
                      "Used Ingredients:" + recipe.usedIngredients.length.toString(),
                      style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w600
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      //mealtitle
                      "Missed Ingredients:" + recipe.missedIngredients.length.toString(),
                      style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w600
                      ),
                      overflow: TextOverflow.ellipsis,
                    )
                  ],
                ),
              )
            ]
        ),
      ),
    );
  }


  Future<List<Recipe>>getRecipesBasedOnProducts() async {
    QuerySnapshot productsSnapshot = await FirebaseFirestore.instance
        .collection('Users')
        .doc(FirebaseAuth.instance.currentUser.uid)
        .collection('Products').get();
    String ingredients = "";
    print(productsSnapshot.docs.elementAt(0).data()['Name']);
    for(int index=0; index< productsSnapshot.docs.length; index++){
      String productName = productsSnapshot.docs.elementAt(index).data()['GeneralName'];
      if(productName != null)
        ingredients = ingredients +  productName +',';
    }

    return await RecipeApiProvider.instance.generateRecipesByIngredients(ingredients);
  }
  @override
  Widget build(BuildContext context) {
    var futureBuilderPossibleRecipes = new FutureBuilder(
        future: getRecipesBasedOnProducts(),
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
    var futureBuilderSavedRecipes = new StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('Users')
            .doc(FirebaseAuth.instance.currentUser.uid)
            .collection('Recipes').snapshots(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
              return Center(child: CircularProgressIndicator());
            default:
              if (snapshot.hasError)
                return Center(child: new Text('Error :${snapshot.error}'));
              else
                return createGridViewSaved(context, snapshot);
          }
        });
    return Scaffold(
      backgroundColor: AppColors().ochre,
      appBar: AppBar(
        backgroundColor: AppColors().navy,
        bottom: new TabBar(
          controller: controller,
          tabs: <Widget>[
            new Tab(text: "Saved recipes"),
            new Tab(text: "Possible recipes"),
          ],
        ),
        title: Text(
          "Recipes list",
          style: TextStyle(fontSize: 25, color: AppColors().ligh_grey),
        ),
        actions: <Widget>[
          IconButton(
            iconSize: 40,
            icon: Icon(
              Icons.search,
              color: AppColors().ligh_grey,
            ),
            onPressed: () async {
              // search product name
            },
          ),
        ],
      ),
      body: new TabBarView(
        controller: controller,
        children: [
          futureBuilderSavedRecipes,
          futureBuilderPossibleRecipes
        ],
      ),
    );
  }
}
