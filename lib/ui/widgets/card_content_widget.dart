import 'package:surveypptik/ui/shared/shared_style.dart';
import 'package:surveypptik/ui/shared/ui_helper.dart';
import 'package:flutter/material.dart';

class CardContentWidget extends StatelessWidget {
  final String content;
  final IconData icon;

  const CardContentWidget({
    Key key,
    @required this.content,
    @required this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(12.0),
            decoration: BoxDecoration(
              color: Colors.grey[850],
              borderRadius: BorderRadius.circular(
                15.0,
              ),
            ),
            child: Icon(
              icon,
              size: 25.0,
            ),
          ),
          horizontalSpaceMedium,
          Text(
            '$content',
            style: cardContentTextStyle,
          )
        ],
      ),
    );
  }
}
