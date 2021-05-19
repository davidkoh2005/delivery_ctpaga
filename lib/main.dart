import 'package:delivery_ctpaga/animation/slideRoute.dart';
import 'package:delivery_ctpaga/providers/provider.dart';
import 'package:delivery_ctpaga/views/loginPage.dart';
import 'package:delivery_ctpaga/env.dart';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:install_plugin/install_plugin.dart';
import 'package:path_provider/path_provider.dart';
import 'package:package_info/package_info.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:ext_storage/ext_storage.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'dart:convert';
import 'dart:async';
import 'dart:io' show Platform;
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
        title: 'Ctlleva',
        theme: ThemeData(
          primarySwatch: Colors.green,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        supportedLocales: [
          Locale('es','ES'),
        ],
        localizationsDelegates: GlobalMaterialLocalizations.delegates,
        home: MyHomePage(title: 'Ctlleva'),
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

class _MyHomePageState extends State<MyHomePage> with WidgetsBindingObserver {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
  String versionApp = "", newVersionApp = "" , urlApp, statusApp = "Cargando...", statusProgress = "0%", savePath;
  int progressDownloader = 0, statusObserver = 0;
  bool statusInstall = false;

  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    initialNotification();
    //changePage();
    checkVersion();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  } 

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    setState(() {
      statusObserver = state.index;
    });
    if(state.index == 0 && progressDownloader == 100 && !statusInstall){
      print("print observer");
      installApp();
    }
  }

  void initialNotification() {
    var initializationSettingsAndroid = new AndroidInitializationSettings('app_icon');
    var initializationSettingsIOS = new IOSInitializationSettings();
    var initializationSettings = InitializationSettings(initializationSettingsAndroid, initializationSettingsIOS
    );
    flutterLocalNotificationsPlugin.initialize(initializationSettings, onSelectNotification: selectNotification,);
  }

  Future selectNotification(String payload) async {
    if (payload != null) {
      debugPrint('notification payload: $payload');
    }
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
              CircularProgressIndicator(
                valueColor: new AlwaysStoppedAnimation<Color>(colorLogo),
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
            if(Platform.isAndroid)
              urlApp = jsonResponse['data']['url'];
            else
              urlApp = jsonResponse['data']['url_ios'];
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
                child: Text('Abrir'),
                onPressed: () {
                  Navigator.pop(context);
                  launch(urlApp);
                },
              ),
              Visibility(
                visible: Platform.isAndroid? true : false,
                child: FlatButton(
                  child: Text('Actualizar'),
                  onPressed: () {
                    Navigator.pop(context);
                    updateApk();
                  },
                )
              )
            ],
          ),
        );
      },
    );
  }

  void _showCompleteNotification() async {

    var android = AndroidNotificationDetails(
        'Complete Downloaded id',
        'Complete Downloaded name',
        'Complete Downloaded description',
        priority: Priority.High,
        importance: Importance.Max,
    );


    var iOS = IOSNotificationDetails(presentSound: false);

    var platformChannelSpecifics = NotificationDetails(
    android, iOS);

    await flutterLocalNotificationsPlugin.show(
        0, 'Ctlleva', "Descarga Completado", platformChannelSpecifics, payload: "complete"
      );

    FlutterRingtonePlayer.playNotification();

  }

  Future<void> _showProgressNotification(percentage) async {
      await Future<void>.delayed(const Duration(seconds: 1), () async {
        final AndroidNotificationDetails androidPlatformChannelSpecifics =
            AndroidNotificationDetails('progress channel', 'progress channel',
                'progress channel description',
                channelShowBadge: false,
                importance: Importance.Max,
                priority: Priority.High,
                onlyAlertOnce: true,
                showProgress: true,
                maxProgress: 100,
                progress: percentage);

        var iOS = IOSNotificationDetails(presentSound: false);
        var platformChannelSpecifics = NotificationDetails(androidPlatformChannelSpecifics, iOS);
        await flutterLocalNotificationsPlugin.show(
            0,
            'Ctlleva',
            'Descargando...',
            platformChannelSpecifics,
            payload: 'progress x');
      });
  }

  Future<void> _cancelNotification() async {
    await flutterLocalNotificationsPlugin.cancelAll();
  }

  updateApk()async{
    setState(() {
      statusInstall = false;
      progressDownloader = 0;
      statusApp = "Cargando...";
    });

    var dir;
    if (Platform.isAndroid) {
      dir = await ExtStorage.getExternalStoragePublicDirectory(
            ExtStorage.DIRECTORY_DOWNLOADS);
    }else{
      dir = (await getApplicationDocumentsDirectory()).path;
    }


    PermissionStatus permissionStatus = await _getStoragePermission();
    if (permissionStatus == PermissionStatus.granted) {

      await deleteFile(File(dir+'/ctlleva.apk'));
      
      setState(() {
        savePath = path.join(dir, 'ctlleva.apk');
      });

      final Dio _dio = Dio();

      try{
        setState(() {
          statusApp = "Descargando...";
        });
        await _dio.download(
          'http://www.ctpaga.app/apk/ctlleva.apk',
          savePath,
          onReceiveProgress: (received, total) async {
            if (total != -1) {
              if ((received / total * 100).toInt() <99)
                _showProgressNotification((received / total * 100).toInt());

              setState(() {
                progressDownloader = (received / total * 100).toInt();
                statusProgress = (received / total * 100).toStringAsFixed(0) + "%";
              });
              if(progressDownloader == 100 && statusObserver == 0){
                await Future.delayed(Duration(seconds: 2));
                await _cancelNotification();
              }
              else if(progressDownloader == 100 && statusObserver != 0){
                await Future.delayed(Duration(seconds: 2));
                await _cancelNotification();
                _showCompleteNotification();
              }
            }
          }
        );

      }catch (ex) {
        print(ex.toString());
        updateApk();
      } 

      setState(() {
        statusApp = "Instalando...";
      });

      if(!statusInstall && statusObserver == 0){
        installApp();
      }

    } else {
      showAlert();
    }
  }

  installApp() async
  {
    await _cancelNotification();
    setState(() {
      statusInstall = true;
    });

    await InstallPlugin.installApk(
      savePath,
      'ctpaga.ctlleva',
    ).then((result) {
      setState(() {
        statusApp = "Cargando...";
      });
      showAlert();
    });
  }

  Future<void> deleteFile(File file) async {
    try {
      if (await file.exists()) {
        await file.delete();
      }
    } catch (e) {
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
