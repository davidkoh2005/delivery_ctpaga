import 'package:delivery_ctpaga/animation/slideRoute.dart';
import 'package:delivery_ctpaga/views/navbar/navbarMain.dart';
import 'package:delivery_ctpaga/views/showDataPaidPage.dart';
import 'package:delivery_ctpaga/providers/provider.dart';
import 'package:delivery_ctpaga/models/commerce.dart';
import 'package:delivery_ctpaga/models/paid.dart';
import 'package:delivery_ctpaga/database.dart';
import 'package:delivery_ctpaga/env.dart';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:convert';
import 'dart:io';


class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage>{
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
  final _controllerSearch = TextEditingController();
  ScrollController scrollController;
  var dbctpaga = DBctpaga();
  DateTime _dateNow = DateTime.now();
  final DateFormat formatter = DateFormat('yyyy-MM-dd');
  List _listSales = new List();
  int _positionButton = 0;
  String _codeUrl;
  double positionScroll = 0.0;

  @override
  void initState() {
    super.initState();
    initialVariable();
    initialNotification();
  }

  @override
  void dispose() {
    super.dispose();
  }  

  initialVariable()async{
    var myProvider = Provider.of<MyProvider>(context, listen: false);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if(prefs.containsKey('date_codeUrl')){
      var _dataCode = DateTime.parse(prefs.getString('date_codeUrl'));
      if(_dateNow.difference(_dataCode).inDays >= 1)
        removeCode();
      else{
        myProvider.codeUrl = prefs.getString('codeUrl');
      }
    }
    _onLoading();
    myProvider.getDataAllPaids(context, true);
  }

  void initialNotification() {
    var initializationSettingsAndroid = new AndroidInitializationSettings('app_icon');
    var initializationSettingsIOS = new IOSInitializationSettings();
    var initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS
    );
    flutterLocalNotificationsPlugin.initialize(initializationSettings, onSelectNotification: selectNotification,);
  }

  Future selectNotification(String payload) async {
    if(payload == "true"){
      searchCode();
    }
  }

  void showNotification(message) async {
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'Message New id',
        'Message New name',
        'Message New description',
        importance: Importance.max,
        priority: Priority.high,
        playSound: true,
    );

    var iOS = IOSNotificationDetails();
    final NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics, iOS:  iOS);

    await flutterLocalNotificationsPlugin.show(
        0, "Código Recibido", message, platformChannelSpecifics, payload: "true"
      );

  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Consumer<MyProvider>(
        builder: (context, myProvider, child) {
          return WillPopScope(
          onWillPop: () async {        
            return false;
          },
          child: Scaffold(
            backgroundColor: Colors.white,
            floatingActionButton: FloatingActionButton(
              backgroundColor: colorGreen,
              onPressed: () {
                _onLoading();
                myProvider.getDataAllPaids(context, true);
              },
              child: Icon(Icons.refresh),
            ),
            body: Stack(
              children: <Widget> [
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    NavbarMain(),
                    GestureDetector(
                      onTap: (){
                        setState(() {
                          _codeUrl = myProvider.codeUrl;
                        });
                        searchCode();
                      },
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(60, 0, 60, 20),
                        child: Container(
                          padding: EdgeInsets.all(20),
                          width: double.infinity,
                          decoration: BoxDecoration(
                            border: Border.all(color: colorGreen),
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
                                      text: myProvider.codeUrl != null? myProvider.codeUrl : "Sin Orden",
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
                    ),
                    Container(
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
                    Container(
                      height: size.height /1.9,
                      child: showList(myProvider)
                    )
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
        padding: EdgeInsets.fromLTRB(30, 0, 30, 10),
        itemCount: myProvider.dataAllPaids.length,
        itemBuilder:  (BuildContext ctxt, int index) {
          return Padding(
            padding: EdgeInsets.only(top:10),
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: colorGreen)
              ),
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
                          valueColor: new AlwaysStoppedAnimation<Color>(colorGreen),
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
                    if(myProvider.codeUrl != null)
                      showMessage("Usted tiene orden Pendiente no puede seleccionar una orden", false);
                    else{
                      setState(() {
                        _positionButton = index+1;
                        _codeUrl = myProvider.dataAllPaids[index]['codeUrl'];
                      });
                      
                      searchCode();
                    }
                  },
                  child: _positionButton != index+1? Container(
                    width: size.width / 5,
                    height: 40,
                    decoration: BoxDecoration(
                      color:  _positionButton == index+1? colorGrey : colorGreen,
                    borderRadius: BorderRadius.circular(30),
                    ),
                    child: Center(
                      child: AutoSizeText(
                        "Ordenar",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                          fontFamily: 'MontserratSemiBold',
                        ),
                        maxFontSize: 14,
                        minFontSize: 14,
                      ),
                    ),
                  ) : Image.asset(
                    "assets/icons/loadingTransparent.gif",
                    width: size.width/8,
                  ),
                ),
              )
            )
          ); 
        }
      );
    }
  }

  removeCode() async {
    var myProvider = Provider.of<MyProvider>(context, listen: false);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove("codeUrl");
    prefs.remove("date_codeUrl");
    prefs.remove("searchAddress");
    myProvider.searchAddress = "";
    myProvider.codeUrl = null;
    setState(() {
      _codeUrl = null;
    });
  }

  searchCode()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var myProvider = Provider.of<MyProvider>(context, listen: false);
    var response, result;
    try
    {
      _onLoading();
      result = await InternetAddress.lookup('google.com'); //verify network
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        response = await http.post(
          urlApi+"showPaidDelivery",
          headers:{
            'Content-Type': 'application/json',
            'X-Requested-With': 'XMLHttpRequest',
            'authorization': 'Bearer ${myProvider.accessTokenDelivery}',
          },
          body: jsonEncode({
            "codeUrl" : _codeUrl,
          }),
        ); 
        var jsonResponse = jsonDecode(response.body); 
        print(jsonResponse);
        if (jsonResponse['statusCode'] == 201) {
          myProvider.getDataAllPaids(context, false);

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
          myProvider.codeUrl = _codeUrl;
          prefs.setString('codeUrl', _codeUrl);
          prefs.setString('date_codeUrl', formatter.format(_dateNow));

          dbctpaga.createOrUpdatePaid(_selectPaid);
          dbctpaga.createOrUpdateCommerces(_selectCommerce);
          dbctpaga.createOrUpdateSales(_listSales);

          setState(() {
            _positionButton = 0;
          });

          Navigator.pop(context);
          Navigator.push(context, SlideLeftRoute(page: ShowDataPaidPage()));
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
    if(myProvider.selectPaid.codeUrl != myProvider.codeUrl){
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
                            fontFamily: 'MontserratSemiBold',
                          )
                        ),
                        TextSpan(
                          text: "...",
                          style: TextStyle(
                            color: colorGreen,
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

