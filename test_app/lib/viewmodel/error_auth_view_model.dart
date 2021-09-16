import 'package:test_app/model/error_auth_model.dart';

class ErrorAuthViewModel {

  ErrorAuthModel? _errorAuthModel;

  setErrorAuth(dynamic post) {
    _errorAuthModel = ErrorAuthModel.fromJson(post);
  }

  ErrorAuthModel? get errorAuthResponse => _errorAuthModel;

}