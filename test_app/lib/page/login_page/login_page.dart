import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';
import 'package:test_app/helper/helper.dart';
import 'package:test_app/helper/helper_widget.dart';
import 'package:test_app/model/login_model.dart';
import 'package:test_app/notifier/auth_notifier.dart';
import 'package:test_app/viewmodel/error_auth_view_model.dart';

import '../home_page.dart';

class LoginPage extends StatefulWidget {

  static const String route_name = "/login_page";

  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  TextEditingController? _textEmailEditingController = TextEditingController();
  TextEditingController? _textPasswordEditingController = TextEditingController();
  final _keyForm = GlobalKey<FormState>();
  String? _flagEmail = "email";
  String? _flagPass = "password";
  String? _textEmail;
  String? _textPass;
  bool _notVisiblePassword = true;
  ProgressDialog? pd;
  AuthNotifier? _authNotifier;

  void _toggle() {
    setState(() {
      _notVisiblePassword = !_notVisiblePassword;
    });
  }

  Future<void> _actionLogin() async {

    final form = _keyForm.currentState;
    form?.save();
    if(_textEmailEditingController!.text.trim().isNotEmpty && _textPasswordEditingController!.text.trim().isNotEmpty){
      setState(() {
        _textEmail = _textEmailEditingController!.text.trim();
        _textPass = _textPasswordEditingController!.text.trim();
      });
      if(_textEmail!.contains(Helper.regexEmail)) {
        pd = WidgetHelper.progressDialogShow(context, pd);
        _authNotifier = Provider.of(context , listen: false);
        final object = LoginModel(
            email: _textEmail,
            password: _textPass
        ).toJson();
        final bodyObject = jsonEncode(object);
        print(bodyObject);
        final response = await _authNotifier?.actionLogin(bodyObject);
        Future.delayed(Duration(milliseconds: 400)).then((value) async{
          print(response);
          ErrorAuthViewModel? _errorAuthViewModel = ErrorAuthViewModel();
          _errorAuthViewModel.setErrorAuth(response);
          pd!.close();
          if(response != null) {
            if(_errorAuthViewModel.errorAuthResponse?.error != null) {
              WidgetHelper.alertDialog(context, "Kesalahan", "${_errorAuthViewModel.errorAuthResponse?.error}", WidgetHelper.modeAlertBack);
            }else {
              await Helper.saveSessionLogin(response);
              Navigator.pushAndRemoveUntil(context,
                  MaterialPageRoute(builder: (_) => HomePage()),
                      (route) => false);
            }
          } else {
            WidgetHelper.alertDialog(context, "Kesalahan", "Gagal Menghubungkan", WidgetHelper.modeAlertBack);
          }

        });
      } else {
        WidgetHelper.alertDialog(context, "Kesalahan", "Format email salah", WidgetHelper.modeAlertBack);
      }


    } else {
      WidgetHelper.alertDialog(context, "Kesalahan", "Email dan Password tidak boleh kosong", WidgetHelper.modeAlertBack);
    }

  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _textEmailEditingController?.dispose();
    _textPasswordEditingController?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
    return Scaffold(
      body: _buildContentLogin(),
    );
  }

  Widget _buildContentLogin() {
    final _mediaHeight = MediaQuery.of(context).size.height;
    final _mediaWidth = MediaQuery.of(context).size.width;
    return Container(
      child: Container(
        width: _mediaWidth,
        height: _mediaHeight,
        child: SafeArea(
          child: SingleChildScrollView(
            child: _buildForm(),
          ),
        ),
      ),
    );
  }

  Widget _buildForm() {
    final _mediaHeight = MediaQuery.of(context).size.height;
    final _mediaWidth = MediaQuery.of(context).size.width;
    return Container(
      width: _mediaWidth,
      padding: EdgeInsets.symmetric(
          horizontal: _mediaWidth/6.75,
        vertical: _mediaHeight/8
      ),
      child: Form(
        key: _keyForm,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.symmetric(
                  horizontal: _mediaWidth/100
              ),
              margin: EdgeInsets.symmetric(
                  vertical: _mediaHeight/30
              ),
              child: Text("LOGIN",
                style: GoogleFonts.poppins(
                    color: Colors.blueAccent,
                    fontWeight: FontWeight.w600,
                    fontSize: _mediaHeight/20
                ),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildText("Email"),
                _buildTextField(_textEmailEditingController, _flagEmail),
                _buildText("Password"),
                _buildTextField(_textPasswordEditingController, _flagPass),
              ],
            ),
            _buildButtonLogin(),
          ],
        ),
      ),
    );
  }

  Widget _buildText(String? text){
    final _mediaHeight = MediaQuery.of(context).size.height;
    final _mediaWidth = MediaQuery.of(context).size.width;
    return Container(
      padding: EdgeInsets.symmetric(
          horizontal: _mediaWidth/100
      ),
      margin: EdgeInsets.symmetric(
          vertical: _mediaHeight/100
      ),
      child: Text("$text",
        style: GoogleFonts.poppins(
            color: Colors.grey.shade500,
            fontWeight: FontWeight.w600,
            fontSize: _mediaHeight/45
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController? textEditingController, String? typeFlag) {
    final _mediaHeight = MediaQuery.of(context).size.height;
    final _mediaWidth = MediaQuery.of(context).size.width;

    var _keyboardType = TextInputType.emailAddress;
    if(typeFlag == _flagPass) _keyboardType = TextInputType.text;


    return Container(
      height: _mediaHeight/14,
      child: Card(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(_mediaWidth/20)
        ),
        elevation: 2.0,
        child: TextFormField(
          controller: textEditingController,
          cursorColor: Colors.tealAccent.shade700,
          onSaved: (val) {
            setState(() {
              if(typeFlag == _flagPass) _textPass = val;
              if(typeFlag == _flagEmail) _textEmail = val;
            });
          },
          obscureText: typeFlag == _flagPass ? _notVisiblePassword : false,
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
            enabledBorder: OutlineInputBorder(borderRadius:BorderRadius.circular(_mediaWidth/20),
                borderSide: BorderSide(color: Colors.white, width: 3.0)),
            focusedBorder: OutlineInputBorder(borderRadius:BorderRadius.circular(_mediaWidth/20),
                borderSide: BorderSide(color: Colors.white, width: 3.0)),
            suffixIcon: Builder(
              builder: (BuildContext context) {
                if(typeFlag == _flagPass) {
                  return GestureDetector(
                    onTap: _toggle,
                    child: Icon(
                      _notVisiblePassword ? Icons.visibility_off : Icons.visibility,
                      semanticLabel: _notVisiblePassword ? 'show password' : 'hide password',
                    ),
                  );
                }
                return SizedBox();
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildButtonLogin() {
    final _mediaHeight = MediaQuery.of(context).size.height;
    final _mediaWidth = MediaQuery.of(context).size.width;

    final _borderRadius = BorderRadius.circular(_mediaWidth/20);
    return Container(
      margin: EdgeInsets.symmetric(
          vertical: _mediaHeight/20
      ),
      padding: EdgeInsets.symmetric(
          horizontal: _mediaWidth/100
      ),
      child: InkWell(
        borderRadius: _borderRadius,
        onTap: _actionLogin,
        child: Container(
          width: _mediaWidth,
          decoration: BoxDecoration(
              color: Colors.blue,
              borderRadius: _borderRadius
          ),
          padding: EdgeInsets.symmetric(
              vertical: _mediaHeight/80
          ),
          child: Text("Masuk",
            style: GoogleFonts.poppins(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: _mediaHeight/50
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }

}
