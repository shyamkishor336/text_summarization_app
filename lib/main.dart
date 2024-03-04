import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:sizer/sizer.dart';
import 'package:text_summarize/homepage.dart';

import 'core/app_theme.dart';

void main() {
  EasyLoading.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, orientation, deviceType) => MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Text Summarization',
        theme: AppThemes.appThemeData[AppTheme.lightTheme],
        themeMode: ThemeMode.light,
        home: Builder(builder: (context) {
          return HomePage();
        }),
        builder: EasyLoading.init(),
      ),
    );
  }
}
