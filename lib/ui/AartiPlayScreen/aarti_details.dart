

class AartiDetails {
  String? name;
  String? des;
  String? image;
  String? audio;
  String? lyrics;

  AartiDetails({this.name, this.des, this.image, this.audio, this.lyrics});

  AartiDetails.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    des = json['des'];
    image = json['image'];
    audio = json['audio'];
    lyrics = json['lyrics'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['des'] = this.des;
    data['image'] = this.image;
    data['audio'] = this.audio;
    data['lyrics'] = this.lyrics;
    return data;
  }
}