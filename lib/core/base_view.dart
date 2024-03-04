import 'package:flutter/material.dart';

class BaseView extends StatelessWidget {
  final Widget body;
  final String? titleText;
  final Color? appBarColor;
  final Color? color;
  final bool resizeToAvoidBottomInset;
  final PopInvokedCallback? onBackCallback;
  final List<Widget> actions;
  final EdgeInsets padding;
  final Widget? bottomSheet;
  final Widget? bottomNavigationBar;
  final Widget? leading;
  final Widget? titleWidget;
  final PreferredSizeWidget? bottomWidget;
  final double elevation;
  final bool automaticallyImplyLeading;
  final bool centerTitle;
  final bool extendBody;
  final Widget? floatingActionButton;
  final FloatingActionButtonLocation? floatingActionButtonLocation;

  const BaseView({
    super.key,
    this.automaticallyImplyLeading = true,
    this.titleText,
    required this.body,
    this.appBarColor,
    this.color,
    this.resizeToAvoidBottomInset = true,
    this.onBackCallback,
    this.bottomSheet,
    this.padding = const EdgeInsets.all(16),
    this.actions = const [],
    this.bottomNavigationBar,
    this.bottomWidget,
    this.elevation = 0,
    this.leading,
    this.floatingActionButton,
    this.titleWidget,
    this.centerTitle = true,
    this.floatingActionButtonLocation,
    this.extendBody = false,
  });

  @override
  Widget build(BuildContext context) => PopScope(
        onPopInvoked: onBackCallback,
        child: Scaffold(
          // backgroundColor: Color.fromARGB(255, 224, 224, 224),
          bottomNavigationBar: bottomNavigationBar,
          bottomSheet: bottomSheet,
          resizeToAvoidBottomInset: resizeToAvoidBottomInset,
          extendBodyBehindAppBar: true,
          extendBody: extendBody,
          appBar: toolbar(context),
          body:  body,
          floatingActionButton: floatingActionButton,
          floatingActionButtonLocation: floatingActionButtonLocation,
        ),
      );

  PreferredSize toolbar(BuildContext context) => PreferredSize(
        preferredSize: Size.fromHeight(bottomWidget != null
            ? 140.0
            : titleText != null
                ? 56.0
                : 0.0),
        child: AppBar(
          automaticallyImplyLeading: false,
          centerTitle: centerTitle,
          leading: leading ?? (automaticallyImplyLeading
                  ? Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: InkWell(
                        onTap: () => Navigator.pop(context),
                        child: const CircleAvatar(
                          backgroundColor: Color(0xff739EC1),
                          child: Icon(
                            Icons.chevron_left_rounded,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    )
                  : null),
          actions: actions,
          elevation: elevation,
          title: titleWidget ??
              Text(
                titleText ?? '',
                style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
              ),
          backgroundColor: appBarColor ?? Colors.transparent,
          bottom: bottomWidget,
        ),
      );
}
