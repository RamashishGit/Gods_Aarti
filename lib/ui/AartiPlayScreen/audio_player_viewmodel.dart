import 'dart:async';
import 'dart:io';
import 'dart:isolate';
import 'dart:ui';
import 'package:allgodsaarti/utils/utils.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:just_audio/just_audio.dart';
import 'package:path_provider/path_provider.dart';

class AudioPlayerViewModel extends ChangeNotifier {
  bool isPlaying = false;
  late final AudioPlayer audioPlayer  = AudioPlayer();

  late Timer timer;
  int timerStart = 0;

  bool isPlayerError = false;

  late BannerAd banner;
  // InterstitialAd? _interstitialAd;
  // RewardedAd? _rewardedAd;
  // int _numRewardedLoadAttempts = 0;

  // RewardedInterstitialAd? _rewardedInterstitialAd;
  // int _numRewardedInterstitialLoadAttempts = 0;

  //int _numInterstitialLoadAttempts = 0;
  //int maxFailedLoadAttempts = 3;
  //int coins = 0;

  //int interstitialAdCounter = 1;

  final buttonNotifier = ValueNotifier<ButtonState>(ButtonState.loading);

  final progressNotifier = ValueNotifier<ProgressBarState>(
    ProgressBarState(
      current: Duration.zero,
      buffered: Duration.zero,
      total: Duration.zero,
    ),
  );

  void init(String? audioUrl, BuildContext context) {
    initPlayer(audioUrl!,context);
    audioUrl = '';
    _createBannerAd();
    //_createInterstitialAd();
    //_createRewardedAd();
    //_createRewardedInterstitialAd();
  }

  @override
  void dispose() {
    audioPlayer.dispose();
    banner.dispose();
    //_interstitialAd?.dispose();
    //_rewardedAd?.dispose();
    //_rewardedInterstitialAd?.dispose();
    super.dispose();
  }

  Future initPlayer(String audioUrl, BuildContext context) async {
    try {
      buttonNotifier.value = ButtonState.loading;
      notifyListeners();
      String fileNameFirebase = getFileName(audioUrl);
      String folderPath = await createFolderPath();
      String folderAudioUrl = '$folderPath/$fileNameFirebase';


      if (await File(folderAudioUrl).exists()) {
        await audioPlayer.setAudioSource(AudioSource.uri(Uri.parse(folderAudioUrl)));
        buttonNotifier.value = ButtonState.playing;
        audioPlayer.play();
        isPlaying = true;
        notifyListeners();
        audioPlayerStateStream();
        audioPlayerPositionStream();
      } else {
        if (await Utils.isNetworkAvailable()) {
          downloadFile(folderPath, audioUrl,fileNameFirebase);
          await audioPlayer.setAudioSource(AudioSource.uri(Uri.parse(audioUrl)));
          buttonNotifier.value = ButtonState.playing;
          audioPlayer.play();
          isPlaying = true;
          notifyListeners();
          isPlayerError = false;
          audioPlayerStateStream();
          audioPlayerPositionStream();
        }else{
          Utils.showAlertDialog(context,"No Internet Connection!",onTap: (){
            Navigator.pop(context);
          });
        }

      }

    } catch (e) {
      isPlayerError = true;
      print("Error loading audio source: $e");
      buttonNotifier.value = ButtonState.paused;
      audioPlayer.stop();
      isPlaying = false;
      showSnack(context,"Sorry for the inconvenience. Please try after sometime!");
      notifyListeners();
    }
  }

  void downloadFile(String folderPath, String audioUrl, String fileNameFirebase) async {
    try{
      String? _taskid = await FlutterDownloader.enqueue(
        url: audioUrl,
        fileName: fileNameFirebase,
        savedDir: folderPath,
        showNotification: true,
        openFileFromNotification: false,
      );
      print(_taskid);

    }catch (e) {
    print("Error downloading audio source: $e");
    }

  }

  String getFileName(String audioUrl) {
    RegExp regExp = new RegExp(r'.+(\/|%2F)(.+)\?.+');
    //This Regex won't work if you remove ?alt...token
    var matches = regExp.allMatches(audioUrl);

    var match = matches.elementAt(0);
    print("${Uri.decodeFull(match.group(2)!)}");
    return Uri.decodeFull(match.group(2)!);
  }

  Future<String> createFolderPath() async {
    final Directory _appDocDir = await getApplicationDocumentsDirectory();
    String folderName = "GodsAudioFiles";
    final Directory _appDocDirFolder =
    Directory("${_appDocDir.path}/$folderName");

    if (await _appDocDirFolder.exists()) {
      return _appDocDirFolder.path;
    }

    final Directory _appDocDirNewFolder =
    await _appDocDirFolder.create(recursive: true);
    return _appDocDirNewFolder.path;
  }

