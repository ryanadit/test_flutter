class LoginModel {

  String? email;
  String? password;
  String? token;

  LoginModel({
    this.token,
    this.email,
    this.password
  });

  factory LoginModel.fromJson(Map? json) => LoginModel(
    email: json?["email"],
    password: json?["password"],
    token: json?["token"]
  );

  Map? toJson() => {
    "email" : email,
    "password" : password
  };

}