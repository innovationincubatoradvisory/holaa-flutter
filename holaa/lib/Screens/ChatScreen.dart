import 'dart:convert';
import 'dart:core';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:holaa/Utils/Message.dart';
import 'package:holaa/Utils/auth.dart';

class MyChatScreen extends StatefulWidget {
  const MyChatScreen({Key key, this.title, @required this.auth})
      : super(key: key);
  final String title;
  final Auth auth;
  @override
  _MyChatState createState() => new _MyChatState();
}

class _MyChatState extends State<MyChatScreen> {
  final List<Message> _messages = <Message>[];

  // Create a text controller. We will use it to retrieve the current value
  // of the TextField!
  final _textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Auth auth = widget.auth;
    DateTime time = DateTime.now();
    String formattedDate = DateFormat('yyyy-MM-dd hh:mm').format(time);

    return new Scaffold(
        appBar: new AppBar(
          backgroundColor: Color(0xff4b2e60),
          leading: IconButton(icon: Icon(Icons.arrow_back), onPressed: () {
            Navigator.pop(context);
          },),
          title: Text(
            auth.projectName.toUpperCase() + " FAQ",
            style: TextStyle(color: Color(0xffffffff)),
            textAlign: TextAlign.center,
          ),
        ),
        body: new Container(
            width: double.infinity,
            height: double.infinity,
            color: Colors.white,
            child: new Container(
              child: new Column(
                children: <Widget>[
                  //Chat list
                  new Flexible(
                    child: new ListView.builder(
                      padding: new EdgeInsets.all(8.0),
                      reverse: true,
                      itemBuilder: (_, int index) => _messages[index],
                      itemCount: _messages.length,
                    ),
                  ),
                  new Divider(height: 1.0),
                  new Container(
                      decoration:
                          new BoxDecoration(color: Theme.of(context).cardColor),
                      child: new IconTheme(
                          data: new IconThemeData(
                              color: Theme.of(context).accentColor),
                          child: new Container(
                            margin: const EdgeInsets.symmetric(horizontal: 2.0),
                            child: new Row(
                              children: <Widget>[
                                new Flexible(
                                  child: new TextField(
                                    controller: _textController,
                                    decoration: new InputDecoration.collapsed(
                                        hintText: "Enter message"),
                                  ),
                                ),

                                //right send button

                                new Container(
                                  margin:
                                      new EdgeInsets.symmetric(horizontal: 2.0),
                                  width: 48.0,
                                  height: 48.0,
                                  child: new IconButton(
                                      icon: Icon(Icons.send,
                                      color: Color(0xff4b2e60)),
                                      onPressed: () => _sendMsg(
                                          _textController.text,
                                          'right',
                                          formattedDate)),
                                ),
                              ],
                            ),
                          ))),
                ],
              ),
            )));
  }

  void _respondMsg(String msg, String messageDirection, String date) {
    if (msg.length == 0) {
      Fluttertoast.showToast(
          msg: "Error, Sorry!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIos: 1,
          backgroundColor: Colors.blue);
    } else {
      _textController.clear();
      Message message = new Message(
        msg: msg,
        direction: messageDirection,
        dateTime: date,
      );
      setState(() {
        _messages.insert(0, message);
      });
    }
  }

  void _sendMsg(String msg, String messageDirection, String date) async {
    if (msg.length == 0) {
      Fluttertoast.showToast(
          msg: "Please Enter Message",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIos: 1,
          backgroundColor: Colors.blue);
    } else {
      _textController.clear();
      Message message = new Message(
        msg: msg,
        direction: messageDirection,
        dateTime: date,
      );

      setState(() {
        _messages.insert(0, message);
      });

      String responder = await sendHolaa(
          msg, widget.auth.token, widget.auth.sessionID, widget.auth.projectID);
      var responder1 = jsonDecode(responder);
      print(responder1);
      var response = responder1['queryResult']['fulfillmentText'];

      _respondMsg(response, 'left', date);
    }
  }

  sendHolaa(
      String msg, String token, String sessionID, String projectID) async {
    var url =
        'https://dialogflow.googleapis.com/v2beta1/projects/$projectID/agent/sessions/$sessionID:detectIntent';
    var data =
        '{"queryInput": { "text": { "text": "$msg", "languageCode": "en" }}}';
    var dataJson = jsonDecode(data);
    var response = await http.post(url, body: jsonEncode(dataJson), headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    });
    print("reached");
    return response.body;
  }

  @override
  void initState() {
    super.initState();
    DateTime time = DateTime.now();
    String date = DateFormat('yyyy-MM-dd hh:mm').format(time);
    _respondMsg('holaa', 'left', date);

  }

  @override
  void dispose() {
    // Every listener should be canceled, the same should be done with this stream.
    // Clean up the controller when the Widget is disposed
    _textController.dispose();
    super.dispose();
  }
}
