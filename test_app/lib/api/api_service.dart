import 'dart:convert';

import 'package:http/http.dart' as http;

class ApiService {

  static final String? url = "https://reqres.in/api";
  static final String? urlLogin = "/login";
  static final String? urlListUser = "/users";

  // TODO : METHOD POST
  static login(dynamic bodyObject) async {
    try{
      final http.Response response =  await http.post(
          Uri.parse("$url$urlLogin"),
          headers: {
            'Content-Type': 'application/json; charset=UTF-8'
          },
          body: bodyObject
      );
      return checkResponse(response);
    } catch (exception) {
      print(exception);
      return checkException(exception);
    }

  }

  // TODO : METHOD GET


  static checkResponse(http.Response response){
    if(response.statusCode == 200){
      String body = utf8.decode(response.bodyBytes);
      final responseJson = jsonDecode(body);
      //print(response.body.runtimeType);
      return responseJson;
    }else{
      return json.decode(response.body);
    }
  }

  static checkException(dynamic exception){
    if(exception.toString().contains('SocketException')) {
      return 'NetworkError';
    } else {
      return null;
    }
  }

}