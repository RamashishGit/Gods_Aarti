import 'dart:convert';

import 'package:advanced_in_app_review/advanced_in_app_review.dart';
import 'package:allgodsaarti/ui/AartiPlayScreen/aarti_details.dart';
import 'package:allgodsaarti/ui/AartiPlayScreen/audio_player_screen.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:in_app_update/in_app_update.dart';

class HomeViewModel extends ChangeNotifier {
  List<AartiDetails> allGodsList = [];
  List<AartiDetails> aartiList = [];
  late String imageUrl;
  final storage = FirebaseStorage.instance;
  final controller = ScrollController();
  double topContainer = 0;
  String mProgress = "";
  bool itemNotFound = false;

  //int _numInterstitialLoadAttempts = 0;
  //int maxFailedLoadAttempts = 3;

  late BannerAd banner;
  // InterstitialAd? _interstitialAd;
  // RewardedAd? _rewardedAd;
  // int _numRewardedLoadAttempts = 0;

  // This list holds the data for the list view
  initState(BuildContext context) {
    controller.addListener(() {
      double value = controller.offset / 119;
      topContainer = value;
      notifyListeners();
    });

    loadJsonData();
    //_createInterstitialAd();
    createBannerAd();
    //_createRewardedAd();
    checkForFlexibleUpdate(context);
  }


  loadJsonData() async {
    String data = await DefaultAssetBundle.of(Get.context!)
        .loadString("assets/file/aarti.json");
    final jsonResult = jsonDecode(data); //latest Dart
    for (Map<String, dynamic> data in jsonResult) {
      aartiList.add(AartiDetails.fromJson(data));
    }

    allGodsList = aartiList;
    notifyListeners();
  }

  Future<void> checkForFlexibleUpdate(BuildContext context) async {
   AppUpdateInfo info =  await InAppUpdate.checkForUpdate();
   if(info.updateAvailability == UpdateAvailability.updateAvailable){
     InAppUpdate.checkForUpdate().then((updateInfo) {
       if (updateInfo.updateAvailability == UpdateAvailability.updateAvailable) {
           //Perform flexible update
           InAppUpdate.startFlexibleUpdate().then((appUpdateResult) {
             if (appUpdateResult == AppUpdateResult.success) {
               //App Update successful
               InAppUpdate.completeFlexibleUpdate();
             }
           });
         }
     });
   }
  }

