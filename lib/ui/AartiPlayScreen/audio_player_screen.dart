import 'package:allgodsaarti/ui/AartiPlayScreen/aarti_details.dart';
import 'package:allgodsaarti/ui/AartiPlayScreen/audio_player_viewmodel.dart';
import 'package:allgodsaarti/ui/settings/settings_screen.dart';
import 'package:allgodsaarti/utils/utils.dart';
import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:lottie/lottie.dart';
import 'package:stacked/stacked.dart';

class AudioPlayerScreen extends StatelessWidget {
  List<AartiDetails> aartiList = [];
  final GlobalKey<FormState> formKey = GlobalKey();
  int index = 0;

  int interstitialAdCounter = 1;
  bool isInterstitialAdDisplayed = false;

  AudioPlayerScreen({Key? key, required this.aartiList, required this.index})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<AudioPlayerViewModel>.reactive(
        viewModelBuilder: () => AudioPlayerViewModel(),
        onModelReady: (viewModel) =>
            viewModel.init(aartiList[index].audio,context),
        builder: (context, viewModel, child) => Scaffold(
              body: SafeArea(
                top: true,
                child: Stack(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Row(
                            // mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                               Lottie.asset('assets/file/diwali-lamp.json',repeat: true,   width: 70.0,
                                    height: 70.0,),
                              Center(
                                child:
                                      Container(
                                    width: 90.0,
                                    height: 90.0,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      image: DecorationImage(
                                          image: AssetImage(Utils.imagePath+aartiList[index].image!), fit: BoxFit.cover),
                                      boxShadow: const [
                                        BoxShadow(
                                          color: Colors.orangeAccent,
                                          spreadRadius: 1,
                                          blurRadius: 10.0,
                                        ),
                                      ],
                                    ),
                                  ),

                              ),
                              Lottie.asset('assets/file/diwali-lamp.json',repeat: true,   width: 70.0,
                                height: 70.0,),
                            ],
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(left: 5, right: 5),
                              child: Container(
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.white,
                                  boxShadow: const [
                                    BoxShadow(
                                      color: Colors.orangeAccent,
                                      spreadRadius: 1,
                                      blurRadius: 10.0,
                                    ),
                                  ],
                                ),
                                child: Scrollbar(
                                  child: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: SingleChildScrollView(
                                      child: Text(aartiList[index].lyrics!,textAlign: TextAlign.center,
                                          style: const TextStyle(
                                              fontWeight: FontWeight.w500,
                                          fontFamily: 'Mukta',
                                          fontSize: 15)),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.only(left: 10, right: 10, top: 10),
                            child: Column(
                              children: [
                                ValueListenableBuilder<ProgressBarState>(
                                  valueListenable: viewModel.progressNotifier,
                                  builder: (_, value, __) {
                                    return ProgressBar(
                                      baseBarColor: Colors.orangeAccent.withOpacity(0.4),
                                      progressBarColor: Colors.deepOrangeAccent,
                                      thumbColor: Colors.deepOrangeAccent,
                                      progress: value.current,
                                      buffered: value.buffered,
                                      total: value.total,
                                      onSeek: viewModel.seek,
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                SizedBox(
                                    height: 50.0,
                                    width: 50.0,
                                    child: Container(
                                      decoration: const BoxDecoration(
                                          shape: BoxShape.circle,
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.orangeAccent,
                                              spreadRadius: 1,
                                              blurRadius: 10.0,
                                            ),
                                          ]),
                                      child: Container(
                                        decoration: const BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Colors.white,
                                        ),
                                        child: IconButton(
                                          icon: const Icon(Icons.skip_previous_rounded,
                                              size: 30.0),
                                          onPressed: () {
                                            if (index > 0) {
                                              index--;
                                              viewModel.initPlayer(
                                                  aartiList[index].audio!,context);
                                            }
                                          },
                                        ),
                                      ),
                                    )),
                                ValueListenableBuilder<ButtonState>(
                                  valueListenable: viewModel.buttonNotifier,
                                  builder: (_, value, __) {
                                    switch (value) {
                                      case ButtonState.loading:
                                        return SizedBox(
                                          height: 40.0,
                                          width: 40.0,
                                          child: CircularProgressIndicator(
                                            valueColor: AlwaysStoppedAnimation(
                                                Colors.orangeAccent),
                                            strokeWidth: 4.0,
                                          ),
                                        );
                                      case ButtonState.paused:
                                        return SizedBox(
                                          height: 70.0,
                                          width: 70.0,
                                          child: Container(
                                            decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Colors.orangeAccent,
                                                    spreadRadius: 1,
                                                    blurRadius: 10.0,
                                                  ),
                                                ]),
                                            child: Container(
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: Colors.white,
                                              ),
                                              child: IconButton(
                                                icon: const Icon(
                                                  Icons.play_arrow,
                                                ),
                                                iconSize: 40.0,
                                                onPressed:()=> viewModel.playPause(context,aartiList[index].audio!),
                                              ),
                                            ),
                                          ),
                                        );
                                      case ButtonState.playing:
                                        return SizedBox(
                                          height: 70.0,
                                          width: 70.0,
                                          child: Container(
                                            decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Colors.orangeAccent,
                                                    spreadRadius: 1,
                                                    blurRadius: 5.0,
                                                  ),
                                                ]),
                                            child: Container(
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: Colors.white,
                                              ),
                                              child: IconButton(
                                                icon: const Icon(
                                                    Icons.pause),
                                                iconSize: 40.0,
                                                onPressed:()=> viewModel.playPause(context,aartiList[index].audio!),
                                              ),
                                            ),
                                          ),
                                        );
                                    }
                                  },
                                ),
                                SizedBox(
                                    height: 50.0,
                                    width: 50.0,
                                    child: Container(
                                      decoration: const BoxDecoration(
                                          shape: BoxShape.circle,
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.orangeAccent,
                                              spreadRadius: 1,
                                              blurRadius: 10.0,
                                            ),
                                          ]),
                                      child: Container(
                                        decoration: const BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Colors.white,
                                        ),
                                        child: IconButton(
                                          icon: const Icon(Icons.skip_next_rounded,
                                              size: 30.0),
                                          onPressed: () {
                                            // if(interstitialAdCounter % 2 == 0){
                                            // if(isInterstitialAdDisplayed){
                                            //   viewModel.showRewardedAd(onAdDismiss:(){
                                            //     if (index >= 0 && index < aartiList.length - 1) {
                                            //       index++;
                                            //       isInterstitialAdDisplayed = false;
                                            //       viewModel.initPlayer(aartiList[index].audio!,context);
                                            //       interstitialAdCounter++;
                                            //     }
                                            //   });
                                            // }else{
                                            //   viewModel.showInterstitialAd(onAdDismiss:(){
                                            //     if (index >= 0 && index < aartiList.length - 1) {
                                            //       index++;
                                            //       isInterstitialAdDisplayed = true;
                                            //       viewModel.initPlayer(aartiList[index].audio!,context);
                                            //       interstitialAdCounter++;
                                            //     }
                                            //   });
                                            // }
                                            // }else{
                                              if (index >= 0 && index < aartiList.length - 1) {
                                                index++;
                                                viewModel.initPlayer(aartiList[index].audio!,context);
                                                interstitialAdCounter++;
                                              }
                                            //}
                                          },
                                        ),
                                      ),
                                    )),
                              ],
                            ),
                          ),

                          SizedBox(height: 60,)
                        ],
                      ),
                    ),
                    Align(
                      alignment: Alignment.topLeft,
                      child: SizedBox(
                        height: 50,
                        width: 50,
                        child: IconButton(
                            onPressed: ()=> Navigator.pop(context),
                            icon: Icon(Icons.arrow_back_ios_new,size: 20,)),
                      ),
                    ),
                    Align(
                      alignment: Alignment.topRight,
                      child: SizedBox(
                        height: 50,
                        width: 50,
                        child: IconButton(
                            onPressed: ()=> Navigator.pushReplacement(
                                context, MaterialPageRoute(builder: (_) =>
                                SettingScreen()
                            )),
                            icon: Icon(Icons.settings,size: 20,)),
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        width: viewModel.banner.size.width.toDouble(),
                        height: viewModel.banner.size.height.toDouble(),
                        child: AdWidget(ad: viewModel.banner),
                      ),
                    ),
                  ],
                ),
              ),
            ));
  }
}
