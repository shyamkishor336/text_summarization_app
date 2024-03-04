import 'dart:io';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';
import 'package:sizer/sizer.dart';
import 'package:styled_widget/styled_widget.dart';
import 'package:text_summarize/core/app_colors.dart';
import 'package:text_summarize/core/app_text_field.dart';
import 'package:text_summarize/core/base_view.dart';
import 'package:text_summarize/core/typography.dart';
import 'core/app_image_picker.dart';


class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final textController = TextEditingController();
  String text = '';
  var percent='0';

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }
final baseUrl = 'https://c54e-49-126-78-155.ngrok-free.app';
// final baseUrl = 'http://127.0.0.1:8000';
  Future<String> getSummarizedText() async {
    final dio = Dio(BaseOptions(
      baseUrl:
      baseUrl,
    ));
    try {
      final response = await dio.get(
        '/summarize',
        queryParameters: {
          'text': textController.text.isNotEmpty ? textController.text : ''
        },
      );
      if (response.statusCode == 200) {
        percent = response.data['percent']??'0';
        return response.data['summary'];
      } else {
        EasyLoading.dismiss();
        return 'Something went wrong...';
      }
    } catch (e) {
      EasyLoading.dismiss();
      return 'Something went wrong...';
    }
  }

  //
  // // https://f2f2-2404-7c00-52-e74a-8c01-738-cd32-b04c.ngrok-free.app
  Future<String> getExtractedText() async {
    final dio = Dio(BaseOptions(
    baseUrl: baseUrl, contentType: 'multipart/form-data'));
    try {
      final mimeType = lookupMimeType(selectedImage!.name);
      final formData = FormData.fromMap({
        'file': MultipartFile.fromBytes(
          selectedImage!.bytes as List<int>,
          filename: selectedImage!.name,
          contentType:
              MediaType(mimeType!.split('/').first, mimeType.split('/').last),
        ),
      });
      final response = await dio.post('/extract', data: formData);
      if (response.statusCode == 200) {
        return response.data['text'].toString();
      } else {
        EasyLoading.dismiss();
        return 'Something went wrong...';
      }
    } catch (e) {
      EasyLoading.dismiss();
      // debugPrint(e.toString());
      return 'Something went wrong...';
    }
  }

  Future<String> getImageTotext(String imagePath) async {
    final textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);
    final RecognizedText recognizedText =
        await textRecognizer.processImage(InputImage.fromFilePath(imagePath));
    String text = recognizedText.text.toString();
    return text;
  }

  @override
  Widget build(BuildContext context) {
    final wd = MediaQuery.of(context).size.width;
    return BaseView(
      bottomNavigationBar: Container(
        height: 36,
        color: Colors.black87,child:
        Center(child: Text('Powered By: Shyam Kishor',style: AppTextStyle.bodyMDBold.copyWith(color: Colors.white),)),),
        body: SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 50,
            width: wd,
            color: Colors.black,
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Center(
                child: Text('TEXT SUMMARIZATION',
                    style: AppTextStyle.titleMDBold
                        .copyWith(color: Colors.white))),
          ),
          SizedBox(
            height: 16,
          ),
          Stack(
            children: [
              AppTextField(
                controller: textController,
                hintText: 'Your Text Here',
                contentPadding: const EdgeInsets.all(8),
                decorationRadius: 8,
                maxLine: 10,
              ).padding(horizontal: 16),
              if (kIsWeb)
                Positioned(
                    bottom: 16,
                    right: 24,
                    child: Container(
                      padding: EdgeInsets.all(4),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: Colors.black12),
                      child: Image.asset(
                        'assets/image/upload_image.png',
                        height: 4.h,
                      ).gestures(onTap: () async {
                        final pickedFile =
                            await AppImagePicker().pickWebImage();
                        if (pickedFile != null) {
                          EasyLoading.show(status: 'Extracting...');
                          selectedImage = pickedFile;
                          textController.text =
                              (await getExtractedText()).replaceAll('\n', ' ');
                          setState(() {
                            EasyLoading.dismiss();
                          });
                        }
                      }),
                    ))
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(colorPrimary)),
                  onPressed: () async {
                    if (textController.text.isNotEmpty) {
                      EasyLoading.show(
                          dismissOnTap: true, status: 'Summarizing...');
                      text = await getSummarizedText();
                      EasyLoading.dismiss();
                      setState(() {});
                    } else {
                      EasyLoading.showError('Please add some text');
                    }
                  },
                  child: Text(
                    'Summarize',
                    style: AppTextStyle.bodySMRegular
                        .copyWith(color: Colors.white),
                  )),
              if (!kIsWeb)
                Container(
                  padding: EdgeInsets.all(4),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.black12),
                  child: Image.asset(
                    'assets/image/upload_image.png',
                    height: 4.h,
                  ).gestures(onTap: () async {
                    final pickedFile = await AppImagePicker().pickSingleImage();
                    if (pickedFile != null) {
                      EasyLoading.show(
                          status: 'Extracting...', dismissOnTap: true);
                      selectedFile = pickedFile;
                      textController.text =
                          (await getImageTotext(selectedFile!.path))
                              .replaceAll('\n', ' ');
                      setState(
                        () {
                          EasyLoading.dismiss();
                        },
                      );
                    }
                  }),
                )
            ],
          ).padding(horizontal: 16),
          Text(
            text.isNotEmpty
                ? 'Summarized Output: $percent%'
                : 'Summarized Output:',
            style: AppTextStyle.bodyLgSemiBold,
          ).padding(left: 16),
          Text(
            text.replaceAll('\n', ' '),
            style: AppTextStyle.bodyMDRegular.copyWith(color: darkText),
          ).padding(all: 16),
        ],
      ),
    ));
  }

  File? selectedFile;
  PlatformFile? selectedImage;
}
