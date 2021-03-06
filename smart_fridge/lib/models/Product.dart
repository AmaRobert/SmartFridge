class Product{
  String id;
  String name;
  String quantity;
  String price;
  String expirationDate;
  String imageUrl;
  String generalName;

  Product({this.id, this.name, this.quantity, this.price, this.expirationDate, this.imageUrl, this.generalName});
  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(id: json['id'], name:  json['name'], expirationDate: json['expirationDate'], quantity: json['quantity'], price: json['price'], imageUrl: json['imageUrl'], generalName: json['GeneralName']);
  }
}