import 'package:delivery_ctpaga/animation/slideRoute.dart';
import 'package:delivery_ctpaga/views/forgotPassword.dart';
import 'package:delivery_ctpaga/views/registerPage.dart';
import 'package:delivery_ctpaga/providers/provider.dart';
import 'package:delivery_ctpaga/env.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:io';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKeyLogin = new GlobalKey<FormState>();
  final FocusNode _emailFocus = FocusNode();  
  final FocusNode _passwordFocus = FocusNode();
  final _passwordController = TextEditingController();
  String _email, _password, _messageError;
  bool passwordVisible = true, _statusError = false;
  var jsonResponse;

  @override
  Widget build(BuildContext context) {

    var size = MediaQuery.of(context).size;

    return WillPopScope(
      onWillPop: () async =>false,
      child: Center(
        child: Scaffold(
          backgroundColor: Colors.white,
          body: Container(
            alignment: Alignment.center,
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                    Image(
                    image: AssetImage("assets/logo/logo.png"),
                    width: size.width/2,
                  ),
                  formLogin(), //form login
                  buttonLogin(), //button login
                  SizedBox(height:20), //separation between two buttons
                  buttonRegister(), //button Register
                ]
              ),
            ),
          ),
        ),
      )
    );
  }

  Widget formLogin(){
    return new Form(
      key: _formKeyLogin,
      child: new ListView(
        shrinkWrap: true,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(30.0, 20.0, 30.0, 0.0),
            child: new TextFormField(
              maxLines: 1,
              keyboardType: TextInputType.emailAddress,
              autofocus: false,
              focusNode: _emailFocus,
              onEditingComplete: () => FocusScope.of(context).requestFocus(_passwordFocus),
              decoration: new InputDecoration(
                labelText: "Email",
                labelStyle: TextStyle(
                  color: colorGreen,
                  fontFamily: 'MontserratSemiBold',
                  fontSize: 14,
                ),
                icon: new Icon(
                  Icons.mail,
                  color: colorGreen,
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: colorGreen),
                ),
              ),
              validator: _validateEmail,
              onSaved: (value) => _email = value.toLowerCase().trim(),
              textInputAction: TextInputAction.next,
              cursorColor: colorGreen,
              style: TextStyle(
                fontFamily: 'MontserratSemiBold',
                fontSize: 14,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(30.0, 20.0, 30.0, 0.0),
            child: new TextFormField(
              controller: _passwordController,
              maxLines: 1,
              autofocus: false,
              keyboardType: TextInputType.text,
              obscureText: passwordVisible,
              focusNode: _passwordFocus,
              decoration: new InputDecoration(
                  labelText: "Contraseña",
                  labelStyle: TextStyle(
                    color: colorGreen,
                    fontFamily: 'MontserratSemiBold',
                    fontSize: 14,
                  ),
                  icon: new Icon(
                    Icons.lock,
                    color: colorGreen
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      passwordVisible
                      ? Icons.visibility_off
                      : Icons.visibility,
                      color: colorGreen,
                      ),
                    onPressed: () {
                      setState(() {
                          passwordVisible = !passwordVisible;
                      });
                    },
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: colorGreen),
                  ),
                ),
              validator: (value) => value.isEmpty? 'Ingrese una contraseña válida': null,
              onSaved: (value) => _password = value.trim(),
              textInputAction: TextInputAction.done,
              onFieldSubmitted: (term){
                FocusScope.of(context).requestFocus(new FocusNode()); //save the keyboard
                clickButtonLogin(); //process that will be carried out when you press the login button
              },
              cursorColor: colorGreen,
              style: TextStyle(
                fontFamily: 'MontserratSemiBold',
                fontSize: 14,
              ),
            ),
          ),
          Visibility(
            visible: _statusError,
            child: Center(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 15.0),
                child: AutoSizeText(
                  _messageError == null? '' : _messageError,
                  style: TextStyle(
                    color: Colors.red,
                    fontFamily: 'MontserratSemiBold',
                    fontSize: 14,
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 15.0),
            child: FlatButton(
              onPressed: () {
                setState(() {
                  _passwordController.clear();
                  _statusError = false;
                });
                Navigator.push(context, SlideLeftRoute(page: ForgotPassword()));
              },
              child: AutoSizeText(
                "Olvidé mi contraseña?",
                style: TextStyle(
                  color: colorGreen,
                  fontFamily: 'MontserratSemiBold',
                  fontSize: 14,
                ),
              )
            )
          ),
        ],
      ),
    );
  }

  Widget buttonLogin(){
    var size = MediaQuery.of(context).size;
    return  GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(new FocusNode()); //save the keyboard
        clickButtonLogin(); //process that will be carried out when you press the login button
      },
      child: Container(
        width:size.width - 100,
        height: size.height / 14,
        decoration: BoxDecoration(
          border: Border.all(
            color: colorGreen, 
            width: 1.0,
          ),
          gradient: LinearGradient(
            colors: [
              colorGreen,
              colorGreen,
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
            'Ingresar',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w500,
              fontFamily: 'MontserratSemiBold',
              fontSize: 14,
            ),
            maxFontSize: 14,
            minFontSize: 14,
          ),
        ),
      ),
    );
  }

  Widget buttonRegister(){
    var size = MediaQuery.of(context).size;
    return  GestureDetector(
      onTap: () {
        setState(() {
          _passwordController.clear();
          _statusError = false;
        });
        Navigator.push(context, SlideLeftRoute(page: RegisterPage()));
      },
      child: Container(
        width:size.width - 100,
        height: size.height / 14,
        decoration: BoxDecoration(
          border: Border.all(
            color: colorGreen, 
            width: 1.0,
          ),
          gradient: LinearGradient(
            colors: [
              colorGreen,
              colorGreen,
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
            'Regístrate',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w500,
              fontFamily: 'MontserratSemiBold',
              fontSize: 14,
            ),
            maxFontSize: 14,
            minFontSize: 14,
          ),
        ),
      ),
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

   clickButtonLogin() async{
     setState(() {
       _statusError = false;
     });
    if (_formKeyLogin.currentState.validate()) {
      _formKeyLogin.currentState.save();
      _onLoading(); // show Loading

      var result, response;
      var myProvider = Provider.of<MyProvider>(context, listen: false);

      try {
        result = await InternetAddress.lookup('google.com'); //verify network
        if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {

          response = await http.post(
            urlApi+"loginDelivery",
            headers:{
              'Accept': 'application/json',
              'Content-Type': 'application/json',
              'X-Requested-With': 'XMLHttpRequest',
            },
            body: jsonEncode({
              'email': _email,
              'password': _password,
            }),
          ); // petición api
          print(response.body);
          jsonResponse = jsonDecode(response.body);

          if (jsonResponse['statusCode'] == 201) {

            SharedPreferences prefs = await SharedPreferences.getInstance();
            prefs.remove("access_token");
            prefs.remove('codeUrl');
            prefs.setString('access_token', jsonResponse['access_token']);
            myProvider.accessTokenDelivery = jsonResponse['access_token'];
            myProvider.statusButton = 2;
            myProvider.searchAddress = "";
            myProvider.statusInitGoogle = false;
            myProvider.statusShedule = false;
            _passwordController.clear();
            myProvider.getDataAllPaids(context, false);
            myProvider.getDataDelivery(true, true, context);
            myProvider.codeUrl = null;

          } else if(jsonResponse['statusCode'] == 401){

            setState(() {
              _passwordController.clear();
              _statusError = true;
              _messageError = "Por favor contactar con el administrador";
            });
            Navigator.pop(context);

          } else if(jsonResponse['statusCode'] == 400){

            setState(() {
              _passwordController.clear();
              _statusError = true;
              _messageError = "Email o contraseña incorrectos";
            });
            Navigator.pop(context);

          } 
        }
      } on SocketException catch (_) {

        setState(() {
          _statusError = true;
          _messageError = "Sin conexión, inténtalo de nuevo mas tarde";
        });
        Navigator.pop(context);

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
                            fontFamily: 'MontserratSemiBold',
                            fontSize: 14,
                          )
                        ),
                        TextSpan(
                          text: "...",
                          style: TextStyle(
                            color: colorGreen,
                            fontFamily: 'MontserratSemiBold',
                            fontSize: 14,
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

}