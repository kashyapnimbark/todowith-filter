import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:kashyap/utils/navigator_service.dart';

import '../constants/app_color.dart';
import '../utils/size_utils.dart';

customDialog({
  required BuildContext context,
  required Widget child,
  Color? backGroundColor,
  bool? barrierDismissible,
  double? padding,
  double? maxWidth,
  Future<bool> Function()? onWillPop,
}) {
  return showGeneralDialog(
    barrierColor: Colors.black.withOpacity(0.4),
    transitionBuilder: (context, a1, a2, widget) {
// Adjust the blur factor as needed
      return Stack(
        children: [
          // Background with blur effect
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
            child: GestureDetector(
              onTap: () {
                NavigatorService.goBack();
              },
              child: Container(
                color: Colors.transparent,
              ),
            ),
          ),
          // Dialog
          SafeArea(
            child: Transform.scale(
              scale: a1.value,
              child: Padding(
                padding: getPadding(all: 20),
                child: Dialog(
                  elevation: 0,
                  surfaceTintColor: AppColors.brickButtonBG,
                  insetPadding: EdgeInsets.symmetric(
                    horizontal: getHorizontalSize(padding ?? 20),
                    vertical: getHorizontalSize(padding ?? 20),
                  ),
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20.0)),
                  ),
                  backgroundColor: backGroundColor ?? AppColors.brickButtonBG,
                  child: Container(
                    constraints: BoxConstraints(maxWidth: maxWidth ?? 400),
                    child: child,
                  ),
                ),
              ),
            ),
          ),
        ],
      );
    },
    transitionDuration: const Duration(milliseconds: 200),
    barrierDismissible: barrierDismissible ?? true,
    barrierLabel: '',
    context: context,
    pageBuilder: (context, animation1, animation2) {
      return const SizedBox();
    },
  );
}

customAlert(
    {required BuildContext context,
    Widget? title,
    Widget? content,
    Widget? cancelWidget,
    Widget? confirmWidget,
    Color? backGroundColor,
    bool? barrierDismissible,
    String? cancelButtonTExt,
    String? confirmButtonText,
    bool? isCenterAction = true,
    VoidCallback? onSubmit,
    Future<bool> Function()? onWillPop}) {
  return showGeneralDialog(
      barrierColor: Colors.black.withOpacity(0.4),
      transitionBuilder: (context, a1, a2, widget) {
        return Transform.scale(
          scale: a1.value,
          child: AlertDialog(
            actionsPadding: getPadding(bottom: 10, right: 20, left: 20),
            contentPadding: getPadding(right: 20, left: 20, top: 15),
            title: title,
            content: SizedBox(width: double.infinity, child: content),
            actionsAlignment:
                isCenterAction! ? MainAxisAlignment.spaceEvenly : null,
            actions: <Widget>[
              cancelWidget ??
                  FilledButton(
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(AppColors.sectionText)),
                    onPressed: () => NavigatorService.goBack(),
                    child: Text(
                      cancelButtonTExt ?? 'Cancel',
                      style: TextStyle(color: AppColors.white),
                    ),
                  ),
              confirmWidget ??
                  FilledButton(
                    style: ButtonStyle(
                        backgroundColor:
                            WidgetStateProperty.all(AppColors.sectionText)),
                    onPressed: onSubmit,
                    child: Text(
                      confirmButtonText ?? 'Yes',
                      style: TextStyle(color: AppColors.white),
                    ),
                  ),
            ],
          ),
        );
      },
      transitionDuration: const Duration(milliseconds: 200),
      barrierDismissible: barrierDismissible ?? true,
      barrierLabel: '',
      context: context,
      pageBuilder: (context, animation1, animation2) {
        return const SizedBox();
      });
}
