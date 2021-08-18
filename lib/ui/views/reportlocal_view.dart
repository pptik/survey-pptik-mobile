import 'package:surveypptik/constants/helper.dart';
import 'package:surveypptik/constants/route_name.dart';
import 'package:surveypptik/ui/shared/shared_style.dart';
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

                                  content:
                                      '${model.absenData[idx].description}',
                                  date:
                                      '${model.formatDate(model.absenData[idx].timestamp)}',
                                  address: '${model.absenData[idx].address} ',
                                  imageUrl:
                                      'http://survey.pptik.id/${model.absenData[idx].image}',
                                  name: '${model.absenData[idx].name}',
                                  imageLocal:
                                      '${model.absenData[idx].localImage}',
                                  status: '${model.absenData[idx].status}',
                                ),
                              ),
                            )
                          : Center(
                              child:CircularProgressIndicator()
                              // Text(
                              //   'None',
                              //   style: profileTextStyle,
                              // ),
                            ),
                    ),
                    Container(
                      height: model.isLoading ? 50.0 : 0,
                      color: Colors.transparent,
                      child: Center(
                        child: new CircularProgressIndicator(),
                      ),
                    ),
                    // Container(
                    //   // padding: EdgeInsets.all(10),
                    //   margin: const EdgeInsets.only(top: 10.0),
                    //   height: 50,
                    //   width: 300,
                    //   decoration: BoxDecoration(
                    //       color: Colors.blue,
                    //       borderRadius: BorderRadius.circular(10)),
                    //   child: FlatButton(
                    //     onPressed: () {
                    //       model.reSendMessages(context);

                    //       // Submit(context);
                    //       // Navigator.push(
                    //       //     context, MaterialPageRoute(builder: (_) => HomePage()));
                    //     },
                    //     child: Text(
                    //       'RESEND',
                    //       style: TextStyle(color: Colors.white, fontSize: 15),
                    //     ),
                    //   ),
                    // ),
                  ],
                ),
              ),
            ),
          ),
          floatingActionButton: Stack(children: [
            Row(mainAxisAlignment: MainAxisAlignment.end, children: [
              FloatingActionButton(
                backgroundColor: Colors.brown,
                child: Icon(Icons.send_to_mobile_rounded),
                onPressed: () {
                  model.setBusy(false);
                  model.reSendMessages(context);
                  // model.goAnotherView(AbsenViewRoute);
                },
                heroTag: "AbsenViewRoute",
              ),
              // Text('Resend'),
              // Container(
              //   // padding: EdgeInsets.all(10),
              //
              //   // margin: const EdgeInsets.only(
              //   //     top: 10, right: 10, left: 10, bottom: 10),
              //   // height: 50,
              //   // width: 300,
              //   // c: TextAlign.center,
              //   margin: EdgeInsets.all(20),
              //   decoration: BoxDecoration(
              //       color: Colors.brown,
              //       borderRadius: BorderRadius.circular(10)),
              //   child: FlatButton(
              //     onPressed: () {
              //       // EasyLoading.show(status: 'loading...');
              //       // EasyLoading.init();
              //       // EasyLoading.show(status: 'loading...');
              //       model.reSendMessages(context);
              //       // Submit(context);
              //       // Navigator.push(
              //       //     context, MaterialPageRoute(builder: (_) => HomePage()));
              //     },
              //     child: Text(
              //       'RESEND',
              //       textAlign: TextAlign.center,
              //       style: TextStyle(color: Colors.white, fontSize: 15,),
              //     ),
              //   ),
              // ),
            ]),
          ])),
    );
  }
}
