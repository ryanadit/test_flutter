import 'package:test_app/model/users/data_users_model.dart';
import 'package:test_app/model/users/support_users_model.dart';

class UserDetailModel{

  DataUsersModel? data;
  SupportUsersModel? support;

  UserDetailModel({this.data, this.support});

  factory UserDetailModel.fromJson(Map? json) => UserDetailModel(
    data: DataUsersModel?.fromJson(json?["data"]),
    support: SupportUsersModel?.fromJson(json?["support"])
  );

}