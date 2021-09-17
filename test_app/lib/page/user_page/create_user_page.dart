import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';
import 'package:test_app/helper/helper.dart';
import 'package:test_app/helper/helper_widget.dart';
import 'package:test_app/model/users/data_users_model.dart';
import 'package:test_app/notifier/users_notifier.dart';

class CreateUserPage extends StatefulWidget {

  static const String route_name = "/create_user";

  final String? mode;
  final DataUsersModel? usersModel;

  CreateUserPage({
    Key? key,
    required this.mode,
    this.usersModel
  }) : super(key: key);

  @override
  _CreateUserPageState createState() => _CreateUserPageState(
    mode: mode,
    usersModel: usersModel
  );
}

class _CreateUserPageState extends State<CreateUserPage> {

  String? mode;
  DataUsersModel? usersModel;

  _CreateUserPageState({this.mode, this.usersModel});
  TextEditingController? _textFirstNameEditingController = TextEditingController();
  TextEditingController? _textLastNameEditingController = TextEditingController();
  TextEditingController? _textEmailEditingController = TextEditingController();
  String? _flagFirstName = "firstName";
  String? _flagLastName = "LastName";
  String? _flagEmail = "email";
  String? _valueEmail;
  String? _valueLastName;
  String? _valueFirstName;
  UsersNotifier? _usersNotifier;
  ProgressDialog? pd;
  final _keyForm = GlobalKey<FormState>();

  _alertSave(BuildContext context) async {
    final title = "Konfirmasi";
    final message = "Apakah anda yakin ingin menyimpan?";
    final form = _keyForm.currentState;
    form?.save();

    if(form!.validate()) return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        if(Platform.isIOS) {
          return CupertinoAlertDialog(
            title: Padding(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).size.height/75
              ),
              child: Text("$title",
                style: GoogleFonts.poppins(
                    fontSize: MediaQuery.of(context).size.height/45,
                    fontWeight: FontWeight.w500,
                    color: Colors.deepOrange
                ),
              ),
            ),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text("$message",
                    style: GoogleFonts.poppins(
                        fontSize: MediaQuery.of(context).size.height/50,
                        fontWeight: FontWeight.normal
                    ),
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              CupertinoDialogAction(
                child: Text('OK',
                  style: GoogleFonts.poppins(
                      fontSize: MediaQuery.of(context).size.height/55,
                      color: Colors.teal
                  ),),
                onPressed: () async {
                  Navigator.of(context).pop();
                  await _saveDataUsers();
                },
              ),
              CupertinoDialogAction(
                child: Text('Batal',
                  style: GoogleFonts.poppins(
                      fontSize: MediaQuery.of(context).size.height/55,
                      color: Colors.redAccent
                  ),),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        } else {
          return AlertDialog(
            title: Padding(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).size.height/75
              ),
              child: Text(title,
                style: GoogleFonts.poppins(
                    fontSize: MediaQuery.of(context).size.height/45,
                    fontWeight: FontWeight.w500,
                    color: Colors.deepOrange
                ),
              ),
            ),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text(message,
                    style: GoogleFonts.roboto(
                        fontSize: MediaQuery.of(context).size.height/50,
                        fontWeight: FontWeight.normal
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                child: Text('OK',
                  style: GoogleFonts.poppins(
                      fontSize: MediaQuery.of(context).size.height/55,
                      color: Colors.teal
                  ),),
                onPressed: () async {
                  Navigator.of(context).pop();
                  await _saveDataUsers();
                },
              ),
              TextButton(
                child: Text('Batal',
                  style: GoogleFonts.poppins(
                      fontSize: MediaQuery.of(context).size.height/55,
                      color: Colors.redAccent
                  ),),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        }

      },
    );
    return ;
  }

  Future<void> _saveDataUsers() async {
    _usersNotifier = Provider.of(context, listen: false);
    dynamic response;
    if(mode == Helper.modeCreate) {
      pd = WidgetHelper.progressDialogShow(context, pd);
      final object = DataUsersModel(
          email: _valueEmail,
          firstName: _valueFirstName,
          lastName: _valueLastName
      ).toJson();
      final bodyObject = jsonEncode(object);
      print(bodyObject);
      response = await _usersNotifier?.actionUserCreate(bodyObject);
    } else {
      pd = WidgetHelper.progressDialogShow(context, pd);
      final object = DataUsersModel(
          email: _valueEmail,
          firstName: _valueFirstName,
          lastName: _valueLastName
      ).toJson();
      final bodyObject = jsonEncode(object);
      response = await _usersNotifier?.actionUserUpdate(bodyObject, usersModel?.id.toString());
    }

    if(response != null) {
      print(response);
      Future.delayed(Duration(milliseconds: 300)).then((value) {
        pd!.close();
        if(mode == Helper.modeCreate) {
          WidgetHelper.alertDialog(context, "Success", "Sukses create employee", WidgetHelper.modeAlertBackPrevious);
        } else {
          WidgetHelper.alertDialog(context, "Success", "Sukses update employee", WidgetHelper.modeAlertBackHome);
        }

      });
    } else {
      pd!.close();
      WidgetHelper.alertDialog(context, "Gagal", "Ada kesalahan, mohon coba lagi", WidgetHelper.modeAlertBack);
    }



  }

