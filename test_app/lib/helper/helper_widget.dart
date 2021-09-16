import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';


class WidgetHelper{

  static ProgressDialog? progressDialogShow(BuildContext context, ProgressDialog? pd){
    final _mediaHeight = MediaQuery.of(context).size.height;
    final _mediaWidth = MediaQuery.of(context).size.width;
    pd = ProgressDialog(context: context);
    pd.show(
        max: 100,
        msg: 'Mohon Tunggu...',
        borderRadius: _mediaWidth/100,
        backgroundColor: Colors.white,
        progressValueColor: Colors.tealAccent.shade700,
        elevation: 5.0,
        barrierDismissible: true,
        msqFontWeight: FontWeight.w500,
        msgFontSize: _mediaHeight/45,
    );
    return pd;
  }

  static Future<void> alertDialog(BuildContext context, String title, String message) async {

    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        if(Platform.isIOS) {
          return CupertinoAlertDialog(
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
                child: Text('Tutup',
                  style: GoogleFonts.poppins(
                      fontSize: MediaQuery.of(context).size.height/55,
                      color: Colors.blueGrey
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
                    style: GoogleFonts.poppins(
                        fontSize: MediaQuery.of(context).size.height/50,
                        fontWeight: FontWeight.normal
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                child: Text('Tutup',
                  style: GoogleFonts.poppins(
                      fontSize: MediaQuery.of(context).size.height/55,
                      color: Colors.blueGrey
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
  }



}