

import 'package:smart_fridge/models/Product.dart';
import 'package:smart_fridge/utils/ServerProvider.dart';

class RepositoryServer{
  List<Product> productList;

  RepositoryServer(){
    this.productList = List<Product>();
    this.init();
  }

  void init() async{
    this.productList = await ServerProvider.server.fetchProducts();
  }

  void addProduct(String name, String expirationDate, String quantity, String price) async {
    Product product = Product(name: name, expirationDate: expirationDate, quantity: quantity, price: price);
    await ServerProvider.server.postProduct(product);
  }

  void removeProduct(int id) async{
    this.productList.removeWhere((product) => product.id == id);
    await ServerProvider.server.deleteProduct(id);
  }

  void updateProduct(int id, String newName, String newExpirationDate, String newQuantity, String newPrice) async {
    await ServerProvider.server.putProduct(Product(id: id, name: newName, expirationDate: newExpirationDate, quantity: newQuantity, price: newPrice));
  }

  Product getProduct(int id) {
    return this.productList.firstWhere((product) => product.id == id);
  }

  int size(){
    return productList.length;
  }
}