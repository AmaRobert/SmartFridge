
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:smart_fridge/models/Product.dart';
import 'package:smart_fridge/models/Recipe.dart';
import 'package:translator/translator.dart';
import 'package:smart_fridge/models/User.dart';
import 'RecipeApiProvider.dart';

Future<bool> signIn(String email, String password) async {
  try {
    await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password);
    return true;
  } catch (e) {
    print(e);
    return false;
  }
}
 getCurrentUser()async{
  return FirebaseAuth.instance.currentUser;
}

Future<bool> register(String email, String password) async {
  try {
    print("registerBefore");
    await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password);
    return true;
  } on FirebaseAuthException catch (e) {
    if (e.code == 'weak-password') {
      print('The password provided is too weak.');
    } else if (e.code == 'email-already-in-use') {
      print('The account already exists for that email.');
    }
    return false;
  } catch (e) {
    print(e.toString());
    return false;
  }
}



Future<bool> addProduct(String barcode, String name, String quantity, String price, String expirationDate, String url) async {
  try {
    String uid = FirebaseAuth.instance.currentUser.uid;
    DocumentReference documentReference = FirebaseFirestore.instance
        .collection('Users')
        .doc(uid)
        .collection('Products')
        .doc(barcode);
    String translatedName = await translate(name);
    String generalName = await RecipeApiProvider.instance.generateNameOfProduct(translatedName);
    FirebaseFirestore.instance.runTransaction((transaction) async {
      DocumentSnapshot snapshot = await transaction.get(documentReference);
      if (!snapshot.exists) {
        documentReference.set({ 'Name': name,
                                 'GeneralName': generalName,
                                'Quantity': quantity,
                                'Price': price,
                                'ExpirationDate': expirationDate,
                                'ImageUrl': url});
        return true;
      }
      //double newAmount = snapshot.data()['Amount'] + value;
      //transaction.update(documentReference, {'Amount': newAmount});
      return true;
    });
    return true;
  } catch (e) {
    return false;
  }
}


Future<bool> saveAccount(String firstName, String lastName, String email, String url) async {
  try {
    String uid = FirebaseAuth.instance.currentUser.uid;
    DocumentReference documentReference = FirebaseFirestore.instance
        .collection('Users')
        .doc(uid);
    FirebaseFirestore.instance.runTransaction((transaction) async {
      DocumentSnapshot snapshot = await transaction.get(documentReference);
      documentReference.set({ 'FirstName': firstName,
        'LastName': lastName,
        'Email': email,
        'ImageUrl': url
      });
      return true;

      //double newAmount = snapshot.data()['Amount'] + value;
      //transaction.update(documentReference, {'Amount': newAmount});
      return true;
    });
    return true;
  } catch (e) {
    return false;
  }
}

Future<bool> saveRecipe(Recipe recipe, List<String> steps) async {
  try {
    String uid = FirebaseAuth.instance.currentUser.uid;
    DocumentReference documentReference = FirebaseFirestore.instance
        .collection('Users')
        .doc(uid)
        .collection('Recipes')
        .doc(recipe.id);
    FirebaseFirestore.instance.runTransaction((transaction) async {
      DocumentSnapshot snapshot = await transaction.get(documentReference);
      if (!snapshot.exists) {
        documentReference.set({ 'title': recipe.title,
          'ImageUrl': recipe.imageUrl,
          'missedIngredients': recipe.missedIngredients,
          'usedIngredients': recipe.usedIngredients,
          'steps': steps});
        return true;
      }
      //double newAmount = snapshot.data()['Amount'] + value;
      //transaction.update(documentReference, {'Amount': newAmount});
      return true;
    });
    return true;
  } catch (e) {
    return false;
  }
}

