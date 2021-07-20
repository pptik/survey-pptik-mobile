import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:surveypptik/constants/helper.dart';
import 'package:surveypptik/ui/shared/colors_helper.dart';
import 'package:surveypptik/ui/shared/shared_style.dart';
import 'package:surveypptik/ui/shared/ui_helper.dart';
import 'package:surveypptik/viewmodels/questioner_view_model.dart';
import 'package:latlong/latlong.dart';
import 'package:stacked/stacked.dart';

class QuestionerView extends StatefulWidget {
  @override
  _QuestionerViewState createState() => _QuestionerViewState();
}

class _QuestionerViewState extends State<QuestionerView> {
  bool q_1 = true;
  bool q_1a = true;
  bool q_2 = true;
  bool q_3 = true;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    // Lock Orientation Portait Only
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);

    return ViewModelBuilder<QuestionerViewModel>.reactive(
      viewModelBuilder: () => QuestionerViewModel(),
      onModelReady: (model) => model.init_state(),
      builder: (context, model, child) => Scaffold(
        appBar: AppBar(
          title: Text('Questioner'),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Center(
                child: Padding(
              padding: EdgeInsets.only(left: 15, right: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  verticalSpaceMedium,
                  Text(
                    "Questioner",
                    style: titleQuestionerStyle,
                  ),
                  verticalSpaceLarge,
                  Text(Helper.firstQuestion),
                  RadioListTile(
                    title: const Text('Yes'),
                    value: true,
                    groupValue: model.q_1,
                    onChanged: (bool value) async {
                      model.group_1(value);
                      setState(() {
                        q_1 = value;
                      });
                    },
                  ),
                  RadioListTile(
                    title: const Text('No'),
                    value: false,
                    groupValue: model.q_1,
                    onChanged: (bool value) async {
                      setState(() {
                        q_1 = value;
                      });
                      model.group_1(value);
                    },
                  ),
                  Visibility(
                    visible: q_1,
                    child: Column(
                      children: <Widget>[
                        Text(Helper.firstPontOneQuestion),
                        RadioListTile(
                          title: const Text('Yes'),
                          value: true,
                          groupValue: model.q_1a,
                          onChanged: (bool value) async {
                            model.group_1a(value);
                            setState(() {
                              q_1a = value;
                            });
                          },
                        ),
                        RadioListTile(
                          title: const Text('No'),
                          value: false,
                          groupValue: model.q_1a,
                          onChanged: (bool value) async {
                            setState(() {
                              q_1a = value;
                            });
                            model.group_1a(value);
                          },
                        ),
                      ],
                    ),
                  ),
                  verticalSpaceSmall,
                  Text(Helper.secondQuestion),
                  RadioListTile(
                    title: const Text('Yes'),
                    value: true,
                    groupValue: model.q_2,
                    onChanged: (bool value) async {
                      model.group_2(value);
                      setState(() {
                        q_2 = value;
                      });
                    },
                  ),
                  RadioListTile(
                    title: const Text('No'),
                    value: false,
                    groupValue: model.q_2,
                    onChanged: (bool value) async {
                      setState(() {
                        q_2 = value;
                      });
                      model.group_2(value);
                    },
                  ),
                  verticalSpaceSmall,
                  Text(Helper.thirdQuestion),
                  RadioListTile(
                    title: const Text('Yes'),
                    value: true,
                    groupValue: model.q_3,
                    onChanged: (bool value) async {
                      model.group_3(value);
                      setState(() {
                        q_3 = value;
                      });
                    },
                  ),
                  RadioListTile(
                    title: const Text('No'),
                    value: false,
                    groupValue: model.q_3,
                    onChanged: (bool value) async {
                      setState(() {
                        q_3 = value;
                      });
                      model.group_3(value);
                    },
                  ),
                  // Visibility(
                  //   visible: q_3,
                  //   child: Container(
                  //     padding: fieldPadding,
                  //     width: screenWidthPercent(
                  //       context,
                  //       multipleBy: 0.9,
                  //     ),
                  //     height: fieldHeight,
                  //     child: DropdownButton(
                  //       isExpanded: true,
                  //       hint: Text('Choose Province'),
                  //       value: model.selectedProvince,
                  //       items: model.province_data == null
                  //           ? null
                  //           : model.province_data.map(
                  //             (value) {
                  //           return DropdownMenuItem(
                  //             child: Text(value.nama),
                  //             value: value.nama,
                  //           );
                  //         },
                  //       ).toList(),
                  //       onChanged: (value) {
                  //         print("ini value $value");
                  //         model.onProvinceChanged(value);
                  //       },
                  //     ),
                  //   ),
                  // ),
                  verticalSpaceMedium,
                  Visibility(
                      visible: q_3,
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            flex: 2,
                            child: TextField(
                              controller: model.keteranganController,
                              minLines: 3,
                              maxLines: 6,
                              keyboardType: TextInputType.multiline,
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  hintText:
                                      "ex : Jawa Barat, Bandung Barat, Ngamprah, Pergi ke toko A"),
                            ),
                          ),
                          Expanded(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10.0),
                              child: Container(
                                child: GestureDetector(
                                  onTap: () {
                                    print("OPen 123");
                                  },
                                  child: FlutterMap(
                                    options: MapOptions(
                                      center: LatLng(model.lat, model.lng),
                                      zoom: 15.9,
                                    ),
                                    layers: [
                                      TileLayerOptions(
                                        // tileProvider: CachedNetworkTileProvider(),
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
                                          // markers: model.markers,
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
                                width: 90,
                                height: 90,
                                color: Colors.blue,
                              ),
                            ),
                          ),
                        ],
                      )),
                  verticalSpaceMedium,
                  Container(
                    padding: fieldPadding,
                    width: screenWidthPercent(
                      context,
                      multipleBy: 0.9,
                    ),
                    height: fieldHeight,
                    child: RaisedButton(
                      color: bluePrimary,
                      onPressed: () {
//                            print('Button Pressed');
//                            model.absent(context);
//                            model.uploadFile();
                        model.send_message(context);
                        model.getBatteryLevel();
                      },
                      child: Text(
                        'Report',
                        style: textButtonTextStyle,
                      ),
                    ),
                  ),
                  verticalSpaceMedium,
                  Container(
                    child: Text(
                      "Message : ${model.battery}",
                      style: TextStyle(
                          fontSize: 14.0, fontWeight: FontWeight.w800),
                    ),
                  )
                ],
              ),
            )),
          ),
        ),
      ),
    );
  }
}