  void onListenerController() {}

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    banner.dispose();
    //_interstitialAd?.dispose();
    //_rewardedAd?.dispose();
    controller.removeListener(onListenerController);
  }

  // This function is called whenever the text field changes
  void runFilter(String enteredKeyword) {
    List<AartiDetails> results = [];
    if (enteredKeyword.isEmpty) {
      // if the search field is empty or only contains white-space, we'll display all users
      results = aartiList;
    } else {
      results = aartiList
          .where((gods) =>
          gods.name!.toLowerCase().contains(enteredKeyword.toLowerCase()))
          .toList();
      if(results.isEmpty){
        itemNotFound = true;
        notifyListeners();
      }
    }

    // Refresh the UI
    allGodsList = results;
    notifyListeners();
  }

  void callHomeScreen(int index){
    //showRewardedAd(onAdDismiss:(){
      Get.to(
          AudioPlayerScreen(
            aartiList: allGodsList,
            index: index,
          ));
    //});
  }

  void createBannerAd() {
    banner = BannerAd(
      //adUnitId: 'ca-app-pub-3940256099942544/6300978111',
      adUnitId: 'ca-app-pub-7165520159369592/4295463145',
      size: AdSize.banner,
      request: AdRequest(),
      listener: BannerAdListener(
        // Called when an ad is successfully received.
        onAdLoaded: (Ad ad) => print('${ad.runtimeType} loaded.'),
        // Called when an ad request failed.
        onAdFailedToLoad: (Ad ad, LoadAdError error) {
          print('${ad.runtimeType} failed to load: $error');
        },
        // Called when an ad opens an overlay that covers the screen.
        onAdOpened: (Ad ad) => print('${ad.runtimeType} opened.'),
        // Called when an ad removes an overlay that covers the screen.
        onAdClosed: (Ad ad) {
          print('${ad.runtimeType} closed');
          ad.dispose();
          createBannerAd();
          print('${ad.runtimeType} reloaded');
        },
      ),
    )..load();
  }

  void inAppReview() {
    initPlatformState();
    AdvancedInAppReview()
        .setMinDaysBeforeRemind(7)
        .setMinDaysAfterInstall(2)
        .setMinLaunchTimes(2)
        .setMinSecondsBeforeShowDialog(4)
        .monitor();
  }

  Future<void> initPlatformState() async {
    String platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    // We also handle the message potentially returning null.
    try {
      platformVersion = await AdvancedInAppReview.platformVersion ??
          'Unknown platform version';
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }
  }

  /*void _createInterstitialAd() {
    InterstitialAd.load(
        //adUnitId: 'ca-app-pub-3940256099942544/1033173712',
        adUnitId: 'ca-app-pub-7165520159369592/9290609265',
        request: AdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(
          onAdLoaded: (InterstitialAd ad) {
            print('$ad loaded');
            _interstitialAd = ad;
            _numInterstitialLoadAttempts = 0;
            _interstitialAd!.setImmersiveMode(true);
          },
          onAdFailedToLoad: (LoadAdError error) {
            print('InterstitialAd failed to load: $error.');
            _numInterstitialLoadAttempts += 1;
            _interstitialAd = null;
            if (_numInterstitialLoadAttempts < maxFailedLoadAttempts) {
              _createInterstitialAd();
            }
          },
        ));
  }*/
  /*Future showInterstitialAd({Function? onAdDismiss})async {
    if (_interstitialAd == null) {
      print('Warning: attempt to show interstitial before loaded.');
      return;
    }
    _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (InterstitialAd ad) =>
          print('ad onAdShowedFullScreenContent.'),
      onAdDismissedFullScreenContent: (InterstitialAd ad) {
        print('$ad onAdDismissedFullScreenContent.');
        onAdDismiss!();
        ad.dispose();
        _createInterstitialAd();
      },
      onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
        print('$ad onAdFailedToShowFullScreenContent: $error');
        ad.dispose();
        _createInterstitialAd();
      },
    );
    _interstitialAd!.show();
    _interstitialAd = null;
  }*/

  /*void _createRewardedAd() {
    RewardedAd.load(
        // adUnitId: Platform.isAndroid
        //     ? 'ca-app-pub-3940256099942544/5224354917'
        //     : 'ca-app-pub-3940256099942544/1712485313',
        adUnitId: Platform.isAndroid
            ? 'ca-app-pub-7165520159369592/3142087599'
            : 'ca-app-pub-3940256099942544/1712485313',
        request: AdRequest(),
        rewardedAdLoadCallback: RewardedAdLoadCallback(
          onAdLoaded: (RewardedAd ad) {
            print('$ad loaded.');
            _rewardedAd = ad;
            _numRewardedLoadAttempts = 0;
          },
          onAdFailedToLoad: (LoadAdError error) {
            print('RewardedAd failed to load: $error');
            _rewardedAd = null;
            _numRewardedLoadAttempts += 1;
            if (_numRewardedLoadAttempts < maxFailedLoadAttempts) {
              _createRewardedAd();
            }
          },
        ));
  }*/

  /*void showRewardedAd({Function? onAdDismiss}) {
    if (_rewardedAd == null) {
      print('Warning: attempt to show rewarded before loaded.');
      return;
    }
    _rewardedAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (RewardedAd ad) =>
          print('ad onAdShowedFullScreenContent.'),
      onAdDismissedFullScreenContent: (RewardedAd ad) {
        print('$ad onAdDismissedFullScreenContent.');
        onAdDismiss!();
        ad.dispose();
        _createRewardedAd();
      },
      onAdFailedToShowFullScreenContent: (RewardedAd ad, AdError error) {
        print('$ad onAdFailedToShowFullScreenContent: $error');
        ad.dispose();
        _createRewardedAd();
      },
    );

    _rewardedAd!.setImmersiveMode(true);
    _rewardedAd!.show(
        onUserEarnedReward: (AdWithoutView ad, RewardItem reward) {
          print('$ad with reward $RewardItem(${reward.amount}, ${reward.type})');
        });
    _rewardedAd = null;
  }*/

}
