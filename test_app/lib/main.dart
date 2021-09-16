import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test_app/helper/helper.dart';
import 'package:test_app/main_app.dart';
import 'package:test_app/page/home_page.dart';
import 'package:test_app/page/login_page/login_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences? sharedPreferences = await SharedPreferences.getInstance();
  String? initialRoute;
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    // transparent status bar
  ));

  // CHECKED LOGIN OR LOGOUT OR NEVER LOGIN
  final login = sharedPreferences.get(Helper.isLogin);
  if(login == Helper.hasLogin){
    initialRoute = LoginPage.route_name;
  } else {
    initialRoute = LoginPage.route_name;
  }



  runApp(MainApp(
    initialRoute: initialRoute,
  ));
}
