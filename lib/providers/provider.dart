import 'package:delivery_ctpaga/animation/slideRoute.dart';
import 'package:delivery_ctpaga/models/commerce.dart';
import 'package:delivery_ctpaga/models/delivery.dart';
import 'package:delivery_ctpaga/models/paid.dart';
import 'package:delivery_ctpaga/views/loginPage.dart';
import 'package:delivery_ctpaga/views/mainMenuBar.dart';
import 'package:delivery_ctpaga/database.dart';
import 'package:delivery_ctpaga/env.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';


class MyProvider with ChangeNotifier {
  //call function BD    
  var dbctpaga = DBctpaga();

  String _accessToken;
  String get accessTokenDelivery =>_accessToken; 
  
  set accessTokenDelivery(String newToken) {
    _accessToken = newToken; 
    notifyListeners(); 
  }

  Delivery _delivery = Delivery();
  Delivery get dataDelivery =>_delivery;

  set dataDelivery(Delivery newDelivery){
    _delivery = newDelivery;
    notifyListeners();
  }

  List _codeUrl;
  List get codeUrl =>_codeUrl; 
  
  set codeUrl(List newcode) {
    _codeUrl = newcode; 
    notifyListeners(); 
  }

  String _addressDelivery;
  String get addressDelivery =>_addressDelivery; 
  
  set addressDelivery(String newAddress) {
    _addressDelivery = newAddress; 
    notifyListeners(); 
  }

  int _statusButton;
  int get statusButton =>_statusButton; 
  
  set statusButton(int newStatus) {
    _statusButton = newStatus; 
    notifyListeners(); 
  }

  bool _statusInitGoogle;
  bool get statusInitGoogle =>_statusInitGoogle; 
  
  set statusInitGoogle(bool newStatus) {
    _statusInitGoogle = newStatus; 
    notifyListeners(); 
  }

  Paid _selectPaid = Paid();
  Paid get selectPaid =>_selectPaid; 
  
  set selectPaid(Paid newItem) {
    _selectPaid = newItem; 
    notifyListeners(); 
  }

  Commerce _commerce = new Commerce();
  Commerce get dataCommerce =>_commerce;

  set dataCommerce(Commerce newCommerce){
    _commerce = newCommerce;
    notifyListeners();
  }

  List _listSales = new List();
  List get dataListSales =>_listSales;

  set dataListSales(List newListSales){
    _listSales = newListSales;
    notifyListeners();
  }

  List _listAllPaids = new List();
  List get dataAllPaids =>_listAllPaids;

  set dataAllPaids(List newListAllPaids){
    _listAllPaids = newListAllPaids;
    notifyListeners();
  }

  List schedule = new List();
  List get getScheduleInitial =>schedule;

  set getScheduleInitial(List newScheduleInitial){
    schedule = newScheduleInitial;
    notifyListeners();
  }

  bool _statusShedule;
  bool get statusShedule =>_statusShedule; 
  
  set statusShedule(bool newStatus) {
    _statusShedule = newStatus; 
    notifyListeners(); 
  }

  String _tokenFCM;
  String get getTokenFCM =>_tokenFCM; 
  
  set getTokenFCM(String newValue) {
    _tokenFCM = newValue; 
    notifyListeners(); 
  }

  
  Delivery delivery = Delivery();
  List listCommerces = new List();

