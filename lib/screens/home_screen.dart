// ignore_for_file: prefer_const_constructors
import 'dart:async';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
// import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/src/provider.dart';

import '../helpers/Icons.dart';
import '../main.dart';
import '../screens/settings_screen.dart';
// import '../widgets/admob_service.dart';
import '../widgets/admob_service.dart';
import '../widgets/no_internet.dart';
import '../provider/navigationBarProvider.dart';
import '../widgets/no_internet_widget.dart';
import '../helpers/Constant.dart';
import '../widgets/load_web_view.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;
  late AnimationController navigationContainerAnimationController =
      AnimationController(
          vsync: this, duration: const Duration(milliseconds: 500));
  @override
  void initState() {
    super.initState();

    Future.delayed(Duration.zero, () {
      context
          .read<NavigationBarProvider>()
          .setAnimationController(navigationContainerAnimationController);
    });
  }

  @override
  void dispose() {
    navigationContainerAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (Platform.isIOS) {
      SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarBrightness: Brightness.dark,
      ));
    }
    return SafeArea(
      top: Platform.isIOS ? false : true,
      child: Scaffold(
          bottomNavigationBar: displayAd(),
          // extendBody: true,
          // backgroundColor: Theme.of(context).cardColor,
          body: LoadWebView(webinitialUrl, true),
          floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
          floatingActionButton: FadeTransition(
              opacity: Tween<double>(begin: 1.0, end: 0.0).animate(
                  CurvedAnimation(
                      parent: navigationContainerAnimationController,
                      curve: Curves.easeInOut)),
              child: SlideTransition(
                  position: Tween<Offset>(
                          begin: Offset.zero, end: const Offset(0.0, 1.0))
                      .animate(CurvedAnimation(
                          parent: navigationContainerAnimationController,
                          curve: Curves.easeInOut)),
                  child: Container(
                    padding: EdgeInsets.all(10),
                    child: FloatingActionButton(
                      child: Lottie.asset(
                        Theme.of(context).colorScheme.settingsIcon,
                        height: 30,
                        repeat: true,
                      ),
                      onPressed: () {
                        // setState(() {
                        navigatorKey.currentState!.pushNamed('settings');
                        // });
                      },
                    ),
                  )))),
    );
  }

  Widget displayAd() {
    if (showBannerAds) {
      return Container(
        height: 50.0,
        width: double.maxFinite,
        child: AdWidget(
            key: UniqueKey(), ad: AdMobService.createBannerAd()..load()),
      );
    } else
      return SizedBox.shrink();
  }
}
