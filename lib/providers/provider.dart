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

  String _codeUrl;
  String get codeUrl =>_codeUrl; 
  
  set codeUrl(String newcode) {
    _codeUrl = newcode; 
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
  
  
  Delivery delivery = Delivery();
  List listCommerces = new List();

  getDataDelivery(status, loading, context)async{

    var result, response, jsonResponse;

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
          await dbctpaga.deleteAll();
          await Future.delayed(Duration(milliseconds: 1000));
          delivery = Delivery(
            id: jsonResponse['data']['id'],
            email: jsonResponse['data']['email'],
            name: jsonResponse['data']['name'],
            phone: jsonResponse['data']['phone'],
            status: jsonResponse['data']['status']
          );

          dataDelivery = delivery;

          if(await dbctpaga.existDelivery() == 0)
            dbctpaga.addNewDelivery(delivery);
          else
            dbctpaga.updateDelivery(delivery); 

          await Future.delayed(Duration(seconds: 1));

          if(loading){
            Navigator.pop(context);
          }

          if(status){
            Navigator.pushReplacement(context, SlideLeftRoute(page: MainMenuBar()));
          }
        }else{
          removeSession(context, true);
        }
      }
    } on SocketException catch (_) {
      if(accessTokenDelivery != null){
        dataDelivery = await dbctpaga.getDelivery();
      }

      if(status){
        Navigator.pushReplacement(context, SlideLeftRoute(page: MainMenuBar()));
      }
    }
  }
 
  removeSession(BuildContext context, status)async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove("access_token");
    dataDelivery = null;
    dbctpaga.deleteAll();

    if(status)
      Navigator.pushReplacement(context, SlideLeftRoute(page: LoginPage()));
  }

}