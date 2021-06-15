import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:smart_fridge/utils/AppColors.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:smart_fridge/main.dart';
import 'package:smart_fridge/utils/flutterfire.dart';
import 'package:image_picker/image_picker.dart';
import 'file:///D:/Facultate/Facultate%20Semestrul%206/PBT/SmartFridge/smart_fridge/lib/authenticate/RegisterPage.dart';
import 'dart:io';
import 'file:///D:/Facultate/Facultate%20Semestrul%206/PBT/SmartFridge/smart_fridge/lib/authenticate/LogInPage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:smart_fridge/models/User.dart';
import 'package:firebase_storage/firebase_storage.dart';
class LogoutPage extends StatefulWidget {
  @override
  _LogoutPage createState() => _LogoutPage();
}

class _LogoutPage extends State<LogoutPage> {

  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();
  File _image;
  final TextEditingController userNameController = TextEditingController();
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  MyUser user;

  @override
  Widget build(BuildContext context) {
    Future getImage() async {
      var image = await ImagePicker.pickImage(source: ImageSource.gallery);

      setState(() {
        _image = image;
        print('Image Path $_image');
      });
    }

    Future<void> uploadFile() async {
      try {
        await FirebaseStorage.instance
            .ref("Users/" + user.email)
            .putFile(_image);
      } on FirebaseException catch (e) {
        // e.g, e.code == 'canceled'
      }
    }
    getUsers() async {
      DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection('Users')
          .doc(FirebaseAuth.instance.currentUser.uid)
          .get();

      user = MyUser(firstName: doc.data()['FirstName'], lastName: doc.data()['LastName'], email: doc.data()['Email'], imageUrl: doc.data()['ImageUrl']);
      print(user.firstName);
      print(user.lastName);
      print(user.email);
      print(user.imageUrl == "");
    }
    var futureBuilder = new FutureBuilder(
        future: getUsers(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
              return Center(child: CircularProgressIndicator());
            default:
              if (snapshot.hasError)
                return Center(child: new Text('Error :${snapshot.error}'));
              else
                return Container(
                  alignment: Alignment.topCenter,
                  margin: EdgeInsets.symmetric(horizontal: 30),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Align(
                              alignment: Alignment.center,
                              child: CircleAvatar(
                                radius: 100,
                                backgroundColor: AppColors().ochre,
                                child: ClipOval(
                                  child: new SizedBox(
                                    width: 180.0,
                                    height: 180.0,
                                    child: (_image!=null)?Image.file(
                                      _image,
                                      fit: BoxFit.fill,
                                    ):Image.network(
                                      user.imageUrl == "" ?  "https://socialistmodernism.com/wp-content/uploads/2017/07/placeholder-image.png" : user.imageUrl,
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 60.0),
                              child: IconButton(
                                icon: Icon(
                                  FontAwesomeIcons.camera,
                                  size: 30.0,
                                ),
                                onPressed: () {
                                  getImage();
                                },
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 50,
                        ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                            color: AppColors().dark_grey, border: Border.all(color: Colors.blue)),
                        child: TextField(
                          controller: firstNameController..text = user.firstName != "" ? user.firstName : "",
                          style: TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                              contentPadding: EdgeInsets.symmetric(horizontal: 10),
                              labelStyle: TextStyle(color: Colors.white),
                              icon: Text("Fist Name: ", style: TextStyle(color: Colors.white),),
                              // prefix: Icon(icon),
                              border: InputBorder.none),
                        ),
                      ),
                        SizedBox(height: 20),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                              color: AppColors().dark_grey, border: Border.all(color: Colors.blue)),
                          child: TextField(
                            controller: lastNameController..text = user.lastName != "" ? user.lastName : "",
                            style: TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                                contentPadding: EdgeInsets.symmetric(horizontal: 10),
                                labelStyle: TextStyle(color: Colors.white),
                                icon: Text("Last Name: ", style: TextStyle(color: Colors.white),),
                                // prefix: Icon(icon),
                                border: InputBorder.none),
                          ),
                        ),
                        SizedBox(height: 20),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                              color: AppColors().dark_grey, border: Border.all(color: Colors.blue)),
                          child: TextField(
                            readOnly: true,
                            controller: userNameController..text = user.email != "" ? user.email : "",
                            style: TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                                contentPadding: EdgeInsets.symmetric(horizontal: 10),
                                labelStyle: TextStyle(color: Colors.white),
                                icon: Text("UserName: ", style: TextStyle(color: Colors.white),),
                                // prefix: Icon(icon),
                                border: InputBorder.none),
                          ),
                        ),
                        SizedBox(height: 30),
                        MaterialButton(
                          elevation: 0,
                          minWidth: double.maxFinite,
                          height: 50,
                          onPressed: () async {
                            await uploadFile().then((value) async {
                              String url = await getImageUrlUser(user.email);
                              user.imageUrl = url;
                              await saveAccount(firstNameController.text, lastNameController.text, userNameController.text, url);
                              print("Account saved");
                            });
                          },
                          color: AppColors().navy,
                          child: Text('Save',
                              style: TextStyle(color: Colors.white, fontSize: 16)),
                          textColor: Colors.white,
                        ),
                        SizedBox(height: 30),
                        MaterialButton(
                          elevation: 0,
                          minWidth: double.maxFinite,
                          height: 50,
                          onPressed: () async {

                            await FirebaseAuth.instance.signOut();
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                builder: (BuildContext context) => LogInPage(),
                              ),
                                  (route) => false,
                            );

                          },
                          color: AppColors().navy,
                          child: Text('Logout',
                              style: TextStyle(color: Colors.white, fontSize: 16)),
                          textColor: Colors.white,
                        ),
                      ],
                    ),
                  ),
                );
          }
        });
    return Scaffold(
        appBar: new AppBar(
          title: new Text("Your Profile"),
          backgroundColor: AppColors().navy,
        ),
        backgroundColor: AppColors().ochre,
        body: futureBuilder);
  }

  _buildTextField(
      TextEditingController controller, IconData icon, String labelText) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
          color: AppColors().dark_grey, border: Border.all(color: Colors.blue)),
      child: TextField(
        controller: controller,
        style: TextStyle(color: Colors.white),
        decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(horizontal: 10),
            labelText: labelText,
            labelStyle: TextStyle(color: Colors.white),
            icon: Icon(
              icon,
              color: Colors.white,
            ),
            // prefix: Icon(icon),
            border: InputBorder.none),
      ),
    );
  }
}
