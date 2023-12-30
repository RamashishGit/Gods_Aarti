import 'package:allgodsaarti/ui/settings/settings_screen_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class SettingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<SettingScreenViewModel>.reactive(
        viewModelBuilder: () => SettingScreenViewModel(),
        onModelReady: (viewModel) => viewModel.init(),
        builder: (context, viewModel, child) => Scaffold(
          appBar: AppBar(
            title: Text("Setting"),
          ),
              body: Container(
                  child: SafeArea(
                      child: ListView(
                children: <Widget>[
                  Column(
                    children: [
                      SizedBox(
                        height: 20,
                      ),
                      ListTile(
                        hoverColor: Colors.deepOrange,
                        onTap: () {
                          viewModel.shareApp();
                        },
                        title:
                        Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: Colors.deepOrange)),
                          child: Row(
                            children: [
                              Padding(
                                padding: EdgeInsets.all(20),
                                child: Container(
                                  child: Icon(
                                    Icons.share,
                                    size: 25,
                                    color: Colors.deepOrange,
                                  ),
                                ),
                              ),
                              Text(
                                'Share App',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 18,
                                ),
                              )
                            ],
                          ),

                        ),

                      ),
                      SizedBox(
                        height: 20,
                      ),
                      ListTile(
                        hoverColor: Colors.deepOrange,
                        onTap: () {
                          viewModel.rateApp();
                        },
                        title:
                        Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: Colors.deepOrange)),
                          child: Row(
                            children: [
                              Padding(
                                padding: EdgeInsets.all(20),
                                child: Icon(
                                  Icons.star_rate_sharp,
                                  size: 25,
                                  color: Colors.deepOrange,
                                ),
                              ),
                              Text(
                                'Rate App',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 18,
                                ),
                              )
                            ],
                          ),

                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      ListTile(
                        hoverColor: Colors.deepOrange,
                        onTap: () {
                          viewModel.privacyPolicy();
                        },
                        title:
                        Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: Colors.deepOrange)),
                          child: Row(
                            children: [
                              Padding(
                                padding: EdgeInsets.all(20),
                                child: Icon(
                                  Icons.privacy_tip_outlined,
                                  size: 25,
                                  color: Colors.deepOrange,
                                ),
                              ),
                              Text(
                                'Privacy Policy',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 18,
                                ),
                              )
                            ],
                          ),

                        ),

                      ),
                    ],
                  ),
                ],
              ))),
            ));
  }
}
