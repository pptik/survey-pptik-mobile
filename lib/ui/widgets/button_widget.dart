import 'package:surveypptik/ui/shared/shared_style.dart';
import 'package:surveypptik/ui/shared/ui_helper.dart';
import 'package:flutter/material.dart';

class ButtonWidget extends StatelessWidget {
  final String title;
  final Function onPressedFunction;

  const ButtonWidget(
      {Key key, @required this.title, @required this.onPressedFunction})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: fieldPadding,
      width: screenWidthPercent(
        context,
        multipleBy: 0.9,
      ),
      height: fieldHeight,
      child: RaisedButton(
        onPressed: onPressedFunction,
        child: Text(
          '$title',
          style: textButtonTextStyle,
        ),
      ),
    );
  }
}
