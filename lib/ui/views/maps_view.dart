import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:surveypptik/viewmodels/maps_view_model.dart';
import 'package:latlong/latlong.dart';
import 'package:stacked/stacked.dart';

class MapView extends StatefulWidget {
  @override
  _MapViewState createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {
  List<LatLng> tappedPoints = [];

  var markers = <Marker>[
    Marker(
      width: 80.0,
      height: 80.0,
      point: LatLng(51.5, -0.09),
      builder: (ctx) => Container(
        child: FlutterLogo(
          colors: Colors.blue,
          key: ObjectKey(Colors.blue),
        ),
      ),
    ),
    Marker(
      width: 80.0,
      height: 80.0,
      point: LatLng(53.3498, -6.2603),
      builder: (ctx) => Container(
        child: FlutterLogo(
          colors: Colors.green,
          key: ObjectKey(Colors.green),
        ),
      ),
    ),
    Marker(
      width: 80.0,
      height: 80.0,
      point: LatLng(48.8566, 2.3522),
      builder: (ctx) => Container(
        child: FlutterLogo(
          colors: Colors.purple,
          key: ObjectKey(Colors.purple),
        ),
      ),
    ),
  ];

  void _handleTap(LatLng latlng) {
    tappedPoints.clear();
    setState(() {
      tappedPoints.add(latlng);
    });
  }

  @override
  Widget build(BuildContext context) {
    var markers = tappedPoints.map((latlng) {
      return Marker(
        width: 80.0,
        height: 80.0,
        point: latlng,
        builder: (ctx) => Container(
          child: Icon(Icons.accessibility_new,color: Color(0xff323d4f),),
        ),
      );
    }).toList();
    // TODO: implement build
    // Lock Orientation Portait Only
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    return ViewModelBuilder<MapsViewModel>.reactive(
      viewModelBuilder: () => MapsViewModel(),
      onModelReady: (model) => model.onModelReady(),
      builder: (context, model, child) => Scaffold(
        appBar: AppBar(
          title: Text(
            'Semut Jabar',
            // style: TextStyle(color: Colors.black),
            style: TextStyle(color: Colors.white, fontFamily: 'tittle'),
          ),
          // leading: IconButton(
          //   icon: Icon(Icons.arrow_back_ios),
          // ),
          // actions: <Widget>[
          //   IconButton(
          //       iconSize: 40,
          //       icon: Icon(
          //         Icons.keyboard_arrow_up,
          //         color: Colors.black87,
          //       ),
          //       onPressed: () {
          //         Scaffold.of(context).showshowSnackBar(SnackBar(
          //           content: Text('Show Snackbar'),
          //           duration: Duration(seconds: 3),
          //         ));
          //       }),
          // ],
          // backgroundColor: Colors.white,
          backgroundColor: Colors.black,
          elevation: 0.0,
        ),
        body: Padding(
          padding: EdgeInsets.all(0.0),
          child: Column(
            children: <Widget>[
//            Row(
//              mainAxisAlignment: MainAxisAlignment.spaceBetween,
//              children: <Widget>[
//
//                new DropdownButton(
//                  value: _currentType,
//                  hint: Text("-- Pilih Tipe Kendaraan"),
//                  items: _dropDownMenuItems,
//                  onChanged: changedDropDownItem,
//                ),
//
//                new DropdownButton(
//                  value: _currentType,
//                  hint: Text("-- Pilih Tipe Kendaraan"),
//                  items: _dropDownMenuItems,
//                  onChanged: changedDropDownItem,
//                ),
//              ],
//            ),
              Flexible(
                child: FlutterMap(
                  options: MapOptions(
                    onTap: _handleTap,
                    minZoom: 8.0,
                    center: LatLng(model.lat, model.lng),
                    zoom: 15.9,
                  ),
                  layers: [
                    TileLayerOptions(
                      tileProvider: CachedNetworkTileProvider(),
                      maxZoom: 20.0,
                      urlTemplate:
                          'http://vectormap.pptik.id/styles/klokantech-basic/{z}/{x}/{y}.png',
                    ),
                    MarkerLayerOptions(
//                    maxClusterRadius: 120,
//                    size: Size(40, 40),
//                    anchor: AnchorPos.align(AnchorAlign.center),
//                    fitBoundsOptions: FitBoundsOptions(
//                      padding: EdgeInsets.all(50),
//                    ),
                      markers: markers,
//                    polygonOptions: PolygonOptions(
//                        borderColor: Colors.blueAccent,
//                        color: Colors.black12,
//                        borderStrokeWidth: 3),
//                    builder: (context, markers) {
//
//                    },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  
  }
  
}
