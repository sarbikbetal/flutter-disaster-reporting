class Info {
  String location;
  String date;
  String weather;
  String situation;
  String worsen;
  String dname;

  Info(
      {this.location,
      this.date,
      this.dname,
      this.situation,
      this.weather,
      this.worsen});

  Info.fromJson(Map<String, dynamic> json)
      : location = json['location'],
        weather = json['weather'],
        date = json['date'],
        worsen = json['worsen'],
        dname = json['D_code'],
        situation = json['situation'];
}
