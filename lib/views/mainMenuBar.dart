import 'package:delivery_ctpaga/views/googleMapsPage.dart';
import 'package:delivery_ctpaga/views/mainPage.dart';
import 'package:delivery_ctpaga/views/profilePage.dart';
import 'package:delivery_ctpaga/providers/provider.dart';
import 'package:delivery_ctpaga/env.dart';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';


class MainMenuBar extends StatefulWidget {
  @override
  _MainMenuBarState createState() => _MainMenuBarState();
}

class _MainMenuBarState extends State<MainMenuBar> {

  final _pageOptions = [
    GoogleMapsPage(),
    MainPage(),
    ProfilePage()
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
                    Expanded(child:_pageOptions[myProvider.statusButton-1]),
                    SizedBox(height: 60),
                  ],
                ),

                Positioned(
                  bottom: 0,
                  left: 0,
                  child: _showMenu(myProvider)
                ),
              ]
            )
          )
        );
      }
    );
  }

  Widget _showMenu(myProvider){
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
          _buildNavItem("Mapa", "assets/icons/mapa.png", myProvider.statusButton, 1),
          _buildNavItem("Inicio" ,"assets/icons/home.png",myProvider.statusButton, 2),
          _buildNavItem("Perfil", "assets/icons/perfil.png", myProvider.statusButton, 3),
        ]
      ),
    );
  }

  Widget _buildNavItem(String _title, String _icon, int _status, int code){
    var size = MediaQuery.of(context).size;
    var myProvider = Provider.of<MyProvider>(context, listen: false);
    return GestureDetector(
      onTap: () async {
        if(code == 3)
          myProvider.getDataDelivery(false, false, context);
          
        myProvider.statusButton = code;
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
                  color: _status == code? colorLogo : colorGreyLogo,
                )
              )
            ),
            Container(
              padding: EdgeInsets.only(top:5, bottom: 5),
              child: AutoSizeText(
                _title,
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                  fontFamily: 'MontserratSemiBold',
                ),
                maxFontSize: 9,
                minFontSize: 9,
              ),
            )
          ]
        )
      )
    );
  }

}
