import 'package:allgodsaarti/ui/SplashSreen/splash_screen_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:stacked/stacked.dart';

class Splash extends StatefulWidget {
  @override
  VideoState createState() => VideoState();
}

class VideoState extends State<Splash> with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<SplashScreenViewModel>.reactive(
        viewModelBuilder: () => SplashScreenViewModel(),
        onModelReady: (viewModel) => viewModel.init(context),
        builder: (context, viewModel, child) => Scaffold(
              body: Container(
                child: Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    Center(
                        child: Lottie.asset(
                      'assets/file/splash.json',
                      repeat: true,
                      width: 500.0,
                    )),
                    Center(
                      child: Container(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SizedBox(
                              height: 300,
                            ),
                            Text(
                              'आरती संग्रह',
                              style: TextStyle(
                                  fontSize: 40,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.red,
                                  fontFamily: 'Mukta'),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Center(
                      child: Container(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            SizedBox(
                              height: 300,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: Text(
                                viewModel.versionName,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.red,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ));
  }
}
