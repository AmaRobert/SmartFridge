import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:smart_fridge/models/Recipe.dart';

//This file will handle all our API calls to the
//Spoonacular API
class RecipeApiProvider{
  //The API service will be a singleton, therefore create a private constructor
  //ApiService._instantiate(), and a static instance variable
  RecipeApiProvider._instantiate();
  static final RecipeApiProvider instance = RecipeApiProvider._instantiate();

  //Add base URL for the spoonacular API, endpoint and API Key as a constant
  final String _baseURL = "api.spoonacular.com";
  static const String API_KEY = "a4450a545b7a40c89c60cf437043c1bb";

  //We create async function to generate meal plan which takes in
  //timeFrame, targetCalories, diet and apiKey
  //If diet is none, we set the diet into an empty string
  //timeFrame parameter sets our meals into 3 meals, which are daily meals.
  //that's why it's set to day
  Future<String> generateNameOfProduct(String product) async {
    //check if diet is null
    Map<String, String> parameters = {
      'locale': "en_US",
      'apiKey': API_KEY,
    };

    //The Uri consists of the base url, the endpoint we are going to use. It has also
    //parameters
    Uri uri = Uri.https(
      _baseURL,
      'food/products/classify',
      parameters,
    );

    //Our header specifies that we want the request to return a json object
    Map<String, String> headers = {
      HttpHeaders.contentTypeHeader: 'application/json',
    };

    /*
    Our try catch uses http.get to retrieve response.
    It then decodes the body of the response into a map,
    and converts the map into a mealPlan object
    by using the facory constructor MealPlan.fromMap
    */
    try {
      //http.get to retrieve the response
      var response = await http.post(uri, headers: headers, body: jsonEncode({ "title": product, "upc": "", "plu_code": "" }));
      //decode the body of the response into a map
      Map<String, dynamic> data = json.decode(response.body);
      //convert the map into a MealPlan Object using the factory constructor,
      //MealPlan.fromMap
      String name = data['matched'];
      return name;
      //MealPlan mealPlan = MealPlan.fromMap(data);
    } catch (err) {
      //If our response has error, we throw an error message
      throw err.toString();
    }
  }
  Future<List<String>> getRecipeInstructions(String id) async {
    Map<String, String> parameters = {
      'stepBreakdown': 'true',
      'apiKey': API_KEY,
    };

    //we call in our recipe id in the Uri, and parse in our parameters
    Uri uri = Uri.https(
      _baseURL,
      '/recipes/$id/analyzedInstructions',
      parameters,
    );

    //And also specify that we want our header to return a json object
    Map<String, String> headers = {
      HttpHeaders.contentTypeHeader: 'application/json',
    };

    //finally, we put our response in a try catch block
    try{
      var response = await http.get(uri, headers: headers);
      List<dynamic> data = json.decode(response.body);
      List<dynamic> mySteps = data.elementAt(0)['steps'];
      List<String> steps = List();
      for(int index = 0; index < mySteps.length; index++){
        steps.add(mySteps.elementAt(index)['step']);
      }
      return steps;
    }catch (err) {
      throw err.toString();
    }
  }

  Future<List<Recipe>> generateRecipesByIngredients(String ingredients) async {
    //check if diet is null
    Map<String, String> parameters = {
      'ingredients': ingredients,
      'number': '10',
      'limitLicense': 'true',
      'ranking': '2',
      'ignorePantry': 'true',
      'apiKey': API_KEY,
    };

    //The Uri consists of the base url, the endpoint we are going to use. It has also
    //parameters
    Uri uri = Uri.https(
      _baseURL,
      'recipes/findByIngredients',
      parameters,
    );

    //Our header specifies that we want the request to return a json object
    Map<String, String> headers = {
      HttpHeaders.contentTypeHeader: 'application/json',
    };

    /*
    Our try catch uses http.get to retrieve response.
    It then decodes the body of the response into a map,
    and converts the map into a mealPlan object
    by using the facory constructor MealPlan.fromMap
    */
    try {
      //http.get to retrieve the response
      var response = await http.get(uri, headers: headers);
      //decode the body of the response into a map
      List<dynamic> data = json.decode(response.body);
      //convert the map into a MealPlan Object using the factory constructor,
      //MealPlan.fromMap
      List<Recipe> recipes = List();
      for(int index=0; index < data.length; index++){
        Recipe recipe = Recipe.fromMap(data[index]);
        recipes.add(recipe);
      }
      return recipes;
      //MealPlan mealPlan = MealPlan.fromMap(data);
    } catch (err) {
      //If our response has error, we throw an error message
      throw err.toString();
    }
  }

  //the fetchRecipe takes in the id of the recipe we want to get the info for
  //We also specify in the parameters that we don't want to include the nutritional
  //information
  //We also parse in our API key
  Future<Recipe> fetchRecipe(String id) async {
    Map<String, String> parameters = {
      'includeNutrition': 'false',
      'apiKey': API_KEY,
    };

    //we call in our recipe id in the Uri, and parse in our parameters
    Uri uri = Uri.https(
      _baseURL,
      '/recipes/$id/information',
      parameters,
    );

    //And also specify that we want our header to return a json object
    Map<String, String> headers = {
      HttpHeaders.contentTypeHeader: 'application/json',
    };

    //finally, we put our response in a try catch block
    try{
      var response = await http.get(uri, headers: headers);
      Map<String, dynamic> data = json.decode(response.body);
      Recipe recipe = Recipe.fromMap(data);
      return recipe;
    }catch (err) {
      throw err.toString();
    }
  }
}
