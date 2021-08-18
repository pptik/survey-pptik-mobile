import 'dart:io';
import 'package:surveypptik/ui/shared/shared_style.dart';
import 'package:surveypptik/ui/shared/ui_helper.dart';
import 'package:surveypptik/viewmodels/absen_view_model.dart';
import 'package:flutter/material.dart';
import 'package:loading_overlay/loading_overlay.dart';
//import 'package:provider_architecture/provider_architecture.dart';
import 'package:stacked/stacked.dart';
import 'package:surveypptik/ui/shared/colors_helper.dart';

// import flutter services
import 'package:flutter/services.dart';

class RadioGroup {
  final int index;
  final String text;
  RadioGroup({this.index, this.text});
}

class AbsenView extends StatefulWidget {
  @override
  _AbsenViewState createState() => _AbsenViewState();
}

class _AbsenViewState extends State<AbsenView> {
  int _rgProgramming = 1;
  String _selectedValue;

  final List<RadioGroup> _programmingList = [
    RadioGroup(index: 1, text: "#LaporanRe"),
    RadioGroup(index: 2, text: "#SayaSakit"),
    RadioGroup(index: 3, text: "#SayaButuhPertolongan"),
  ];
  @override
  Widget build(BuildContext context) {
    // Lock Orientation Portait Only
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);

    return ViewModelBuilder<AbsenViewModel>.reactive(
      viewModelBuilder: () => AbsenViewModel(),
      onModelReady: (model) {
        model.openLocationSetting();
        model.getNumberPhone();
      },
      builder: (context, model, child) => Scaffold(
        appBar: AppBar(
          title: Text('Survey PPTIK'),
        ),
        body: LoadingOverlay(
          isLoading: model.busy,
          child: SafeArea(
            child: SingleChildScrollView(
              child: Center(
                child: Container(
                  padding: EdgeInsets.all(12),
                  width: screenWidthPercent(
                    context,
                    multipleBy: 0.95,
                  ),
                  child: Column(
                    children: <Widget>[
                      verticalSpaceMedium,
                      InkWell(
                        onTap: () async {
                          await model.cameraView();
                        },
                        child: Container(
                          padding: fieldPadding,
                          width: screenWidthPercent(
                            context,
                            multipleBy: 0.83,
                          ),
                          height: screenHeightPercent(
                            context,
                            multipleBy: 0.4,
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.greenAccent,
                              width: 2.0,
                            ),
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          child: model.isPathNull() == false
                              ? Center(
                                  child: Text(
                                    'Tap',
                                    style: textButtonTextStyle,
                                  ),
                                )
                              :Image.file(File(model.imagePath),fit: BoxFit.cover,)
                              // // : FittedBox(
                              // //     child: Image.file(File(model.imagePath)),
                              // //     fit: BoxFit.fitWidth,
                              //
                              //   ),
                        ),
                      ),
                      verticalSpaceMedium,
                      Visibility(
                        visible: false,
                        child: LocationWidget(
                          title: 'Lat',
                          content: '${model.lat}',
                          visible: model.isPathNull(),
                        ),
                      ),
                      // Lng
                      verticalSpaceSmall,
                      Visibility(
                        visible: false,
                        child: LocationWidget(
                          title: 'Lng',
                          content: '${model.lng}',
                          visible: model.isPathNull(),
                        ),
                      ),

                      verticalSpaceMedium,
                      Visibility(
                        visible: false,
                        child: Text(
                          'Address',
                          style: absenNameTextStyle,
                        ),
                      ),
                      verticalSpaceSmall,
                      Visibility(
                        visible: false,
                        child: Text(
                          '${model.address}',
                          maxLines: 4,
                          overflow: TextOverflow.ellipsis,
                          style: absenContentTextStyle,
                          textAlign: TextAlign.center,
                        ),
                      ),
                      verticalSpaceMedium,
                      Visibility(
                        visible: model.isPathNull(),
                        child: Text(
                          "Today's Activity",
                          style: absenNameTextStyle,
                        ),
                      ),
                      verticalSpaceSmall,
                      Visibility(
                        visible: model.isPathNull(),
                        child: Container(
                          padding: fieldPadding,
                          width: screenWidthPercent(
                            context,
                            multipleBy: 0.9,
                          ),
                          child: TextField(
                            controller: model.commentController,
                            maxLines: null,
                            keyboardType: TextInputType.text,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                      ),
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
                            // model.reSendMessages(context);
                            model.sendMessages(context);
                          },
                          child: Text(
                            'Report',
                            style: textButtonTextStyle,
                          ),
                        ),
                      ),
                      verticalSpaceSmall
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class LocationWidget extends StatelessWidget {
  const LocationWidget({
    Key key,
    this.title,
    this.content,
    this.visible = true,
  }) : super(key: key);

  final String title;
  final String content;
  final bool visible;

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: visible,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Text(
            '$title',
            style: absenNameTextStyle,
          ),
          Text(
            '$content',
            style: absenContentTextStyle,
          ),
        ],
      ),
    );
  }
}