Future<bool> addProductInShopping(String barcode, String name, String quantity, String price, String expirationDate, String url) async {
  try {
    String uid = FirebaseAuth.instance.currentUser.uid;
    DocumentReference documentReference = FirebaseFirestore.instance
        .collection('Users')
        .doc(uid)
        .collection('Shop')
        .doc(barcode);
    String translatedName = await translate(name);
    String generalName = await RecipeApiProvider.instance.generateNameOfProduct(translatedName);
    FirebaseFirestore.instance.runTransaction((transaction) async {
      DocumentSnapshot snapshot = await transaction.get(documentReference);
      if (!snapshot.exists) {
        documentReference.set({ 'Name': name,
          'GeneralName': generalName,
          'Quantity': quantity,
          'Price': price,
          'ExpirationDate': expirationDate,
          'ImageUrl': url});
        return true;
      }
      //double newAmount = snapshot.data()['Amount'] + value;
      //transaction.update(documentReference, {'Amount': newAmount});
      return true;
    });
    return true;
  } catch (e) {
    return false;
  }
}
Future<String> translate(String text) async{
  final translator = GoogleTranslator();

  // Passing the translation to a variable
  var translation = await translator.translate(text, from: 'ro', to: 'en');

  return translation.toString();
}
Future<bool> addProductByBarcode(String barcode, String name, String quantity, String price, String expirationDate, String url) async {
  try {
    DocumentReference documentReference = FirebaseFirestore.instance
        .collection('Products')
        .doc(barcode);
    String translatedName = await translate(name);
    String generalName = await RecipeApiProvider.instance.generateNameOfProduct(translatedName);
    FirebaseFirestore.instance.runTransaction((transaction) async {
      DocumentSnapshot snapshot = await transaction.get(documentReference);
      if (!snapshot.exists) {
        documentReference.set({
          'Name': name,
          'GeneralName': generalName,
          'Quantity': quantity,
          'Price': price,
          'ExpirationDate': expirationDate,
          'ImageUrl': url});
        return true;
      }
      //double newAmount = snapshot.data()['Amount'] + value;
      //transaction.update(documentReference, {'Amount': newAmount});
      return true;
    });
    return true;
  } catch (e) {
    return false;
  }
}

Future<bool> barcodeExists(String barcode) async {
  try {
    DocumentReference documentReference = FirebaseFirestore.instance
        .collection('Products')
        .doc(barcode);
    return FirebaseFirestore.instance.runTransaction((transaction) async {
      DocumentSnapshot snapshot = await transaction.get(documentReference);
      if (!snapshot.exists) {
        return false;
      }
      //double newAmount = snapshot.data()['Amount'] + value;
      //transaction.update(documentReference, {'Amount': newAmount});
      return true;
    });
  } catch (e) {
    return false;
  }
}

Future<Product> getProductByBarcode(String barcode) async {
  try {
    DocumentReference documentReference = FirebaseFirestore.instance
        .collection('Products')
        .doc(barcode);
    return FirebaseFirestore.instance.runTransaction((transaction) async {
      DocumentSnapshot snapshot = await transaction.get(documentReference);
      //double newAmount = snapshot.data()['Amount'] + value;
      //transaction.update(documentReference, {'Amount': newAmount});
      return Product(id: barcode, name: snapshot.data()['Name'], expirationDate: snapshot.data()['ExpirationDate'], price: snapshot.data()['Price'], quantity: snapshot.data()['Quantity'], imageUrl: snapshot.data()['ImageUrl'], generalName: snapshot.data()['GeneralName']);
    });
  } catch (e) {
    return null;
  }
}
Future<String> getImageUrlUser(String email) async{
  final ref = FirebaseStorage.instance
      .ref("Users/")
      .child(email);
  return await ref.getDownloadURL();
}
Future<String> getImageUrl(String barcode) async{
  final ref = FirebaseStorage.instance
      .ref()
      .child(barcode);
  return await ref.getDownloadURL();
}

Future<bool> removeProduct(String barcode) async {
  print(barcode);
  String uid = FirebaseAuth.instance.currentUser.uid;
  FirebaseFirestore.instance
      .collection('Users')
      .doc(uid)
      .collection('Products')
      .doc(barcode)
      .delete();
  return true;
}

Future<bool> removeRecipe(String id) async {
  String uid = FirebaseAuth.instance.currentUser.uid;
  FirebaseFirestore.instance
      .collection('Users')
      .doc(uid)
      .collection('Recipes')
      .doc(id)
      .delete();
  return true;
}

Future<bool> removeProductShopping(String barcode) async {
  print(barcode);
  String uid = FirebaseAuth.instance.currentUser.uid;
  FirebaseFirestore.instance
      .collection('Users')
      .doc(uid)
      .collection('Shop')
      .doc(barcode)
      .delete();
  return true;
}
