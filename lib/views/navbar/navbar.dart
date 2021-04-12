
import 'package:delivery_ctpaga/env.dart';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class Navbar extends StatefulWidget {
  Navbar(this._title);
  final String _title;

  @override
  _NavbarState createState() => _NavbarState(this._title);
}

class _NavbarState extends State<Navbar> {
  _NavbarState(this._title);
  final String _title;

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Stack(
      children: <Widget>[
        Container(
          width: size.width,
          height: size.height/7,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(top:20),
                child: Row(
                  children: <Widget>[
                    GestureDetector(
                      onTap: (){
                        Navigator.pop(context);
                      },
                      child: Padding(
                        padding: EdgeInsets.only(left:15, right: 15),
                        child: Container(
                          width: size.width / 10,
                          height: size.width / 10,
                          decoration: BoxDecoration(
                            color: colorLogo,
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Icon(
                              Icons.close,
                              color: Colors.white,
                            )
                          ),
                        )
                      ),
                    ),
                    
                    AutoSizeText(
                      _title,
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'MontserratSemiBold',
                      ),
                      maxFontSize: 14,
                      minFontSize: 14,
                    ),
                  ],
                ),
              ),

            ]
          ),
        ),
      ],
    );

  }
}