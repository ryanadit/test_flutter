class ErrorAuthModel {

  String? error;

  ErrorAuthModel({this.error});

  factory ErrorAuthModel.fromJson(Map? json) => ErrorAuthModel(
    error: json?["error"]
  );

}