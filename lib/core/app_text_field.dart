import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:styled_widget/styled_widget.dart';
import 'package:text_summarize/core/typography.dart';

enum BorderStyle { underline, circular }

class AppTextField extends StatefulWidget {
  final FormFieldValidator<String>? validator;
  final TextInputType textInputType;
  final EdgeInsets contentPadding;
  final String? hintText;
  final String? labelText;
  final Widget? prefixWidget;
  final Widget? suffixWidget;
  final bool obscureText;
  final double decorationRadius;
  final bool isDense;
  final int maxLength;
  final int maxLine;
  final Key? key1;
  final bool digitsOnly;
  final Color? labelColor;
  final Color fillColor;
  final String prefixText;
  final bool readOnly;
  final TextInputAction textInputAction;
  final bool enableFocusBorder;
  final ValueChanged<String>? onChanged;
  final TextCapitalization textCapitalization;
  final TextEditingController controller;
  final Color? textColor;
  final VoidCallback? onTap;
  final String? initialValue;
  final Function? onSend;
  final double bottomPadding;
  final bool hasText;

  const AppTextField({
    super.key,
    this.validator,
    this.obscureText = false,
    this.decorationRadius = 40,
    this.textCapitalization = TextCapitalization.none,
    this.digitsOnly = false,
    required this.controller,
    this.textInputType = TextInputType.text,
    this.contentPadding = const EdgeInsets.only(left: 24, top: 16, bottom: 16),
    this.prefixWidget,
    this.suffixWidget,
    this.hintText = '',
    this.textInputAction = TextInputAction.next,
    this.maxLength = 50,
    this.enableFocusBorder = true,
    this.onChanged,
    this.textColor,
    this.prefixText = '',
    this.labelColor,
    this.labelText,
    this.readOnly = false,
    this.maxLine = 1,
    this.key1,
    this.onTap,
    this.initialValue,
    this.isDense = false,
    this.onSend,
    this.bottomPadding = 12,
    this.fillColor = Colors.white,
    this.hasText = false,
  });

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  late bool isPasswordInVisible;

  @override
  void initState() {
    isPasswordInVisible = widget.obscureText;
    super.initState();
  }

  @override
  Widget build(BuildContext context) => TextFormField(
        key: widget.key1,
        readOnly: widget.hasText ? true : widget.readOnly,
        cursorColor: widget.textColor,
        validator: widget.validator,
        obscureText: isPasswordInVisible,
        textCapitalization: widget.textCapitalization,
        textInputAction: widget.textInputAction,
        controller:
            widget.hasText ? TextEditingController() : widget.controller,
        onChanged: widget.onChanged,
        initialValue: widget.initialValue,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        maxLines: widget.maxLine,
        onTap: widget.onTap,
        onFieldSubmitted: (value) => widget.onSend?.call(value),
        inputFormatters: widget.digitsOnly
            ? <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(widget.maxLength),
              ]
            : [],
        keyboardType: widget.textInputType,
        decoration: InputDecoration(
          isDense: widget.isDense,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(
                Radius.circular(widget.hasText ? 8 : widget.decorationRadius)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(
                Radius.circular(widget.hasText ? 8 : widget.decorationRadius)),
            borderSide: BorderSide(color: Colors.black54),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(
                Radius.circular(widget.hasText ? 8 : widget.decorationRadius)),
            borderSide: BorderSide(color: Colors.red),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(
                Radius.circular(widget.hasText ? 8 : widget.decorationRadius)),
            borderSide: BorderSide(color: Colors.black54),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(
                Radius.circular(widget.hasText ? 8 : widget.decorationRadius)),
            borderSide: BorderSide(color: Colors.red),
          ),
          suffixIcon: widget.suffixWidget ??
              (widget.obscureText
                  ? (isPasswordInVisible
                      ? GestureDetector(
                          onTap: () {
                            setState(() {
                              isPasswordInVisible = false;
                            });
                          },
                          child: const Icon(
                            Icons.visibility_off_outlined,
                            color: Colors.grey,
                          ),
                        ).padding(right: 24)
                      : GestureDetector(
                          onTap: () {
                            setState(() {
                              isPasswordInVisible = true;
                            });
                          },
                          child: const Icon(
                            Icons.visibility_outlined,
                            color: Colors.grey,
                          ),
                        ).padding(right: 24))
                  : const SizedBox()),
          prefixIcon: widget.hasText
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      widget.hintText ?? '',
                      style: AppTextStyle.bodySMRegular
                          .copyWith(fontWeight: FontWeight.w500),
                    ),
                    Text(
                      widget.controller.text,
                      style: AppTextStyle.bodyMDRegular
                          .copyWith(color: Colors.grey),
                    )
                  ],
                ).padding(left: 24, top: 3)
              : widget.prefixWidget,
          filled: true,
          prefixText: widget.prefixText,
          fillColor: widget.fillColor,
          errorStyle: AppTextStyle.bodySMRegular.copyWith(
            color: Colors.red,
          ),
          labelStyle: AppTextStyle.bodySMRegular.copyWith(
            color: Colors.grey,
          ),
          contentPadding: widget.hasText
              ? const EdgeInsets.only(left: 24, top: 20, bottom: 20)
              : widget.contentPadding,
          labelText: widget.labelText,
          hintText: widget.hasText ? '' : widget.hintText,
          hintStyle: AppTextStyle.bodySMRegular.copyWith(
            color: Colors.grey,
          ),
        ),
        style: AppTextStyle.bodyMDRegular,
      ).padding(bottom: widget.bottomPadding);
}