  getDataDelivery(status, loading, context)async{

    var result, response, jsonResponse;
    schedule = [];

    try {
      result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        response = await http.post(
          urlApi+"delivery",
          headers:{
            'Content-Type': 'application/json',
            'X-Requested-With': 'XMLHttpRequest',
            'authorization': 'Bearer $accessTokenDelivery',
          },
        ); 
        print("bearer $accessTokenDelivery");
        jsonResponse = jsonDecode(response.body);
        print(jsonResponse);
        if (jsonResponse['statusCode'] == 201) {
          delivery = Delivery(
            id: jsonResponse['data']['id'],
            email: jsonResponse['data']['email'],
            name: jsonResponse['data']['name'],
            phone: jsonResponse['data']['phone'],
            status: jsonResponse['data']['status'],
            codeUrlPaid:jsonResponse['data']['codeUrlPaid'],
            statusAvailability : jsonResponse['data']['statusAvailability'],
            tokenFCM: jsonResponse['data']['token_fcm'],
          );

          dataDelivery = delivery;
          
          if(jsonResponse['data']['codeUrlPaid'] != null){
            var codeUrlJson = jsonDecode(jsonResponse['data']['codeUrlPaid']);
            var _listCode = new List();
            codeUrlJson.forEach((element) => _listCode.add(element));
            codeUrl = _listCode;
          }
          else
            codeUrl = [];

          if(await dbctpaga.existDelivery() == 0)
            dbctpaga.addNewDelivery(delivery);
          else
            dbctpaga.updateDelivery(delivery); 
          
          if(dataDelivery.status != 1)
            removeSession(context, true);
          else{

            if(delivery.tokenFCM == null && getTokenFCM != delivery.tokenFCM)
              updateToken(getTokenFCM, context);
            
            if(jsonResponse['scheduleInitial'] != null && jsonResponse['scheduleFinal'] != null){
              schedule.add(jsonResponse['scheduleInitial']);
              schedule.add(jsonResponse['scheduleFinal']);

              dbctpaga.createOrUpdateSettings(schedule);
            }

            //verifySchedule();

            await Future.delayed(Duration(seconds: 1));

            if(loading){
              Navigator.pop(context);
            }

            if(status){
              Navigator.pushReplacement(context, SlideLeftRoute(page: MainMenuBar()));
            }
          }
        }else{
          removeSession(context, true);
        }
      }
    } on SocketException catch (_) {
      if(accessTokenDelivery != null){
        dataDelivery = await dbctpaga.getDelivery();

        if(dataDelivery.codeUrlPaid != null){
            var codeUrlJson = jsonDecode(dataDelivery.codeUrlPaid);
            var _listCode = new List();
            codeUrlJson.forEach((element) => _listCode.add(element));
            codeUrl = _listCode;
          }
          else
            codeUrl = [];
      }

      if(status){
        Navigator.pushReplacement(context, SlideLeftRoute(page: MainMenuBar()));
      }
    }
  }

  updateToken(token, context)async{
    var result, response, jsonResponse;
       try {
        result = await InternetAddress.lookup('google.com');
        if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {

          response = await http.post(
            urlApi+"updateDelivery",
            headers:{
              'Content-Type': 'application/json',
              'X-Requested-With': 'XMLHttpRequest',
              'authorization': 'Bearer $accessTokenDelivery',
            },
            body: jsonEncode({
              'token_fcm': token,
            }),
          ); 

          jsonResponse = jsonDecode(response.body); 

          print(jsonResponse);

          if (jsonResponse['statusCode'] == 201) {
            getDataDelivery(false, false, context);
          } 
        }
      } on SocketException catch (_) {
        print("Sin conexión a internet");
      }
  }

  verifySchedule(){
    DateTime _today = DateTime.now();
    var _dateSheduleInitialGet = getTime(schedule[0]['value']);
    var _dateSheduleFinalGet = getTime(schedule[1]['value']); 


    var hoursInitial = getHours(_dateSheduleInitialGet['hours'], _dateSheduleInitialGet['anteMeridiem']);
    var hoursFinal = getHours(_dateSheduleFinalGet['hours'], _dateSheduleFinalGet['anteMeridiem']);
      
    DateTime _dateSheduleInitial = new DateTime(_today.year, _today.month, _today.day, hoursInitial, int.parse(_dateSheduleInitialGet['min']), 0);
    DateTime _dateSheduleFinal = new DateTime(_today.year, _today.month, _today.day, hoursFinal, int.parse(_dateSheduleFinalGet['min']), 0);
    
    if(_today.isAfter(_dateSheduleInitial) && _today.isBefore(_dateSheduleFinal))
      statusShedule = true;
    else
      statusShedule = false;
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

  getDataAllPaids(context, status)async{
    _listAllPaids = [];

    var result, response, jsonResponse;

    try {
      result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        response = await http.get(
          urlApi+"showPaidAll",
          headers:{
            'Content-Type': 'application/json',
            'X-Requested-With': 'XMLHttpRequest',
            'authorization': 'Bearer $accessTokenDelivery',
          },
        ); 
        print("bearer $accessTokenDelivery");
        jsonResponse = jsonDecode(response.body);
        print(jsonResponse);
        if (jsonResponse['statusCode'] == 201) {
          dataAllPaids = jsonResponse['data'];
        }else if (jsonResponse['statusCode'] == 401) {
          removeSession(context, true);
        }
        if(status)
          Navigator.pop(context);
      }
    } on SocketException catch (_) {
      if(status)
        Navigator.pop(context);
    }
  }

 
  removeSession(BuildContext context, statusLogin)async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove("access_token");
    delivery = Delivery(
      status: 0,
    );
    dataDelivery = delivery;
    dbctpaga.deleteAll();
    codeUrl = null;

    if(statusLogin)
      Navigator.pushReplacement(context, SlideLeftRoute(page: LoginPage()));
  }

}