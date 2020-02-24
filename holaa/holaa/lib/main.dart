import 'dart:core';

import 'package:flutter/material.dart';
import 'package:holaa/Constant/Constant.dart';
import 'package:holaa/Screens/ChatScreen.dart';

main() {
  runApp(new MaterialApp(
    title: 'Fluter',
    debugShowCheckedModeBanner: false,
    theme: new ThemeData(
      accentColor: Colors.blue,
      primaryColor: Colors.white,
      primaryColorDark: Colors.white,
      fontFamily: 'Gamja Flower',
    ),
    home: new MyChatScreen(),
    routes: <String, WidgetBuilder>{
      CHAT_SCREEN: (BuildContext context) => new MyChatScreen()
    },
  ));
}
