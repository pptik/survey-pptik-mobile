import 'package:surveypptik/constants/helper.dart';
import 'package:surveypptik/constants/route_name.dart';
import 'package:surveypptik/ui/shared/shared_style.dart';
import 'package:surveypptik/ui/widgets/list_content_widget.dart';
import 'package:surveypptik/viewmodels/home_view_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:surveypptik/ui/shared/colors_helper.dart';
//import 'package:provider_architecture/provider_architecture.dart';
import 'package:stacked/stacked.dart';

// import flutter services
import 'package:flutter/services.dart';

class HomeView extends StatefulWidget {
  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  int page;
  @override
  Widget build(BuildContext context) {
    // Lock Orientation Portait Only
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);

    return ViewModelBuilder<HomeViewModel>.reactive(
      viewModelBuilder: () => HomeViewModel(),
      onModelReady: (model) => model.onModelReady(),
      builder: (context, model, child) => Scaffold(
          appBar: AppBar(
            title: Text('Survey PPTIK'),
            actions: <Widget>[
              FlatButton(
                onPressed: () {
                  model.goAnotherView(QuestionerViewRoute);
                },
                child: Text("AM"),
              ),
              PopupMenuButton<String>(
                onSelected: (item) async {
                  print('item selected $item');
                  if (item.contains('Profile')) {
                    model.goAnotherView(ProfileViewRoute);
                  } else {
                    model.signOut(context);
                  }
                },
                itemBuilder: (context) {
                  return Helper.choices.map(
                    (choice) {
                      return PopupMenuItem<String>(
                        value: choice,
                        child: Text(choice),
                      );
                    },
                  ).toList();
                },
              ),
            ],
          ),
          body: SafeArea(
            child: RefreshIndicator(
              onRefresh: () async {
                print('refresh');
                model.getAllReport(1);
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
                                itemBuilder: (ctx, idx) => ListContentWidget(
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
                                ),
                              ),
                            )
                          : Center(
                              child: Text(
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
                  ],
                ),
              ),
            ),
          ),
          floatingActionButton: Stack(children: [
            Row(mainAxisAlignment: MainAxisAlignment.end, children: [
              FloatingActionButton(
                backgroundColor: bluePrimary,
                child: Icon(Icons.add),
                onPressed: () {
                  model.goAnotherView(AbsenViewRoute);
                },
                heroTag: "AbsenViewRoute",
              )
            ]),
          ])),
    );
  }
}
