import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:prime_web/helpers/Constant.dart';
import '../widgets/admob_service.dart';
import '../widgets/load_web_view.dart';

class WebUrlScreen extends StatefulWidget {
  final String url;
  WebUrlScreen(this.url);

  static const routeName = '/webView';

  @override
  State<WebUrlScreen> createState() => _WebUrlScreenState();
}

class _WebUrlScreenState extends State<WebUrlScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: displayAd(), body: LoadWebView(widget.url, true));
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
