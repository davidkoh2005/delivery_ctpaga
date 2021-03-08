import 'package:delivery_ctpaga/views/navbar/navbarMain.dart';
import 'package:delivery_ctpaga/providers/provider.dart';
import 'package:delivery_ctpaga/env.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';

class GoogleMapsPage extends StatefulWidget {
  @override
  _GoogleMapsPageState createState() => _GoogleMapsPageState();
}

class _GoogleMapsPageState extends State<GoogleMapsPage> {
  Completer<GoogleMapController> _controllerGoogleMap = Completer();
  GoogleMapController newGoogleMapController;

  Position currentPosition;
  var geoLocator = Geolocator(), _currentMapType = MapType.normal;
  final Set<Marker> _markers = Set();

  String addressSearch;

  void locatePosition() async {
    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.bestForNavigation);
    currentPosition = position;

    LatLng latLatPosition = LatLng(position.latitude, position.longitude);

    CameraPosition cameraPosition = new CameraPosition(target: latLatPosition, zoom: 16);
    newGoogleMapController.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
  }

  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(10.498344, -66.880764),
    zoom: 14,
  );

  @override
  Widget build(BuildContext context) {
    return Consumer<MyProvider>(
      builder: (context, myProvider, child) {
        return WillPopScope(
          onWillPop: () async => false,
          child: Scaffold(
            backgroundColor: Colors.white,
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                locatePosition();
              },
              child: Icon(Icons.gps_fixed),
              backgroundColor: colorGreen,
            ),
            body: Stack(
              children: <Widget> [
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    NavbarMain(),
                    Expanded(
                      child: Stack(
                        children: [
                          GoogleMap(
                            markers: _markers,
                            myLocationEnabled: true,
                            zoomControlsEnabled: false,
                            myLocationButtonEnabled: false,
                            mapType: _currentMapType,
                            initialCameraPosition: _kGooglePlex,
                            onMapCreated: (GoogleMapController controller) {
                              _controllerGoogleMap.complete(controller);
                              newGoogleMapController = controller;
                              locatePosition();
                            },
                            onTap: (latlang){
                              if(_markers.length>=1)
                                {
                                  _markers.clear();
                                }

                              _onAddMarkerButtonPressed(latlang);
                            },
                          ),

                          Positioned(
                            top: 30.0,
                            right: 15.0,
                            left: 15.0,
                            child: Container(
                              height: 50.0,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.0),
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey,
                                    offset: Offset(1.0, 5.0),
                                    blurRadius: 10,
                                    spreadRadius: 3
                                  ),
                                ],
                              ),
                              child: TextFormField(
                                decoration: InputDecoration(
                                  hintText: "Ingrese dirección a buscar",
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.only(left:15.0, top: 15.0),
                                  suffixIcon:  IconButton(
                                    icon: Icon(Icons.search, color: colorGrey,),
                                    onPressed: searchNavigate,
                                    iconSize: 30.0,
                                  ),
                                ),
                                onChanged: (val) {
                                  setState(() {
                                    addressSearch = val.trim();
                                  });
                                },
                                textInputAction: TextInputAction.done,
                                cursorColor: colorGreen,
                                onFieldSubmitted: (term){
                                  FocusScope.of(context).requestFocus(new FocusNode());
                                  searchNavigate();
                                }, 
                                style: TextStyle(
                                  fontFamily: 'MontserratSemiBold',
                                ),
                              )
                            ),
                          ),

                          Positioned(
                            right: 15,
                            top: 100.0,
                            child: FloatingActionButton(
                              onPressed: _onMapTypeButtonPressed,
                              materialTapTargetSize: MaterialTapTargetSize.padded,
                              backgroundColor: colorGreen,
                              child: Icon(
                                Icons.public,
                                size: 36.0,
                              ),
                            ),
                          ),
                        ],
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

  _onMapTypeButtonPressed(){
    setState(() {
      _currentMapType = _currentMapType == MapType.normal? MapType.satellite : MapType.normal;
    });
  }

  searchNavigate() async {
    List<Location> locations = await locationFromAddress(addressSearch);
    
    locationFromAddress(addressSearch).then((result) {
      newGoogleMapController.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(locations[0].latitude, locations[0].longitude),
          zoom: 16.0,
        ),
      ));
    });

  }


   void _onAddMarkerButtonPressed(LatLng latlang) {
    setState(() {
      _markers.add(Marker(
        // This marker id can be anything that uniquely identifies each marker.
        markerId: MarkerId(latlang.toString()),
        position: latlang,
        infoWindow: InfoWindow(
          title: latlang.toString(),
        ),
        icon: BitmapDescriptor.defaultMarker,
      ));
    });
  }

}

