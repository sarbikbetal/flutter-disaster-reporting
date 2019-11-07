class Info {
  String location;
  String date;
  String weather;
  String situation;
  String worsen;
  String dcode;

  Info(
      {this.location,
      this.date,
      this.dcode,
      this.situation,
      this.weather,
      this.worsen});

  Info.fromJson(Map<String, dynamic> json)
      : location = json['location'],
        weather = json['weather'],
        date = json['date'],
        worsen = json['worsen'],
        dcode = json['D_code'],
        situation = json['situation'];
}
