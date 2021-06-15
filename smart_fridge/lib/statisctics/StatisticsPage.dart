import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:smart_fridge/utils/AppColors.dart';

class StatisticsPage extends StatefulWidget {
  @override
  _StatisticsPageState createState() => _StatisticsPageState();
}

class _StatisticsPageState extends State<StatisticsPage> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: Colors.pink,
      appBar: new AppBar(
        title: new Text("Statistics Page"),
        backgroundColor: AppColors().navy,
      ),
      body: new Center(
        child: new Text("This is the statistics page"),
      ),
    );
  }
}
