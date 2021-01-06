import 'package:delivery_ctpaga/views/navbar/navbarMain.dart';
import 'package:delivery_ctpaga/models/delivery.dart';
import 'package:delivery_ctpaga/env.dart';

import 'package:flutter/material.dart';


class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final _formKeySearch = new GlobalKey<FormState>();
  Delivery delivery = Delivery();

  // ignore: unused_field
  int clickBotton = 0, _statusCoin = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }


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
                      showSearch(),
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


  showSearch(){
    var scaleFactor = MediaQuery.of(context).textScaleFactor;
    
    return Form(
      key: _formKeySearch,
      child: new ListView(
        padding: EdgeInsets.only(top: 0),
        shrinkWrap: true,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(30.0, 0.0, 30.0, 30.0),
            child: Center(
              child: Text(
                "Buscar Código",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 25 * scaleFactor,
                  fontWeight: FontWeight.bold
                )
              ),
            ) 
          ),

          Padding(
            padding: const EdgeInsets.fromLTRB(60.0, 0.0, 60.0, 30.0),
            child: TextFormField(
              autofocus: false,
              textCapitalization:TextCapitalization.sentences,
              decoration: InputDecoration(
                labelText: 'código',
                labelStyle: TextStyle(
                  color: colorText
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: colorGreen),
                ),
              ),
              validator: _validateCode,
              textInputAction: TextInputAction.done,
              onEditingComplete: () {
                FocusScope.of(context).requestFocus(new FocusNode());
              },
              cursorColor: colorGreen,
            ),
          ),
          buttonSearch(),
        ]
      ),
    );
  }

  Widget buttonSearch(){
    var scaleFactor = MediaQuery.of(context).textScaleFactor;
    var size = MediaQuery.of(context).size;
    return Padding(
      padding: EdgeInsets.only(left:60, right:60),
      child: GestureDetector(
        onTap: () {
          //TODO:Aqui
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
              "BUSCAR",
              style: TextStyle(
                color: Colors.white,
                fontSize: 15 * scaleFactor,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      )
    );
  }

  String _validateCode(String value) {
    // This is just a regular expression for phone*$
    String p = '[a-zA-Z0-9]';
    RegExp regExp = new RegExp(p);

    if (value.isNotEmpty && regExp.hasMatch(value) && value.length >=6) {
      // So, the phone is valid
      return null;
    }

    // The pattern of the phone didn't match the regex above.
    return 'Ingrese el código correctamente';
  }

}

