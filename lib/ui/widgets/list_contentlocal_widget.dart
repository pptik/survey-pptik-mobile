import 'dart:io';

import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:surveypptik/constants/const.dart';
import 'package:surveypptik/constants/route_name.dart';
import 'package:surveypptik/locator.dart';
import 'package:surveypptik/models/send_absen.dart';
import 'package:surveypptik/services/alert_service.dart';
import 'package:surveypptik/services/ftp_service.dart';
import 'package:surveypptik/services/navigation_service.dart';
import 'package:surveypptik/services/rmq_service.dart';
import 'package:surveypptik/ui/shared/colors_helper.dart';
import 'package:surveypptik/ui/shared/rounded_bordered_container.dart';
import 'package:surveypptik/ui/shared/shared_style.dart';
import 'package:surveypptik/ui/shared/ui_helper.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:surveypptik/ui/views/preview_view.dart';
import 'package:surveypptik/ui/widgets/button_widget.dart';
class ListContentLocalWidget extends StatelessWidget {

  const ListContentLocalWidget({
    Key key,
    @required this.date,
    @required this.address,
    @required this.content,
    @required this.imageUrl,
    @required this.name,
    @required this.networkstatus,
    @required this.imageLocal,
    @required this.company,
    @required this.guid,
    @required this.lat,
    @required this.long,
    @required this.image,
    @required this.timetamp,
    @required this.data_report,
    @required this.unit,
    @required this.signalCarrier,
    @required this.signalStrength,
    @required this.signalType,
    @required this.reportType,

    this.detailFunction,
    this.img=false,
    this.send, this.status
  }) : super(key: key);
  final String send;
  final String date;
  final String content;
  final String address;
  final String name;
  final String imageUrl;
  final String imageLocal;
  final String status;
  final Function detailFunction;
  final String networkstatus;
  final String company;
  final String guid;
  final String lat;
  final String long;
  final String image;
  final String timetamp;
  final String unit;
  final String signalCarrier;
  final String signalStrength;
  final String signalType;
  final String reportType;

