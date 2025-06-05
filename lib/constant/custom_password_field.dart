import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hikkingapp/constant/custom_textfield.dart';
import 'package:hikkingapp/constant/text_field_type.dart';

class CustomPasswordField extends StatefulWidget {
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmited;
  final String hintText;
  final TextFieldType type;
  final String title;
  final bool required;
  final EdgeInsets? margin;
  final TextInputType textInputType;
  final int? maxLength;
  final double bottomMargin;
  final double horizontalMargin;
  final AutovalidateMode? autovalidateMode;
  final bool? enabled;
  final FormFieldSetter<String>? onSaved;
  final FormFieldValidator<String>? validator;
  final Widget? leading;
  final Widget? trailing;
  final VoidCallback? onTap;
  final Widget? prefix;
  final double borderRadius;
  final List<TextInputFormatter>? inputFormatters;
  final TextInputAction textInputAction;
  const CustomPasswordField({
    Key? key,
    this.autovalidateMode,
    this.borderRadius = 15,
    this.bottomMargin = 10,
    this.controller,
    this.enabled,
    this.hintText = "",
    this.horizontalMargin = 0,
    this.inputFormatters,
    this.leading,
    this.margin,
    this.maxLength,
    this.onChanged,
    this.onSaved,
    this.onSubmited,
    this.onTap,
    this.prefix,
    this.required = false,
    this.textInputType = TextInputType.text,
    required this.title,
    this.trailing,
    this.type = TextFieldType.Outline,
    this.validator,
    this.textInputAction = TextInputAction.done,
  }) : super(key: key);

  @override
  State<CustomPasswordField> createState() => _CustomPasswordFieldState();
}

class _CustomPasswordFieldState extends State<CustomPasswordField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return CustomTextField(
      autovalidateMode: widget.autovalidateMode,
      borderRadius: widget.borderRadius,
      bottomMargin: widget.bottomMargin,
      controller: widget.controller,
      obscureText: _obscureText,
      hintText: widget.hintText,
      horizontalMargin: widget.horizontalMargin,
      inputFormatters: widget.inputFormatters,
      margin: widget.margin,
      onSaved: widget.onSaved,
      enabled: widget.enabled,
      leading: widget.leading,
      maxLength: widget.maxLength,
      onChanged: widget.onChanged,
      onSubmited: widget.onSubmited,
      onTap: widget.onTap,
      prefix: widget.prefix,
      required: widget.required,
      textInputType: widget.textInputType,
      title: widget.title,
      trailing: widget.trailing,
      type: widget.type,
      validator: widget.validator,
      textInputAction: widget.textInputAction,
      showSearchIcon: true,
      suffixIcon: _obscureText
          ? Icons.visibility_rounded
          : Icons.visibility_off_rounded,
      suffixIconSize: 26,
      onSuffixPressed: () {
        setState(() {
          _obscureText = !_obscureText;
        });
      },
    );
  }
}
