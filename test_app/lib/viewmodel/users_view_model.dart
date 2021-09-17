import 'package:test_app/model/users/users_model.dart';

class UsersViewModel {

  UsersModel? _usersModel;

  setDataUsers(dynamic json) {
    _usersModel = UsersModel?.fromJson(json);
  }

  UsersModel? get getDataUser => _usersModel;

}