import 'dart:io';

import 'package:flutter/services.dart';
import 'package:surveypptik/ui/shared/colors_helper.dart';
import 'package:surveypptik/ui/shared/shared_style.dart';
import 'package:surveypptik/ui/shared/ui_helper.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ListContentWidget extends StatelessWidget {
  const ListContentWidget(
      {Key key,
      @required this.date,
      @required this.address,
      @required this.content,
      @required this.imageUrl,
      @required this.name,
      @required this.imageLocal,
      this.checkImage})
      : super(key: key);

  final String date;
  final String content;
  final String address;
  final String name;
  final String imageUrl;
  final String imageLocal;
  final String checkImage;
  Future<bool> checkimageAssets() async {
    if (await rootBundle.loadString('${imageLocal}') != null) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> checkImageExternal() async {
    if (await File(imageLocal).exists()) {
      print("File exists");
      return true;
    } else {
      print("File don't exists");
      return false;
    }
  }

  Widget _BuildImage(BuildContext context) {
    // print("data image $imageLocal");
    // if (checkImageExternal != true) {
    //   print("object true");

    //   print("ini ada data local");
    // } else {
    //   CachedNetworkImage(
    //     placeholder: (context, url) => CircularProgressIndicator(),
    //     imageUrl: imageUrl,
    //     fit: BoxFit.cover,
    //     width: 250,
    //     height: 250,
    //   );

    //   print("ini ambil dari internet");
    //   print(imageUrl);
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: white,
      height: screenHeightFraction(
        context,
        dividedBy: 4,
      ),
      width: screenWidthPercent(
        context,
        multipleBy: 0.95,
      ),
      child: Card(
        elevation: 5,
        color: white,
        child: Row(
          children: <Widget>[
            AspectRatio(
                aspectRatio: 5 / 6,
                child: Image.file(
                  File(imageLocal),
                  fit: BoxFit.cover,
                  width: 250,
                  height: 250,
                )),
            Flexible(
              child: Container(
                padding: EdgeInsets.only(
                  top: 8.0,
                  left: 8.0,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Flexible(
                      child: Text(
                        date,
                        style: homeDateTextStyle,
                      ),
                    ),
                    verticalSpaceSmall,
                    Flexible(
                      child: Text(
                        '$content',
                        style: homeContentTextStyle,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
//                    verticalSpaceSmall,
//                    Text(
//                      '$address',
//                      style: homeContentTextStyle,
//                      maxLines: 4,
//                      overflow: TextOverflow.ellipsis,
//                    ),
                    verticalSpaceSmall,
                    Flexible(
                      child: Text(
                        '$name',
                        style: homeNameTextStyle,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