  final String data_report;
  final bool img;
  void data(BuildContext contexts){
    showDialog(
        barrierDismissible: true,
        context: contexts,
        builder: (BuildContext context) {
          return Dialog(

              backgroundColor: Colors.transparent,
              shape: RoundedRectangleBorder(
                  borderRadius:
                  BorderRadius.circular(20.0)), //this right here
              child:PreviewImageScreen(imagePath: imageLocal,)
          );
        });
  }
  @override
  Widget build(BuildContext context) {
    return RoundedContainer(
      padding: const EdgeInsets.all(0),
      margin: EdgeInsets.all(5),
      elevation: 2,
      height: 300,
      child: Row(
        children: <Widget>[
          InkWell(
            onTap: ()=>data(context),
            child: Container(
              width: 140,
              decoration: BoxDecoration(
                  image: DecorationImage(
                    image:FileImage(File(imageLocal)),
                    fit: BoxFit.cover,
                  )),
            ),
          ),
          Flexible(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    children: <Widget>[

                      Expanded(
                        child: Text(
                          "$date",
                          overflow: TextOverflow.fade,
                          softWrap: true,
                          style: TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 15),
                        ),
                        flex: 2,
                      ),
                      // Container(
                      //   width: 50,
                      //   child: IconButton(
                      //     onPressed: () {
                      //       detailFunction;
                      //     },
                      //     color: color_mandarin,
                      //     icon: Icon(Icons.arrow_forward_ios),
                      //     iconSize: 20,
                      //   ),
                      // )
                    ],
                  ),
                  Container(
                    child: Text("$date",style: TextStyle(color: color_independent),),
                  ),
                  SizedBox(height: 10,),
                  Container(
                    child: Text("$content",style: TextStyle(color: color_silverv),),
                  ),
                  SizedBox(height: 7,),

                  Container(
                    child: Text("$address",style: TextStyle(color: color_silverv),),
                  ),
                  SizedBox(height: 10,),
                  Text(
                    "Network Status:$networkstatus",
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: Colors.black),
                  ),
                  SizedBox(height: 24,),
                  Text(
                    "$name",
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: Colors.orange),
                  ),
                  Text(
                    "$status",
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: Colors.blue),
                  ),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: (send=='pending')?FaIcon(FontAwesomeIcons.clock,size: 15,color: Colors.grey,):FaIcon(FontAwesomeIcons.check,size: 15,color: Colors.grey,),
                  ),
                  InkWell(
                    // onTap: Resend(context),
                    child:  ButtonTheme(
                        minWidth: 120.0,
                        height: 35.0,
                        child: RaisedButton(
                          onPressed: () {
                            Resend(context);
                          },
                          child: Text("Resend"),
                        ),
                      ),
                    // child: ButtonWidget(
                    //   title: 'Resend',
                    //   onPressedFunction: () {
                    //   },
                    //
                    // ),

                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Resend(BuildContext context)async {
    final ProgressDialog pr = ProgressDialog(context);
    pr.style(
        message: 'Loading...',
        borderRadius: 5.0,
        backgroundColor: color_independent,
        progressWidget: CircularProgressIndicator(),
        elevation: 10.0,
        insetAnimCurve: Curves.easeInOut,
        progress: 0.0,
        // TextDirection: TextDirection.LTR,
        maxProgress: 200.0,
        progressTextStyle: TextStyle(
            color: Colors.black, fontSize: 10.0, fontWeight: FontWeight.w400),
        messageTextStyle: TextStyle(
            color: Colors.black, fontSize: 19.0, fontWeight: FontWeight.w600));

    final NavigationService _navigationService = locator<NavigationService>();
    final AlertService _alertService = locator<AlertService>();
    print(address);
    print(name);
    print(date);
    var absentData = SendAbsen(
        address:'${address}',
        cmdType:0,
        company:'${company}',
        description:'${content}',
        guid:'${guid}',
        image:'${image}' ,
        lat:'${lat}' ,
        long:'${long}',
        localImage:'${imageLocal}',
        msgType:1,
        name:'${name}',
        status:'REPORT',
        timestamp:'${timetamp}',
        unit:'${unit}',
        signalCarrier:'${signalCarrier}',
        signalStrength:int.parse('${signalStrength}'),
        signalType:'${signalType}',
        reportType:'${reportType}',
        networkStatus:'${networkstatus}' ,

    );
    final sendAbsen = sendAbsenToJson(absentData);
    print(sendAbsen);
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        pr.show();
        sendToftp(absentData,imageLocal,guid,timetamp,context);
      }
    } on SocketException catch (_) {
      print('not connected');
      _alertService.showWarning(
        context,
        'Warning',
        'Connection problem 😭, data temporarily will be saved om the device',
            () {
          _navigationService.replaceTo(DashboardRoute);
          pr.hide();
        },
      );
    }

  }

  void sendToftp(surveyData,imageLocal,String guid, timestamp, BuildContext context)async {
    final NavigationService _navigationService = locator<NavigationService>();
    final AlertService _alertService = locator<AlertService>();
    final FtpService _ftpService = locator<FtpService>();
    bool isSuccess =
        await _ftpService.uploadFile(File(imageLocal), guid, timestamp);
    if(isSuccess){
      sendToRmq(surveyData,context);
    }else{
      _alertService.showWarning(
        context,
        'Warning',
        'Connection Server problem 😭, data temporarily will be saved om the device',
            () {
          _navigationService.replaceTo(DashboardRoute);
        },
      );
    }

  }

  void sendToRmq(surveyData, BuildContext context)async {
    final NavigationService _navigationService = locator<NavigationService>();
    final AlertService _alertService = locator<AlertService>();
    final RMQService _rmqService = locator<RMQService>();
    final sendSurvey = sendAbsenToJson(surveyData);
    _alertService.showSuccess(
      context,
      'Success',
      'Data Survey Berhasil Di kirim 🙂',
          () {
        _navigationService.replaceTo(DashboardRoute);
      },
    );
    _rmqService.publish(sendSurvey);

  }
}








