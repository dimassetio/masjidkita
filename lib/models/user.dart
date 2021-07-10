import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  static const ID = "id";
  static const NAME = "name";
  static const EMAIL = "email";
  static const ROLE = "role";
  static const LASTLOGIN = "last_login";

  String? id;
  String? name;
  String? email;
  String? role;
  // String last_login;

  UserModel({this.id, this.name, this.email, this.role});

  UserModel.fromSnapshot(DocumentSnapshot snapshot) {
    name = snapshot[NAME];
    email = snapshot[EMAIL];
    id = snapshot[ID];
    role = snapshot[ROLE];
    // last_login = snapshot.data()[LASTLOGIN];
  }
}
