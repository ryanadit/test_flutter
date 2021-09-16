import 'package:test_app/model/login_model.dart';

class AuthViewModel {

  LoginModel? _loginModel;

  setDataResponseLogin(dynamic post) {
    _loginModel = LoginModel?.fromJson(post);
  }

  LoginModel? get loginResponse => _loginModel;

}