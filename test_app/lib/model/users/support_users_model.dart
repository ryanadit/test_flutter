class SupportUsersModel{

  String? url;
  String? text;

  SupportUsersModel({this.text, this.url});

  factory SupportUsersModel.fromJson(Map? json) => SupportUsersModel(
    url: json?["url"],
    text: json?["text"]
  );

}