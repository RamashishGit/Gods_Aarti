import 'package:allgodsaarti/ui/HomeScreen/home_screen_viewmodel.dart';
import 'package:allgodsaarti/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:stacked/stacked.dart';

class HomeScreen extends StatelessWidget {
  final GlobalKey<FormState> formKey = GlobalKey();

  HomeScreen({Key? key}) : super(key: key);
  final double itemSize = 90.0;
  TextEditingController textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<HomeViewModel>.reactive(
        viewModelBuilder: () => HomeViewModel(),
        onModelReady: (viewModel) => viewModel.initState(context),
        builder: (context, viewModel, child) => WillPopScope(
              onWillPop: () async {
                // await viewModel.showInterstitialAd(onAdDismiss: () {
                //   return true;
                // });
                viewModel.inAppReview();
                return true;
              },
              child: Scaffold(
                  body: Stack(
                children: [
                  CustomScrollView(slivers: <Widget>[
                    SliverAppBar(
                      expandedHeight: 75.0,
                      flexibleSpace: FlexibleSpaceBar(
                        background: Container(
                          color: Colors.white,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(
                                height: MediaQuery.of(context).viewPadding.top,
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: TextField(
                                  onChanged: (value) =>
                                      viewModel.runFilter(value),
                                  decoration: InputDecoration(
                                    contentPadding: const EdgeInsets.symmetric(
                                        vertical: 10.0, horizontal: 15),
                                    hintText: "Search",
                                    suffixIcon: const Icon(Icons.search),
                                    // prefix: Icon(Icons.search),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(20.0),
                                      borderSide: const BorderSide(),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    viewModel.allGodsList.isNotEmpty
                        ? SliverList(
                            delegate: SliverChildBuilderDelegate(
                            (_, int index) {
                              return Column(
                                    children: [
                                      if (index == 0)
                                        SizedBox(
                                          height: 12,
                                        ),
                                      AartiItem(
                                        godsList: viewModel.allGodsList,
                                        index: index,
                                        onTap: () {
                                          viewModel.callHomeScreen(index);
                                        },
                                      ),
                                      if (viewModel.allGodsList.length -1 == index)
                                    SizedBox(
                                      height: 50,
                                    )
                                ],
                              );
                            },
                            childCount: viewModel.allGodsList.length,
                          ))
                        : SliverToBoxAdapter(
                            child: Container(
                                child: Center(
                                    child: !viewModel.itemNotFound
                                        ? CircularProgressIndicator()
                                        : Text(
                                            'No Result Found',
                                            style: TextStyle(fontSize: 15),
                                          ))))
                  ]),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      width: viewModel.banner.size.width.toDouble(),
                      height: viewModel.banner.size.height.toDouble(),
                      child: AdWidget(ad: viewModel.banner),
                    ),
                  ),
                ],
              )),
            ));
  }

}

class AartiItem extends StatelessWidget {
  const AartiItem(
      {super.key,
      required this.godsList,
      required this.index,
      required this.onTap});

  final godsList;
  final int index;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () async {
           onTap!();
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4.0),
          child: Card(
              elevation: 1,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                alignment: Alignment.center,
                child: Column(
                  children: [
                    Row(
                      children: [
                        SizedBox(
                          height: 100,
                          width: 100,
                          child: Center(
                            child:
                                  Container(
                                width: 90.0,
                                height: 90.0,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                      image: AssetImage(Utils.imagePath+godsList[index].image!), fit: BoxFit.cover),
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
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                godsList[index].name!,
                                style: const TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.w700),
                              ),
                              const SizedBox(
                                height: 8,
                              ),
                              Text(godsList[index].des!),
                            ],
                          ),
                        ),
                        Container(
                          child: const Icon(
                            Icons.play_circle_outline,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              )),
        ));
  }
}
