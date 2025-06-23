import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:hikkingapp/constant/app_color.dart';
import 'package:hikkingapp/constant/theme.dart';
import 'package:hikkingapp/constant/font.dart';
import 'package:hikkingapp/constant/size.utils.dart';

class LoginCustomDropdown extends StatelessWidget {
  final String? value;
  final List<String> items;
  final String title;
  final String? hint;
  final bool required;
  final ValueChanged<String?>? onChanged;
  final String? Function(String?)? validator;
  final double bottomMargin;
  final double borderRadius;
  final TextEditingController? controller;

  const LoginCustomDropdown({
    super.key,
    required this.value,
    required this.items,
    required this.title,
    this.required = false,
    this.hint,
    this.onChanged,
    this.validator,
    this.bottomMargin = 10,
    this.borderRadius = 15,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: bottomMargin),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title.isNotEmpty)
            Padding(
              padding: EdgeInsets.only(bottom: 10.hp),
              child: RichText(
                text: TextSpan(
                  text: title,
                  style: const TextStyle(
                    fontFamily: Fonts.poppin,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    color: CustomTheme.lightTextColor,
                  ),
                ),
              ),
            ),
          DropdownButtonFormField2<String>(
            isExpanded: true,
            value: value,
            decoration: InputDecoration(
              isDense: true,
              contentPadding: EdgeInsets.symmetric(
                vertical: 18.hp,
                horizontal: CustomTheme.symmetricHozPadding,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(borderRadius),
                borderSide: const BorderSide(color: CustomTheme.gray),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(borderRadius),
                borderSide: const BorderSide(color: CustomTheme.gray),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(borderRadius),
                borderSide: BorderSide(
                  color: CustomTheme.gray,
                ),
              ),
            ),
            style: const TextStyle(
              fontFamily: Fonts.poppin,
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: CustomTheme.lightTextColor,
            ),
            hint: Text(
              hint ?? "Select",
              style: const TextStyle(
                fontFamily: Fonts.poppin,
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: CustomTheme.gray,
              ),
            ),
            iconStyleData: const IconStyleData(
              icon: Icon(Icons.keyboard_arrow_down_rounded),
              iconSize: 24,
              iconEnabledColor: CustomTheme.gray,
            ),
            items: items
                .map((item) => DropdownMenuItem<String>(
                      value: item,
                      child: Text(item),
                    ))
                .toList(),
            onChanged: onChanged,
            validator: validator,
            dropdownStyleData: DropdownStyleData(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(borderRadius),
              ),
              offset: const Offset(0, 0),
              maxHeight: 200,
            ),
          ),
        ],
      ),
    );
  }
}
