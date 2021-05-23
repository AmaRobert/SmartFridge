import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:smart_fridge/utils/AppColors.dart';
import 'package:smart_fridge/models/Product.dart';

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

    controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Material(
        color: Colors.transparent,
        child: ScaleTransition(
          scale: scaleAnimation,
          child: Container(
            width: 120,
            height: 150,
            decoration: ShapeDecoration(
                color: AppColors().burnt_sienna,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0))),
            child: ListView(
                children:[
                  Center(
                    child: Padding(
                      padding: EdgeInsets.all(10),
                      child: Text(widget.product.name),
                    ),
                  ),
                  Center(
                    child: Padding(
                      padding: EdgeInsets.all(10),
                      child: Text(widget.product.quantity),
                    ),
                  ),
                  Center(
                    child: Padding(
                    padding: EdgeInsets.all(10),
                    child: Text(widget.product.price),
                    ),
                  ),
                  Center(
                    child: Padding(
                      padding: EdgeInsets.all(10),
                      child: Text(widget.product.expirationDate),
                    ),
                  ),
                ],
              ),
          ),
        ),
      ),
    );
  }
}