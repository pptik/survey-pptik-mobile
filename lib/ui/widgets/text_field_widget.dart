import 'package:surveypptik/ui/shared/shared_style.dart';
import 'package:surveypptik/ui/shared/ui_helper.dart';
import 'package:flutter/material.dart';

class TextFieldWidget extends StatelessWidget {
  final String hintText;
  final IconData icon;
  final TextEditingController textFieldController;
  final TextInputType keyboardType;
  final bool isPassword;

  const TextFieldWidget({
    Key key,
    @required this.hintText,
    @required this.icon,
    @required this.keyboardType,
    @required this.isPassword,
    this.textFieldController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: fieldPadding,
      width: screenWidthPercent(
        context,
        multipleBy: 0.9,
      ),
      height: fieldHeight,
      child: TextField(
        obscureText: isPassword,
        controller: textFieldController,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          prefixIcon: Icon(
            icon,
            color: Colors.white,
          ),
          hintText: '$hintText',
        ),
      ),
    );
  }
}
