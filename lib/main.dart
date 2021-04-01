import 'package:delivery_ctpaga/animation/slideRoute.dart';
import 'package:delivery_ctpaga/providers/provider.dart';
import 'package:delivery_ctpaga/views/loginPage.dart';
import 'package:delivery_ctpaga/env.dart';

import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:install_plugin/install_plugin.dart';
import 'package:path_provider/path_provider.dart';
import 'package:package_info/package_info.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'dart:convert';
import 'dart:async';
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
  String versionApp = "", newVersionApp = "" , urlApp, statusApp = "Cargando...", statusProgress = "0%";
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
              Container(
                padding: EdgeInsets.only(top:5, bottom: 5),
                child: AutoSizeText(
                  statusApp,
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'MontserratSemiBold',
                  ),
                  maxFontSize: 24,
                  minFontSize: 24,
                ),
              ),
              Visibility(
                visible: statusApp == 'Descargando...'? true : false,
                child: Container(
                  padding: EdgeInsets.only(top:5, bottom: 5),
                  child: AutoSizeText(
                    statusProgress,
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'MontserratSemiBold',
                    ),
                    maxFontSize: 24,
                    minFontSize: 24,
                  ),
                )
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
                child: Text('Actualizar'),
                onPressed: () {
                  Navigator.pop(context);
                  updateApk();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  updateApk()async{
    final dir = await _getDownloadDirectory();

    PermissionStatus permissionStatus = await _getStoragePermission();
    if (permissionStatus == PermissionStatus.granted) {
      setState(() {
        statusApp = "Solicitando Permiso del Almacenamiento";
      });
      final savePath = path.join(dir.path, 'delivery ctpaga.apk');
      final Dio _dio = Dio();

      try{
        setState(() {
          statusApp = "Descargando...";
        });
        await _dio.download(
          'http://www.ctpaga.app/apk/delivery%20ctpaga.apk',
          savePath,
          onReceiveProgress: (received, total) {
            if (total != -1) {
              setState(() {
                statusProgress = (received / total * 100).toStringAsFixed(0) + "%";
              });
            }
          }
        );

      }catch (ex) {
        print(ex.toString());
      } 


      print("print entro instalar");
      setState(() {
        statusApp = "Instalando...";
      });

      await InstallPlugin.installApk(
        savePath,
        'com.example.delivery_ctpaga',
      );


    } else {
      print("entro error permiso");
      updateApk();
    }
  }

  Future<PermissionStatus> _getStoragePermission() async {
    final PermissionStatus permission = await Permission.storage.status;
    if (permission != PermissionStatus.granted &&
        permission != PermissionStatus.denied) {
      final Map<Permission, PermissionStatus> permissionStatus =
          await [Permission.storage].request();
      return permissionStatus[Permission.storage] ??
          PermissionStatus.undetermined;
    } else {
      return permission;
    }
  }


  Future<Directory> _getDownloadDirectory() async {
    if (Platform.isAndroid) {
      return await getApplicationDocumentsDirectory();
    }

    // in this example we are using only Android and iOS so I can assume
    // that you are not trying it for other platforms and the if statement
    // for iOS is unnecessary

    // iOS directory visible to user
    return await getApplicationDocumentsDirectory();
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
      myProvider.getTokenFCM = prefs.containsKey('tokenFCM')? prefs.getString('tokenFCM') : null;
      myProvider.getDataDelivery(true, false, context);
      myProvider.getDataAllPaids(context, false);
    }else{
      Navigator.pushReplacement(context, SlideLeftRoute(page: LoginPage()));
    }
  }
}
