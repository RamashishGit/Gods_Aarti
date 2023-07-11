import 'package:flutter/material.dart';

class AartiPlayScreen extends StatefulWidget {
  const AartiPlayScreen({super.key});

  @override
  State<AartiPlayScreen> createState() => _AartiPlayScreenState();
}

class _AartiPlayScreenState extends State<AartiPlayScreen> {
  double _currentSliderValue = 20;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
        ),
        title: const Text("Aarti Play Area"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Row(
              // mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Align(
                  alignment: Alignment.topLeft,
                  child: SizedBox(
                    width: 100,
                    height: 100,
                    child: CircleAvatar(
                      backgroundImage:
                      AssetImage('assets/splash_logo.png'),
                    ),
                  ),
                ),
                const SizedBox(width: 10,),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 15),
                    child: Column(
                      children: [
                        Text(
                          "Shri Ganesh Ji Ki aarti(Marathi)",
                          style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                        ),
                        Text(
                          "Shri Ganesh Ji Ki aarti(Marathi)",
                          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20,),
            Padding(
              padding: const EdgeInsets.only(left: 5,right: 5),
              child: Container(
                height: 300,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white,
                  boxShadow: const [
                    BoxShadow(color: Colors.grey,
                      spreadRadius: 1,
                      blurRadius: 10.0,),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(25.0),
                  child: Text("FSFSFSFSFSFFSFSFSFSFSFSFSFFSFSFSFSFSFSFFSFSFS"),
                ),
              ),
            ),
            const SizedBox(height: 10,),
            Padding(
              padding: const EdgeInsets.only(left: 10,right: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("10:10",
                  style: TextStyle(
                    fontSize: 15
                  ),),
                  Expanded(
                    child: Slider(
                      value: _currentSliderValue,
                      max: 100,
                      divisions: 5,
                      label: _currentSliderValue.round().toString(),
                      onChanged: (double value) {
                        setState(() {
                          _currentSliderValue = value;
                        });
                      },
                    ),
                  ),
                  const Text("10:10",
                    style: TextStyle(
                        fontSize: 15
                    ),),
                ],
              ),
            ),
            Row(
              children: [
                Expanded(
                    child: Container()
                ),
                Expanded(
                  child: SizedBox(
                      height: 60.0,
                      width: 60.0,
                      child: IconButton(
                        icon: const Icon(Icons.skip_previous_rounded, size: 30.0), onPressed: () {  },
                      )
                  ),
                ),
                SizedBox(
                    height: 90.0,
                    width: 90.0,
                    child: IconButton(
                      icon: const Icon(Icons.play_circle_fill, size: 50.0), onPressed: () {  },
                    )
                ),
                SizedBox(
                    height: 60.0,
                    width: 60.0,
                    child: IconButton(
                      icon:const Icon(Icons.skip_next_rounded, size: 30.0), onPressed: () {  },
                    )
                ),
                SizedBox(
                    height: 60.0,
                    width: 60.0,
                    child: IconButton(
                      icon: const Icon(Icons.volume_off_rounded, size: 30.0,), onPressed: () {  },
                    )
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
