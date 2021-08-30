import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  static const ID = "id";
  static const NAME = "name";
  static const EMAIL = "email";
  static const ROLE = "role";
  static const MASJID = "masjid";
  static const LASTLOGIN = "last_login";

  String? id;
  String? name;
  String? email;
  String? role;
  String? masjid;
  // String last_login;

  UserModel({this.id, this.name, this.email, this.role, this.masjid});

  UserModel.fromSnapshot(DocumentSnapshot snapshot) {
    name = snapshot.data()?[NAME];
    email = snapshot.data()?[EMAIL];
    id = snapshot.data()?[ID];
    role = snapshot.data()?[ROLE];
    masjid = snapshot.data()?[MASJID];
    // last_login = snapshot.data()[LASTLOGIN];
  }
}
