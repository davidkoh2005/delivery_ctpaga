import 'package:delivery_ctpaga/views/mainPage.dart';
import 'package:delivery_ctpaga/providers/provider.dart';
import 'package:delivery_ctpaga/env.dart';

import 'package:provider/provider.dart';
import 'package:flutter/material.dart';


class MainMenuBar extends StatefulWidget {
  @override
  _MainMenuBarState createState() => _MainMenuBarState();
}

class _MainMenuBarState extends State<MainMenuBar> {
  int _statusButton = 2;

  final _pageOptions = [
    Container(child: Center(child: Text("Google Maps"),),),
    MainPage(),
    Container(child: Center(child: Text("Confirguracion"),),),
  ];
  
  @override
  Widget build(BuildContext context) {

    return Consumer<MyProvider>(
      builder: (context, myProvider, child) {
        return WillPopScope(
          onWillPop: () async =>false,
          child: Scaffold(
            backgroundColor: Colors.white,
            body: Stack(
              children: [
                Column(
                  children: <Widget>[
                    Expanded(child:_pageOptions[_statusButton-1]),
                    SizedBox(height: 60),
                  ],
                ),

                Positioned(
                  bottom: 0,
                  left: 0,
                  child: _showMenu()
                ),
              ]
            )
          )
        );
      }
    );
  }

  Widget _showMenu(){
    var size = MediaQuery.of(context).size;
    return Container(
      width: size.width,
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            width: 0.5,
            color: Colors.black45
          )
        ),
        color: Colors.white,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        mainAxisSize :MainAxisSize.max,
        children: <Widget>[
          _buildNavItem("Mapa", "assets/icons/mapa.png", _statusButton, 1),
          _buildNavItem("Inicio" ,"assets/icons/home.png",_statusButton, 2),
          _buildNavItem("Confirguración", "assets/icons/configuracion.png", _statusButton, 3),
        ]
      ),
    );
  }

  Widget _buildNavItem(String _title, String _icon, int _status, int code){
    var size = MediaQuery.of(context).size;
    var scaleFactor = MediaQuery.of(context).textScaleFactor;
    
    return GestureDetector(
      onTap: () async {
        setState((){

          _statusButton = code;
        }); 
      },
      child: Container(
        color: Colors.white,
        padding: EdgeInsets.only(top:10),
        width: size.width / 5.1,
        child: Column(
          children: <Widget> [
            Container(
              child: Center(
                child: Image.asset(
                  _icon,
                  width: size.width / 15,
                  height: size.width / 15,
                  color: _status == code? colorGreen : Colors.black,
                )
              )
            ),
            Container(
              padding: EdgeInsets.only(top:5, bottom: 5),
              child: Text(
                _title,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 10 * scaleFactor,
                  fontWeight: _status == code? FontWeight.bold: FontWeight.normal
                ),
              ),
            )
          ]
        )
      )
    );
  }

}
