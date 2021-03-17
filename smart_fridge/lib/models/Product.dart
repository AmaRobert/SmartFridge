class Product{
  int id;
  String name;
  String quantity;
  String price;
  String expirationDate;

  Product({this.id, this.name, this.quantity, this.price, this.expirationDate});
  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(id: json['id'], name:  json['name'], expirationDate: json['expirationDate'], quantity: json['quantity'], price: json['price']);
  }
}