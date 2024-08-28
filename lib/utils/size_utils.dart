import 'package:flutter/cupertino.dart';

Size size =
    WidgetsBinding.instance.platformDispatcher.views.first.physicalSize /
        WidgetsBinding.instance.platformDispatcher.views.first.devicePixelRatio;

num statusBar = MediaQueryData.fromView(
        WidgetsBinding.instance.platformDispatcher.views.first)
    .viewPadding
    .top;
num bottomBar = MediaQueryData.fromView(
        WidgetsBinding.instance.platformDispatcher.views.first)
    .viewPadding
    .bottom;

get height {
  num statusBar = MediaQueryData.fromView(
          WidgetsBinding.instance.platformDispatcher.views.first)
      .viewPadding
      .top;
  num bottomBar = MediaQueryData.fromView(
          WidgetsBinding.instance.platformDispatcher.views.first)
      .viewPadding
      .bottom;
  num screenHeight = size.height - statusBar - bottomBar;
  return screenHeight;
}

get width {
  return size.width;
}

double getHorizontalSize(double px) {
  return ((px * width) / width);
}

///This method is used to set padding/margin (for the top and bottom side) & height of the screen or widget according to the Viewport height.
double getVerticalSize(double px) {
  return ((px * height) / (height - statusBar));
}

double horizontalRation(double persentage) {
  return size.width * persentage;
}

///This method is used to set smallest px in image height and width
double getSize(double px) {
  var height = getVerticalSize(px);
  var width = getHorizontalSize(px);
  if (height < width) {
    return height.toInt().toDouble();
  } else {
    return width.toInt().toDouble();
  }
}

///This method is used to set text font size according to Viewport
double getFontSize(double px) {
  return getSize(px);
}

double statusBarSize() {
  return MediaQueryData.fromView(
          WidgetsBinding.instance.platformDispatcher.views.first)
      .viewPadding
      .top;
}

double systemNavigationBarSize() {
  return MediaQueryData.fromView(
          WidgetsBinding.instance.platformDispatcher.views.first)
      .viewPadding
      .bottom;
}

///This method is used to set padding responsively
EdgeInsetsGeometry getPadding({
  double? all,
  double? left,
  double? top,
  double? right,
  double? bottom,
}) {
  return getMarginOrPadding(
    all: all,
    left: left,
    top: top,
    right: right,
    bottom: bottom,
  );
}

///This method is used to set margin responsively
EdgeInsetsGeometry getMargin({
  double? all,
  double? left,
  double? top,
  double? right,
  double? bottom,
}) {
  return getMarginOrPadding(
    all: all,
    left: left,
    top: top,
    right: right,
    bottom: bottom,
  );
}

///This method is used to get padding or margin responsively
EdgeInsetsGeometry getMarginOrPadding({
  double? all,
  double? left,
  double? top,
  double? right,
  double? bottom,
}) {
  if (all != null) {
    left = all;
    top = all;
    right = all;
    bottom = all;
  }
  return EdgeInsets.only(
    left: getHorizontalSize(
      left ?? 0,
    ),
    top: getVerticalSize(
      top ?? 0,
    ),
    right: getHorizontalSize(
      right ?? 0,
    ),
    bottom: getVerticalSize(
      bottom ?? 0,
    ),
  );
}
