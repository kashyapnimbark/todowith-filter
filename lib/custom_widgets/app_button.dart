import 'package:flutter/material.dart';
import '../constants/app_color.dart';
import '../utils/size_utils.dart';

class AppButton extends StatelessWidget {
  final String? buttonText;
  final void Function()? onTap;
  final Widget? child;
  final Color? color;
  final Color? borderColor;
  final Color? textColor;
  final TextStyle? textStyle;
  final BorderRadiusGeometry? borderRadius;
  final double? fontSize;
  final double? height;
  final double? width;
  final bool? isBorder;
  final EdgeInsetsGeometry? padding;

  final double? borderWidth;

  const AppButton(
      {super.key,
      this.buttonText,
      required this.onTap,
      this.child,
      this.color,
      this.borderColor,
      this.textColor,
      this.textStyle,
      this.borderRadius,
      this.fontSize,
      this.height,
      this.isBorder = false,
      this.borderWidth,
      this.padding,
      this.width});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: width,
        height: height ?? getVerticalSize(46),
        padding: padding,
        decoration: BoxDecoration(
            color: color ?? AppColors.buttonBgColor,
            borderRadius: borderRadius ?? BorderRadius.circular(5),
            border: Border.all(
                style: isBorder! ? BorderStyle.solid : BorderStyle.none,
                color: borderColor ?? Colors.black,
                width: borderWidth ?? 0)),
        child: Center(
          child: child ??
              Text(
                buttonText!,
                style: textStyle ??
                    TextStyle(
                        color: textColor ?? AppColors.white,
                        fontSize: fontSize ?? getFontSize(17),
                        fontWeight: FontWeight.bold),
              ),
        ),
      ),
    );
  }
}
