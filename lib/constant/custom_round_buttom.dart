import 'package:flutter/material.dart';
import 'package:hikkingapp/constant/app_color.dart';
import 'package:hikkingapp/constant/theme.dart';
import 'package:hikkingapp/constant/size.utils.dart';

class CustomRoundedButtom extends StatefulWidget {
  const CustomRoundedButtom({
    Key? key,
    required this.title,
    required this.onPressed,
    this.isDisabled = false,
    this.isLoading = false,
    this.padding,
    this.color,
    this.horizontalPadding = 12,
    this.verticalPadding = 12,
    this.fontSize = 14,
    this.textColor = Colors.white,
    this.borderColor = Colors.white,
    this.fontWeight = FontWeight.w700,
    this.horizontalMargin = 0,
    this.icon,
    this.iconColor,
    this.verificationAmount,
  }) : super(key: key);
  final String title;
  final Function()? onPressed;
  final bool isDisabled;
  final bool isLoading;
  final Color? color;
  final EdgeInsets? padding;
  final double horizontalPadding;
  final double verticalPadding;
  final double fontSize;
  final Color? textColor;
  final FontWeight fontWeight;
  final double horizontalMargin;
  final IconData? icon;
  final Color? iconColor;
  final Color? borderColor;
  final String? verificationAmount;

  @override
  CustomRoundedButtomState createState() => CustomRoundedButtomState();
}

class CustomRoundedButtomState extends State<CustomRoundedButtom> {
  @override
  Widget build(BuildContext context) {
    final _theme = Theme.of(context);
    print(_theme.primaryColor);
    return Container(
      padding: EdgeInsets.symmetric(horizontal: widget.horizontalMargin),
      child: Material(
        color: widget.isDisabled
            ? CustomTheme.lightGray
            : (widget.color ?? _theme.primaryColor),
        borderRadius: BorderRadius.circular(15),
        child: InkWell(
          onTap: () {
            if (!widget.isDisabled && widget.onPressed != null) {
              widget.onPressed!(); // <-- call the function
            }
          },
          borderRadius: BorderRadius.circular(15),
          child: Container(
            padding: widget.padding ??
                EdgeInsets.symmetric(
                  vertical: widget.verticalPadding,
                  horizontal: widget.horizontalPadding,
                ),
            child: Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    widget.title,
                    style: _theme.textTheme.displaySmall!.copyWith(
                      fontWeight: widget.fontWeight,
                      color: widget.isDisabled
                          ? CustomTheme.gray
                          : widget.textColor,
                      fontSize: widget.fontSize,
                    ),
                  ),
                  if (widget.icon != null)
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 4.wp),
                      child: Icon(
                        widget.icon,
                        color: widget.iconColor ?? Colors.white,
                        size: 22,
                      ),
                    ),
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 350),
                    switchInCurve: Curves.easeOut,
                    switchOutCurve: Curves.easeOut,
                    child: widget.isLoading
                        ? Container(
                            height: 14,
                            width: 14,
                            margin: const EdgeInsets.only(left: 8),
                            child: const CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : Container(),
                  ),
                ],
              ),
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              border: widget.isDisabled
                  ? null
                  : Border.all(
                      color: widget.borderColor ?? CustomTheme.primaryColor,
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
