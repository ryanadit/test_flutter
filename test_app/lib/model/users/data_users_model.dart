class DataUsersModel {

  int? id;
  String? email;
  String? firstName;
  String? lastName;
  String? avatar;
  String? createdAt;


  DataUsersModel({this.email, this.avatar, this.firstName, this.id, this.lastName, this.createdAt});

  factory DataUsersModel.fromJson(Map? json) => DataUsersModel(
    id: json?["id"],
    email: json?["email"],
    firstName: json?["first_name"],
    lastName: json?["last_name"],
    avatar: json?["avatar"],
    createdAt: json?["createdAt"],
  );

  Map? toJson() => {
    "email" : email,
    "first_name" : firstName,
    "last_name" : lastName
  };

}