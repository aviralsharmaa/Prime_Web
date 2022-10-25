import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:prime_web/helpers/Constant.dart';
import 'package:prime_web/widgets/firebase_initialize.dart';
import '../provider/navigationBarProvider.dart';
import 'package:provider/src/provider.dart';

import '../main.dart';
import '../screens/home_screen.dart';
import '../widgets/admob_service.dart';
import '../widgets/app_lifecycle_refactor.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage();
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  final GlobalKey<NavigatorState> _homeNavigatorKey =
      GlobalKey<NavigatorState>();
  late AnimationController navigationContainerAnimationController =
      AnimationController(
          vsync: this, duration: const Duration(milliseconds: 500));
  AppLifecycleReactor? _appLifecycleReactor;
  @override
  void dispose() {
    navigationContainerAnimationController.dispose();
    super.dispose();
    // dispose controller
  }

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration.zero, () {
      context
          .read<NavigationBarProvider>()
          .setAnimationController(navigationContainerAnimationController);
    });
    FirebaseInitialize.initFirebaseState();
    if (showOpenAds == true) {
      AdMobService appOpenAdManager = AdMobService()..loadOpenAd();
      _appLifecycleReactor =
          AppLifecycleReactor(appOpenAdManager: appOpenAdManager);
      _appLifecycleReactor!.listenToAppStateChanges();
    }
  }

  @override
  Widget build(BuildContext context) {
    // SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    //   statusBarColor: Theme.of(context).cardColor,
    //   statusBarBrightness: Brightness.light,
    //   statusBarIconBrightness: Theme.of(context).brightness == Brightness.dark
    //       ? Brightness.light
    //       : Brightness.dark,
    // ));

    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Theme.of(context).cardColor,
      statusBarBrightness: Theme.of(context).brightness == Brightness.dark
          ? Brightness.dark
          : Brightness.light,
      statusBarIconBrightness: Theme.of(context).brightness == Brightness.dark
          ? Brightness.light
          : Brightness.dark,
    ));
    return WillPopScope(
      onWillPop: () => _navigateBack(context),
      child: Scaffold(
        extendBody: false,
        body: Navigator(
          key: _homeNavigatorKey,
          initialRoute: 'home',
          onGenerateRoute: (routeSettings) {
            return MaterialPageRoute(builder: (_) => HomeScreen());
          },
        ),
      ),
    );
  }

  Future<bool> _navigateBack(BuildContext context) async {
    if (mounted) {
      if (!context
          .read<NavigationBarProvider>()
          .animationController
          .isAnimating) {
        context.read<NavigationBarProvider>().animationController.reverse();
      }
    }
    final isFirstRouteInCurrentTab =
        !await _homeNavigatorKey.currentState!.maybePop();

    if (!isFirstRouteInCurrentTab) {
      return Future.value(false);
    } else {
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                title: const Text('Do you want to exit app?'),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('No'),
                  ),
                  TextButton(
                    onPressed: () {
                      SystemNavigator.pop();
                    },
                    child: const Text('Yes'),
                  ),
                ],
              ));

      return Future.value(true);
    }
  }
}
