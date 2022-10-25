import 'dart:async';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import '../widgets/no_internet.dart';
import '../widgets/no_internet_widget.dart';
import '../widgets/load_web_view.dart';

class WebviewScreen extends StatefulWidget {
  final String title;
  final String content;
  final String url;
  WebviewScreen(this.title, this.content, this.url);

  static const routeName = '/webView';

  @override
  State<WebviewScreen> createState() => _WebviewScreenState();
}

class _WebviewScreenState extends State<WebviewScreen> {
  String _connectionStatus = 'Unknown';
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;
  @override
  void initState() {
    super.initState();
    NoInternet.initConnectivity().then((value) => setState(() {
          _connectionStatus = value;
        }));
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen((ConnectivityResult result) {
      NoInternet.updateConnectionStatus(result).then((value) => setState(() {
            _connectionStatus = value;
          }));
    });
  }

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String message = Theme.of(context).brightness == Brightness.dark
        ? "<font color='white'>" + widget.content + "</font>"
        : "<font color='black'>" + widget.content + "</font>";
    return SafeArea(
      top: Platform.isIOS ? false : true,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          title: Text(widget.title),
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios_new_rounded,
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.white
                  : Colors.black,
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ),
        body: widget.url == ''
            ? Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: LoadWebView(message, false))
            : _connectionStatus == 'ConnectivityResult.none'
                ? const NoInternetWidget()
                : LoadWebView(widget.url, true),
      ),
    );
  }
}