  void playPause(BuildContext context, String audioUrl) async {
    if(!isPlayerError){
      if (isPlaying) {
        audioPlayer.pause();
        isPlaying = false;
        notifyListeners();
      } else {
        audioPlayer.play();
        isPlaying = true;
        notifyListeners();
      }
    }else{
      initPlayer(audioUrl, context);
    }
  }

  void seek(Duration position) {
    audioPlayer.seek(position);
  }

  void _createBannerAd() {
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
          _createBannerAd();
          print('${ad.runtimeType} reloaded');
        },
      ),
    )..load();
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

  /*void showInterstitialAd({Function? onAdDismiss}) {
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
        *//*adUnitId: Platform.isAndroid
            ? 'ca-app-pub-3940256099942544/5224354917'
            : 'ca-app-pub-3940256099942544/1712485313',*//*
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

  /*void _createRewardedInterstitialAd() {
    RewardedInterstitialAd.load(
        *//*adUnitId: Platform.isAndroid
            ? 'ca-app-pub-3940256099942544/5354046379'
            : 'ca-app-pub-3940256099942544/6978759866',*//*
        adUnitId: Platform.isAndroid
            ? 'ca-app-pub-7165520159369592/8502225485'
            : 'ca-app-pub-3940256099942544/6978759866',
        request: AdRequest(),
        rewardedInterstitialAdLoadCallback: RewardedInterstitialAdLoadCallback(
          onAdLoaded: (RewardedInterstitialAd ad) {
            print('$ad loaded.');
            _rewardedInterstitialAd = ad;
            _numRewardedInterstitialLoadAttempts = 0;
          },
          onAdFailedToLoad: (LoadAdError error) {
            print('RewardedInterstitialAd failed to load: $error');
            _rewardedInterstitialAd = null;
            _numRewardedInterstitialLoadAttempts += 1;
            if (_numRewardedInterstitialLoadAttempts < maxFailedLoadAttempts) {
              _createRewardedInterstitialAd();
            }
          },
        ));
  }*/

  /*void showRewardedInterstitialAd({Function? onAdDismiss}) {
    if (_rewardedInterstitialAd == null) {
      print('Warning: attempt to show rewarded interstitial before loaded.');
      return;
    }
    _rewardedInterstitialAd!.fullScreenContentCallback =
        FullScreenContentCallback(
          onAdShowedFullScreenContent: (RewardedInterstitialAd ad) =>
              print('$ad onAdShowedFullScreenContent.'),
          onAdDismissedFullScreenContent: (RewardedInterstitialAd ad) {
            print('$ad onAdDismissedFullScreenContent.');
            ad.dispose();
            _createRewardedInterstitialAd();
          },
          onAdFailedToShowFullScreenContent:
              (RewardedInterstitialAd ad, AdError error) {
            print('$ad onAdFailedToShowFullScreenContent: $error');
            ad.dispose();
            _createRewardedInterstitialAd();
          },
        );

    _rewardedInterstitialAd!.setImmersiveMode(true);
    _rewardedInterstitialAd!.show(
        onUserEarnedReward: (AdWithoutView ad, RewardItem reward) {
          print('$ad with reward $RewardItem(${reward.amount}, ${reward.type})');
        });
    _rewardedInterstitialAd = null;
  }*/

  void audioPlayerStateStream() {
    audioPlayer.playerStateStream.listen((playerState) {
      final isPlaying = playerState.playing;
      final processingState = playerState.processingState;
      if (processingState == ProcessingState.loading ||
          processingState == ProcessingState.buffering) {
        buttonNotifier.value = ButtonState.loading;
      } else if (!isPlaying) {
        buttonNotifier.value = ButtonState.paused;
      } else if (processingState != ProcessingState.completed) {
        buttonNotifier.value = ButtonState.playing;
      } else {
        audioPlayer.seek(Duration.zero);
        audioPlayer.pause();
      }
    });
  }

  void audioPlayerPositionStream() {
    audioPlayer.positionStream.listen((position) {
      final oldState = progressNotifier.value;
      progressNotifier.value = ProgressBarState(
        current: position,
        buffered: oldState.buffered,
        total: oldState.total,
      );
    });

    audioPlayer.bufferedPositionStream.listen((bufferedPosition) {
      final oldState = progressNotifier.value;
      progressNotifier.value = ProgressBarState(
        current: oldState.current,
        buffered: bufferedPosition,
        total: oldState.total,
      );
    });

    audioPlayer.durationStream.listen((totalDuration) {
      final oldState = progressNotifier.value;
      progressNotifier.value = ProgressBarState(
        current: oldState.current,
        buffered: oldState.buffered,
        total: totalDuration ?? Duration.zero,
      );
    });
  }

  void showSnack(BuildContext context,String text) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(text),behavior: SnackBarBehavior.floating,));
  }
}


class ProgressBarState {
  ProgressBarState({
    required this.current,
    required this.buffered,
    required this.total,
  });
  final Duration current;
  final Duration buffered;
  final Duration total;
}

enum ButtonState { paused, playing, loading }