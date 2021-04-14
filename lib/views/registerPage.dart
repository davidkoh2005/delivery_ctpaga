import 'package:delivery_ctpaga/providers/provider.dart';
import 'package:delivery_ctpaga/env.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'dart:io';

class RegisterPage extends StatefulWidget {

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKeyRegister = new GlobalKey<FormState>();
  final passwordController = TextEditingController();
  final FocusNode _nameFocus = FocusNode(); 
  final FocusNode _phoneFocus = FocusNode();  
  final FocusNode _emailFocus = FocusNode();  
  final FocusNode _passwordFocus = FocusNode();
  final FocusNode _passwordConfirmFocus = FocusNode();
  String _name, _phone, _email, _password, _passwordConfirm, _messageError;
  bool passwordVisible = true, _statusError = false;
  var jsonResponse;

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Center(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Container(
          alignment: Alignment.center,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                  Image(
                  image: AssetImage("assets/logo/logo-CTLLEVA.png"),
                  height: size.height/5,
                ),
                
                formRegister(), //form Register
                buttonRegister(), // button Register
              ]
            ),
          ),
        ),
      ),
    );
  }

  Widget formRegister(){
    return new Form(
      key: _formKeyRegister,
      child: new ListView(
        shrinkWrap: true,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(30.0, 10.0, 30.0, 0.0),
            child: new TextFormField(
              autofocus: false,
              focusNode: _nameFocus,
              onEditingComplete: () => FocusScope.of(context).requestFocus(_phoneFocus),
              textCapitalization:TextCapitalization.words,
              decoration: InputDecoration(
                icon: Icon(Icons.person, color: colorLogo),
                labelText: 'Nombre y Apellido',
                labelStyle: TextStyle(
                  color: colorLogo,
                  fontFamily: 'MontserratSemiBold',
                  fontSize: 14,
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: colorLogo),
                ),
              ),
              onSaved: (String value) => _name = value,
              validator: _validateName,
              textInputAction: TextInputAction.next,
              cursorColor: colorLogo,
              style: TextStyle(
                fontFamily: 'MontserratSemiBold',
                fontSize: 14,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(30.0, 10.0, 30.0, 0.0),
            child: new TextFormField(
              autofocus: false,
              focusNode: _phoneFocus,
              maxLength: 20,
              onEditingComplete: () => FocusScope.of(context).requestFocus(_emailFocus),
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                icon: Icon(Icons.phone, color: colorLogo),
                labelText: 'Teléfono',
                labelStyle: TextStyle(
                  color: colorLogo,
                  fontFamily: 'MontserratSemiBold',
                  fontSize: 14,
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: colorLogo),
                ),
              ),
              onSaved: (String value) => _phone = value,
              validator: _validatePhone,
              textInputAction: TextInputAction.next,
              cursorColor: colorLogo,
              style: TextStyle(
                fontFamily: 'MontserratSemiBold',
                fontSize: 14,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(30.0, 10.0, 30.0, 0.0),
            child: new TextFormField(
              autofocus: false,
              maxLines: 1,
              keyboardType: TextInputType.emailAddress,
              focusNode: _emailFocus,
              onEditingComplete: () => FocusScope.of(context).requestFocus(_passwordFocus),
              decoration: new InputDecoration(
                  labelText: 'Email',
                  labelStyle: TextStyle(
                    color: colorLogo,
                    fontFamily: 'MontserratSemiBold',
                    fontSize: 14,
                  ),
                  icon: new Icon(
                    Icons.mail,
                    color: colorLogo,
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: colorLogo),
                  ),
              ),
              validator: _validateEmail,
              onSaved: (String value) => _email = value.toLowerCase().trim(),
              textInputAction: TextInputAction.next,
              cursorColor: colorLogo,
              style: TextStyle(
                fontFamily: 'MontserratSemiBold',
                fontSize: 14,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(30.0, 10.0, 30.0, 0.0),
            child: new TextFormField(
              autofocus: false,
              maxLines: 1,
              keyboardType: TextInputType.text,
              obscureText: passwordVisible,
              focusNode: _passwordFocus,
              onEditingComplete: () => FocusScope.of(context).requestFocus(_passwordConfirmFocus),
              decoration: new InputDecoration(
                  labelText: 'Contraseña',
                  labelStyle: TextStyle(
                    color: colorLogo,
                    fontFamily: 'MontserratSemiBold',
                    fontSize: 14,
                  ),
                  icon: new Icon(
                    Icons.lock,
                    color: colorLogo
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      passwordVisible
                      ? Icons.visibility_off
                      : Icons.visibility,
                      color: colorLogo
                      ),
                    onPressed: () {
                      setState(() {
                          passwordVisible = !passwordVisible;
                      });
                    },
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: colorLogo),
                  ),
              ),
              validator: _validatePassword,
              onSaved: (String value) => _password = value,
              textInputAction: TextInputAction.next,
              cursorColor: colorLogo,
              style: TextStyle(
                fontFamily: 'MontserratSemiBold',
                fontSize: 14,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(30.0, 10.0, 30.0, 10.0),
            child: new TextFormField(
              autofocus: false,
              maxLines: 1,
              keyboardType: TextInputType.text,
              obscureText: passwordVisible,
              focusNode: _passwordConfirmFocus,
              decoration: new InputDecoration(
                  labelText: 'Confirmar Contraseña',
                  labelStyle: TextStyle(
                    color: colorLogo,
                    fontFamily: 'MontserratSemiBold',
                    fontSize: 14,
                  ),
                  icon: new Icon(
                    Icons.lock,
                    color: colorLogo
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      passwordVisible
                      ? Icons.visibility_off
                      : Icons.visibility,
                      color: colorLogo,
                      ),
                    onPressed: () {
                      setState(() {
                          passwordVisible = !passwordVisible;
                      });
                    },
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: colorLogo),
                  ),
                ),
              validator: _validatePasswordConfirm,
              onSaved: (String value) => _passwordConfirm = value,
              textInputAction: TextInputAction.done,
              onFieldSubmitted: (term){
                FocusScope.of(context).requestFocus(new FocusNode()); //save the keyboard
                _clickButtonRegister(); //process that will be carried out when you press the register button
              },
              cursorColor: colorLogo,
              style: TextStyle(
                fontFamily: 'MontserratSemiBold',
                fontSize: 14,
              ),
            ),
          ),

          _statusError ? Center(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(10.0, 15.0, 0.0, 50.0),
                child: AutoSizeText(
                  _messageError == null? '' : _messageError,
                  style: TextStyle(
                    color: Colors.red,
                    fontFamily: 'MontserratSemiBold',
                    fontSize: 14,
                  ),
                ),
              ),
            )
          : Padding(padding: EdgeInsets.only(top: 50.0)),
        ],
      ),
    );
  }

  Widget buttonRegister(){
    var size = MediaQuery.of(context).size;
    return  GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(new FocusNode()); //save the keyboard
        _clickButtonRegister(); //process that will be carried out when you press the register button
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
            'Registrar Cuenta',
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

  _clickButtonRegister() async{
    setState(() {
      _statusError = false;
    });
    if (_formKeyRegister.currentState.validate()) {
      _formKeyRegister.currentState.save();
      
      _onLoading();

      var result, response;

      try {
        result = await InternetAddress.lookup('google.com'); //verify network
        if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {

          response = await http.post(
            urlApi+"signupDelivery",
            headers:{
              'Content-Type': 'application/json',
              'X-Requested-With': 'XMLHttpRequest',
            },
            body: jsonEncode({
              'name': _name,
              'email': _email,
              'password': _password,
              'password_confirmation': _passwordConfirm,
              'phone': _phone,
            }),
          ); // peticion api
          
          print(response.body);
          jsonResponse = jsonDecode(response.body);
          print(jsonResponse);
          if (jsonResponse['statusCode'] == 201) {
            /* Navigator.pop(context);
            showMessage("La cuenta fue registrado correctamente!, Debe contactar con el administrador para la aoturización de la aplicación", true);
            Navigator.pushReplacement(context, SlideLeftRoute(page: LoginPage())); */
            var myProvider = Provider.of<MyProvider>(context, listen: false);
            SharedPreferences prefs = await SharedPreferences.getInstance();
            prefs.setString('access_token', jsonResponse['access_token']);
            myProvider.accessTokenDelivery = jsonResponse['access_token'];
            myProvider.statusButton = 2;
            myProvider.addressDelivery = "";
            myProvider.statusInitGoogle = false;
            myProvider.getTokenFCM = null; 
            myProvider.getDataAllPaids(context, false);
            myProvider.getDataDelivery(true, true, context); 

          } else if(jsonResponse['errors'] != null){

            setState(() {
              _statusError = true;
              _messageError = 'El correo ya se encuentra registrado.';
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
    // This is just a regular expression for phone
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


  String _validatePassword(String value) {
    String errorValidate = 'La contraseña es inválida, debe tener:';
    if (value.isEmpty) {
      // The form is empty
      return 'Ingrese una contraseña válido';
    }
    // This is just a regular expression for password
    String epUpperCase = "(?=.*[A-Z])";                 // should contain at least one upper case
    String epLowerCase = "(?=.*[a-z])";                    // should contain at least one lower case
    String epDigit= "(?=.*?[0-9])";                        // should contain at least one digit
    String epSpecialCharacter = "(?=.*?[-_!@#\$&*~])";  // should contain at least one Special character
    RegExp regExp = new RegExp(epUpperCase);

    if (!regExp.hasMatch(value)){
      errorValidate = errorValidate + '\n\n Una letra mayúscula.';
    }
    regExp = new RegExp(epLowerCase);
    if (!regExp.hasMatch(value)){
      errorValidate = errorValidate + '\n\n Una letra minúscula.';
    }
    regExp = new RegExp(epDigit);
    if (!regExp.hasMatch(value)){
      errorValidate = errorValidate + '\n\n Un número numérico.';
    }
    regExp = new RegExp(epSpecialCharacter);
    if (!regExp.hasMatch(value)){
      errorValidate = errorValidate + '\n\n Un Carácter Especial.';
    }

    if (value.length < 6){
      errorValidate = errorValidate + '\n\n Al menos 6 caracteres.';
    }

    if (errorValidate == 'La contraseña es inválida, debe tener:'){
      // So, the Password is valid
      _password = value;
      return null;
    }
    
    return errorValidate;

  }

  String _validatePasswordConfirm(String value) {
    if(value.isNotEmpty){
      if (_password == value){
        return null;
      }
      return 'La contraseña no coincide';
    }
    return '';
  }
}