
import 'package:delivery_ctpaga/views/navbar/navbar.dart';
import 'package:delivery_ctpaga/providers/provider.dart';
import 'package:delivery_ctpaga/env.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';

import 'package:provider/provider.dart';
import 'package:flutter/material.dart';



class ShowDataPaidPage extends StatefulWidget {
  
  @override
  _ShowDataPaidPageState createState() => _ShowDataPaidPageState();
}

class _ShowDataPaidPageState extends State<ShowDataPaidPage> {
  String codeUrl;

  void initState() {
    super.initState();
  }

  void dispose(){
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    var myProvider = Provider.of<MyProvider>(context, listen: false);

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

  Widget showDataPaid(){
    var myProvider = Provider.of<MyProvider>(context, listen: false);
    var scaleFactor = MediaQuery.of(context).textScaleFactor;
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
              child: Text(
                "COMMERCIO",
                style: TextStyle(
                  fontSize: 15 * scaleFactor,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            )
          )
        ),
        Container(
          padding: EdgeInsets.fromLTRB(30,0,30,5),
          alignment: Alignment.centerLeft,
          child: RichText(
            text: TextSpan(
              text: 'Nombre: ',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15 * scaleFactor,
                color: Colors.black,
              ),
              children: <TextSpan>[
                TextSpan(
                  text: myProvider.dataCommerce.name,
                  style: TextStyle(
                    fontSize: 15 * scaleFactor,
                    color: Colors.black,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ],
            ),
          ),
        ),
        Container(
          padding: EdgeInsets.fromLTRB(30,0,30,5),
          alignment: Alignment.centerLeft,
          child: RichText(
            text: TextSpan(
              text: 'Dirección: ',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15 * scaleFactor,
                color: Colors.black,
              ),
              children: <TextSpan>[
                TextSpan(
                  text: myProvider.dataCommerce.address,
                  style: TextStyle(
                    fontSize: 15 * scaleFactor,
                    color: Colors.black,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ],
            ),
          ),
        ),
        Container(
          padding: EdgeInsets.fromLTRB(30,0,30,5),
          alignment: Alignment.centerLeft,
          child: RichText(
            text: TextSpan(
              text: 'Telefono: ',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15 * scaleFactor,
                color: Colors.black,
              ),
              children: <TextSpan>[
                TextSpan(
                  text: myProvider.dataCommerce.phone,
                  style: TextStyle(
                    fontSize: 15 * scaleFactor,
                    color: Colors.black,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ],
            ),
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
              child: Text(
                "CONTACTO",
                style: TextStyle(
                  fontSize: 15 * scaleFactor,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            )
          )
        ),

        Container(
          padding: EdgeInsets.fromLTRB(30,0,30,5),
          alignment: Alignment.centerLeft,
          child: RichText(
            text: TextSpan(
              text: 'Nombre: ',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15 * scaleFactor,
                color: Colors.black,
              ),
              children: <TextSpan>[
                TextSpan(
                  text: myProvider.selectPaid.nameClient,
                  style: TextStyle(
                    fontSize: 15 * scaleFactor,
                    color: Colors.black,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ],
            ),
          ),
        ),

        Container(
          padding: EdgeInsets.fromLTRB(30,0,30,5),
          alignment: Alignment.centerLeft,
          child: RichText(
            text: TextSpan(
              text: 'Correo: ',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15 * scaleFactor,
                color: Colors.black,
              ),
              children: <TextSpan>[
                TextSpan(
                  text: myProvider.selectPaid.email,
                  style: TextStyle(
                    fontSize: 15 * scaleFactor,
                    color: Colors.black,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ],
            ),
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
              child: Text(
                "DETALLE DE ENVÍO",
                style: TextStyle(
                  fontSize: 15 * scaleFactor,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            )
          )
        ),

        Container(
          padding: EdgeInsets.fromLTRB(30,0,30,5),
          alignment: Alignment.centerLeft,
          child: RichText(
            text: TextSpan(
              text: 'Nombre: ',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15 * scaleFactor,
                color: Colors.black,
              ),
              children: <TextSpan>[
                TextSpan(
                  text: myProvider.selectPaid.nameShipping,
                  style: TextStyle(
                    fontSize: 15 * scaleFactor,
                    color: Colors.black,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ],
            ),
          ),
        ),
        Container(
          padding: EdgeInsets.fromLTRB(30,0,30,5),
          alignment: Alignment.centerLeft,
          child: RichText(
            text: TextSpan(
              text: 'Teléfono: ',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15 * scaleFactor,
                color: Colors.black,
              ),
              children: <TextSpan>[
                TextSpan(
                  text: myProvider.selectPaid.numberShipping,
                  style: TextStyle(
                    fontSize: 15 * scaleFactor,
                    color: Colors.black,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ],
            ),
          ),
        ),
        Container(
          padding: EdgeInsets.fromLTRB(30,0,30,5),
          alignment: Alignment.centerLeft,
          child: RichText(
            text: TextSpan(
              text: 'Dirección: ',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15 * scaleFactor,
                color: Colors.black,
              ),
              children: <TextSpan>[
                TextSpan(
                  text: myProvider.selectPaid.addressShipping,
                  style: TextStyle(
                    fontSize: 15 * scaleFactor,
                    color: Colors.black,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ],
            ),
          ),
        ),
        Container(
          padding: EdgeInsets.fromLTRB(30,0,30,5),
          alignment: Alignment.centerLeft,
          child: RichText(
            text: TextSpan(
              text: 'Detalle: ',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15 * scaleFactor,
                color: Colors.black,
              ),
              children: <TextSpan>[
                TextSpan(
                  text: myProvider.selectPaid.detailsShipping,
                  style: TextStyle(
                    fontSize: 15 * scaleFactor,
                    color: Colors.black,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ],
            ),
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
              child: Text(
                "ENVIO SELECCIONADO",
                style: TextStyle(
                  fontSize: 15 * scaleFactor,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            )
          )
        ),
        Container(
          padding: EdgeInsets.fromLTRB(30,0,30,5),
          alignment: Alignment.centerLeft,
          child: RichText(
            text: TextSpan(
              text: 'Status: ',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15 * scaleFactor,
                color: Colors.black,
              ),
              children: <TextSpan>[
                TextSpan(
                  text: myProvider.selectPaid.statusShipping == 0? "NO ENTREGADO" : "ENTREGADO",
                  style: TextStyle(
                    fontSize: 15 * scaleFactor,
                    color: Colors.black,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ],
            ),
          ),
        ),
        Container(
          padding: EdgeInsets.fromLTRB(30,0,30,5),
          alignment: Alignment.centerLeft,
          child: RichText(
            text: TextSpan(
              text: 'Descripción: ',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15 * scaleFactor,
                color: Colors.black,
              ),
              children: <TextSpan>[
                TextSpan(
                  text: myProvider.selectPaid.selectShipping,
                  style: TextStyle(
                    fontSize: 15 * scaleFactor,
                    color: Colors.black,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ],
            ),
          ),
        ),
        Container(
          padding: EdgeInsets.fromLTRB(30,0,30,5),
          alignment: Alignment.centerLeft,
          child: RichText(
            text: TextSpan(
              text: 'Precio: ',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15 * scaleFactor,
                color: Colors.black,
              ),
              children: <TextSpan>[
                TextSpan(
                  text: showTotal(myProvider.selectPaid.coin, myProvider.selectPaid.priceShipping),
                  style: TextStyle(
                    fontSize: 15 * scaleFactor,
                    color: Colors.black,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ],
            ),
          ),
        ),
        Container(
          padding: EdgeInsets.fromLTRB(30,0,30,5),
          alignment: Alignment.centerRight,
          child: RichText(
            text: TextSpan(
              text: 'Descuento: ',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15 * scaleFactor,
                color: Colors.black,
              ),
              children: <TextSpan>[
                TextSpan(
                  text: "${myProvider.selectPaid.percentage} %",
                  style: TextStyle(
                    fontSize: 15 * scaleFactor,
                    color: Colors.black,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ],
            ),
          ),
        ),

        Container(
          padding: EdgeInsets.fromLTRB(30,0,30,5),
          alignment: Alignment.centerRight,
          child: RichText(
            text: TextSpan(
              text: 'Total: ',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15 * scaleFactor,
                color: Colors.black,
              ),
              children: <TextSpan>[
                TextSpan(
                  text: showTotal(myProvider.selectPaid.coin, myProvider.selectPaid.total),
                  style: TextStyle(
                    fontSize: 15 * scaleFactor,
                    color: Colors.black,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ],
            ),
          ),
        ),

        Container(
          padding: EdgeInsets.fromLTRB(30,0,30,5),
          alignment: Alignment.center,
          child: RichText(
            text: TextSpan(
              text: 'Status del Pago: ',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15 * scaleFactor,
                color: Colors.black,
              ),
              children: <TextSpan>[
                TextSpan(
                  text: myProvider.dataListSales[0]['statusSale'] == 0? "SIN PAGAR" : "PAGADO",
                  style: TextStyle(
                    fontSize: 15 * scaleFactor,
                    color: myProvider.dataListSales[0]['statusSale'] == 0? Colors.red : Colors.green,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ],
            ),
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
              child: Text(
                "PRODUCTOS Y/O SERVICIOS",
                style: TextStyle(
                  fontSize: 15 * scaleFactor,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
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
                    fontSize: 15 * scaleFactor,
                  ),
                ),
              ),
              DataColumn(
                label: Text(
                  'Nombre',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontStyle: FontStyle.italic,
                    fontSize: 15 * scaleFactor,
                  ),
                ),
              ),
              DataColumn(
                label: Text(
                  'Precio',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontStyle: FontStyle.italic,
                    fontSize: 15 * scaleFactor,
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
                  )
                ),
              ),
            ],
          ),
        );
      },
    );
  }

}