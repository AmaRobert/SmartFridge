/* This class is responsible for getting and displaying meals
in our webview
*/
class Recipe {
  final String id;
  final String title;
  final String imageUrl;
  final List<dynamic> missedIngredients;
  final List<dynamic> usedIngredients;
  //has Equipment, Ingredients, Steps, e.t.c
  Recipe({this.id, this.title, this.imageUrl, this.missedIngredients, this.usedIngredients});
  //The spoonacularSourceURL displays the meals recipe in our webview
  factory Recipe.fromMap(Map<String, dynamic> map) {
    return Recipe(
      id: map['id'].toString(),
      title: map['title'],
      imageUrl: map['image'],
      missedIngredients: map['missedIngredients'],
      usedIngredients: map['usedIngredients'],
    );
  }
}