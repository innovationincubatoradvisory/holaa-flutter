import 'dart:core';
import 'package:flutter/material.dart';
import 'package:holaa/Screens/ChatScreen.dart';
import 'package:holaa/Utils/auth.dart';

main(String projectName) {
  var auth = new Auth(projectName);
  runApp(new MaterialApp(
    title: 'Holaa',
    debugShowCheckedModeBanner: false,
    theme: new ThemeData(
      accentColor: Colors.blue,
      primaryColor: Colors.white,
      primaryColorDark: Colors.white,
      fontFamily: 'Gamja Flower',
    ),
    home: new MyChatScreen(auth: auth),
    routes: <String, WidgetBuilder>{
      '/MyChatScreen': (BuildContext context) => new MyChatScreen(auth: auth),
    },
  ));
}
