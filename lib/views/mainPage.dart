import 'package:delivery_ctpaga/animation/slideRoute.dart';
import 'package:delivery_ctpaga/views/navbar/navbarMain.dart';
import 'package:delivery_ctpaga/views/showDataPaidPage.dart';
import 'package:delivery_ctpaga/providers/provider.dart';
import 'package:delivery_ctpaga/models/commerce.dart';
import 'package:delivery_ctpaga/models/paid.dart';
import 'package:delivery_ctpaga/database.dart';
import 'package:delivery_ctpaga/env.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'dart:convert';
import 'dart:io';


class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final _formKeySearch = new GlobalKey<FormState>();
  var dbctpaga = DBctpaga();
  DateTime _dateNow = DateTime.now();
  final DateFormat formatter = DateFormat('yyyy-MM-dd');
  List _listSales = new List();
  bool _statusBotton = false; 
  String _codeUrl;

  @override
  void initState() {
    super.initState();
    initialVariable();
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
      if(_dateNow.difference(_dataCode).inDays > 1)
        removeCode();
      else{
        myProvider.codeUrl = prefs.getString('codeUrl');
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    var scaleFactor = MediaQuery.of(context).textScaleFactor;

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
                      Consumer<MyProvider>(
                        builder: (context, myProvider, child) {
                          return Visibility(
                            visible: myProvider.codeUrl == null? false : true,
                            child: GestureDetector(
                              onTap: (){
                                setState(() {
                                  _codeUrl = myProvider.codeUrl;
                                });
                                searchCode();
                              },
                              child: Padding(
                                padding: EdgeInsets.fromLTRB(60, 0, 60, 40),
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
                                        padding: EdgeInsets.only(bottom: 20),
                                        alignment: Alignment.center,
                                        child: Text(
                                          "Ultima Busqueda:",
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 25 * scaleFactor,
                                            fontWeight: FontWeight.bold,
                                            fontFamily: 'MontserratSemiBold',
                                          )
                                        ),
                                      ),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          RichText(
                                            text: TextSpan(
                                              text: 'Código: ',
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 15 * scaleFactor,
                                                color: Colors.black,
                                                fontFamily: 'MontserratSemiBold',
                                              ),
                                              children: <TextSpan>[
                                                TextSpan(
                                                  text: myProvider.codeUrl,
                                                  style: TextStyle(
                                                    fontSize: 15 * scaleFactor,
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.normal,
                                                    fontFamily: 'MontserratSemiBold',
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          IconButton(
                                            iconSize: 25,
                                            icon: Icon(
                                              Icons.delete,
                                              color: Colors.red,
                                              ),
                                            onPressed: () {
                                              removeCode();
                                            }
                                          )
                                        ],
                                      ),
                                      ],
                                  ),
                                )
                              )
                            )
                          );
                        }
                      ),
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

  removeCode() async {
    var myProvider = Provider.of<MyProvider>(context, listen: false);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove("codeUrl");
    prefs.remove("date_codeUrl");
    prefs.remove("searchAddress");
    myProvider.searchAddress = "";
    myProvider.codeUrl = null;
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
                  fontSize: 20 * scaleFactor,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'MontserratSemiBold',
                )
              ),
            ) 
          ),

          Padding(
            padding: const EdgeInsets.fromLTRB(60.0, 0.0, 60.0, 30.0),
            child: TextFormField(
              autofocus: false,
              decoration: InputDecoration(
                labelText: 'código',
                labelStyle: TextStyle(
                  color: colorText,
                  fontFamily: 'MontserratSemiBold',
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: colorGreen),
                ),
              ),
              validator: _validateCode,
              textInputAction: TextInputAction.done,
              onSaved: (val) => _codeUrl = val,
              onChanged: (val){
                setState(() {
                  _codeUrl = val;
                });
              },
              onEditingComplete: () {
                FocusScope.of(context).requestFocus(new FocusNode());
                if (_formKeySearch.currentState.validate()) {
                  _formKeySearch.currentState.save();
                  searchCode();
                }
              },
              cursorColor: colorGreen,
              style: TextStyle(
                fontFamily: 'MontserratSemiBold',
              ),
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
        onTap: () async {
          FocusScope.of(context).requestFocus(new FocusNode());
          setState(() => _statusBotton = true);
          await Future.delayed(Duration(milliseconds: 150));
          setState(() => _statusBotton = false);
          if (_formKeySearch.currentState.validate()) {
            _formKeySearch.currentState.save();
            searchCode();
          }
        },
        child: Container(
          width:size.width - 100,
          height: size.height / 20,
          decoration: BoxDecoration(
            color: _statusBotton? colorGrey : colorGreen,
          borderRadius: BorderRadius.circular(30),
          ),
          child: Center(
            child: Text(
              "BUSCAR",
              style: TextStyle(
                color: Colors.white,
                fontSize: 15 * scaleFactor,
                fontWeight: FontWeight.w500,
                fontFamily: 'MontserratSemiBold',
              ),
            ),
          ),
        ),
      )
    );
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
          urlApi+"showPaid",
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

          Navigator.pop(context);
          Navigator.push(context, SlideLeftRoute(page: ShowDataPaidPage()));
        }else{
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
    var scaleFactor = MediaQuery.of(context).textScaleFactor;
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
                    fontSize: 15 * scaleFactor,
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
    var scaleFactor = MediaQuery.of(context).textScaleFactor;

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
                            fontSize: 15 * scaleFactor,
                            fontFamily: 'MontserratSemiBold',
                          )
                        ),
                        TextSpan(
                          text: "...",
                          style: TextStyle(
                            color: colorGreen,
                            fontSize: 15 * scaleFactor,
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

