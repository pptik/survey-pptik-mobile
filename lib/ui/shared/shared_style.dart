import 'package:surveypptik/ui/shared/colors_helper.dart';
import 'package:flutter/material.dart';

// Box Decorations
BoxDecoration fieldDecortaion = BoxDecoration(
  borderRadius: BorderRadius.circular(5),
  color: Colors.grey[200],
);

BoxDecoration disabledFieldDecortaion = BoxDecoration(
    borderRadius: BorderRadius.circular(5), color: Colors.grey[100]);

// Field Variables

const double fieldHeight = 55;
const double smallFieldHeight = 40;
const double inputFieldBottomMargin = 30;
const double inputFieldSmallBottomMargin = 0;
const EdgeInsets fieldPadding = const EdgeInsets.symmetric(horizontal: 15);
const EdgeInsets largeFieldPadding =
    const EdgeInsets.symmetric(horizontal: 15, vertical: 15);

// Text Variables
const TextStyle buttonTitleTextStyle =
    const TextStyle(fontWeight: FontWeight.w700, color: Colors.white);

// Text Styles
const TextStyle titleTextStyle = const TextStyle(
  fontSize: 32.0,
  fontWeight: FontWeight.w700,
  letterSpacing: 1.5,
);

const TextStyle textButtonTextStyle = const TextStyle(
  fontSize: 18.0,
  fontWeight: FontWeight.bold,
  letterSpacing: 1.5,
);

const TextStyle profileTextStyle = const TextStyle(
  fontSize: 20.0,
  fontWeight: FontWeight.w400,
);

const TextStyle cardTitleTextStyle = const TextStyle(
  fontSize: 18.0,
  fontWeight: FontWeight.w400,
);

const TextStyle cardTitleYellowTextStyle = const TextStyle(
  fontSize: 18.0,
  fontWeight: FontWeight.w400,
  color: Colors.yellowAccent,
);

const TextStyle cardContentTextStyle = const TextStyle(
  fontSize: 15.0,
  fontWeight: FontWeight.w300,
);

// home view
const TextStyle homeDateTextStyle = const TextStyle(
  fontSize: 16.0,
  color: text_little,
  fontWeight: FontWeight.bold,
);

const TextStyle homeContentTextStyle = const TextStyle(
  fontSize: 14.0,
  color: text_little,
  fontWeight: FontWeight.w300,
);

const TextStyle homeNameTextStyle = const TextStyle(
  fontSize: 14.0,
  color: text_little,  
  fontWeight: FontWeight.bold,
);
const TextStyle absenContentTextStyle = const TextStyle(
  fontSize: 17.0,
  fontWeight: FontWeight.w300,
);

const TextStyle absenNameTextStyle = const TextStyle(
  fontSize: 17.0,
  fontWeight: FontWeight.bold,
);

const TextStyle titleQuestionerStyle = const TextStyle(
  fontSize:25.0,
  fontWeight: FontWeight.bold,
);
