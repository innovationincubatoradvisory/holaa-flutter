library holaa;

import 'package:flutter/material.dart';
import 'dart:core';

import 'package:holaa/Screens/ChatScreen.dart';
import 'package:holaa/Utils/auth.dart';

class Holaa {
  static holaaChat({
    @required BuildContext context,
    @required String projectName,
  }) {
    assert(context != null, "context is null!!");
    assert(projectName != null, "ProjectName is null!!");
    var auth = new Auth(projectName);
    return new Scaffold(
      
      body: new MyChatScreen(auth: auth),
      
    );
  }
}
