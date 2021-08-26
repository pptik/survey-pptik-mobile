import 'dart:io';

import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:surveypptik/constants/const.dart';
import 'package:surveypptik/ui/shared/colors_helper.dart';
import 'package:surveypptik/ui/shared/rounded_bordered_container.dart';
import 'package:surveypptik/ui/shared/shared_style.dart';
import 'package:surveypptik/ui/shared/ui_helper.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:surveypptik/ui/views/preview_view.dart';
import 'package:surveypptik/ui/widgets/button_widget.dart';
class ListContentWidget extends StatelessWidget {
  const ListContentWidget({
    Key key,
    @required this.date,
    @required this.address,
    @required this.content,
    @required this.imageUrl,
    @required this.name,
    @required this.networkstatus,
    @required this.imageLocal,
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
  final String networkstatus;
  final Function detailFunction;
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
              child:PreviewImageScreen(imagePath:imageUrl,)
          );
        });
  }
  @override
  Widget build(BuildContext context) {
    return RoundedContainer(
      padding: const EdgeInsets.all(0),
      margin: EdgeInsets.all(5),
      elevation: 1,
      height: 300,
      child: Row(
        children: <Widget>[
          InkWell(
            // onTap: ()=>data(context),
            child: Container(
              width: 140,
              decoration: BoxDecoration(
                  image: DecorationImage(
                    image: img==true?FileImage(File(imageLocal)):NetworkImage(imageUrl),
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
                  SizedBox(height: 24,),
                  SizedBox(height: 10,),
                  Text(
                    "Network Status:$networkstatus",
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: Colors.black),
                  ),
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

                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Resend(BuildContext context) {

  }
}




// class ListContentWidget extends StatelessWidget {
//   const ListContentWidget({
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
//   final bool img;
//   final String networkstatus;
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
//       height: screenHeightFraction(
//         context,
//         dividedBy: 4,
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
//               aspectRatio: 5 / 6,
//
//               // child: Image.file(
//               //   File(imageUrl),
//               //   fit: BoxFit.cover,
//               //   width: 250,
//               //   height: 250,
//               // )
//               child: Image.network(
//                 imageUrl,
//                 // fit: BoxFit.cover,
//                 width: 250,
//                 height: 250,
//               ),
//             ),
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
//                         style: homeDateTextStyle,
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
//                     verticalSpaceSmall,
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
