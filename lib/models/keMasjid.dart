import 'package:cloud_firestore/cloud_firestore.dart';

class KeMasjidModel {
  static const ID = "id";
  static const NAMA = "nama";
  static const ALAMAT = "alamat";
  static const LASTLOGIN = "last_login";
  static const PHOTOURL = "pohoto_url";

  String? id;
  String? nama;
  String? alamat;
  // String? photo_url;

  KeMasjidModel({this.id, this.nama, this.alamat});

  KeMasjidModel.fromSnapshot(DocumentSnapshot snapshot) {
    nama = snapshot[NAMA];
    alamat = snapshot[ALAMAT];
    id = snapshot[ID];
    // photo_url = snapshot[PHOTOURL];
  }
}
