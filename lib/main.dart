import 'package:delivery_ctpaga/animation/slideRoute.dart';
import 'package:delivery_ctpaga/providers/provider.dart';
import 'package:delivery_ctpaga/views/loginPage.dart';
import 'package:delivery_ctpaga/env.dart';

import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:package_info/package_info.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:io';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider( 
      create: (_) => MyProvider(),
      child: MaterialApp(
        title: 'Delivery ctpaga',
        theme: ThemeData(
          primarySwatch: Colors.green,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        supportedLocales: [
          Locale('es','ES'),
        ],
        localizationsDelegates: GlobalMaterialLocalizations.delegates,
        home: MyHomePage(title: 'Ctpaga'),
      )
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String versionApp = "", newVersionApp = "" , urlApp;
  void initState() {
    super.initState();
    //changePage();
    checkVersion();
  }

  @override
  Widget build(BuildContext context) {

    var size = MediaQuery.of(context).size;

    return WillPopScope(
      onWillPop: () async =>false,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image(
                image: AssetImage("assets/icons/delivery.png"),
                width: size.width/1.2,
              ),
              Image.asset(
                "assets/icons/loadingTransparent.gif",
                width: size.width/6,
              ),
            ]
          ),
        ),
      ),
    );
  }

  checkVersion()async{
    var result, response, jsonResponse;
    final PackageInfo info = await PackageInfo.fromPlatform();
    try {
      result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        response = await http.post(
          urlApi+"version",
          headers:{
            'Content-Type': 'application/json',
            'X-Requested-With': 'XMLHttpRequest',
          },
          body: jsonEncode({
            'app': 'delivery ctpaga',
          }),
        ); 

        jsonResponse = jsonDecode(response.body);
        print(jsonResponse);
        if (jsonResponse['statusCode'] == 201) {
          if(info.version != jsonResponse['data']['version']){
            versionApp = info.version;
            newVersionApp = jsonResponse['data']['version'];
            urlApp = jsonResponse['data']['url'];
            showAlert();
          }else{
            changePage();
          }
        }else{
          print("Error Network");
          changePage();
        }
      }
    } on SocketException catch (_) {
      print("Error Network");
      changePage();
    }
  }

  showAlert(){
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () async =>false,
          child: AlertDialog(
            title: Text("Nueva versión"),
            content: Text("Versión Actual es $versionApp y la nueva versión es $newVersionApp "),
            actions: <Widget>[
              FlatButton(
                child: Text('Update'),
                onPressed: () {
                  launch(urlApp);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  changePage() async{
    var myProvider = Provider.of<MyProvider>(context, listen: false);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // timeout and then shows login and registration or main page
    await Future.delayed(Duration(seconds: 2));
    if(prefs.containsKey('access_token')){
      myProvider.accessTokenDelivery = prefs.getString('access_token');
      myProvider.addressDelivery = prefs.containsKey('addressDelivery')? prefs.getString('addressDelivery') : '';
      myProvider.statusButton = 2;
      myProvider.statusInitGoogle = false;
      myProvider.statusShedule = false;
      myProvider.getDataDelivery(true, false, context);
      myProvider.getDataAllPaids(context, false);
      myProvider.getTokenFCM = prefs.containsKey('tokenFCM')? prefs.getString('tokenFCM') : null;
    }else{
      Navigator.pushReplacement(context, SlideLeftRoute(page: LoginPage()));
    }
  }
}
