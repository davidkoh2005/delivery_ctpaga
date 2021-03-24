import 'package:delivery_ctpaga/animation/slideRoute.dart';
import 'package:delivery_ctpaga/views/navbar/navbarMain.dart';
import 'package:delivery_ctpaga/views/updatePasswordPage.dart';
import 'package:delivery_ctpaga/providers/provider.dart';
import 'package:delivery_ctpaga/env.dart';

import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:searchable_dropdown/searchable_dropdown.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'dart:io';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _scrollController = ScrollController();
  final _formKeyContact = new GlobalKey<FormState>();
  final _formKeyVehicle = new GlobalKey<FormState>();
  final FocusNode _nameFocus = FocusNode(); 
  final FocusNode _phoneFocus = FocusNode();
  final FocusNode _emailFocus = FocusNode();
  final FocusNode _modelFocus = FocusNode();
  final FocusNode _markFocus = FocusNode();
  final FocusNode _colorsFocus = FocusNode();
  final FocusNode _licensePlateFocus = FocusNode();
  String _name, _phone, _email, _statusDropdown = "", _model, _mark, _colorName, _colorHex, _licensePlate;
  var urlProfile;
  bool _statusClickColors = false;

  @override
  void initState() {
    super.initState();
    initialVariable();
  }

  initialVariable(){
    var myProvider = Provider.of<MyProvider>(context, listen: false);
    setState(() {
        _colorName = myProvider.dataDelivery.colorName;
    });
  }

  @override
  Widget build(BuildContext context) {

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
                  child: SingleChildScrollView(
                    controller: _scrollController,
                    child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(bottom: 50, top: 50),
                          child: showImage()
                        ),
                        
                        dropdownList("Cuenta"),
                        Visibility(
                          visible: _statusDropdown == "Cuenta"? true : false,
                          child: formContact(),
                        ),
                          dropdownList("Vehículo"),
                        Visibility(
                          visible: _statusDropdown == "Vehículo"? true : false,
                          child: formVehicle(),
                        ),
                      ]
                    )
                  )
                ),
              ],
            ),
          ]
        )
      )
    );
  }

  Widget showImage(){
    var size = MediaQuery.of(context).size;
    return Consumer<MyProvider>(
      builder: (context, myProvider, child) {
        if(myProvider.dataPicturesDelivery != null && myProvider.dataPicturesDelivery.length != 0){
          //DefaultCacheManager().removeFile(url+"/storage/Users/${myProvider.dataUser.id}/Profile.jpg");
          //DefaultCacheManager().emptyCache();

          if(urlProfile != null)
            if(urlProfile.indexOf('/storage/Delivery/')<0)
              DefaultCacheManager().emptyCache();
              urlProfile = null;


          for (var item in myProvider.dataPicturesDelivery) {

            if(item != null && item.description == 'Profile'){
              urlProfile = item.url;
              break;
            }
          }

          if (urlProfile != null)
          {
            return GestureDetector(
              onTap: () {
                _showSelectionDialog(context);
                showNotification();
              },
              child: ClipOval(
                child: new CachedNetworkImage(
                  imageUrl: "http://"+url+urlProfile,
                  fit: BoxFit.cover,
                  height: size.width / 3.5,
                  width: size.width / 3.5,
                  placeholder: (context, url) {
                    return Container(
                      margin: EdgeInsets.all(15),
                      child:CircularProgressIndicator(
                        valueColor: new AlwaysStoppedAnimation<Color>(colorGreen),
                      ),
                    );
                  },
                  errorWidget: (context, url, error) => Icon(Icons.error, color: Colors.red, size: size.width / 8),
                ),
              )
            );
          }
        } 
        return GestureDetector(
          onTap: () {
            _showSelectionDialog(context);
            showNotification();
          },
          child: ClipOval(
            child: Image(
              image: AssetImage("assets/icons/addPhoto.png"),
              width: size.width / 3,
              height: size.width / 3,
            ),
          ),
        );
      }
    );
  }

  showNotification(){
    var size = MediaQuery.of(context).size;
    return showDialog(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () async => true,
          child: AlertDialog(
            backgroundColor: Colors.white,
            content: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.all(5),
                  child: ClipOval(
                    child: Image(
                      image: AssetImage("assets/icons/avatar.png"),
                      width: size.width / 3.5,
                    ),
                  )
                ),
                Container(
                  padding: EdgeInsets.all(5),
                  child: Text(
                    'Por Favor tomar o seleccionar foto donde se muestra la cara. (Sin ediciones ni filtros)',
                    textAlign: TextAlign.justify,
                    style: TextStyle(
                      color: Colors.black,
                      fontFamily: 'MontserratSemiBold',
                    )
                  ),
                ),
              ],
            ),
          )
        );
      },
    );
  }

  Future<void> _showSelectionDialog(BuildContext context) {
    
    return showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(20),
          topLeft: Radius.circular(20)
        ),
      ),
      backgroundColor: Colors.white,
      builder: (BuildContext bc){
          return Container(
            child: new Wrap(
              spacing: 20,
              children: <Widget>[
                new ListTile(
                  leading: new Icon(Icons.crop_original, color:Colors.black, size: 30.0),
                  title: new AutoSizeText(
                    "Galeria",
                    style: TextStyle(
                      fontFamily: 'MontserratSemiBold',
                      fontSize:14
                    ),
                    maxFontSize: 14,
                    minFontSize: 14,
                  ),
                  onTap: () => _getImage(context, ImageSource.gallery),       
                ),
                new ListTile(
                  leading: new Icon(Icons.camera, color:Colors.black, size: 30.0),
                  title: new AutoSizeText(
                    "Camara",
                    style: TextStyle(
                      fontFamily: 'MontserratSemiBold',
                      fontSize:14
                    ),
                    maxFontSize: 14,
                    minFontSize: 14,
                  ),
                  onTap: () => _getImage(context, ImageSource.camera),          
                ),
              ],
            ),
          );
      }
    );
  }

  _getImage(BuildContext context, ImageSource source) async {
    var picture = await ImagePicker().getImage(source: source,  imageQuality: 50, maxHeight: 600, maxWidth: 900);
    var myProvider = Provider.of<MyProvider>(context, listen: false);

    var cropped;

    if(picture != null){
      cropped = await ImageCropper.cropImage(
        sourcePath: picture.path,
        aspectRatio:  CropAspectRatio(
          ratioX: 1, ratioY: 1
        ),
        compressQuality: 100,
        maxWidth: 700,
        maxHeight: 700,
        compressFormat: ImageCompressFormat.jpg,
        androidUiSettings: AndroidUiSettings(
          toolbarTitle: "Editar Foto",
          backgroundColor: Colors.black,
          toolbarWidgetColor: Colors.black,
        ),
        iosUiSettings: IOSUiSettings(
          title: 'Editar Foto',
        )
      );

      if(cropped != null){

        Navigator.of(context).pop();

        _onLoading();
        try
        {
          String base64Image = base64Encode(cropped.readAsBytesSync());
          var response = await http.post(
            urlApi+"updateDeliveryImg",
            headers:{
              'X-Requested-With': 'XMLHttpRequest',
              'authorization': 'Bearer ${myProvider.accessTokenDelivery}',
            },
            body: {
              "image": base64Image,
              "urlPrevious": urlProfile== null? '' : urlProfile,
              "description": "Profile",
              "type": "jpg"
            }
          );

          var jsonResponse = jsonDecode(response.body); 
          print(jsonResponse); 
          if (jsonResponse['statusCode'] == 201) {
            myProvider.getDataDelivery(false, true, context);
            showMessage("Guardado Correctamente", true);
            await Future.delayed(Duration(seconds: 1));
            Navigator.pop(context);
          }  
        }on SocketException catch (_) {
          print("error network");
        } 
      }
    }
  }

  Widget dropdownList(_title){
    var size = MediaQuery.of(context).size;
    return Padding(
      padding: 	EdgeInsets.only(top: 5, bottom: 5),
      child: GestureDetector(
        onTap: () => setState(() {
          if(_statusDropdown == _title){
            _statusDropdown = "";
          }else{
            _statusDropdown = _title;
          }
        }),
        child: Container(
          padding: EdgeInsets.only(left: 30, right: 30),
          width: size.width,
          height: 50,
          color: colorGreyOpacity,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              AutoSizeText(
                _title,
                style: TextStyle(
                  fontFamily: 'MontserratSemiBold',
                  fontSize:14
                ),
                maxFontSize: 14,
                minFontSize: 14,
              ),
              Icon(
                _statusDropdown == _title? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                color: colorGreen,
              ),
            ]
          ),
        )
      )
    );
  }

  Widget formContact(){
    
    return Consumer<MyProvider>(
      builder: (context, myProvider, child) {
        return new Form(
          key: _formKeyContact,
          child: new ListView(
            padding: EdgeInsets.only(top: 0),
            controller: _scrollController,
            shrinkWrap: true,
            children: <Widget>[

              Padding(
                padding: const EdgeInsets.fromLTRB(30.0, 10.0, 30.0, 0.0),
                child: new TextFormField(
                  initialValue: myProvider.dataDelivery == null ? '' : myProvider.dataDelivery.name,
                  autofocus: false,
                  textCapitalization:TextCapitalization.sentences, 
                  decoration: InputDecoration(
                    labelText: 'Nombre y Apellido',
                    labelStyle: TextStyle(
                      color: colorText,
                      fontFamily: 'MontserratSemiBold',
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: colorGreen),
                    ),
                  ),
                  onSaved: (String value) => _name = value,
                  validator: _validateName,
                  textInputAction: TextInputAction.next,
                  focusNode: _nameFocus,
                  onEditingComplete: () => FocusScope.of(context).requestFocus(_phoneFocus),
                  cursorColor: colorGreen,
                  style: TextStyle(
                    fontFamily: 'MontserratSemiBold',
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.fromLTRB(30.0, 10.0, 30.0, 0.0),
                child: new TextFormField(
                  initialValue: myProvider.dataDelivery == null? '' : myProvider.dataDelivery.phone,
                  autofocus: false,
                  keyboardType: TextInputType.phone,
                  maxLength: 20,
                  decoration: InputDecoration(
                    labelText: 'Teléfono',
                    labelStyle: TextStyle(
                      color: colorText,
                      fontFamily: 'MontserratSemiBold',
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: colorGreen),
                    ),
                  ),
                  onSaved: (String value) => _phone = value,
                  validator: _validatePhone,
                  focusNode: _phoneFocus,
                  textInputAction: TextInputAction.done,
                  onEditingComplete: () => FocusScope.of(context).requestFocus(_emailFocus),
                  cursorColor: colorGreen,
                  style: TextStyle(
                    fontFamily: 'MontserratSemiBold',
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(30.0, 10.0, 30.0, 10.0),
                child: new TextFormField(
                  initialValue: myProvider.dataDelivery == null? '' : myProvider.dataDelivery.email,
                  autofocus: false,
                  maxLines: 1,
                  focusNode: _emailFocus,
                  keyboardType: TextInputType.emailAddress,
                  decoration: new InputDecoration(
                      labelText: 'Email',
                      labelStyle: TextStyle(
                        color: colorText,
                        fontFamily: 'MontserratSemiBold',
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: colorGreen),
                      ),
                  ),
                  validator: _validateEmail,
                  onSaved: (String value) => _email = value.toLowerCase().trim(),
                  textInputAction: TextInputAction.done,
                  onFieldSubmitted: (term){
                    FocusScope.of(context).requestFocus(new FocusNode());
                    buttonClickSave();
                  },
                  cursorColor: colorGreen,
                  style: TextStyle(
                    fontFamily: 'MontserratSemiBold',
                  ),
                ),
              ),

              Align(
                alignment: Alignment.center,
                child: FlatButton(
              
                  onPressed: () => nextPage(),
                  child: AutoSizeText(
                    "Cambiar contraseña",
                    style: TextStyle(
                      color: Colors.black87,
                      decoration: TextDecoration.underline,
                      fontFamily: 'MontserratSemiBold',
                    ),
                    maxFontSize: 14,
                    minFontSize: 14,
                  ),
                ),
              ),

              buttonSave(0),
            ],
          ),
        );
      }
    );
  }

  Widget formVehicle(){
    var size = MediaQuery.of(context).size;
    return Consumer<MyProvider>(
      builder: (context, myProvider, child) {
        return new Form(
          key: _formKeyVehicle,
          child: new ListView(
            padding: EdgeInsets.only(top: 0),
            controller: _scrollController,
            shrinkWrap: true,
            children: <Widget>[
              
              Padding(
                padding: const EdgeInsets.fromLTRB(30.0, 10.0, 30.0, 0.0),
                child: new TextFormField(
                  initialValue: myProvider.dataDelivery == null ? '' : myProvider.dataDelivery.mark,
                  autofocus: false,
                  textCapitalization:TextCapitalization.sentences, 
                  decoration: InputDecoration(
                    labelText: 'Marca',
                    labelStyle: TextStyle(
                      color: colorText,
                      fontFamily: 'MontserratSemiBold',
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: colorGreen),
                    ),
                  ),
                  onSaved: (String value) => _mark = value,
                  validator: _validateName,
                  textInputAction: TextInputAction.next,
                  focusNode: _markFocus,
                  onEditingComplete: () => FocusScope.of(context).requestFocus(_modelFocus),
                  cursorColor: colorGreen,
                  style: TextStyle(
                    fontFamily: 'MontserratSemiBold',
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.fromLTRB(30.0, 10.0, 30.0, 0.0),
                child: new TextFormField(
                  initialValue: myProvider.dataDelivery == null ? '' : myProvider.dataDelivery.model,
                  autofocus: false,
                  textCapitalization:TextCapitalization.sentences, 
                  decoration: InputDecoration(
                    labelText: 'Modelo',
                    labelStyle: TextStyle(
                      color: colorText,
                      fontFamily: 'MontserratSemiBold',
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: colorGreen),
                    ),
                  ),
                  onSaved: (String value) => _model = value,
                  validator: _validateName,
                  textInputAction: TextInputAction.next,
                  focusNode: _modelFocus,
                  onEditingComplete: () => FocusScope.of(context).requestFocus(_colorsFocus),
                  cursorColor: colorGreen,
                  style: TextStyle(
                    fontFamily: 'MontserratSemiBold',
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.fromLTRB(30.0, 30.0, 30.0, 0.0),
                child: AutoSizeText(
                  "Color",
                  style: TextStyle(
                    color:colorText,
                    fontFamily: 'MontserratSemiBold',
                    fontSize:14
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.fromLTRB(30.0, 5.0, 30.0, 0.0),
                child: SearchableDropdown.single(
                  displayClearIcon: false,
                  items: listColors.map((result) {
                      return (DropdownMenuItem(
                        child: Padding(
                          padding: EdgeInsets.only(top:5, bottom:5),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Container(
                                width: size.width / 10,
                                height: size.width / 10,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(color: Colors.black),
                                  color: hexToColor(result['hex']),
                                ),
                              ),
                              SizedBox(width: 20),
                              Expanded(child: AutoSizeText(
                                result['name'],
                                style: TextStyle(
                                  fontFamily: 'MontserratSemiBold',
                                  fontSize:14
                                ),
                              ),),
                            ],
                          )
                        ),
                        value: result,
                      )
                    );
                  }).toList(),
                  closeButton: "Cerrar",
                  hint: myProvider.dataDelivery == null ? '' : myProvider.dataDelivery.colorName,
                  searchHint: "Color",
                  keyboardType: TextInputType.text,
                  onChanged: (value){
                    setState(() {
                        _colorName = value['name'];
                        _colorHex = value['hex'];
                    });
                  },
                  isExpanded: true,
                  validator: (value) => _colorName == null && _statusClickColors? "Ingrese el color correctamente": null,
                ),
              ),

              Padding(
                padding: const EdgeInsets.fromLTRB(30.0, 10.0, 30.0, 40.0),
                child: new TextFormField(
                  initialValue: myProvider.dataDelivery == null ? '' : myProvider.dataDelivery.licensePlate,
                  autofocus: false,
                  textCapitalization:TextCapitalization.characters, 
                  decoration: InputDecoration(
                    labelText: 'Número de placa',
                    labelStyle: TextStyle(
                      color: colorText,
                      fontFamily: 'MontserratSemiBold',
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: colorGreen),
                    ),
                  ),
                  onSaved: (String value) => _licensePlate = value,
                  validator: _validateName,
                  textInputAction: TextInputAction.done,
                  focusNode: _licensePlateFocus,
                  onFieldSubmitted: (term){
                    FocusScope.of(context).requestFocus(new FocusNode());
                    buttonClickSaveVehicle();
                  },
                  cursorColor: colorGreen,
                  style: TextStyle(
                    fontFamily: 'MontserratSemiBold',
                  ),
                ),
              ),

              buttonSave(1),
            ],
          ),
        );
      }
    );
  }

  Widget buttonSave(index){
    var size = MediaQuery.of(context).size;
    return Padding(
      padding: EdgeInsets.only(left:30, right:30, bottom:30),
      child: GestureDetector(
        onTap: () {
          if(index == 0)
            buttonClickSave();
          else
            buttonClickSaveVehicle();
        },
        child: Container(
          width:size.width - 100,
          height: size.height / 20,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                colorGreen,
                colorGreen
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(30),
            ),
          child: Center(
            child: AutoSizeText(
              "GUARDAR",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w500,
                fontFamily: 'MontserratSemiBold',
              ),
              maxFontSize: 14,
              minFontSize: 14,
            ),
          ),
        ),
      )
    );
  }

  void buttonClickSave()async{
    if (_formKeyContact.currentState.validate()) {
      _formKeyContact.currentState.save();
      _onLoading();
      var result, response, jsonResponse;
       try {
        result = await InternetAddress.lookup('google.com');
        if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
          var myProvider = Provider.of<MyProvider>(context, listen: false);

          response = await http.post(
            urlApi+"updateDelivery",
            headers:{
              'Content-Type': 'application/json',
              'X-Requested-With': 'XMLHttpRequest',
              'authorization': 'Bearer ${myProvider.accessTokenDelivery}',
            },
            body: jsonEncode({
              'name': _name,
              'phone': _phone,
              'email': _email,
            }),
          ); 

          jsonResponse = jsonDecode(response.body); 
          if (jsonResponse['statusCode'] == 201) {
            myProvider.getDataDelivery(false, false, context);
            Navigator.pop(context);
            showMessage("Guardado Correctamente", true);
            await Future.delayed(Duration(seconds: 1));
            Navigator.pop(context);
          } 
        }
      } on SocketException catch (_) {
        showMessage("Sin conexión a internet", false);
      } 
    }
  }

  void buttonClickSaveVehicle()async{
    setState(() {
      _statusClickColors = true;
    });
    if (_formKeyVehicle.currentState.validate()) {
      _formKeyVehicle.currentState.save();
      _onLoading();
      var result, response, jsonResponse;
       try {
        result = await InternetAddress.lookup('google.com');
        if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
          var myProvider = Provider.of<MyProvider>(context, listen: false);

          response = await http.post(
            urlApi+"updateDelivery",
            headers:{
              'Content-Type': 'application/json',
              'X-Requested-With': 'XMLHttpRequest',
              'authorization': 'Bearer ${myProvider.accessTokenDelivery}',
            },
            body: jsonEncode({
              'model': _model,
              'mark': _mark,
              'colorName': _colorName,
              'colorHex': _colorHex,
              'licensePlate': _licensePlate,
            }),
          ); 

          jsonResponse = jsonDecode(response.body); 
          if (jsonResponse['statusCode'] == 201) {
            myProvider.getDataDelivery(false, false, context);
            Navigator.pop(context);
            showMessage("Guardado Correctamente", true);
            await Future.delayed(Duration(seconds: 1));
            Navigator.pop(context);
          } 
        }
      } on SocketException catch (_) {
        showMessage("Sin conexión a internet", false);
      } 
    }
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

  nextPage()async{
    await Future.delayed(Duration(milliseconds: 150));
    Navigator.push(context, SlideLeftRoute(page: UpdatePasswordPage()));
  }

  String _validateName(String value) {
    // This is just a regular expression for name
    String p = '[a-zA-Z]';
    RegExp regExp = new RegExp(p);

    if (value.isNotEmpty && regExp.hasMatch(value) && value.length >=3) {
      // So, the name is valid
      return null;
    }

    // The pattern of the name and surname didn't match the regex above.
    return 'Ingrese nombre y apellido válido';
  }

  String _validatePhone(String value) {
    // This is just a regular expression for phone*$
    String p = r'^(?:(\+)58|0)(?:2(?:12|4[0-9]|5[1-9]|6[0-9]|7[0-8]|8[1-35-8]|9[1-5]|3[45789])|4(?:1[246]|2[46]))\d{7}$';
    RegExp regExp = new RegExp(p);

    if (value.isNotEmpty && regExp.hasMatch(value) && value.length >=9) {
      // So, the phone is valid
      return null;
    }

    // The pattern of the phone didn't match the regex above.
    return 'Ingrese un número de teléfono válido';
  }

  String _validateEmail(String value) {
    value = value.trim().toLowerCase();
    // This is just a regular expression for email addresses
    String p = "[a-zA-Z0-9\+\.\_\%\-\+]{1,256}" +
        "\\@" +
        "[a-zA-Z0-9][a-zA-Z0-9\\-]{0,64}" +
        "(" +
        "\\." +
        "[a-zA-Z0-9][a-zA-Z0-9\\-]{0,25}" +
        ")+";
    RegExp regExp = new RegExp(p);

    if (value.isNotEmpty &&regExp.hasMatch(value)) {
      return null;     
    }

    // The pattern of the email didn't match the regex above.
    return 'Ingrese un email válido';
  }

  Color hexToColor(String code) {
    return new Color(int.parse(code.substring(1, 7), radix: 16) + 0xFF000000);
  }

}