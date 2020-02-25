import 'dart:convert';
import 'package:http/http.dart' as http;

class Auth {
  var token;
  var projectID;
  var sessionID;
  var projectName;
  Auth(String project) {
    getToken(project);
    projectName = project;
  }
  getToken(String projectName) async {
    var url = 'https://loopback-bot-dialogflow.holaa.ai/dialogflowapi/gettoken';
    var response = await http.post(url, body: {"projectname": projectName});
    Map userMap = jsonDecode(response.body);
    print(jsonDecode(response.body));
    token = userMap['token'];
    projectID = userMap['project_id'];
    sessionID = userMap['session_id'];
  }
}