//
// class ListContentLocalWidget extends StatelessWidget {
//   const ListContentLocalWidget({
//     Key key,
//     @required this.date,
//     @required this.address,
//     @required this.content,
//     @required this.imageUrl,
//     @required this.name,
//     @required this.imageLocal,
//     this.checkImage,
//     @required this.status,
//     @required this.networkstatus,
//     this.img,
//   }) : super(key: key);
//
//   final String date;
//   final String content;
//   final String address;
//   final String name;
//   final String imageUrl;
//   final String imageLocal;
//   final String checkImage;
//   final String status;
//   final String networkstatus;
//   final bool img;
//   Future<bool> checkimageAssets() async {
//     if (await rootBundle.loadString('${imageLocal}') != null) {
//       return true;
//     } else {
//       return false;
//     }
//   }
//
//   Future<bool> checkImageExternal() async {
//     if (await File(imageLocal).exists()) {
//       print("File exists");
//       return true;
//     } else {
//       print("File don't exists");
//       return false;
//     }
//   }
//
//   Widget _BuildImage(BuildContext context) {
//     // print("data image $imageLocal");
//     // if (checkImageExternal != true) {
//     //   print("object true");
//
//     //   print("ini ada data local");
//     // } else {
//     //   CachedNetworkImage(
//     //     placeholder: (context, url) => CircularProgressIndicator(),
//     //     imageUrl: imageUrl,
//     //     fit: BoxFit.cover,
//     //     width: 250,
//     //     height: 250,
//     //   );
//
//     //   print("ini ambil dari internet");
//     //   print(imageUrl);
//     // }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       color: white,
//       // height: 300,
//       height: screenHeightFraction(
//         context,
//         dividedBy: 3,
//       ),
//       width: screenWidthPercent(
//         context,
//         multipleBy: 0.95,
//       ),
//       child: Card(
//         elevation: 5,
//         color: white,
//         child: Row(
//           children: <Widget>[
//             AspectRatio(
//                 aspectRatio: 5 / 6,
//                 child: Image.file(
//                   File(imageLocal),
//                   fit: BoxFit.cover,
//                   width: 250,
//                   height: 250,
//                 )
//                 // child: Image.network(
//                 //   imageUrl,
//                 //   // fit: BoxFit.cover,
//                 //   width: 250,
//                 //   height: 250,
//                 // ),
//                 ),
//             Flexible(
//               child: Container(
//                 padding: EdgeInsets.only(
//                   top: 8.0,
//                   left: 8.0,
//                 ),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: <Widget>[
//                     Flexible(
//                       child: Text(
//                         date,
//                         style: homeNameTextStyle,
//                       ),
//                     ),
//                     verticalSpaceSmall,
//                     Flexible(
//                       child: Text(
//                         '$content',
//                         style: homeContentTextStyle,
//                         maxLines: 2,
//                         overflow: TextOverflow.ellipsis,
//                       ),
//                     ),
// //                    verticalSpaceSmall,
// //                    Text(
// //                      '$address',
// //                      style: homeContentTextStyle,
// //                      maxLines: 4,
// //                      overflow: TextOverflow.ellipsis,
// //                    ),
//                     verticalSpaceSmall,
//                     Flexible(
//                       child: Text(
//                         '$name',
//                         style: homeNameTextStyle,
//                       ),
//                     ),
//                     Flexible(
//                       child: Text(
//                         'Network Status:${networkstatus}',
//                         style: homeNameTextStyle,
//                       ),
//                     ),
//
//                     Flexible(
//                       child: Text(
//                         '$status',
//                         style: homeNameTextStyle,
//                       ),
//                     ),
//                       SizedBox(height: 10,),
//                     Flexible(child:ButtonWidget(
//                       title:'Resend',
//                       onPressedFunction: () {
//                         // model.loginAccount(context);
//                       },
//
//                     ),
//                     //
//                     ),
//                     SizedBox(height: 10,),
//                     Flexible(child:ButtonWidget(
//                       title:'Hapus',
//                       onPressedFunction: () {
//                         // model.loginAccount(context);
//                       },
//
//                     ),
//                       //
//                     ),
//                     // SizedBox(height: 10,),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
