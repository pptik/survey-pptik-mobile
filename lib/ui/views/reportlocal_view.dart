import 'package:flutter/widgets.dart';
import 'package:surveypptik/constants/helper.dart';
import 'package:surveypptik/constants/route_name.dart';
import 'package:surveypptik/ui/shared/shared_style.dart';
import 'package:surveypptik/ui/shared/ui_helper.dart';
import 'package:surveypptik/ui/widgets/button_widget.dart';
// import 'package:surveypptik/ui/widgets/list_content_widget.dart';
import 'package:surveypptik/ui/widgets/list_contentlocal_widget.dart';
import 'package:surveypptik/viewmodels/home_view_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:surveypptik/ui/shared/colors_helper.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
//import 'package:provider_architecture/provider_architecture.dart';
import 'package:stacked/stacked.dart';

// import flutter services
import 'package:flutter/services.dart';

class LocalReportView extends StatefulWidget {
  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<LocalReportView> {
  int page;
  @override
  Widget build(BuildContext context) {
    // Lock Orientation Portait Only
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);

    return ViewModelBuilder<HomeViewModel>.reactive(
      viewModelBuilder: () => HomeViewModel(),
      // onModelReady: (model) => model.onModelReady(),
      onModelReady: (model) => model.onModeLocal(),
      // model.getAllReport(1);
      builder: (context, model, child) => Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.brown,
            title: Text('Survey PPTIK'),
            actions: <Widget>[
              // FlatButton(
              //   onPressed: () {
              //     model.goAnotherView(QuestionerViewRoute);
              //   },
              //   child: Text("AM"),
              // ),
              // PopupMenuButton<String>(
              //   onSelected: (item) async {
              //     print('item selected $item');
              //     if (item.contains('Profile')) {
              //       model.goAnotherView(ProfileViewRoute);
              //     } else {
              //       model.signOut(context);
              //     }
              //   },
              //   itemBuilder: (context) {
              //     return Helper.choices.map(
              //       (choice) {
              //         return PopupMenuItem<String>(
              //           value: choice,
              //           child: Text(choice),
              //         );
              //       },
              //     ).toList();
              //   },
              // ),
            ],
          ),
          body: SafeArea(
            child: RefreshIndicator(
              onRefresh: () async {
                print('refresh');
                // model.getAllReport(1);
                model.getReportInternal();
              },
              child: Container(
                color: Color(0xffC1C1C1),
                child: Column(
                  children: <Widget>[
                    Expanded(
                      child: model.absenData.length != 0
                          ? NotificationListener<ScrollNotification>(
                              onNotification: (ScrollNotification scrollInfo) {
                                if (!model.isLoading &&
                                    scrollInfo.metrics.pixels ==
                                        scrollInfo.metrics.maxScrollExtent) {
                                  model.pages += 1;
                                  model.loadMoreData(model.pages);
                                }
                              },
                              child: ListView.builder(
                                padding: EdgeInsets.only(
                                  top: 8.0,
                                  bottom: 8.0,
                                  right: 4.0,
                                  left: 4.0,
                                ),
                                itemCount: model.absenData.length,
                                itemBuilder: (ctx, idx) =>
                                    // GestureDetector()

                                    ListContentLocalWidget(
                                  content: '${model.absenData[idx].description}',
                                  date: '${model.formatDate(model.absenData[idx].timestamp)}',
                                  address: '${model.absenData[idx].address} ',
                                  imageUrl: 'http://survey.pptik.id/${model.absenData[idx].image}',
                                  name: '${model.absenData[idx].name}',
                                  networkstatus: '${model.absenData[idx].networkstatus}',
                                  imageLocal: '${model.absenData[idx].localImage}',
                                  status: '${model.absenData[idx].status}',
                                      guid: '${model.absenData[idx].guid}',
                                      company: '${model.absenData[idx].company}',
                                      lat: '${model.absenData[idx].lat}',
                                      long: '${model.absenData[idx].long}',
                                      image: '${model.absenData[idx].image}',
                                      timetamp: '${model.absenData[idx].timestamp}',
                                      signalType: '${model.absenData[idx].signalType}',
                                      signalStrength: '${model.absenData[idx].signalStrength}',
                                      signalCarrier: '${model.absenData[idx].signalCarrier}',
                                      unit: '${model.absenData[idx].unit}',
                                ),
                              ),
                            )
                          : Center(
                          child:
                              Text(
                                'None',
                                style: profileTextStyle,
                              ),
                              ),
                    ),
                    Container(
                      height: model.isLoading ? 50.0 : 0,
                      color: Colors.transparent,
                      child: Center(
                        child: new CircularProgressIndicator(),
                      ),
                    ),
                    verticalSpaceSmall,
                    ButtonTheme(
                      minWidth: 300.0,
                      height: 43.0,
                      child: RaisedButton(
                        onPressed: () {
                          // Resend(context);
                          model.reSendMessages(context);
                        },
                        child: Text("Resend All",style:TextStyle(fontSize: 17),),
                      ),
                    ),
                    verticalSpaceSmall,
                    // verticalSpaceSmall,
                    ButtonTheme(
                      minWidth: 300.0,
                      height: 43.0,
                      child: RaisedButton(
                        onPressed: () {
                          // Resend(context);
                          model.deleteAll(context);
                        },
                        child: Text("Delete All",style:TextStyle(fontSize: 17),),
                      ),
                    ),
                    verticalSpaceSmall,
                  ],
                ),
              ),
            ),
          ),

          // floatingActionButton: Stack(children: [
          //   Row(mainAxisAlignment: MainAxisAlignment.end, children: [
          //     FloatingActionButton(
          //       backgroundColor: Colors.brown,
          //       child: Icon(Icons.send_to_mobile_rounded),
          //       onPressed: () {
          //         model.setBusy(false);
          //         model.reSendMessages(context);
          //         // model.goAnotherView(AbsenViewRoute);
          //       },
          //       heroTag: "AbsenViewRoute",
          //     ),
          //   ]),
          //   // SizedBox.fromSize(10.0)
          // SizedBox(height: 30,),
          //   Row(children: [
          //     // EdgeInsets.all(10),
          //     FloatingActionButton(
          //       backgroundColor: Colors.brown,
          //       child: Icon(Icons.delete),
          //       onPressed: () {
          //         model.setBusy(false);
          //         model.reSendMessages(context);
          //         // model.goAnotherView(AbsenViewRoute);
          //       },
          //       heroTag: "AbsenViewRoute",
          //     ),
          //   ]),
          // ]),
      ),
    );
  }
}
