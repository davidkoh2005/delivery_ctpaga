import 'package:delivery_ctpaga/animation/slideRoute.dart';
import 'package:delivery_ctpaga/views/navbar/navbarMain.dart';
import 'package:delivery_ctpaga/views/updatePasswordPage.dart';
import 'package:delivery_ctpaga/providers/provider.dart';
import 'package:delivery_ctpaga/env.dart';

import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'dart:io';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _scrollController = ScrollController();
  final _formKeyContact = new GlobalKey<FormState>();
  final FocusNode _nameFocus = FocusNode(); 
  final FocusNode _phoneFocus = FocusNode();
  final FocusNode _emailFocus = FocusNode();
  String _name, _phone, _email;

  @override
  Widget build(BuildContext context) {

    return WillPopScope(
      onWillPop: () async {        
        return false;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
          children: <Widget> [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                NavbarMain(),
                Expanded(
                  child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      formContact(),
                    ]
                  )
                ),
              ],
            ),
          ]
        )
      )
    );
  }



  Widget formContact(){
    var scaleFactor = MediaQuery.of(context).textScaleFactor;

    return Consumer<MyProvider>(
      builder: (context, myProvider, child) {
        return new Form(
          key: _formKeyContact,
          child: new ListView(
            padding: EdgeInsets.only(top: 0),
            controller: _scrollController,
            shrinkWrap: true,
            children: <Widget>[
              
              Padding(
                padding: const EdgeInsets.fromLTRB(30.0, 0.0, 30.0, 30.0),
                child: Center(
                  child: Text(
                    "Perfil",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 25 * scaleFactor,
                      fontWeight: FontWeight.bold
                    )
                  ),
                ) 
              ),

              Padding(
                padding: const EdgeInsets.fromLTRB(30.0, 10.0, 30.0, 0.0),
                child: new TextFormField(
                  initialValue: myProvider.dataDelivery == null ? '' : myProvider.dataDelivery.name,
                  autofocus: false,
                  textCapitalization:TextCapitalization.sentences, 
                  decoration: InputDecoration(
                    labelText: 'Nombre y Apellido',
                    labelStyle: TextStyle(
                      color: colorText,
                      fontFamily: 'MontserratSemiBold',
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: colorGreen),
                    ),
                  ),
                  onSaved: (String value) => _name = value,
                  validator: _validateName,
                  textInputAction: TextInputAction.next,
                  focusNode: _nameFocus,
                  onEditingComplete: () => FocusScope.of(context).requestFocus(_phoneFocus),
                  cursorColor: colorGreen,
                  style: TextStyle(
                    fontFamily: 'MontserratSemiBold',
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.fromLTRB(30.0, 10.0, 30.0, 0.0),
                child: new TextFormField(
                  initialValue: myProvider.dataDelivery == null? '' : myProvider.dataDelivery.phone,
                  autofocus: false,
                  keyboardType: TextInputType.phone,
                  maxLength: 20,
                  decoration: InputDecoration(
                    labelText: 'Teléfono',
                    labelStyle: TextStyle(
                      color: colorText,
                      fontFamily: 'MontserratSemiBold',
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: colorGreen),
                    ),
                  ),
                  onSaved: (String value) => _phone = value,
                  validator: _validatePhone,
                  focusNode: _phoneFocus,
                  textInputAction: TextInputAction.done,
                  onEditingComplete: () => FocusScope.of(context).requestFocus(_emailFocus),
                  cursorColor: colorGreen,
                  style: TextStyle(
                    fontFamily: 'MontserratSemiBold',
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(30.0, 10.0, 30.0, 10.0),
                child: new TextFormField(
                  initialValue: myProvider.dataDelivery == null? '' : myProvider.dataDelivery.email,
                  autofocus: false,
                  maxLines: 1,
                  focusNode: _emailFocus,
                  keyboardType: TextInputType.emailAddress,
                  decoration: new InputDecoration(
                      labelText: 'Email',
                      labelStyle: TextStyle(
                        color: colorText,
                        fontFamily: 'MontserratSemiBold',
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: colorGreen),
                      ),
                  ),
                  validator: _validateEmail,
                  onSaved: (String value) => _email = value.toLowerCase().trim(),
                  textInputAction: TextInputAction.done,
                  onFieldSubmitted: (term){
                    FocusScope.of(context).requestFocus(new FocusNode());
                    buttonClickSave();
                  },
                  cursorColor: colorGreen,
                  style: TextStyle(
                    fontFamily: 'MontserratSemiBold',
                  ),
                ),
              ),

              Align(
                alignment: Alignment.center,
                child: FlatButton(
              
                  onPressed: () => nextPage(),
                  child: Text(
                    "Cambiar contraseña",
                    style: TextStyle(
                      color: Colors.black87,
                      fontSize: 15 * scaleFactor,
                      decoration: TextDecoration.underline,
                      fontFamily: 'MontserratSemiBold',
                    )
                  ),
                ),
              ),

              buttonSave(),
            ],
          ),
        );
      }
    );
  }

  Widget buttonSave(){
    var scaleFactor = MediaQuery.of(context).textScaleFactor;
    var size = MediaQuery.of(context).size;
    return Padding(
      padding: EdgeInsets.only(left:30, right:30, bottom:30),
      child: GestureDetector(
        onTap: () {
          buttonClickSave();
        },
        child: Container(
          width:size.width - 100,
          height: size.height / 20,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                colorGreen,
                colorGreen
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(30),
            ),
          child: Center(
            child: Text(
              "GUARDAR",
              style: TextStyle(
                color: Colors.white,
                fontSize: 15 * scaleFactor,
                fontWeight: FontWeight.w500,
                fontFamily: 'MontserratSemiBold',
              ),
            ),
          ),
        ),
      )
    );
  }

  void buttonClickSave()async{
    if (_formKeyContact.currentState.validate()) {
      _formKeyContact.currentState.save();
      _onLoading();
      var result, response, jsonResponse;
       try {
        result = await InternetAddress.lookup('google.com');
        if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
          var myProvider = Provider.of<MyProvider>(context, listen: false);

          response = await http.post(
            urlApi+"updateDelivery",
            headers:{
              'Content-Type': 'application/json',
              'X-Requested-With': 'XMLHttpRequest',
              'authorization': 'Bearer ${myProvider.accessTokenDelivery}',
            },
            body: jsonEncode({
              'name': _name,
              'phone': _phone,
              'email': _email,
            }),
          ); 

          jsonResponse = jsonDecode(response.body); 
          if (jsonResponse['statusCode'] == 201) {
            myProvider.getDataDelivery(false, false, context);
            Navigator.pop(context);
            showMessage("Guardado Correctamente", true);
            await Future.delayed(Duration(seconds: 1));
            Navigator.pop(context);
          } 
        }
      } on SocketException catch (_) {
        showMessage("Sin conexión a internet", false);
      } 
    }
  }

  Future<void> _onLoading() async {
    var scaleFactor = MediaQuery.of(context).textScaleFactor;

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
                    valueColor: new AlwaysStoppedAnimation<Color>(colorGreen),
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
                            fontSize: 15 * scaleFactor,
                            fontFamily: 'MontserratSemiBold',
                          )
                        ),
                        TextSpan(
                          text: "...",
                          style: TextStyle(
                            color: colorGreen,
                            fontSize: 15 * scaleFactor,
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
    var scaleFactor = MediaQuery.of(context).textScaleFactor;
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
                  color: colorGreen,
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
                    fontSize: 15 * scaleFactor,
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

  nextPage()async{
    await Future.delayed(Duration(milliseconds: 150));
    Navigator.push(context, SlideLeftRoute(page: UpdatePasswordPage()));
  }

  String _validateName(String value) {
    // This is just a regular expression for name
    String p = '[a-zA-Z]';
    RegExp regExp = new RegExp(p);

    if (value.isNotEmpty && regExp.hasMatch(value) && value.length >=3) {
      // So, the name is valid
      return null;
    }

    // The pattern of the name and surname didn't match the regex above.
    return 'Ingrese nombre y apellido válido';
  }

  String _validatePhone(String value) {
    // This is just a regular expression for phone*$
    String p = r'^(?:(\+)58|0)(?:2(?:12|4[0-9]|5[1-9]|6[0-9]|7[0-8]|8[1-35-8]|9[1-5]|3[45789])|4(?:1[246]|2[46]))\d{7}$';
    RegExp regExp = new RegExp(p);

    if (value.isNotEmpty && regExp.hasMatch(value) && value.length >=9) {
      // So, the phone is valid
      return null;
    }

    // The pattern of the phone didn't match the regex above.
    return 'Ingrese un número de teléfono válido';
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

