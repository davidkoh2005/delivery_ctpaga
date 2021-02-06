
import 'package:delivery_ctpaga/views/navbar/navbar.dart';
import 'package:delivery_ctpaga/providers/provider.dart';
import 'package:delivery_ctpaga/models/paid.dart';
import 'package:delivery_ctpaga/database.dart';
import 'package:delivery_ctpaga/env.dart';

import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:io';



class ShowDataPaidPage extends StatefulWidget {
  
  @override
  _ShowDataPaidPageState createState() => _ShowDataPaidPageState();
}

class _ShowDataPaidPageState extends State<ShowDataPaidPage> {
  var dbctpaga = DBctpaga();
  String codeUrl;
  final elements = [
    "PRODUCTOS NO RETIRADO",
    "PRODUCTOS RETIRADO",
    "PRODUCTOS ENTREGADO",
  ];

  void initState() {
    super.initState();
  }

  void dispose(){
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return Consumer<MyProvider>(
      builder: (context, myProvider, child) {
        return WillPopScope(
          onWillPop: () async {return true;},
          child: Scaffold(
            backgroundColor: Colors.white,
            body: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Navbar("Código: ${myProvider.codeUrl}"),
                Expanded(
                  child: showDataPaid(),
                ),
              ],
            ),
          )
        );
      }
    );
  }

  Widget showDataPaid(){
    var myProvider = Provider.of<MyProvider>(context, listen: false);
    var size = MediaQuery.of(context).size;
    return ListView(
      padding: EdgeInsets.only(bottom: 20),
      children: <Widget>[
        Padding(
          padding: EdgeInsets.fromLTRB(40, 0, 40, 20),
          child: Container(
            alignment: Alignment.center,
            height: size.height / 20,
            decoration: BoxDecoration(
              color: colorGreen,
              borderRadius: BorderRadius.circular(30),
            ),
            child: Center(
              child: AutoSizeText(
                "COMMERCIO",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'MontserratSemiBold',
                ),
                maxFontSize: 14,
                minFontSize: 14,
              ),
            )
          )
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.fromLTRB(30,0,30,5),
                  alignment: Alignment.centerLeft,
                  width: size.width - 100,
                  child: AutoSizeText.rich(
                    TextSpan(
                      text: 'Nombre: ',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        fontFamily: 'MontserratSemiBold',
                      ),
                      children: <TextSpan>[
                        TextSpan(
                          text: myProvider.dataCommerce.name,
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
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(30,0,30,5),
                  alignment: Alignment.centerLeft,
                  width: size.width - 100,
                  child: AutoSizeText.rich(
                    TextSpan(
                      text: 'Dirección: ',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        fontFamily: 'MontserratSemiBold',
                      ),
                      children: <TextSpan>[
                        TextSpan(
                          text: myProvider.dataCommerce.address,
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
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(30,0,30,5),
                  alignment: Alignment.centerLeft,
                  width: size.width - 100,
                  child: AutoSizeText.rich(
                    TextSpan(
                      text: 'Telefono: ',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        fontFamily: 'MontserratSemiBold',
                      ),
                      children: <TextSpan>[
                        TextSpan(
                          text: myProvider.dataCommerce.phone,
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
                ),
              ],
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: EdgeInsets.only(right:50),
                  child: IconButton(
                    icon: Image.asset(
                      "assets/icons/mapa.png",
                      width: size.width / 15,
                      height: size.width / 15,
                      color: colorGreen,
                    ), 
                    onPressed: () async{
                  /*  SharedPreferences prefs = await SharedPreferences.getInstance();
                      prefs.setString('searchAddress', myProvider.selectPaid.addressShipping);
                      myProvider.statusInitGoogle = true;
                      myProvider.statusButton = 1;
                      myProvider.searchAddress = myProvider.dataCommerce.address;
                      Navigator.pop(context); */
                      openGoogleMaps(myProvider.dataCommerce.address);
                    }
                  ),
                ),
              ],
            ),
          ],
        ),

        Padding(
          padding: EdgeInsets.fromLTRB(40, 20, 40, 20),
          child: Container(
            alignment: Alignment.center,
            height: size.height / 20,
            decoration: BoxDecoration(
              color: colorGreen,
              borderRadius: BorderRadius.circular(30),
            ),
            child: Center(
              child: AutoSizeText(
                "CONTACTO",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'MontserratSemiBold',
                ),
                maxFontSize: 14,
                minFontSize: 14,
              ),
            )
          )
        ),

        Container(
          padding: EdgeInsets.fromLTRB(30,0,30,5),
          alignment: Alignment.centerLeft,
          child: AutoSizeText.rich(
            TextSpan(
              text: 'Nombre: ',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black,
                fontFamily: 'MontserratSemiBold',
              ),
              children: <TextSpan>[
                TextSpan(
                  text: myProvider.selectPaid.nameClient,
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
        ),

        Container(
          padding: EdgeInsets.fromLTRB(30,0,30,5),
          alignment: Alignment.centerLeft,
          child: AutoSizeText.rich(
            TextSpan(
              text: 'Correo: ',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black,
                fontFamily: 'MontserratSemiBold',
              ),
              children: <TextSpan>[
                TextSpan(
                  text: myProvider.selectPaid.email,
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
        ),

        Padding(
          padding: EdgeInsets.fromLTRB(40, 20, 40, 20),
          child: Container(
            alignment: Alignment.center,
            height: size.height / 20,
            decoration: BoxDecoration(
              color: colorGreen,
              borderRadius: BorderRadius.circular(30),
            ),
            child: Center(
              child: AutoSizeText(
                "DETALLE DE ENVÍO",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'MontserratSemiBold',
                ),
                maxFontSize: 14,
                minFontSize: 14,
              ),
            )
          )
        ),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.fromLTRB(30,0,30,5),
                  alignment: Alignment.centerLeft,
                  width: size.width - 100,
                  child: AutoSizeText.rich(
                    TextSpan(
                      text: 'Nombre: ',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        fontFamily: 'MontserratSemiBold',
                      ),
                      children: <TextSpan>[
                        TextSpan(
                          text: myProvider.selectPaid.nameShipping,
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
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(30,0,30,5),
                  alignment: Alignment.centerLeft,
                  width: size.width - 100,
                  child: AutoSizeText.rich(
                    TextSpan(
                      text: 'Teléfono: ',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        fontFamily: 'MontserratSemiBold',
                      ),
                      children: <TextSpan>[
                        TextSpan(
                          text: myProvider.selectPaid.statusShipping >=1? myProvider.selectPaid.numberShipping : "BLOQUEADO",
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
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(30,0,30,5),
                  alignment: Alignment.centerLeft,
                  width: size.width - 100,
                  child: AutoSizeText.rich(
                    TextSpan(
                      text: 'Dirección: ',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        fontFamily: 'MontserratSemiBold',
                      ),
                      children: <TextSpan>[
                        TextSpan(
                          text: myProvider.selectPaid.statusShipping >=1? myProvider.selectPaid.addressShipping : "BLOQUEADO",
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
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(30,0,30,5),
                  alignment: Alignment.centerLeft,
                  width: size.width - 100,
                  child: AutoSizeText.rich(
                    TextSpan(
                      text: 'Detalle: ',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        fontFamily: 'MontserratSemiBold',
                      ),
                      children: <TextSpan>[
                        TextSpan(
                          text: myProvider.selectPaid.statusShipping >=1? myProvider.selectPaid.detailsShipping : "BLOQUEADO",
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
                ),
              ],
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: EdgeInsets.only(right:50),
                  child: IconButton(
                    icon: Image.asset(
                      "assets/icons/mapa.png",
                      width: size.width / 15,
                      height: size.width / 15,
                      color: colorGreen,
                    ), 
                    onPressed: () async{
                      /* SharedPreferences prefs = await SharedPreferences.getInstance();
                      prefs.setString('searchAddress', myProvider.selectPaid.addressShipping);
                      myProvider.statusButton = 1;
                      myProvider.searchAddress = myProvider.selectPaid.addressShipping;
                      myProvider.statusInitGoogle = true;
                      Navigator.pop(context); */
                      openGoogleMaps(myProvider.selectPaid.addressShipping);
                    }
                  ),
                ),
              ],
            ),
          ],
        ),


        Padding(
          padding: EdgeInsets.fromLTRB(40, 20, 40, 20),
          child: Container(
            alignment: Alignment.center,
            height: size.height / 20,
            decoration: BoxDecoration(
              color: colorGreen,
              borderRadius: BorderRadius.circular(30),
            ),
            child: Center(
              child: AutoSizeText(
                "ENVIO SELECCIONADO",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'MontserratSemiBold',
                ),
                maxFontSize: 14,
                minFontSize: 14,
              ),
            )
          )
        ),
        Container(
          padding: EdgeInsets.fromLTRB(30,0,30,5),
          alignment: Alignment.centerLeft,
          child: ListBody(
            children: [
              AutoSizeText(
                'Estado: ',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  fontFamily: 'MontserratSemiBold',
                ),
                maxFontSize: 14,
                minFontSize: 14,
              ),
              CheckboxListTile(
                contentPadding: EdgeInsets.zero,
                title: AutoSizeText(
                  "PRODUCTOS NO RETIRADO",
                  textAlign: TextAlign.justify,
                  style: TextStyle(
                    color: Colors.black,
                    fontFamily: 'MontserratSemiBold',
                  ),
                  maxFontSize: 14,
                  minFontSize: 14,
                ),
                value: 0 <= myProvider.selectPaid.statusShipping? true: false,
                activeColor: colorGreen,
                onChanged: (newValue) { 
                  verifyUpdate(0);
                },
                controlAffinity: ListTileControlAffinity.leading,  //  <-- leading Checkbox
              ),
              CheckboxListTile(
                contentPadding: EdgeInsets.zero,
                title: AutoSizeText(
                  "PRODUCTOS RETIRADO",
                  textAlign: TextAlign.justify,
                  style: TextStyle(
                    color: Colors.black,
                    fontFamily: 'MontserratSemiBold',
                  ),
                  maxFontSize: 14,
                  minFontSize: 14,
                ),
                value: 1 == myProvider.selectPaid.statusShipping? true: false,
                activeColor: colorGreen,
                onChanged: (newValue) { 
                  verifyUpdate(1);
                },
                controlAffinity: ListTileControlAffinity.leading,  //  <-- leading Checkbox
              ),
              CheckboxListTile(
                contentPadding: EdgeInsets.zero,
                title: AutoSizeText(
                  "PRODUCTOS ENTREGADO",
                  textAlign: TextAlign.justify,
                  style: TextStyle(
                    color: Colors.black,
                    fontFamily: 'MontserratSemiBold',
                  ),
                  maxFontSize: 14,
                  minFontSize: 14,
                ),
                value: 2 <= myProvider.selectPaid.statusShipping? true: false,
                activeColor: colorGreen,
                onChanged: (newValue) { 
                  verifyUpdate(2);
                },
                controlAffinity: ListTileControlAffinity.leading,  //  <-- leading Checkbox
              ),
            ],
          ),
        ),
        Container(
          padding: EdgeInsets.fromLTRB(30,0,30,5),
          alignment: Alignment.centerLeft,
          child: AutoSizeText.rich(
            TextSpan(
              text: 'Descripción: ',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black,
                fontFamily: 'MontserratSemiBold',
              ),
              children: <TextSpan>[
                TextSpan(
                  text: myProvider.selectPaid.selectShipping,
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
        ),
        Container(
          padding: EdgeInsets.fromLTRB(30,0,30,5),
          alignment: Alignment.centerLeft,
          child: AutoSizeText.rich(
            TextSpan(
              text: 'Precio: ',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black,
                fontFamily: 'MontserratSemiBold',
              ),
              children: <TextSpan>[
                TextSpan(
                  text: showTotal(myProvider.selectPaid.coin, myProvider.selectPaid.priceShipping),
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
        ),
        Container(
          padding: EdgeInsets.fromLTRB(30,0,30,5),
          alignment: Alignment.centerRight,
          child: AutoSizeText.rich(
            TextSpan(
              text: 'Descuento: ',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black,
                fontFamily: 'MontserratSemiBold',
              ),
              children: <TextSpan>[
                TextSpan(
                  text: "${myProvider.selectPaid.percentage} %",
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
        ),

        Container(
          padding: EdgeInsets.fromLTRB(30,0,30,5),
          alignment: Alignment.centerRight,
          child: AutoSizeText.rich(
            TextSpan(
              text: 'Total: ',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black,
                fontFamily: 'MontserratSemiBold',
              ),
              children: <TextSpan>[
                TextSpan(
                  text: showTotal(myProvider.selectPaid.coin, myProvider.selectPaid.total),
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
        ),

        Container(
          padding: EdgeInsets.fromLTRB(30,0,30,5),
          alignment: Alignment.center,
          child: AutoSizeText.rich(
            TextSpan(
              text: 'Estado del Pago: ',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black,
                fontFamily: 'MontserratSemiBold',
              ),
              children: <TextSpan>[
                TextSpan(
                  text: myProvider.dataListSales[0]['statusSale'] == 0? "SIN PAGAR" : "PAGADO",
                  style: TextStyle(
                    color: myProvider.dataListSales[0]['statusSale'] == 0? Colors.red : Colors.green,
                    fontWeight: FontWeight.normal,
                    fontFamily: 'MontserratSemiBold',
                  ),
                ),
              ],
            ),
            maxFontSize: 14,
            minFontSize: 14,
          ),
        ),

        Padding(
          padding: EdgeInsets.fromLTRB(40, 20, 40, 20),
          child: Container(
            alignment: Alignment.center,
            height: size.height / 20,
            decoration: BoxDecoration(
              color: colorGreen,
              borderRadius: BorderRadius.circular(30),
            ),
            child: Center(
              child: AutoSizeText(
                "PRODUCTOS Y/O SERVICIOS",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'MontserratSemiBold',
                ),
                maxFontSize: 14,
                minFontSize: 14,
              ),
            )
          )
        ),
        
        Padding(
          padding: EdgeInsets.fromLTRB(20, 0, 20, 20),
          child: DataTable(
            columns: <DataColumn>[
              DataColumn(
                label: Text(
                  'Cantidad',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontStyle: FontStyle.italic,
                    fontFamily: 'MontserratSemiBold',
                  ),
                ),
              ),
              DataColumn(
                label: Text(
                  'Nombre',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontStyle: FontStyle.italic,
                    fontFamily: 'MontserratSemiBold',
                  ),
                ),
              ),
              DataColumn(
                label: Text(
                  'Precio',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontStyle: FontStyle.italic,
                    fontFamily: 'MontserratSemiBold',
                  ),
                ),
              ),
            ],
            rows: myProvider.dataListSales.length == 0?
              const <DataRow>[]
            :
              List<DataRow>.generate(
                myProvider.dataListSales.length,
                (index) => DataRow(
                  cells: [
                    DataCell(
                      Text(myProvider.dataListSales[index]['quantity'].toString()),
                    ),
                    DataCell(
                      Text(myProvider.dataListSales[index]['name']),
                    ),
                    DataCell(
                      Text(showPrice(myProvider.dataListSales[index]['price'], myProvider.dataListSales[index]['coinClient'], myProvider.dataListSales[index]['coin'], myProvider.dataListSales[index]['rate']),),
                    ),
                  ]
                )
              ).toList(),
          ),
        ),

      ],
    );
  }

  openGoogleMaps(destination)async{
    _onLoading();
    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    Navigator.pop(context);
    launch("https://www.google.com/maps/dir/?api=1&origin=${position.latitude}+${position.longitude}&destination=${destination.replaceAll(' ','%20')}&travelmode=driving&dir_action=navigat");
  }

  showTotal(coin, price){
    var lowPrice = new MoneyMaskedTextController(initialValue: 0, decimalSeparator: ',', thousandSeparator: '.',  leftSymbol: '\$', );
    
    if(coin  == 1)
      lowPrice = new MoneyMaskedTextController(initialValue: 0, decimalSeparator: ',', thousandSeparator: '.',  leftSymbol: 'Bs ', );

    lowPrice.updateValue(double.parse(price));

    return "${lowPrice.text}";
  }

  showPrice(price, coinClient, coin ,rate){
    price = price.replaceAll(",", ".");
    var lowPrice = new MoneyMaskedTextController(initialValue: 0, decimalSeparator: ',', thousandSeparator: '.',  leftSymbol: '\$', );
    double priceDouble = double.parse(price);
    double varRate = double.parse(rate);

    if(coinClient  == 1)
      lowPrice = new MoneyMaskedTextController(initialValue: 0, decimalSeparator: ',', thousandSeparator: '.',  leftSymbol: 'Bs ', );

    if(coin == 0 && coinClient == 1)
      lowPrice.updateValue(priceDouble * varRate);
    else if(coin == 1 && coinClient == 0)
      lowPrice.updateValue(priceDouble / varRate);
    else
      lowPrice.updateValue(priceDouble);

    return "${lowPrice.text}";
  }

  verifyUpdate(index){
    var myProvider = Provider.of<MyProvider>(context, listen: false);
    if(myProvider.selectPaid.statusShipping < index && myProvider.selectPaid.statusShipping == index-1)
      showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return WillPopScope(
            onWillPop: () async =>false,
            child: AlertDialog(
              title: Text("Cambiar Estado de Envio"),
              content: Text("Está seguro que desea cambiar estado de envio a ${elements[index]}"),
              actions: <Widget>[
                FlatButton(
                  child: Text('Si'),
                  onPressed: () {
                    Navigator.pop(context);
                    sendUpdate(index);
                  },
                ),
                FlatButton(
                  child: Text('No'),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          );
        },
      );
  }

  sendUpdate(index)async{
    var myProvider = Provider.of<MyProvider>(context, listen: false);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var response, result;
    try
    {
      _onLoading();
      result = await InternetAddress.lookup('google.com'); //verify network
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        response = await http.post(
          urlApi+"changeStatus",
          headers:{
            'Content-Type': 'application/json',
            'X-Requested-With': 'XMLHttpRequest',
            'authorization': 'Bearer ${myProvider.accessTokenDelivery}',
          },
          body: jsonEncode({
            "codeUrl" : myProvider.codeUrl,
            "statusShipping" : index,
          }),
        ); 
        var jsonResponse = jsonDecode(response.body); 
        print(jsonResponse);
        if (jsonResponse['statusCode'] == 201) {
          if(index == 2){
            prefs.remove("codeUrl");
            prefs.remove("date_codeUrl");
            prefs.remove("searchAddress");
            myProvider.searchAddress = "";
            myProvider.codeUrl = null;
            Navigator.pop(context);
            Navigator.pop(context);
            showMessage("Guardado Correctamente", true);
          }else{
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
          
            
            myProvider.selectPaid = _selectPaid;

            dbctpaga.createOrUpdatePaid(_selectPaid);

            Navigator.pop(context);
            showMessage("Guardado Correctamente", true);
          }
          
        }else{
          Navigator.pop(context);
          showMessage(jsonResponse['message'], false);
        }
      }
    } on SocketException catch (_) {
      Navigator.pop(context);
      showMessage("No hay internet verifica tu conexión", false);
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


class MySelectionItem extends StatelessWidget {
  final String title;
  final bool isForList;

  const MySelectionItem({Key key, this.title, this.isForList = true}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60.0,
      child: isForList
          ? Padding(
              child: _buildItem(context),
              padding: EdgeInsets.all(10.0),
            )
          : Card(
              margin: EdgeInsets.symmetric(horizontal: 10.0),
              child: Stack(
                children: <Widget>[
                  _buildItem(context),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Icon(Icons.arrow_drop_down),
                  )
                ],
              ),
            ),
    );
  }

  Widget _buildItem(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      alignment: Alignment.center,
      child: FittedBox(
          child: AutoSizeText(
        title,
      )),
    );
  }
}