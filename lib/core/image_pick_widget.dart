import 'dart:io';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:styled_widget/styled_widget.dart';

class ImagePickWidget extends StatelessWidget {
  File? file;
  Widget? text;
  final VoidCallback onPressed;
  final VoidCallback? onCancel;

  ImagePickWidget(
      {super.key,
      this.file,
      required this.onPressed,
      this.onCancel,
      this.text});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 100.w,
      child: file != null
          ? Column(
            children: [
              Align(alignment: Alignment.centerRight, child: Icon(Icons.cancel).gestures(onTap: onCancel)),
            text??SizedBox()
            ],
          )
          : Image.asset(
            'assets/image/upload_image.png',
            height: 2.h,
          ).gestures(onTap: onPressed),
    );
  }
}
