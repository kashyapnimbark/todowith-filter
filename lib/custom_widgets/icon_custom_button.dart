


import 'package:flutter/material.dart';
import 'package:kashyap/utils/size_utils.dart';

class IconCustomButton {
  final String? text;
  final Icon? icon;
  final Color color;

  const IconCustomButton({
    this.text,
    this.icon,
    required this.color,
  });
}

Widget buildChildWithIcon(IconCustomButton iconCustomButton, double iconPadding,
    TextStyle textStyle) {
  return buildChildWithIC(
      iconCustomButton.text, iconCustomButton.icon, iconPadding, textStyle);
}

Widget buildChildWithIC(
    String? text, Icon? icon, double gap, TextStyle textStyle) {
  var children = <Widget>[];
  children.add(icon ?? Container());
  if (text != null) {
    children.add(Padding(padding: getPadding(all: gap)));
    children.add(buildText(text, textStyle));
  }

  return Wrap(
    direction: Axis.horizontal,
    crossAxisAlignment: WrapCrossAlignment.center,
    children: children,
  );
}

Widget buildText(String text, TextStyle style) {
  return Text(text, style: style);
}
