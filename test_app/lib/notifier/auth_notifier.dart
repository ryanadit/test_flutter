import 'package:flutter/cupertino.dart';
import 'package:test_app/api/api_service.dart';
import 'package:test_app/helper/helper.dart';

class AuthNotifier with ChangeNotifier {

  Map? _responseLogin = {};

  setDataResponseLogin(dynamic post) {
    _responseLogin = {};
    _responseLogin = post;
    notifyListeners();
  }

  Map? getDataResponseLogin() => _responseLogin;

  Future actionLogin(dynamic bodyObject) async {
    final response = await ApiService.login(bodyObject);
    if(response != Helper.networkError && response != null) {
      if(response is Map){
        setDataResponseLogin(response);
        return response;
      }
      return;
    }
    return;
  }


}