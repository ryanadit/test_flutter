import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';
import 'package:test_app/helper/helper_widget.dart';
import 'package:test_app/page/login_page/login_page.dart';
import 'package:test_app/viewmodel/auth_view_model.dart';

class Helper {

  static final String isLogin = "isLogin";
  static final String accessToken = "token";
  static final String? networkError = "NetworkError";
  static final int? hasLogin = 1;

  // FLAG UPDATE AND CREATE USERS
  static final String modeCreate = "create";
  static final String modeUpdate = "update";

  static final RegExp regexEmail = RegExp(r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$');


  static Future<void> saveSessionLogin(dynamic response) async {

    SharedPreferences? _sharedPreferences = await SharedPreferences?.getInstance();
    AuthViewModel? _authViewModel = AuthViewModel();
    _authViewModel.setDataResponseLogin(response);
    final token = _authViewModel.loginResponse?.token;
    _sharedPreferences.setInt(isLogin, 1);
    _sharedPreferences.setString(accessToken, token.toString());
    print(_sharedPreferences.get(isLogin));

  }

  static Future<void> logoutSession(BuildContext context) async {
    SharedPreferences? _sharedPreferences = await SharedPreferences?.getInstance();
    ProgressDialog? pd;
    pd = WidgetHelper.progressDialogShow(context, pd);
    _sharedPreferences.clear();
    Future.delayed(Duration(milliseconds: 400)).then((value) {
      pd!.close();
      Navigator.of(context).pushNamedAndRemoveUntil(LoginPage.route_name, (route) => false);
    });

  }


}