import 'package:flutter/material.dart';

import '../constants/app_color.dart';


class AppTextFieldWithLabel extends StatelessWidget {
  final String? labelText;
  final String? hintText;
  final int? maxLines;
  final int? minLines;
  final double? height;
  final double? width;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final Widget? suffixIcon;

  // final Widget? prefixIcon;
  final double? hintFontSize;
  final void Function(String)? onChanged;
  final TextInputAction? textInputAction;
  final bool? readOnly;
  final void Function()? onTap;
  final bool? obscureText;
  final bool? isError;
  final int? maxLength;
  final TextInputType? keyboardType;
  final Color? borderColor;
  final TextCapitalization? textCapitalization;
  final String? Function(String?)? validator;

  const AppTextFieldWithLabel({
    super.key,
    this.labelText,
    this.maxLength,
    this.maxLines,
    this.minLines,
    this.controller,
    this.focusNode,
    this.suffixIcon,
    // this.prefixIcon,
    this.hintText,
    this.hintFontSize,
    this.onChanged,
    this.height,
    this.width,
    this.borderColor,
    this.readOnly = false,
    this.isError = false,
    this.onTap,
    this.obscureText,
    this.textInputAction,
    this.textCapitalization,
    this.keyboardType,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          labelText ?? "",
          style: TextStyle(
              color: isError! ? Colors.red[900] : AppColors.textFieldText,
              fontSize: 17),
        ),
        const SizedBox(height: 5),
        SizedBox(
          height: height,
          width: width,
          child: TextFormField(
            maxLength: maxLength,
            //autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: validator,
            keyboardType: keyboardType,
            onTap: onTap,
            readOnly: readOnly!,
            minLines: minLines ?? 1,
            textCapitalization:
                textCapitalization ?? TextCapitalization.sentences,
            textInputAction: textInputAction,
            style: TextStyle(
              color:
                  AppColors.blackFont, /*decoration: TextDecoration.underline*/
            ),
            obscureText: obscureText ?? false,
            cursorColor: AppColors.textFieldBorder,
            maxLines: maxLines ?? 1,
            controller: controller,
            focusNode: focusNode,

            decoration: InputDecoration(
              suffixIcon: suffixIcon,
              // prefix: prefixIcon,
              contentPadding: const EdgeInsets.only(bottom: 0.0, top: 15.0),
              prefix: const Padding(padding: EdgeInsets.only(left: 20.0)),
              hintText: hintText,
              hintStyle: TextStyle(
                fontSize: hintFontSize ?? 14,
                fontWeight: FontWeight.normal,
              ),
              errorMaxLines: 3,

              // contentPadding: const EdgeInsets.symmetric(
              //   vertical: 5,
              //   horizontal: 15,
              // ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5),
                borderSide: BorderSide(
                  color: readOnly!
                      ? (borderColor == null)
                          ? AppColors.grey
                          : borderColor!
                      : AppColors.textFieldBorder,
                ),
              ),
              // errorBorder: const OutlineInputBorder(
              //   borderSide: BorderSide(width: 1, color: Colors.red),
              // ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5),
                borderSide: BorderSide(
                  color: readOnly!
                      ? (borderColor == null)
                          ? AppColors.grey
                          : borderColor!
                      : AppColors.textFieldBorder,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5),
                borderSide: BorderSide(
                  width: 1,
                  color: readOnly!
                      ? (borderColor == null)
                          ? AppColors.grey
                          : borderColor!
                      : AppColors.textFieldBorder,
                ),
              ),
            ),
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }
}
