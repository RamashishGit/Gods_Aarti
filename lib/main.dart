import 'dart:isolate';
import 'dart:ui';
import 'package:allgodsaarti/ui/SplashSreen/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

void main()async{
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();
  // Plugin must be initialized before using
  await FlutterDownloader.initialize(
      debug: true, // optional: set to false to disable printing logs to console (default: true)
      ignoreSsl: true // option: set to false to disable working with http links (default: false)
  );

  FlutterDownloader.registerCallback(downloadCallback);

  await Firebase.initializeApp();
  runApp(const MyApp());
}

@pragma('vm:entry-point')
void downloadCallback(String id, int status, int progress) {
  final SendPort? send =
  IsolateNameServer.lookupPortByName('downloader_send_port');
  send!.send([id, status, progress]);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: "Gods Aarti",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.red,
        colorScheme: ColorScheme.light(secondary: Colors.green, primary: Colors.deepOrangeAccent)
      ),
      home:  Splash(),
    );
  }
}