  // TODO SET VALUE USER
  void _setDataUser() {
    if(mounted)setState(() {
      _textFirstNameEditingController = TextEditingController(text: usersModel?.firstName);
      _textLastNameEditingController = TextEditingController(text: usersModel?.lastName);
      _textEmailEditingController = TextEditingController(text: usersModel?.email);
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if(mode == Helper.modeUpdate)_setDataUser();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _textLastNameEditingController?.dispose();
    _textFirstNameEditingController?.dispose();
    _textEmailEditingController?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildBodyContent(),
    );
  }

  AppBar _buildAppBar() {
    final _mediaHeight = MediaQuery.of(context).size.height;
    final _mediaWidth = MediaQuery.of(context).size.width;
    String? titleAppBar = "Create Employee";

    if(mode == Helper.modeUpdate) titleAppBar = "Update Employee";

    return AppBar(
      title: Text("$titleAppBar",
        style: GoogleFonts.poppins(
            fontSize: _mediaHeight/40
        ),
      ),
      leading: IconButton(
        icon: Icon(
          Icons.clear,
        ),
        onPressed: () {
          Navigator.of(context).pop();
        },
      ),
      actions: [
        TextButton(
            onPressed: () {
              _alertSave(context);
            },
            child: Text("Simpan",
              style: GoogleFonts.poppins(
                  fontSize: _mediaHeight/50,
                  fontWeight: FontWeight.w300,
                color: Colors.white
              ),
            ),
        ),
      ],
    );
  }

  Widget _buildBodyContent() {
    final _mediaHeight = MediaQuery.of(context).size.height;
    final _mediaWidth = MediaQuery.of(context).size.width;

    return SingleChildScrollView(
      child: Container(
        width: _mediaWidth,
        height: _mediaHeight,
        padding: EdgeInsets.symmetric(
            horizontal: _mediaWidth/10,
            vertical: _mediaHeight/50
        ),
        child: Form(
          key: _keyForm,
          child: Column(
            children: [
              _buildTextField(_textEmailEditingController, "Email", _flagEmail, Icons.alternate_email_rounded),
              _buildTextField(_textFirstNameEditingController, "First Name", _flagFirstName, Icons.person),
              _buildTextField(_textLastNameEditingController, "Last Name", _flagLastName, Icons.person),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController? textEditingController, String? title, String? flagType, IconData icons) {
    final _mediaHeight = MediaQuery.of(context).size.height;
    final _mediaWidth = MediaQuery.of(context).size.width;

    var _keyboardType = TextInputType.text;

    final _errorBorder = OutlineInputBorder(borderRadius:BorderRadius.circular(_mediaWidth/40),
        borderSide: BorderSide(color: Colors.redAccent, width: _mediaWidth/500));

    final _icon = Container(
      margin: EdgeInsets.only(
        right: _mediaWidth/80
      ),
      child: Icon(
        icons,
        color: Colors.blueGrey,
        size: _mediaHeight/30,
      ),
    );

    return Container(
      margin: EdgeInsets.symmetric(
        vertical: _mediaHeight/90
      ),
      child: Row(
        children: [
          _icon,
          Flexible(
            child: Container(
              child: TextFormField(
                controller: textEditingController,
                cursorColor: Colors.blueAccent,
                onSaved: (val) {
                  setState(() {
                    if(flagType == _flagEmail) _valueEmail = val;
                    if(flagType == _flagFirstName) _valueFirstName = val;
                    if(flagType == _flagLastName) _valueLastName = val;
                  });
                },
                validator: (val) {
                  if(val!.isEmpty) {
                    return "$title is Empty";
                  }
                  else if(flagType == _flagEmail && !val.contains(Helper.regexEmail)) {
                    return "$title wrong format";
                  }
                  return null;
                },
                keyboardType: _keyboardType,
                style: GoogleFonts.poppins(
                    color: Colors.grey.shade800,
                    fontWeight: FontWeight.w600,
                    fontSize: _mediaHeight/50
                ),
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(
                      horizontal: _mediaWidth/30,
                      vertical: _mediaHeight/50
                  ),
                  fillColor: Colors.white,
                  filled: true,
                  labelText: "$title",
                  labelStyle: GoogleFonts.poppins(
                      color: Colors.grey,
                      fontWeight: FontWeight.w600,
                      fontSize: _mediaHeight/55
                  ),
                  enabledBorder: OutlineInputBorder(borderRadius:BorderRadius.circular(_mediaWidth/40),
                      borderSide: BorderSide(color: Colors.blueGrey, width: _mediaWidth/500)),
                  focusedErrorBorder: _errorBorder,
                  errorBorder: _errorBorder,
                  focusedBorder: OutlineInputBorder(borderRadius:BorderRadius.circular(_mediaWidth/40),
                      borderSide: BorderSide(color: Colors.blueAccent, width: _mediaWidth/500)),
                  prefixIconConstraints: BoxConstraints(
                      maxWidth: _mediaWidth/15
                  ),
                  prefixStyle: TextStyle(color: Colors.transparent),


                ),
              ),
            ),
          )
        ],
      ),
    );
  }

}
