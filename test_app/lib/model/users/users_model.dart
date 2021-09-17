import 'package:test_app/model/users/data_users_model.dart';
import 'package:test_app/model/users/support_users_model.dart';

class UsersModel {

  int? page;
  int? perPage;
  int? total;
  int? totalPages;
  List<DataUsersModel>? data;
  SupportUsersModel? support;

  UsersModel({this.page, this.data, this.perPage, this.total, this.totalPages, this.support});

  factory UsersModel.fromJson(Map? json) => UsersModel(
    page: json?["page"],
    perPage: json?["per_page"],
    total: json?["total"],
    totalPages: json?["total_pages"],
    data: List<DataUsersModel>.from(json?["data"].map((e) {
      return DataUsersModel.fromJson(e);
    })),
    support: SupportUsersModel?.fromJson(json?["support"])
  );

}