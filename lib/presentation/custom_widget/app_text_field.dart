// ignore_for_file: must_be_immutable, overridden_fields, annotate_overrides

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppTextFiled extends StatefulWidget {
  TextEditingController controller;
  String hintText;
  String labeltext;
  String? valueToChange;
  bool? isPassword;
  Function(dynamic value)? onChanage;
  void Function()? onTap;
  String? Function(String?)? validator;
  TextInputType? keyboardType;
  EdgeInsets? scrollPadding;
  Widget? prefixIcon;
  Widget? suffixIcon;
  GlobalKey? key;
  AutovalidateMode? autovalidateMode;
  List<TextInputFormatter>? inputFormatters;
  int? maxLine;

  AppTextFiled({
    super.key,
    required this.controller,
    required this.hintText,
    required this.labeltext,
    this.onChanage,
    this.onTap,
    this.valueToChange,
    this.isPassword,
    this.validator,
    this.keyboardType,
    this.scrollPadding,
    this.prefixIcon,
    this.suffixIcon,
    this.autovalidateMode,
    this.inputFormatters,
    this.maxLine,
  });

  @override
  State<AppTextFiled> createState() => _AppTextFiledState();
}

class _AppTextFiledState extends State<AppTextFiled> {
  @override
  void initState() {
    if (widget.valueToChange != null) {
      widget.controller.text = widget.valueToChange!;
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      //height: 54,
      padding: const EdgeInsets.all(5),
      child: TextFormField(
        maxLines: widget.maxLine,
        autovalidateMode: widget.autovalidateMode,
        inputFormatters: widget.inputFormatters,
        scrollPadding: widget.scrollPadding ?? const EdgeInsets.all(20.0),
        onTap: widget.onTap,
        keyboardType: widget.keyboardType ?? TextInputType.text,
        controller: widget.controller,
        obscureText: widget.isPassword ?? false,
        validator: widget.validator,
        decoration: InputDecoration(
          // filled: true,
          // fillColor: const Color.fromARGB(255, 212, 106, 141),
          prefixIcon: widget.prefixIcon,
          suffixIcon: widget.suffixIcon,
          labelText: widget.labeltext,
          hintText: widget.hintText,
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(10),
            ),
          ),
        ),
      ),
    );
  }
}
