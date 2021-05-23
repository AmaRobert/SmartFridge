import 'package:smart_fridge/models/Product.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';

class ServerProvider{
  final String url = "http://192.168.100.3:3007/";

  ServerProvider._();

  static final server = ServerProvider._();

  Future<List<Product>> fetchProducts() async {
    final response = await http.get(url + 'products');
    List<Product> productsList = List<Product>();
    if(response.statusCode == 200){
      jsonDecode(response.body).forEach((element){
        Product product = Product.fromJson(element);
        productsList.add(product);
      });
      return productsList;
    } else{
      throw Exception('Failed to load data!');
    }
  }

  Future<Product> postProduct(Product product) async {
    final response = await http.post(url + 'products',
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'name': product.name,
          'expirationDate': product.expirationDate,
          'quantity': product.quantity,
          'price': product.price
        }));
    if (response.statusCode == 200) {
      return Product.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Something went wrong!');
    }
  }

  Future<bool> putProduct(Product product) async {
    final response = await http.put(url + 'product/' + product.id.toString(),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'id': product.id.toString(),
          'name': product.name,
          'expirationDate': product.expirationDate,
          'quantity': product.quantity,
          'price': product.price
        }));
    if (response.statusCode == 200) {
      return true;
    } else {
      throw Exception('Something went wrong!');
    }
  }

  Future<bool> deleteProduct(int id) async {
    final response = await http.delete(url + 'product/' + id.toString());
    if (response.statusCode == 200) {
      return true;
    } else {
      throw Exception('Something went wrong!');
    }
  }
}