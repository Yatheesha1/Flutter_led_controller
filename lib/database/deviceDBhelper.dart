import 'dart:async';
import 'dart:io' as io;
import 'package:ledcontroller/Data/device_data.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

class DeviceDBHelper {
  static Database _db;

  String tablename = "Devices";
  String databasename = "ledcontroller.db";
  String deviceid = "deviceid";
  String devicename = "devicename";
  String deviceuid = "deviceuid";
  String devicemodel = "devicemodel";
  String devicedone = "devicedone";

  Future<Database> get db async {
    if (_db != null) return _db;
    _db = await initDb();
    return _db;
  }

  initDb() async {
    io.Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, databasename);
    var theDb = await openDatabase(path, version: 1, onCreate: _onCreate);
    if (theDb != null)
      print("Table created");
    else
      print("Table not created");
    return theDb;
  }

  void _onCreate(Database db, int version) async {
    // When creating the db, create the table
    await db.execute('''CREATE TABLE 
        $tablename ($deviceid INTEGER PRIMARY KEY autoincrement, 
        $devicename TEXT, $devicemodel TEXT, $deviceuid TEXT NOT NULL UNIQUE, 
        $devicedone INTEGER)''');
  }

  Future<DeviceData> insertDeviceData(DeviceData deviceData) async {
    try {
      deviceData.id = await _db.insert(tablename, deviceData.toMap());
      return deviceData;
    } catch (e) {
      print("Error on inserting data");
    }
    return null;
  }

  Future<int> updateDeviceData(DeviceData deviceData) async {
    try {
      return await _db.update(tablename, deviceData.toMap(),
          where: "$deviceid = ?", whereArgs: [deviceData.id]);
    } catch (e) {
      print("Error on updating data");
    }
    return null;
  }

  Future<DeviceData> getDeviceData(int id) async {
    List<Map> maps = await _db.query(tablename,
        columns: [deviceid, devicename, deviceuid, devicemodel, devicedone],
        where: "$deviceid = ?",
        whereArgs: [id]);
    if (maps.length > 0) {
      return new DeviceData.fromMap(maps.first);
    }
    return null;
  }

  Future<List<DeviceData>> getDeviceDatas() async {
    var dbClient = await db;
    List<Map> list = await dbClient.rawQuery('SELECT * FROM $tablename');
    List<DeviceData> deviceDatas = new List();
    for (int i = 0; i < list.length; i++) {
      deviceDatas.add(DeviceData.fromMap(list[i]));
    }
    print(deviceDatas.length);
    return deviceDatas;
  }

  Future<int> deleteDeviceData(int id) async {
  try{
    return await _db.delete(tablename, where: "$deviceid = ?", whereArgs: [id]);
    }  catch (e) {
      print("Error on deleting data");
  }
    return null;
  
  }

  Future close() async => _db.close();
}
