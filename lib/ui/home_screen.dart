import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeState();
}

class _HomeState extends State<HomeScreen> {
  final List<Map<String, dynamic>> _allGods = [
    {
      "id": 1,
      "name": "Shri Ganesh Ji ki Aarti(Marathi)",
      "des": "Android Developer",
      "image": "assets/shri_ganesh_ji_lalbaug.jpg",
    },
    {
      "id": 2,
      "name": "Shri Ganesh Ji ki Aarti(Hindi)",
      "des": "Android Developer",
      "image": "assets/shri_ganesh_ji.jpg",
    },
    {
      "id": 3,
      "name": "Shri Hanuman Ji Ki Aarti",
      "des": "Android Developer",
      "image": "assets/shri_hanuman_ji.jpg",
    },
    {
      "id": 4,
      "name": "Shri Krishna Ji Ki Aarti",
      "des": "Android Developer",
      "image": "assets/shri_krishna_ji.jpg",
    },
    {
      "id": 5,
      "name": "Shri Khatu Shyam Ji Ki Aarti",
      "des": "Android Developer",
      "image": "assets/shri_khatu_shyam.jpg",
    },
    {
      "id": 6,
      "name": "Shri Ramchandra Ji Ki Aarti",
      "des": "Android Developer",
      "image": "assets/shri_ramchandra_ji.jpg",
    },
    {
      "id": 7,
      "name": "Shri Shiv Ji Ki Aarti",
      "des": "Android Developer",
      "image": "assets/shri_shiv_ji.jpg",
    },
    {
      "id": 8,
      "name": "Shri Shani Dev Ji Ki Aarti",
      "des": "Android Developer",
      "image": "assets/shri_shani_dev.jpg",
    },
    {
      "id": 9,
      "name": "Shri Satyanarayan Ji Ki Aarti",
      "des": "Android Developer",
      "image": "assets/shri_satya_narayan.jpg",
    },
    {
      "id": 10,
      "name": "Shri Sai Ji Ki Aarti",
      "des": "Android Developer",
      "image": "assets/shri_sai_baba.jpg",
    },
    {
      "id": 11,
      "name": "Shri Vishnu Ji Ki Aarti",
      "des": "Android Developer",
      "image": "assets/shri_vishnu_ji.jpg",
    },
    {
      "id": 12,
      "name": "Shri Raghuvir Ji Ki Aarti",
      "des": "Android Developer",
      "image": "assets/shri_raghuvar_ji.jpg",
    },
    {
      "id": 13,
      "name": "Kunjbihari Ji Ki Aarti",
      "des": "Android Developer",
      "image": "assets/shri_kunj_bihari.jpg",
    },
    {
      "id": 14,
      "name": "Shri Bhairav Ji Ki Aarti",
      "des": "Android Developer",
      "image": "assets/shri_bhairav_ji.jpg",
    },
    {
      "id": 15,
      "name": "Shri Baba Balak Nath Ji Ki Aarti",
      "des": "Android Developer",
      "image": "assets/shri_baba_balak_nath.jpg",
    },
    {
      "id": 16,
      "name": "Shri Santoshi Mata Ji Ki Aarti",
      "des": "Android Developer",
      "image": "assets/shri_santoshi_mata.jpg",
    },
    {
      "id": 17,
      "name": "Shri Saraswati Mata Ji Ki Aarti",
      "des": "Android Developer",
      "image": "assets/shri_saraswati.jpg",
    },
    {
      "id": 18,
      "name": "Shri Laxmi Mata Ji Ki Aarti",
      "des": "Android Developer",
      "image": "assets/shri_laxmi_mata.jpg",
    },
    {
      "id": 19,
      "name": "Shri Parvati Mata Ji Ki Aarti",
      "des": "Android Developer",
      "image": "assets/shri_parvati_mata.jpg",
    },
    {
      "id": 20,
      "name": "Shri Ganga Mata Ji Ki Aarti",
      "des": "Android Developer",
      "image": "assets/shri_ganga_mata.jpg",
    },
    {
      "id": 21,
      "name": "Shri Kali Mata Ji Ki Aarti",
      "des": "Android Developer",
      "image": "assets/shri_kali_mata.jpg",
    },
    {
      "id": 22,
      "name": "Shri Jagdambe Mata Ji Ki Aarti",
      "des": "Android Developer",
      "image": "assets/shri_jagdambe_mata.jpg",
    },
    {
      "id": 23,
      "name": "Shri Durga Mata Ji Ki Aarti",
      "des": "Android Developer",
      "image": "assets/shri_durga_mata.jpg",
    },
    {
      "id": 24,
      "name": "Shri Ambe Mata Ji Ki Aarti",
      "des": "Android Developer",
      "image": "assets/shri_ambe_mata.jpg",
    },
  ];

// This list holds the data for the list view
  List<Map<String, dynamic>> _foundGods = [];
  @override
  initState() {
    // at the beginning, all users are shown
    _foundGods = _allGods;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Aarti List"),
          centerTitle: true,
        ),
        body: ListView.builder(
            itemCount: _allGods.length,
            itemBuilder: (BuildContext context, int index) {
              return Card(
                  child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                alignment: Alignment.center,
                child: Column(
                  children: [
                    Row(
                      children: [
                        SizedBox(
                          width: 90,
                          height: 90,
                          child: CircleAvatar(
                            backgroundImage:
                                AssetImage(_foundGods[index]['image']),
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(_foundGods[index]['name'],
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w700
                              ),),
                              SizedBox(
                                height: 8,
                              ),
                              Text(_foundGods[index]['des']),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ));
            }));
  }
}
