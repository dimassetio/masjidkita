import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:masjidkita/controllers/authController.dart';
import 'package:masjidkita/integrations/controllers.dart';
import 'package:masjidkita/models/manMasjid.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:masjidkita/integrations/firestore.dart';
import 'package:masjidkita/models/user.dart';
import 'package:masjidkita/routes/route_name.dart';
import 'package:masjidkita/screens/fitur/Kelola_Masjid/Dialog/cekLog.dart';
import 'package:masjidkita/screens/utils/widgets/AddOrJoin.dart';
import 'package:nb_utils/nb_utils.dart';

class ManMasjidController extends GetxController {
  static ManMasjidController instance = Get.find();

  TextEditingController nama = TextEditingController();
  TextEditingController alamat = TextEditingController();
  // TextEditingController photo_url = TextEditingController();
  TextEditingController deskripsi = TextEditingController();
  TextEditingController kecamatan = TextEditingController();
  TextEditingController kodePos = TextEditingController();
  TextEditingController kota = TextEditingController();
  TextEditingController provinsi = TextEditingController();
  TextEditingController tahun = TextEditingController();
  TextEditingController luasTanah = TextEditingController();
  TextEditingController luasBangunan = TextEditingController();
  TextEditingController statusTanah = TextEditingController();
  TextEditingController legalitas = TextEditingController();

  Rx<ManMasjidModel> keMasjidModel = ManMasjidModel().obs;
  ManMasjidModel get keMasjid => keMasjidModel.value;
  set keMasjid(ManMasjidModel value) => this.keMasjidModel.value = value;

  var haveMasjid = false.obs;

  @override
  void onReady() {
    super.onReady();
    // _getManMasjidModel();
    // ever(authController.firebaseUser, _getManMasjidModel);
    ever(authController.userModel, _getManMasjidModel);
  }

  testdata() {
    // clear();
    return _getManMasjidModel(authController.user);
    // _setHaveMasjid();
  }

  void clear() {
    keMasjidModel.value = ManMasjidModel();
  }

  _setHaveMasjid() {
    if (keMasjid.nama == null) {
      haveMasjid.value = false;
    } else {
      haveMasjid.value = true;
    }
    print(haveMasjid.value);
  }

  addMasjidToFirestore(String userId) async {
    await firebaseFirestore.collection(masjidCollection).doc(userId).set({
      "nama": nama.text.trim(),
      "id": userId,
      "alamat": alamat.text.trim(),
      "photoUrl": "",
    });
    await firebaseFirestore.collection(usersCollection).doc(userId).update({
      "masjid": userId,
    });
    await _getManMasjidModel(authController.user);
    clearControllers();
  }

  updateDataMasjid() async {
    Map<String, dynamic> data = new HashMap();
    if (nama.text != "") data['nama'] = nama.text;
    if (alamat.text != "") data["alamat"] = alamat.text;
    // if (photoUrl != null) data["photoUrl"] = "";
    if (deskripsi.text != "") data["deskripsi"] = deskripsi.text;
    if (kecamatan.text != "") data["kecamatan"] = kecamatan.text;
    if (kodePos.text != "") data["kodePos"] = kodePos.text;
    if (kota.text != "") data["kota"] = kota.text;
    if (provinsi.text != "") data["provinsi"] = provinsi.text;
    if (tahun.text != "") data["tahun"] = tahun.text;
    if (luasTanah.text != "") data["luasTanah"] = luasTanah.text;
    if (luasBangunan.text != "") data["luasBangunan"] = luasBangunan.text;
    if (statusTanah.text != "") data["statusTanah"] = statusTanah.text;
    if (legalitas.text != "") data["legalitas"] = legalitas.text;
    print(data);
    await firebaseFirestore
        .collection(masjidCollection)
        .doc(keMasjid.id)
        .update(data);
    await _getManMasjidModel(keMasjid);
  }

  _getManMasjidModel(userModel) async {
    try {
      keMasjidModel.value = await firebaseFirestore
          .collection(masjidCollection)
          .doc(authController.user.masjid)
          .get()
          .then((doc) => ManMasjidModel.fromSnapshot(doc));
    } catch (e) {
      keMasjidModel.value = ManMasjidModel();
    }
    _setHaveMasjid();
  }

  clearControllers() {
    nama.clear();
    alamat.clear();
    deskripsi.clear();
    kecamatan.clear();
    kodePos.clear();
    kota.clear();
    provinsi.clear();
    tahun.clear();
    luasTanah.clear();
    luasBangunan.clear();
    statusTanah.clear();
    legalitas.clear();
    // photo_url.clear();
  }
}
