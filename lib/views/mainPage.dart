import 'package:delivery_ctpaga/animation/slideRoute.dart';
import 'package:delivery_ctpaga/views/navbar/navbarMain.dart';
import 'package:delivery_ctpaga/views/showDataPaidPage.dart';
import 'package:delivery_ctpaga/providers/provider.dart';
import 'package:delivery_ctpaga/models/commerce.dart';
import 'package:delivery_ctpaga/models/paid.dart';
import 'package:delivery_ctpaga/database.dart';
import 'package:delivery_ctpaga/env.dart';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoder/geocoder.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:convert';
import 'dart:async';
import 'dart:io';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage>{
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  final _controllerSearch = TextEditingController();
  ScrollController scrollController;
  var dbctpaga = DBctpaga();
  DateTime currentBackPressTime;
  final DateFormat formatter = DateFormat('yyyy-MM-dd');
  List _listSales = new List();
  int _positionButton = 0;
  double positionScroll = 0.0;
  String _selectCodeUrl ='';

  @override
  void initState() {
    super.initState();
    initialVariable();
    initialNotification();
    registerNotification();
  }

  initialVariable(){
    var myProvider = Provider.of<MyProvider>(context, listen: false);

    const oneSec = const Duration(seconds:1);
    new Timer.periodic(oneSec, (Timer t) => verifyShedule(myProvider));
  }

  verifyShedule(myProvider){
    DateTime _today = DateTime.now();
    DateTime _dateSheduleInitial = new DateTime(_today.year, _today.month, _today.day, 0, 0, 0);
    DateTime _dateSheduleFinal = new DateTime(_today.year, _today.month, _today.day, 23, 59, 0);
    
    if(myProvider.schedule.length >0){

      var _dateSheduleInitialGet = getTime(myProvider.schedule[0]['value']);
      var _dateSheduleFinalGet = getTime(myProvider.schedule[1]['value']); 

      var hoursInitial = getHours(_dateSheduleInitialGet['hours'], _dateSheduleInitialGet['anteMeridiem']);
      var hoursFinal = getHours(_dateSheduleFinalGet['hours'], _dateSheduleFinalGet['anteMeridiem']);
        
      _dateSheduleInitial = new DateTime(_today.year, _today.month, _today.day, hoursInitial, int.parse(_dateSheduleInitialGet['min']), 0);
      _dateSheduleFinal = new DateTime(_today.year, _today.month, _today.day, hoursFinal, int.parse(_dateSheduleFinalGet['min']), 0);

    }

    if(_today.isAfter(_dateSheduleInitial) && _today.isBefore(_dateSheduleFinal))
      myProvider.statusShedule = true;
    else
      myProvider.statusShedule = false;


    if(myProvider.statusShedule && myProvider.dataDelivery.statusAvailability==1)
      locatePosition(myProvider);
  }

  getHours(hours, anteMeridiem){

    if(anteMeridiem == "PM")
      return int.parse(hours) + 12;
    
    return int.parse(hours);
  }


  getTime(value){
    var array, hours, min, anteMeridiem;
    var result = new Map(); 
    array = value.split(":");

    hours = array[0];

    array = array[1].split(" ");
    min = array[0];
    anteMeridiem = array[1];

    result['hours'] = hours;
    result['min'] = min;
    result['anteMeridiem']= anteMeridiem;
    return result;
  }

  void locatePosition(myProvider) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Position position = await _determinePosition();

    final coordinates = new Coordinates(position.latitude, position.longitude);

    var addresses = await Geocoder.local.findAddressesFromCoordinates(coordinates);
    var first = addresses.first;
    var addressDelivery = "${first.subLocality}, ${first.addressLine}";

    if(addressDelivery != myProvider.addressDelivery){
      myProvider.addressDelivery = addressDelivery;
      prefs.setString("addressDelivery", addressDelivery);
      var result, response, jsonResponse;
       try {
        result = await InternetAddress.lookup('google.com');
        if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {

          response = await http.post(
            urlApi+"updateDelivery",
            headers:{
              'Content-Type': 'application/json',
              'X-Requested-With': 'XMLHttpRequest',
              'authorization': 'Bearer ${myProvider.accessTokenDelivery}',
            },
            body: jsonEncode({
              'addressposition': addressDelivery,
            }),
          ); 

          jsonResponse = jsonDecode(response.body); 
          if (jsonResponse['statusCode'] == 201) {
            myProvider.getDataDelivery(false, false, context);
          } 
        }
      } on SocketException catch (_) {
        print("Sin conexión a internet");
      } 
    }

  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Los servicios de ubicación están inhabilitados.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Los permisos de ubicación están permanentemente denegados, no podemos solicitar permisos.');
    }

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission != LocationPermission.whileInUse &&
          permission != LocationPermission.always) {
        return Future.error(
            'Se deniegan los permisos de ubicación (valor real: $permission).');
      }
    }

    return await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.bestForNavigation);
  }

  void registerNotification() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var myProvider = Provider.of<MyProvider>(context, listen: false);
    _firebaseMessaging.requestNotificationPermissions(
      const IosNotificationSettings(
        sound: true, badge: true, alert: true, provisional: true
      )
    );

    _firebaseMessaging.onIosSettingsRegistered.listen((IosNotificationSettings settings) {
      print("Settings registered: $settings");
    });

    _firebaseMessaging.configure(onMessage: (Map<String, dynamic> message) {
      print('onMessage: $message');
      myProvider.getDataDelivery(false, false, context);
      showNotification(message['notification']['title'],message['notification']['body']);
      return;
    }, onResume: (Map<String, dynamic> message) {
      print('onResume: $message');
      myProvider.getDataDelivery(false, false, context);
      showNotification(message['notification']['title'],message['notification']['body']);
      return;
    }, onLaunch: (Map<String, dynamic> message) {
      print('onLaunch: $message');
      myProvider.getDataDelivery(false, false, context);
      showNotification(message['notification']['title'],message['notification']['body']);
      return;
    });

    _firebaseMessaging.getToken().then((token) {
      print("token: $token");
      prefs.setString('tokenFCM', token);
      myProvider.getTokenFCM = token;
      if(token != myProvider.dataDelivery.tokenFCM || myProvider.getTokenFCM != token)
        myProvider.updateToken(token, context);
    }).catchError((err) {
      Fluttertoast.showToast(msg: err.message.toString());
    });
  }

  @override
  void dispose() {
    super.dispose();
  }  

  void initialNotification() {
    var initializationSettingsAndroid = new AndroidInitializationSettings('app_icon');
    var initializationSettingsIOS = new IOSInitializationSettings();
    var initializationSettings = InitializationSettings(initializationSettingsAndroid, initializationSettingsIOS
    );
    flutterLocalNotificationsPlugin.initialize(initializationSettings, onSelectNotification: selectNotification,);
  }

  Future selectNotification(String payload) async {
    if(payload == "true"){
      _onLoading();
      searchCode(true);
    }
  }

  void showNotification(title, message) async {

    var android = AndroidNotificationDetails(
        'Message New id',
        'Message New name',
        'Message New description',
        priority: Priority.High,
        importance: Importance.Max,
    );


    var iOS = IOSNotificationDetails(presentSound: false);

    var platformChannelSpecifics = NotificationDetails(
    android, iOS);

    await flutterLocalNotificationsPlugin.show(
        0, title, message, platformChannelSpecifics, payload: "true"
      );

    FlutterRingtonePlayer.playNotification();

  }

  // ignore: missing_return
  Future<bool> _onBackPressed(){
    DateTime now = DateTime.now();
    if (currentBackPressTime == null || now.difference(currentBackPressTime) > Duration(seconds: 2)) {
      currentBackPressTime = now;
      Fluttertoast.showToast(msg: "Presiona dos veces para salir de la aplicación");
      return Future.value(false);
    }
    exit(0);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MyProvider>(
        builder: (context, myProvider, child) {
          return WillPopScope(
          onWillPop:_onBackPressed,
          child: Scaffold(
            backgroundColor: Colors.white,
            floatingActionButton: new Visibility(
              visible: myProvider.statusShedule? myProvider.dataDelivery.statusAvailability==0? false: true : false,
              child:  FloatingActionButton(
                backgroundColor: colorLogo,
                onPressed: () {
                  _onLoading();
                  myProvider.getDataDelivery(false, false, context);
                  myProvider.getDataAllPaids(context, true);
                },
                child: Icon(Icons.refresh),
              ),
            ),
            body: Stack(
              children: <Widget> [
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    NavbarMain(),
                    Padding(
                      padding: EdgeInsets.only(right:10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Container(
                            padding: EdgeInsets.only(right:10),
                            child: AutoSizeText(
                              "Disponibilidad",
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'MontserratSemiBold',
                              ),
                              maxFontSize: 19,
                              minFontSize: 19,
                            ),
                          ),
                          Switch(
                            value: myProvider.statusShedule? myProvider.dataDelivery.statusAvailability==0? false: true : false,
                            onChanged: (value) {
                              _onLoading();
                              myProvider.getDataDelivery(false, false, context).then((_) {
                                if(myProvider.dataDelivery.status == 0){
                                  Navigator.pop(context);
                                  showMessage("No está autorizado para trabajar como delivery", false);
                                }else if(myProvider.dataDelivery.status == 2){
                                  Navigator.pop(context);
                                  showMessage("Tu cuenta se encuentra en revisión", false);
                                }else if(myProvider.dataDelivery.status == 3){
                                  myProvider.removeSession(context);
                                  showMessage("Tu cuenta se encuentra en revisión", false);
                                }else
                                  verifyStatus(myProvider);
                              });
                            },
                            activeTrackColor: colorGrey,
                            activeColor: colorLogo
                          ),
                        ],
                      ),
                    ),
                    Visibility(
                      visible: myProvider.codeUrl.length != 0? true : myProvider.dataDelivery.statusAvailability ==1? true : false,
                      child: GestureDetector(
                        onTap: (){
                          _onLoading();
                          myProvider.getDataDelivery(false, false, context).then((_) {
                            if(myProvider.statusShedule && myProvider.codeUrl.length != 0)
                                searchCode(true);
                            else{
                              Navigator.pop(context);
                              showMessage("El horario es de ${myProvider.schedule[0]['value']} hasta las ${myProvider.schedule[1]['value']}", false);
                            }
                          });
                        },
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(60, 0, 60, 20),
                          child: Container(
                            padding: EdgeInsets.all(20),
                            width: double.infinity,
                            decoration: BoxDecoration(
                              border: Border.all(color: colorLogo),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Column(
                              children: [
                                Container(
                                  padding: EdgeInsets.only(bottom: 10),
                                  alignment: Alignment.center,
                                  child: AutoSizeText(
                                    "Orden Pendiente:",
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'MontserratSemiBold',
                                    ),
                                    maxFontSize: 24,
                                    minFontSize: 24,
                                  ),
                                ),
                                AutoSizeText.rich(
                                  TextSpan(
                                    text: 'Código: ',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                      fontFamily: 'MontserratSemiBold',
                                    ),
                                    children: <TextSpan>[
                                      TextSpan(
                                        text: myProvider.codeUrl.length != 0? myProvider.codeUrl[0] : "Sin Orden",
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.normal,
                                          fontFamily: 'MontserratSemiBold',
                                        ),
                                      ),
                                    ],
                                  ),
                                  maxFontSize: 14,
                                  minFontSize: 14,
                                ),
                              ],
                            ),
                          )
                        )
                      )
                    ),
                    Visibility(
                      visible: myProvider.statusShedule? myProvider.dataDelivery.statusAvailability==0? false: true : false,
                      child: Container(
                        padding: EdgeInsets.only(left: 20, bottom: 10),
                        alignment: Alignment.centerLeft,
                        child: AutoSizeText(
                          "Orden Disponible:",
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'MontserratSemiBold',
                          ),
                          maxFontSize: 20,
                          minFontSize: 20,
                        ),
                      ),
                    ),

                    Visibility(
                      visible: myProvider.statusShedule? myProvider.dataDelivery.statusAvailability==0? false: true : false,
                      child: Expanded(
                        child: showList(myProvider),
                      ),
                    ),

                    Visibility(
                      visible: myProvider.statusShedule? myProvider.dataDelivery.statusAvailability==0? !false: !true : !false,
                      child: Expanded(
                        child: Center(
                          child: AutoSizeText(
                            myProvider.codeUrl.length == 0? "Debe estar disponible para recibir pedidos" : "Debe completar el orden pendiente",
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                              fontFamily: 'MontserratSemiBold',
                            ),
                            maxFontSize: 14,
                            minFontSize: 14,
                          ),
                        ),
                      ),
                    ),
                    
                  ],
                ),
              ]
            )
          ),
        );
      }
    );
  }

  showList(myProvider){
    var size = MediaQuery.of(context).size;
    if(myProvider.dataAllPaids.length == 0)
      return Center(
        child: AutoSizeText(
          "No hay Orden disponible",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w500,
            fontFamily: 'MontserratSemiBold',
          ),
          maxFontSize: 14,
          minFontSize: 14,
        ),
      );
    else{
      return ListView.builder(
        shrinkWrap: true, 
        padding: EdgeInsets.fromLTRB(30, 0, 30, 0),
        itemCount: myProvider.dataAllPaids.length,
        itemBuilder:  (BuildContext ctxt, int index) {
          return Padding(
            padding: EdgeInsets.only(top:10),
            child: Container(
              child: ListTile(
                onTap: () => null,
                leading: ClipOval(
                  child: CachedNetworkImage(
                    imageUrl: "http://"+url+myProvider.dataAllPaids[index]['url'],
                    fit: BoxFit.cover,
                    width: size.width / 8,
                    height: size.width / 8,
                    placeholder: (context, url) {
                      return Container(
                        margin: EdgeInsets.all(15),
                        child:CircularProgressIndicator(
                          valueColor: new AlwaysStoppedAnimation<Color>(colorLogo),
                        ),
                      );
                    },
                    errorWidget: (context, url, error) => Icon(Icons.error, color: Colors.red, size: size.width / 7,),
                  ),
                ),
                title: AutoSizeText(
                  myProvider.dataAllPaids[index]['name'],
                  style: TextStyle(
                    color:  colorText,
                    fontWeight: FontWeight.normal,
                    fontFamily: 'MontserratSemiBold',
                  ),
                  minFontSize: 14,
                  maxFontSize: 14,
                ),
                subtitle: AutoSizeText(
                  myProvider.dataAllPaids[index]['address'],
                  style: TextStyle(
                    color:  colorText,
                    fontWeight: FontWeight.normal,
                    fontFamily: 'MontserratSemiBold',
                  ),
                  minFontSize: 10,
                  maxFontSize: 10,
                ),
                trailing: GestureDetector(
                  onTap: () async {
                    if(myProvider.codeUrl.length != 0)
                      showMessage("Usted tiene orden Pendiente no puede seleccionar una orden", false);
                    else{
                      _onLoading();
                      myProvider.getDataDelivery(false, false, context).then((_) {
                        if(myProvider.statusShedule){
                          setState(() {
                            _positionButton = index+1;
                          });

                          _selectCodeUrl= myProvider.dataAllPaids[index]['codeUrl'];

                          searchCode(false);
                        }else{
                          Navigator.pop(context);
                          showMessage("El horario es de ${myProvider.schedule[0]['value']} hasta las ${myProvider.schedule[1]['value']}", false);
                        }
                      });
                    }
                  },
                  child: _positionButton != index+1? Container(
                    width: size.width / 5,
                    height: 40,
                    decoration: BoxDecoration(
                      color:  _positionButton == index+1? colorGrey : colorLogo,
                    borderRadius: BorderRadius.circular(30),
                    ),
                    child: Center(
                      child: AutoSizeText(
                        "Tomar",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                          fontFamily: 'MontserratSemiBold',
                        ),
                        maxFontSize: 14,
                        minFontSize: 14,
                      ),
                    ),
                  ) : CircularProgressIndicator(
                    valueColor: new AlwaysStoppedAnimation<Color>(colorLogo),
                  ),
                ),
              )
            )
          ); 
        }
      );
    }
  }

  verifyStatus(myProvider) async {
    if(myProvider.statusShedule){
      if(myProvider.codeUrl.length == 0){
        if(myProvider.dataDelivery.statusAvailability==0){
          myProvider.getDataAllPaids(context, false);
        }
        changeStatus();
      }else{
        Navigator.pop(context);
        showMessage("Debe completar el orden pendiente: ${myProvider.codeUrl[0]}", false);
      }
    }else{
      Navigator.pop(context);
      showMessage("El horario es de ${myProvider.schedule[0]['value']} hasta las ${myProvider.schedule[1]['value']}", false);
    }
  }

  changeStatus()async{
    var myProvider = Provider.of<MyProvider>(context, listen: false);
    var response, result;
    try
    {
      result = await InternetAddress.lookup('google.com'); //verify network
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        response = await http.post(
          urlApi+"updateDelivery",
          headers:{
            'Content-Type': 'application/json',
            'X-Requested-With': 'XMLHttpRequest',
            'authorization': 'Bearer ${myProvider.accessTokenDelivery}',
          },
          body: jsonEncode({
            "statusAvailability" : myProvider.dataDelivery.statusAvailability == 1? 0 : 1,
          }),
        ); 
        var jsonResponse = jsonDecode(response.body); 
        print(jsonResponse);
        if (jsonResponse['statusCode'] == 201) {
          myProvider.getDataDelivery(false, true, context);
        }else{
          Navigator.pop(context);
          showMessage(jsonResponse['message'], false);
        }
      }
    } on SocketException catch (_) {
      Navigator.pop(context);
      showMessage("Sin conexión a internet", false);
    }
  }

  removeCode() async {
    var myProvider = Provider.of<MyProvider>(context, listen: false);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove("codeUrl");
    prefs.remove("addressDelivery");
    myProvider.addressDelivery = "";
    myProvider.dataDelivery.codeUrlPaid = null;
  }

  searchCode(statusOrder)async{
    var myProvider = Provider.of<MyProvider>(context, listen: false);
    var response, result; 
    try
    {
      result = await InternetAddress.lookup('google.com'); //verify network
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        response = await http.post(
          statusOrder? urlApi+"showPaidDelivery" : urlApi+"orderPaidDelivery",
          headers:{
            'Content-Type': 'application/json',
            'X-Requested-With': 'XMLHttpRequest',
            'authorization': 'Bearer ${myProvider.accessTokenDelivery}',
          },
          body: jsonEncode({
            "codeUrl" : statusOrder? myProvider.codeUrl[0] : _selectCodeUrl,
          }),
        ); 
        var jsonResponse = jsonDecode(response.body); 
        print(jsonResponse);
        if (jsonResponse['statusCode'] == 201) {
          myProvider.getDataDelivery(false, false, context);

          _controllerSearch.clear();
          _listSales = [];
          for (var item in jsonResponse['data']['sales']) {
            setState(() {
              _listSales.add(item);
            });
          }

          var _selectPaid;
          _selectPaid = Paid(
            user_id: jsonResponse['data']['paid']['user_id'],
            commerce_id: jsonResponse['data']['paid']['commerce_id'],
            codeUrl: jsonResponse['data']['paid']['codeUrl'],
            nameClient: jsonResponse['data']['paid']['nameClient'],
            total: jsonResponse['data']['paid']['total'],
            coin: jsonResponse['data']['paid']['coin'],
            email: jsonResponse['data']['paid']['email'],
            nameShipping: jsonResponse['data']['paid']['nameShipping'] == null? '' : jsonResponse['data']['paid']['nameShipping'],
            numberShipping: jsonResponse['data']['paid']['numberShipping'] == null? '' : jsonResponse['data']['paid']['numberShipping'],
            addressShipping: jsonResponse['data']['paid']['addressShipping'] == null? '' : jsonResponse['data']['paid']['addressShipping'],
            detailsShipping: jsonResponse['data']['paid']['detailsShipping'] == null? '' : jsonResponse['data']['paid']['detailsShipping'],
            selectShipping: jsonResponse['data']['paid']['selectShipping'] == null? '' : jsonResponse['data']['paid']['selectShipping'],
            priceShipping: jsonResponse['data']['paid']['priceShipping'] == null? '0' : jsonResponse['data']['paid']['priceShipping'],
            statusShipping: jsonResponse['data']['paid']['statusShipping'] ,
            percentage: jsonResponse['data']['paid']['percentage'] ,
            nameCompanyPayments: jsonResponse['data']['paid']['nameCompanyPayments'],
            date: jsonResponse['data']['paid']['date'],
          );
        
          var _selectCommerce;
          _selectCommerce = Commerce(
            rif: jsonResponse['data']['commerce']['rif'],
            name: jsonResponse['data']['commerce']['name'],
            address: jsonResponse['data']['commerce']['address'],
            phone: jsonResponse['data']['commerce']['phone'],
            userUrl: jsonResponse['data']['commerce']['userUrl'],
          );
          
          myProvider.selectPaid = _selectPaid;
          myProvider.dataCommerce = _selectCommerce;
          myProvider.dataListSales = _listSales;

          dbctpaga.createOrUpdatePaid(_selectPaid);
          dbctpaga.createOrUpdateCommerces(_selectCommerce);
          dbctpaga.createOrUpdateSales(_listSales);

          await Future.delayed(Duration(seconds: 2));

          setState(() {
            _positionButton = 0;
          });

          Navigator.pop(context);
          Navigator.push(context, SlideLeftRoute(page: ShowDataPaidPage()));
        }else if (jsonResponse['statusCode'] == 401) {
          myProvider.removeSession(context);
          Navigator.pop(context);
        }else{
          setState(() {
            _positionButton = 0;
          });
          _controllerSearch.clear();
          Navigator.pop(context);
          showMessage(jsonResponse['message'], false);
        }
      }
    } on SocketException catch (_) {
      getDataDB();
    }
  }

  getDataDB()async{
    var myProvider = Provider.of<MyProvider>(context, listen: false);
    myProvider.selectPaid = await dbctpaga.getPaid();
    myProvider.dataCommerce = await dbctpaga.getCommerce();
    myProvider.dataListSales = await dbctpaga.getSales();
    if(myProvider.selectPaid.codeUrl != myProvider.codeUrl[0]){
      myProvider.selectPaid = null;
      myProvider.dataCommerce = null;
      myProvider.dataListSales = [];
      Navigator.pop(context);
      showMessage("Sin conexión a internet", false);
    }else{
      Navigator.pop(context);
      Navigator.push(context, SlideLeftRoute(page: ShowDataPaidPage()));
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

}

