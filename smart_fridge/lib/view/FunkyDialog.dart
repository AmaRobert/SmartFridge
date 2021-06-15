import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:smart_fridge/utils/AppColors.dart';
import 'package:smart_fridge/models/Product.dart';
import 'package:smart_fridge/utils/flutterfire.dart';
import 'package:smart_fridge/utils/NotificationPlugin.dart';

class FunkyOverlay extends StatefulWidget {
  Product product;
  FunkyOverlay({this.product});
  @override
  State<StatefulWidget> createState() => FunkyOverlayState();
}

class FunkyOverlayState extends State<FunkyOverlay>
    with SingleTickerProviderStateMixin {
  AnimationController controller;
  Animation<double> scaleAnimation;

  onNotificationClick(String payload) {
    print('Payload $payload');
  }
  @override
  void initState() {
    super.initState();
    controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 450));
    scaleAnimation =
        CurvedAnimation(parent: controller, curve: Curves.elasticInOut);

    controller.addListener(() {
      setState(() {});
    });
    notificationPlugin.setOnNotificationClick(onNotificationClick);
    controller.forward();
  }

  Widget _buildExpirationWidget(){
    final DateTime now = DateTime.now();
    List<String> stringExpiration = widget.product.expirationDate.split('/');
    String savedDateString = "";
    if(stringExpiration.length == 3)
      savedDateString = stringExpiration[2] + '-' + stringExpiration[1] + '-' + stringExpiration[0];
    else{
      stringExpiration = widget.product.expirationDate.split('.');
      if(stringExpiration.length == 3){
        savedDateString = stringExpiration[2] + '-' + stringExpiration[1] + '-' + stringExpiration[0];
      }else
        savedDateString = widget.product.expirationDate;
    }

    final DateTime expirationDate = new DateFormat("yyyy-MM-dd").parse(savedDateString);
    int difference = expirationDate.difference(now).inDays;
    if(difference > 0)
      return Text("Expiration date: " + widget.product.expirationDate, style: TextStyle(fontSize: 18),);
    else
      return Row(
        children: [
          Text("Expiration date: " + widget.product.expirationDate, style: TextStyle(fontSize: 18),),
          Icon(Icons.block, color: Colors.red,)
        ],
      );

  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Material(
        color: Colors.transparent,
        child: ScaleTransition(
          scale: scaleAnimation,
          child: Stack(
              alignment: Alignment.topCenter,
              overflow: Overflow.visible,
              children: [
            Container(
              width: 300,
              height: 265,
              decoration: ShapeDecoration(
                  color: AppColors().burnt_sienna,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0))),
              child: Column(
                children: [
                  SizedBox(height: 80,),
                  Center(
                    child: Padding(
                      padding: EdgeInsets.all(10),
                      child: Text(
                        "Name: " + widget.product.name,
                        overflow: TextOverflow.ellipsis,

                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  ),
                  Center(
                    child: Padding(
                      padding: EdgeInsets.all(10),
                      child: Text(
                        "Quantity: " + widget.product.quantity,
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  ),
                  Center(
                    child: Padding(
                      padding: EdgeInsets.all(10),
                      child: Text(
                        "Price: " + widget.product.price,
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  ),
                  Center(
                    child: Padding(
                      padding: EdgeInsets.all(10),
                      child: _buildExpirationWidget(),
                    ),
                  ),
                ],
              ),
            ),
              Positioned(
                top: -75,
                child: new Container(
                  width: 150,
                  height: 150,
                  decoration:  new BoxDecoration(
                    shape: BoxShape.circle,
                    image: new DecorationImage(
                      fit:  BoxFit.fill,
                      image: NetworkImage(widget.product.imageUrl),
                    )
                  ),
                )
              ),
                Positioned(
                  right: 10.0,
                  child: GestureDetector(
                    onTap: ()async{
                      bool isRemoved = await removeProduct(widget.product.id);
                      if(isRemoved)
                        await notificationPlugin.cancelNotification();
                      Navigator.of(context).pop();
                    },
                    child: Align(
                      alignment: Alignment.topRight,
                      child: Icon(Icons.delete,color: AppColors().ligh_grey,size: 30,)
                    ),
                  ),
                ),
                Positioned(
                  left: 10.0,
                  child: GestureDetector(
                    onTap: ()async{
                      await addProductInShopping(widget.product.id, widget.product.name, widget.product.quantity, widget.product.price, widget.product.expirationDate, widget.product.imageUrl);
                      Navigator.of(context).pop();
                    },
                    child: Align(
                        alignment: Alignment.topLeft,
                        child: Icon(Icons.shopping_cart,color: AppColors().ligh_grey,size: 30,)
                    ),
                  ),
                )
          ]),
        ),
      ),
    );
  }
}
