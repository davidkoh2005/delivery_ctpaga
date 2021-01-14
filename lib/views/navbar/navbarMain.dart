import 'package:delivery_ctpaga/animation/slideRoute.dart';
import 'package:delivery_ctpaga/providers/provider.dart';
import 'package:delivery_ctpaga/views/loginPage.dart';
import 'package:delivery_ctpaga/env.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:io';


class NavbarMain extends StatefulWidget {
  NavbarMain();

  @override
  _NavbarMainState createState() => _NavbarMainState();
}

class _NavbarMainState extends State<NavbarMain> {
  _NavbarMainState();

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Stack(
      children: <Widget>[
        Container(
          width: size.width,
          height: size.height/7,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(top:30, right:20),
                child: IconButton(
                  iconSize: size.width / 10,
                  icon: ImageIcon(
                    AssetImage('assets/icons/salir.png',),
                    size: size.width/16,
                  ),
                  onPressed: () {
                    exit();
                  }
                )
              )
            ]
          ),
        ),

        GestureDetector(
          onTap: () => launch("http://$url"),
          child: Padding(
            padding: EdgeInsets.only(top: 50, left: 30),
            child: Container(
              child: Image(
                image: AssetImage("assets/logo/logo.png"),
                width: size.width/3.5,
              ),
            )
          )
        ),

      ],
    );

  }

  exit() async {
    _onLoading();
    var myProvider = Provider.of<MyProvider>(context, listen: false);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var result, response, jsonResponse;
    try {
      result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        response = await http.post(
          urlApi+"logout",
          headers:{
            'Content-Type': 'application/json',
            'X-Requested-With': 'XMLHttpRequest',
            'authorization': 'Bearer ${myProvider.accessTokenDelivery}',
          },
        );

        jsonResponse = jsonDecode(response.body); 
        print(jsonResponse);
        prefs.remove("access_token");
        myProvider.removeSession(context, false);
        Navigator.pop(context);
        await Future.delayed(Duration(milliseconds: 150));
        Navigator.pushReplacement(context, SlideLeftRoute(page: LoginPage()));
      }
    } on SocketException catch (_) {
      Navigator.pop(context);
      showMessage("Sin conexión a internet. Intentalo de nuevo!", false);
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
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: size.width / 20,
                    fontFamily: 'MontserratExtraBold',
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
                            fontFamily: 'MontserratExtraBold',
                          )
                        ),
                        TextSpan(
                          text: "...",
                          style: TextStyle(
                            color: colorGreen,
                            fontSize: 15 * scaleFactor,
                            fontFamily: 'MontserratExtraBold',
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