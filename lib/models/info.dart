import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class Info {
  String location;
  String date;
  String weather;
  String situation;
  String worsen;
  String dname;
  int id;

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

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'location': location,
      'weather': weather,
      'date': date,
      'worsen': worsen,
      'dname': dname,
      'situation': situation,
    };
    if (id != null) {
      map['id'] = id.toString();
    }
    return map;
  }

  Info.fromMap(Map<String, dynamic> map) {
    location = map['location'];
    weather = map['weather'];
    date = map['date'];
    worsen = map['worsen'];
    dname = map['dname'];
    situation = map['situation'];
  }
}

class InfoProvider {
  Database db;

  final String infoTable = 'infos';
  String location = 'location';
  String date = 'date';
  String weather = 'weather';
  String situation = 'situation';
  String worsen = 'worsen';
  String dname = 'dname';
  String id = 'id';

  Future open(String path) async {
    String databasesPath = await getDatabasesPath();
    String dbpath = join(databasesPath, path);
    db = await openDatabase(dbpath, version: 1,
        onCreate: (Database db, int version) async {
      await db.execute('''
      CREATE TABLE IF NOT EXISTS $infoTable ( 
        $id integer primary key autoincrement, 
        $location text not null,
        $date text not null,
        $weather text ,
        $situation text ,
        $worsen text not null,
        $dname text not null
        )
      ''');
    });
  }

  Future<Info> insert(Info info) async {
    info.id = await db.insert(infoTable, info.toMap());
    return info;
  }

  Future<List<Info>> getRecords() async {
    List<Map> maps = await db.query(infoTable);
    if (maps.length > 0) {
      List<Info> records;
      maps.toList().forEach((info) {
        records.add(Info.fromMap(info));
        print(info.toString());
      });
      return records;
    }
    return null;
  }

  Future<Info> getAllRecord() async {
    List<Map> maps = await db.query(infoTable);
    if (maps.length > 0) {
      print(Info.fromMap(maps.first).toString());
      return Info.fromMap(maps.first);
    }
    return null;
  }

  Future<int> delete(int id) async {
    return await db.delete(infoTable, where: '$id = ?', whereArgs: [id]);
  }

  Future<int> update(Info info) async {
    return await db.update(infoTable, info.toMap(),
        where: '$id = ?', whereArgs: [info.id]);
  }

  Future close() async => db.close();
}
