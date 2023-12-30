import 'package:allgodsaarti/ui/HomeScreen/home_screen.dart';
import 'package:allgodsaarti/utils/utils.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:in_app_update/in_app_update.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';
class SplashScreenViewModel extends ChangeNotifier {

  final ref = FirebaseDatabase.instance.ref();
  String versionName = "Version ";
  late BuildContext context;

  init(BuildContext context){
    context = context;
    getAppVersion();
    Future.delayed(Duration(seconds: 3), () async {
      forceUpdate(context);
    });
  }


  void getAppVersion() async{
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    versionName = "Version : ${packageInfo.version}";
    notifyListeners();
  }

  void forceUpdate(BuildContext context) async{
    DatabaseReference ref = FirebaseDatabase.instance.ref().child('minversion');
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    int appVersionCode = int.parse(packageInfo.buildNumber);
    final snapshot = await ref.get();
    if (snapshot.exists) {
      Object? serverMinVersion = snapshot.value;
      String strServerMinVersion = serverMinVersion.toString();
      if(int.parse(strServerMinVersion) > appVersionCode){
        checkForImmediateUpdate(context);
      }else{
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (_) =>
            HomeScreen()
        ));
      }
    } else {
      print('No data available.');
    }
  }

  void checkForImmediateUpdate(BuildContext context) async{
    AppUpdateInfo info =  await InAppUpdate.checkForUpdate();
    if(info.updateAvailability == UpdateAvailability.updateAvailable){
      InAppUpdate.checkForUpdate().then((updateInfo) {
        if (updateInfo.updateAvailability == UpdateAvailability.updateAvailable) {
          //Perform immediate update
          InAppUpdate.performImmediateUpdate().then((appUpdateResult) {
            if (appUpdateResult != AppUpdateResult.success) {
              //App Update successful
            }else{
              Navigator.pushReplacement(
                  context, MaterialPageRoute(builder: (_) =>
                  HomeScreen()
              ));
            }
          });
        }
      });
    }else{
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (_) =>
          HomeScreen()
      ));
    }
  }
}