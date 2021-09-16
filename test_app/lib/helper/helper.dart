import 'package:shared_preferences/shared_preferences.dart';
import 'package:test_app/viewmodel/auth_view_model.dart';

class Helper {

  static final String isLogin = "isLogin";
  static final String? networkError = "NetworkError";
  static final int? hasLogin = 1;


  static Future<void> saveSessionLogin(dynamic response) async {
    SharedPreferences? _sharedPreferences = await SharedPreferences?.getInstance();
    AuthViewModel? _authViewModel = AuthViewModel();
    _authViewModel.setDataResponseLogin(response);

    _sharedPreferences.setInt(isLogin, 1);


  }

  static Future<void> logoutSession() async {
    SharedPreferences? _sharedPreferences = await SharedPreferences?.getInstance();
    _sharedPreferences.setBool(isLogin, false);
  }


}