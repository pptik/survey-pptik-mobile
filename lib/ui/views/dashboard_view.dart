import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:surveypptik/constants/const.dart';
import 'package:surveypptik/constants/helper.dart';
import 'package:surveypptik/constants/route_name.dart';
import 'package:surveypptik/viewmodels/dashboard_view_model.dart';
import 'package:stacked/stacked.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Dashboard extends StatelessWidget {
  const Dashboard({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return ViewModelBuilder<DashboardView>.reactive(
      viewModelBuilder: () => DashboardView(),
      onModelReady: (model) => model.initData(),
      builder: (context, model, child) => Scaffold(
          appBar: AppBar(
            iconTheme: IconThemeData(color: Theme.of(context).primaryColor),
            titleSpacing: 0.0,
            elevation: 0.5,
            backgroundColor: Colors.brown,
            centerTitle: true,
            title: Text(
              "Dashboard",
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 20.0),
              textAlign: TextAlign.center,
            ),
            actions: [
              Container(
                margin: EdgeInsets.only(right: 14),
                child: PopupMenuButton<String>(
                  onSelected: (item) async {
                    print('item selected $item');
                    if (item.contains('Profile')) {
                      model.goAnotherView(ProfileViewRoute);
                    } else {
                      print('getting out');
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
                  child: CircleAvatar(
                    backgroundColor: Colors.grey.shade300,
                    child: CircleAvatar(
                        radius: 16,
                        backgroundColor: Colors.black,
                        child: Image.network(
                          "${model.pathImage}",
                          errorBuilder: (BuildContext context, Object exception,
                              StackTrace stackTrace) {
                            return Text('${model.name.characters.first}');
                          },
                        )),
                  ),
                ),
              )
            ],
          ),
          backgroundColor: Colors.brown,
          body: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            physics: ScrollPhysics(),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                    margin: EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                    child: Text(
                      "Hallo...",
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 20.0),
                    )),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 18),
                  child: Text(
                    "Selamat Datang ${model.name}",
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 15.0),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  // child: Text(
                  //   'Survey Pisang',
                  //   style: TextStyle(
                  //     color: Colors.amberAccent,
                  //     // height: 20,
                  //   ),
                  // ),
                  height: size.width * 0.25,
                  child: Center(
                    child: Text(
                      'Survey PPTIK',
                      style:
                          TextStyle(fontSize: 25, fontWeight: FontWeight.w800),
                    ),
                  ),
                  margin: EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Colors.black,
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                    margin: EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                    child: Text(
                      "Activity",
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 20.0),
                    )),
                GridView(
                  cacheExtent: 0.0,
                  children: activities
                      .map(
                        (activity) => Column(
                          children: <Widget>[
                            InkWell(
                              child: CircleAvatar(
                                radius: 20,
                                backgroundColor: Colors.black,
                                child: activity.icon != null
                                    ? Icon(
                                        activity.icon,
                                        size: 18.0,
                                        color: color_white,
                                      )
                                    : null,
                              ),
                              onTap: () => model.goAnotherView(activity.route),
                            ),
                            const SizedBox(height: 5.0),
                            Text(
                              activity.title,
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 14.0),
                            ),
                          ],
                        ),
                      )
                      .toList(),
                  shrinkWrap: true,
                  physics: ClampingScrollPhysics(),
                  gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
                    mainAxisSpacing: 1.0,
                    crossAxisSpacing: 15.0,
                    crossAxisCount: 3,
                  ),
                ),
                SizedBox(
                  height: 200,
                  width: 100,
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Text(
                    "Version 1.1.3",
                    style: TextStyle(color: Colors.black),
                  ),
                )
              ],
            ),
          )),
    );
  }
}

class Activity {
  final String title;
  final IconData icon;
  final String route;
  Activity({this.title, this.icon, this.route});
}

final List<Activity> activities = [
  Activity(
      title: "My Report", icon: FontAwesomeIcons.listOl, route: HomeViewRoute),
  Activity(
      title: "Pending Report",
      icon: FontAwesomeIcons.list,
      route: LocalReportViewRoute),
  // Activity(
  //     title: "Maps", icon: FontAwesomeIcons.mapMarkedAlt, route: MapViewRoute),
  // Activity(
  //     title: "Guest Book",
  //     icon: FontAwesomeIcons.bookReader,
  //     route: GuestBookViewRoute),
  // Activity(
  //     title: "Trajectory",
  //     icon: FontAwesomeIcons.mapSigns,
  //     route: TrajectoryViewRoute)
];
