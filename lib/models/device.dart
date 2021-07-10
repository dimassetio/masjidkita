class DeviceModel {
  static const ID = "id";
  static const NAME = "name";
  static const OS = "os";
  static const TOKEN = "token";
  static const LOCATION = "location";

  String? id;
  String? name;
  String? os;
  String? token;
  Map? location;

  DeviceModel({this.id, this.name, this.os, this.token, this.location});
}
