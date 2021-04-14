import 'package:delivery_ctpaga/animation/slideRoute.dart';
import 'package:delivery_ctpaga/views/navbar/navbarMain.dart';
import 'package:delivery_ctpaga/views/updatePasswordPage.dart';
import 'package:delivery_ctpaga/providers/provider.dart';
import 'package:delivery_ctpaga/service/fileDocuments.dart';
import 'package:delivery_ctpaga/env.dart';

import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:searchable_dropdown/searchable_dropdown.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
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
  final _formKeyDocuments = new GlobalKey<FormState>();
  final FocusNode _nameFocus = FocusNode(); 
  final FocusNode _phoneFocus = FocusNode();
  final FocusNode _emailFocus = FocusNode();
  final FocusNode _modelFocus = FocusNode();
  final FocusNode _markFocus = FocusNode();
  final FocusNode _colorsFocus = FocusNode();
  final FocusNode _licensePlateFocus = FocusNode();
  final FocusNode _licenseFocus = FocusNode();
  final FocusNode _drivingLicenseFocus = FocusNode();
  final FocusNode _civilLiabilityFocus = FocusNode();
  
  String _name, _phone, _email, _statusDropdown = "", 
        _model, _mark, _colorName, _colorHex, _licensePlate,
        urlFile, fileName;

  var urlProfile, urlLicense, urlDrivingLicense, urlCivilLiability;
  bool _statusClickColors = false;

  @override
  void initState() {
    super.initState();
    initialVariable();
  }

  initialVariable(){
    var myProvider = Provider.of<MyProvider>(context, listen: false);
    urlProfile = myProvider.urlProfile;
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

                        dropdownList("Documentos"),
                        Visibility(
                          visible: _statusDropdown == "Documentos"? true : false,
                          child: formDocuments(),
                        ),

                        dropdownList("Selfie de Verificación"),
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
    if (urlProfile != null){
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
                  valueColor: new AlwaysStoppedAnimation<Color>(colorLogo),
                ),
              );
            },
            errorWidget: (context, url, error) => Icon(Icons.error, color: Colors.red, size: size.width / 8),
          ),
        )
      );
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
                  onTap: () => _getImage(context, ImageSource.gallery, 'Profile'),       
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
                  onTap: () => _getImage(context, ImageSource.camera, 'Profile'),          
                ),
              ],
            ),
          );
      }
    );
  }

  Future<void> _showSelectionDialogDocuments(BuildContext context, description) {
    
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
                  leading: new Icon(Icons.file_present, color:Colors.black, size: 30.0),
                  title: new AutoSizeText(
                    "Archivo",
                    style: TextStyle(
                      fontFamily: 'MontserratSemiBold',
                      fontSize:14
                    ),
                    maxFontSize: 14,
                    minFontSize: 14,
                  ),
                  onTap: () {
                    Navigator.of(context).pop();
                    _getFile(description);
                  }       
                ),
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
                  onTap: () => _getImage(context, ImageSource.gallery, description),       
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
                  onTap: () => _getImage(context, ImageSource.camera, description),          
                ),
              ],
            ),
          );
      }
    );
  }

  _getImage(BuildContext context, ImageSource source, String description) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var picture = await ImagePicker().getImage(source: source,  imageQuality: 50, maxHeight: 600, maxWidth: 900);

    var cropped;

    if(picture != null){
      if(description == 'Profile')
        cropped = await ImageCropper.cropImage(
          sourcePath: picture.path,
          aspectRatio:  CropAspectRatio(
            ratioX: 1, ratioY: 1
          ),
          compressQuality: 100,
          maxWidth: 700,
          maxHeight: 700,
          cropStyle: CropStyle.circle,
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
      else
        cropped = await ImageCropper.cropImage(
          sourcePath: picture.path,
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
        if(description == 'Selfie')
          Navigator.pop(context);
        else
          Navigator.of(context).pop();

        _onLoading();
        var urlPrevius = getUrl(description);

        try
        {
          var myProvider = Provider.of<MyProvider>(context, listen: false);
          String base64Image = base64Encode(cropped.readAsBytesSync());
          var response = await http.post(
            description == 'Profile' ? urlApi+"updateDeliveryImg" : urlApi+"updateDeliveryDocuments",
            headers:{
              'X-Requested-With': 'XMLHttpRequest',
              'authorization': 'Bearer ${myProvider.accessTokenDelivery}',
            },
            body: {
              "image": base64Image,
              "urlPrevious": urlPrevius== null? '' : urlPrevius,
              "description": description,
              "type": "jpg"
            }
          );

          var jsonResponse = jsonDecode(response.body); 
          print(jsonResponse); 
          if (jsonResponse['statusCode'] == 201) {
            if(description == 'Profile'){
              DefaultCacheManager().emptyCache();
              prefs.remove("urlProfile");
              myProvider.urlProfile = null;
            }
            await myProvider.getDataDelivery(false, true, context);
            setState(() {
              urlProfile = myProvider.urlProfile;
            });
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

  _getFile(String description)async{
    FilePickerResult result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if(result != null) {
      File file = File(result.files.single.path);
      
      FileDocuments classFile = new FileDocuments();

      urlFile = file.path;
      fileName = classFile.getName(file.path);

      _onLoading();
      var urlPrevius = getUrl(description);

      try
      {
        var myProvider = Provider.of<MyProvider>(context, listen: false);
        String base64File = base64Encode(file.readAsBytesSync());
        var response = await http.post(
          urlApi+"updateDeliveryDocuments",
          headers:{
            'X-Requested-With': 'XMLHttpRequest',
            'authorization': 'Bearer ${myProvider.accessTokenDelivery}',
          },
          body: {
            "fileDocument": base64File,
            "urlPrevious": urlPrevius== null? '' : urlPrevius,
            "description": description,
            "type": "pdf",
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

    } else {
      Navigator.pop(context);
    }
  }

  Widget dropdownList(_title){
    var myProvider = Provider.of<MyProvider>(context, listen: false);
    var size = MediaQuery.of(context).size;
    return Padding(
      padding: 	EdgeInsets.only(top: 5, bottom: 5),
      child: GestureDetector(
        onTap: () {
          if(_title != 'Selfie de Verificación')
            setState(() {
              if(_statusDropdown == _title){
                _statusDropdown = "";
              }else{
                _statusDropdown = _title;
              }
            });
          else if (!myProvider.statusSelfie)
            showDialogSelfie(context);
        },
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
                  _title == 'Selfie de Verificación' ? myProvider.statusSelfie? Icons.check_circle : Icons.add_a_photo :_statusDropdown == _title? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                  color: colorLogo,
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
                      borderSide: BorderSide(color: colorLogo),
                    ),
                  ),
                  onSaved: (String value) => _name = value,
                  validator: _validateName,
                  textInputAction: TextInputAction.next,
                  focusNode: _nameFocus,
                  onEditingComplete: () => FocusScope.of(context).requestFocus(_phoneFocus),
                  cursorColor: colorLogo,
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
                      borderSide: BorderSide(color: colorLogo),
                    ),
                  ),
                  onSaved: (String value) => _phone = value,
                  validator: _validatePhone,
                  focusNode: _phoneFocus,
                  textInputAction: TextInputAction.done,
                  onEditingComplete: () => FocusScope.of(context).requestFocus(_emailFocus),
                  cursorColor: colorLogo,
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
                        borderSide: BorderSide(color: colorLogo),
                      ),
                  ),
                  validator: _validateEmail,
                  onSaved: (String value) => _email = value.toLowerCase().trim(),
                  textInputAction: TextInputAction.done,
                  onFieldSubmitted: (term){
                    FocusScope.of(context).requestFocus(new FocusNode());
                    buttonClickSave();
                  },
                  cursorColor: colorLogo,
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
                      borderSide: BorderSide(color: colorLogo),
                    ),
                  ),
                  onSaved: (String value) => _mark = value,
                  validator: _validateName,
                  textInputAction: TextInputAction.next,
                  focusNode: _markFocus,
                  onEditingComplete: () => FocusScope.of(context).requestFocus(_modelFocus),
                  cursorColor: colorLogo,
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
                      borderSide: BorderSide(color: colorLogo),
                    ),
                  ),
                  onSaved: (String value) => _model = value,
                  validator: _validateName,
                  textInputAction: TextInputAction.next,
                  focusNode: _modelFocus,
                  onEditingComplete: () => FocusScope.of(context).requestFocus(_colorsFocus),
                  cursorColor: colorLogo,
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
                    _colorName = value['name'];
                    _colorHex = value['hex'];
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
                      borderSide: BorderSide(color: colorLogo),
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
                  cursorColor: colorLogo,
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

  Widget formDocuments(){

    return Consumer<MyProvider>(
      builder: (context, myProvider, child) {
        return new Form(
          key: _formKeyDocuments,
          child: new ListView(
            padding: EdgeInsets.only(top: 0),
            controller: _scrollController,
            shrinkWrap: true,
            children: <Widget>[
              
              Visibility(
                visible: !myProvider.statusLicense,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(30.0, 10.0, 30.0, 0.0),
                  child: new TextFormField(
                    initialValue: 'SELECCIONAR ARCHIVO',
                    autofocus: false,
                    textCapitalization:TextCapitalization.sentences, 
                    decoration: InputDecoration(
                      labelText: 'Licencia',
                      labelStyle: TextStyle(
                        color: colorText,
                        fontFamily: 'MontserratSemiBold',
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: colorLogo),
                      ),
                    ),
                    textInputAction: TextInputAction.next,
                    focusNode: _licenseFocus,
                    onEditingComplete: () => FocusScope.of(context).requestFocus(_drivingLicenseFocus),
                    cursorColor: colorLogo,
                    style: TextStyle(
                      fontFamily: 'MontserratSemiBold',
                    ),
                    readOnly: true,
                    onTap: (){
                      _showSelectionDialogDocuments(context, 'License');
                    },
                  ),
                )
              ),

              Visibility(
                visible: myProvider.statusLicense,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(30.0, 10.0, 30.0, 0.0),
                  child: showCheck('Licencia'),
                ),
              ),

              Visibility(
                visible: !myProvider.statusDrivingLicense,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(30.0, 10.0, 30.0, 0.0),
                  child: new TextFormField(
                    initialValue: 'SELECCIONAR ARCHIVO',
                    autofocus: false,
                    textCapitalization:TextCapitalization.sentences, 
                    decoration: InputDecoration(
                      labelText: 'Carnet de Circulación',
                      labelStyle: TextStyle(
                        color: colorText,
                        fontFamily: 'MontserratSemiBold',
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: colorLogo),
                      ),
                    ),
                    textInputAction: TextInputAction.next,
                    focusNode: _drivingLicenseFocus,
                    onEditingComplete: () => FocusScope.of(context).requestFocus(_civilLiabilityFocus),
                    cursorColor: colorLogo,
                    style: TextStyle(
                      fontFamily: 'MontserratSemiBold',
                    ),
                    readOnly: true,
                    onTap: (){
                      _showSelectionDialogDocuments(context, 'Driving License');
                    },
                  ),
                )
              ),

              Visibility(
                visible: myProvider.statusDrivingLicense,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(30.0, 10.0, 30.0, 0.0),
                  child: showCheck('Carnet de Circulación'),
                ),
              ),

              Visibility(
                visible: !myProvider.statusCivilLiability,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(30.0, 10.0, 30.0, 30.0),
                  child: new TextFormField(
                    initialValue: 'SELECCIONAR ARCHIVO',
                    autofocus: false,
                    textCapitalization:TextCapitalization.sentences, 
                    decoration: InputDecoration(
                      labelText: 'Responsabilidad Civil',
                      labelStyle: TextStyle(
                        color: colorText,
                        fontFamily: 'MontserratSemiBold',
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: colorLogo),
                      ),
                    ),
                    textInputAction: TextInputAction.next,
                    focusNode: _civilLiabilityFocus,
                    cursorColor: colorLogo,
                    style: TextStyle(
                      fontFamily: 'MontserratSemiBold',
                    ),
                    readOnly: true,
                    onTap: (){
                      _showSelectionDialogDocuments(context, 'Civil Liability');
                    },
                  ),
                )
              ),

              Visibility(
                visible: myProvider.statusCivilLiability,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(30.0, 10.0, 30.0, 30.0),
                  child: showCheck('Responsabilidad Civil'),
                ),
              ),


            ],
          ),
        );
      }
    );
  }

  showCheck(title){
    return ListTile(
      title: AutoSizeText(
        title,
        style: TextStyle(
          color:  colorText,
          fontWeight: FontWeight.normal,
          fontFamily: 'MontserratSemiBold',
        ),
        minFontSize: 14,
        maxFontSize: 14,
      ),
      trailing: Icon(
        Icons.check_circle,
        color: colorLogo,
      ),
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
                colorLogo,
                colorLogo
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

  getUrl(description){
    var myProvider = Provider.of<MyProvider>(context, listen: false);
    if(description == 'Profile')
      return myProvider.urlProfile;
    else if(description == 'License')
      return myProvider.urlLicense;
    else if(description == 'Driving License')
      return myProvider.urlDrivingLicense;
    else if(description == 'Civil Liability')
      return myProvider.urlCivilLiability;
    else
      return null;
  }

  showDialogSelfie(context)
  {
    var size = MediaQuery.of(context).size;
    showDialog(
      barrierDismissible: true,
      context: context,
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () async =>true,
          child: AlertDialog(
            title: Text("Importante"),
            content: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.all(5),
                  child: Image(
                    image: AssetImage("assets/icons/selfie.png"),
                    width: size.width,
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(5),
                  child: Text(
                    'Por Favor tomar una foto donde se muestre su rostro sosteniendo una hoja con la palabra CTlleva con la fecha actual',
                    textAlign: TextAlign.justify,
                    style: TextStyle(
                      color: Colors.black,
                      fontFamily: 'MontserratSemiBold',
                    )
                  ),
                ),
              ],
            ),
            actions: <Widget>[
              FlatButton(
                child: Text('Aceptar'),
                onPressed: () {
                  _getImage(context, ImageSource.camera, 'Selfie'); 
                },
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