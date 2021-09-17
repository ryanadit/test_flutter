import 'package:test_app/model/users/user_detail_model.dart';

class UserDetailViewModel {

  UserDetailModel? _dataUsersModel;

  setDataUser(dynamic json){
    _dataUsersModel = UserDetailModel?.fromJson(json);
  }

  UserDetailModel? get getDataUser => _dataUsersModel;

}