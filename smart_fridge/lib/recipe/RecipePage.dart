import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:smart_fridge/models/Recipe.dart';
import 'package:smart_fridge/utils/AppColors.dart';
import 'package:smart_fridge/utils/flutterfire.dart';
import 'package:webview_flutter/webview_flutter.dart';

class RecipeScreen extends StatefulWidget {
  //This stateful widget page takes in String mealType and Recipe recipe
  final Recipe recipe;
  final List<String> steps;
  RecipeScreen({ this.recipe, this.steps});
  @override
  _RecipeScreenState createState() => _RecipeScreenState();
}
class _RecipeScreenState extends State<RecipeScreen> {
  void addMissedIngredientsToShoppingList(Recipe recipe){
    for(int index=0; index < recipe.missedIngredients.length; index++){
      addProductInShopping(recipe.missedIngredients.elementAt(index)['id'].toString(),
          recipe.missedIngredients.elementAt(index)['name'],
          recipe.missedIngredients.elementAt(index)['amount'].toString(),
          "0",
          "",
          recipe.missedIngredients.elementAt(index)['image']
      );
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //AppBar is widget.mealType
      appBar: AppBar(
        backgroundColor: AppColors().navy,
        title: Text(widget.recipe.title),
      ),
      /**
       * Body is a Webview. Ensure you have imported webview flutter.
       *
       * initialUrl- spoonacularSourceUrl of our parsed in recipe
       * javascriptMode - set to unrestricted so as JS can load in the webview
       */
      body: Container(
        color: AppColors().ochre,
        child: Column(
          children: <Widget>[
            Image(
              image: NetworkImage(widget.recipe.imageUrl,scale: 0.7)
            ),
            Text("Ingredients: ", style: TextStyle(
                  fontSize: 30,
                  color: AppColors().ligh_grey
                ),),
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(left: 100, top: 16),
                child: ListView.builder(
                    itemCount: widget.recipe.usedIngredients.length + widget.recipe.missedIngredients.length,
                    itemBuilder: (context, index){
                      int usedLength = widget.recipe.usedIngredients.length;
                      if(index < usedLength)
                        return Row(
                          children: [
                            Text(widget.recipe.usedIngredients.elementAt(index)['original'],
                              style: TextStyle(color: AppColors().ligh_grey),
                            ),
                            Icon(Icons.check, color: Colors.green,)
                          ],
                        );
                      else
                        return Row(
                          children: [
                            Text(widget.recipe.missedIngredients.elementAt(index - usedLength)['original'],
                              style: TextStyle(color: AppColors().ligh_grey),
                            ),
                            Icon(Icons.block, color: Colors.red,)
                          ],
                        );
                    }),
              ),
            ),
            Text("Steps: ", style: TextStyle(
                fontSize: 30,
                color: AppColors().ligh_grey
            ),),
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(left: 0, top: 16),
                child: ListView.builder(
                    itemCount: widget.steps.length,
                    itemBuilder: (context, index){
                      return Text("Step " + (index + 1).toString() + ': ' + widget.steps.elementAt(index));
                    }),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          addMissedIngredientsToShoppingList(widget.recipe);
          saveRecipe(widget.recipe, widget.steps);
          Navigator.pop(context);
        },
        child: Icon(Icons.add, size: 40, color: AppColors().ligh_grey),
        backgroundColor: AppColors().navy,
      ),
    );
  }
}