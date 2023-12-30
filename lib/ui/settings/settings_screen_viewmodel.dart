
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

class SettingScreenViewModel extends ChangeNotifier {

  void init() {

  }

  void shareApp(){
    Share.share('Hey! check out this new app https://play.google.com/store/apps/details?id=com.rts.godsaarti', subject: 'All Gods Aarti App Link');
  }

  void rateApp() async {
      final appId = 'com.rts.godsaarti';
      final url = Uri.parse("https://play.google.com/store/apps/details?id=$appId");
      launchUrl(
        url,
        mode: LaunchMode.externalApplication,
      );
  }

  void privacyPolicy() async {
    final url = Uri.parse("https://www.termsfeed.com/live/ee9690a9-7d76-4b1d-b0c0-f83683bf17e7");
    launchUrl(
      url,
      mode: LaunchMode.externalApplication,
    );
  }

}