import 'package:delivery_ctpaga/env.dart';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'dart:io';

class ForgotPassword extends StatefulWidget {

  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final _formKeyForgotPassword = new GlobalKey<FormState>();
  final FocusNode _emailFocus = FocusNode(); 
  String _email;

  @override
  Widget build(BuildContext context) {

    var size = MediaQuery.of(context).size;

    return Center(
      child: Scaffold(
        backgroundColor: Colors.white,
        body:Container(
          child:Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[

              Image(
                image: AssetImage("assets/logo/logo.png"),
                width: size.width/2,
              ),

              formEmail(),// form Email
              buttonSend(), //button send

            ]
          ),
        ),
      ),
    );
  }

  Widget formEmail(){
    return new Form(
      key: _formKeyForgotPassword,
      child: new ListView(
        shrinkWrap: true,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(30.0, 20.0, 30.0, 50.0),
            child: new TextFormField(
              maxLines: 1,
              keyboardType: TextInputType.emailAddress,
              autofocus: false,
              focusNode: _emailFocus,
              onEditingComplete: () {
                FocusScope.of(context).requestFocus(new FocusNode());
              },
              decoration: new InputDecoration(
                  hintText: "Email",
                  icon: new Icon(
                    Icons.mail,
                    color: colorLogo,
                  )
              ),
              validator: _validateEmail ,
              onSaved: (value) => _email = value.trim(),
              textInputAction: TextInputAction.done,
              onFieldSubmitted: (term){
                FocusScope.of(context).requestFocus(new FocusNode()); //save the keyboard
                clickButtonSend(); //process to be performed when you press the submit button
              },
              style: TextStyle(
                fontFamily: 'MontserratSemiBold',
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buttonSend(){
    var size = MediaQuery.of(context).size;
    return  GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(new FocusNode()); //save the keyboard
        clickButtonSend(); //process to be performed when you press the submit button
      },
      child: Container(
        width:size.width - 100,
        height: size.height / 14,
        decoration: BoxDecoration(
          border: Border.all(
            color: colorLogo, 
            width: 1.0,
          ),
          gradient: LinearGradient(
            colors: [
              colorLogo,
              colorLogo,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              offset: Offset(5, 5),
              blurRadius: 10,
            )
          ],
        ),
        child: Center(
          child: AutoSizeText(
            'Enviar',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w500,
              fontFamily: 'MontserratSemiBold',
            ),
            maxFontSize: 14,
            minFontSize: 14,
          ),
        ),
      ),
    );
  }

  void clickButtonSend()async{
    if (_formKeyForgotPassword.currentState.validate()) {
      _formKeyForgotPassword.currentState.save();
      var response, result;
      try
      {
        _onLoading();
        result = await InternetAddress.lookup('google.com'); //verify network
        if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {

          response = await http.get(
            "http://$url/password/delivery/create?email=$_email",
            headers:{
              'Content-Type': 'application/json',
              'X-Requested-With': 'XMLHttpRequest',
            },
          ); 
          var jsonResponse = jsonDecode(response.body); 
          print(jsonResponse);
          if (jsonResponse['statusCode'] == 201) {
            Navigator.pop(context);
            showMessage("Enlace de restablecimiento de contraseña se ha enviado al correo electrónico", true);

          }else{
            Navigator.pop(context);
            showMessage(jsonResponse['message'], false);
          }
        }
      } on SocketException catch (_) {
        Navigator.pop(context);
        showMessage("Sin conexión a internet", false);
      }
    }
  }

  Future<void> _onLoading() async {
    
    return showDialog(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () async => false,
          child: AlertDialog(
            backgroundColor: Colors.white,
            content: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.all(5),
                  child: CircularProgressIndicator(
                    valueColor: new AlwaysStoppedAnimation<Color>(colorLogo),
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(5),
                  child: RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: "Cargando ",
                          style: TextStyle(
                            color: Colors.black,
                            fontFamily: 'MontserratSemiBold',
                          )
                        ),
                        TextSpan(
                          text: "...",
                          style: TextStyle(
                            color: colorLogo,
                            fontFamily: 'MontserratSemiBold',
                          )
                        ),
                      ]
                    ),
                  ),
                ),
              ],
            ),
          )
        );
      },
    );
  }

  Future<void> showMessage(_titleMessage, _statusCorrectly) async {
    var size = MediaQuery.of(context).size;

    return showDialog(
      context: context,
      barrierDismissible: true, 
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          content: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              _statusCorrectly? Padding(
                padding: EdgeInsets.all(5),
                child: Icon(
                  Icons.check_circle,
                  color: colorLogo,
                  size: size.width / 8,
                )
              )
              : Padding(
                padding: EdgeInsets.all(5),
                child: Icon(
                  Icons.error,
                  color: Colors.red,
                  size: size.width / 8,
                )
              ),
              Container(
                padding: EdgeInsets.all(5),
                child: Text(
                  _titleMessage,
                  style: TextStyle(
                    color: Colors.black,
                    fontFamily: 'MontserratSemiBold',
                  )
                ),
              ),
            ],
          ),
        );
      },
    );
  }



  String _validateEmail(String value) {
    value = value.trim().toLowerCase();
    // This is just a regular expression for email addresses
    String p = "[a-zA-Z0-9\+\.\_\%\-\+]{1,256}" +
        "\\@" +
        "[a-zA-Z0-9][a-zA-Z0-9\\-]{0,64}" +
        "(" +
        "\\." +
        "[a-zA-Z0-9][a-zA-Z0-9\\-]{0,25}" +
        ")+";
    RegExp regExp = new RegExp(p);

    if (value.isNotEmpty &&regExp.hasMatch(value)) {
      return null;     
    }

    // The pattern of the email didn't match the regex above.
    return 'Ingrese un email válido';
  }
}