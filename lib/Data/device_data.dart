final String devicename = "devicename";
final String deviceuid = "deviceuid";
final String devicemodel = "devicemodel";
final String devicedone = "devicedone";
final String deviceid = "deviceid";

class DeviceData {
  String name;
  String uid;
  String model;
  bool done;
  int id;
  static final columns = [
    deviceid,
    devicename,
    devicemodel,
    deviceuid,
    devicedone
  ];

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      devicename: name,
      deviceuid: uid,
      devicemodel: model,
      devicedone: done == true ? 1 : 0
    };
    if (id != null) {
      map[deviceid] = id;
    }
    return map;
  }

  DeviceData();

  DeviceData.fromMap(Map<String, dynamic> map) {
    id = map[deviceid];
    name = map[devicename];
    uid = map[deviceuid];
    model = map[devicemodel];
    done = map[devicedone] == 1;
  }
}
