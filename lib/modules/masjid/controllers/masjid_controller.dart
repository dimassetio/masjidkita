import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mosq/modules/masjid/models/masjid_model.dart';
import 'package:get/get.dart';
import 'package:mosq/integrations/firestore.dart';
import 'package:mosq/integrations/controllers.dart';
import 'package:mosq/routes/route_name.dart';
import 'package:nb_utils/nb_utils.dart';

class MasjidController extends GetxController {
  static MasjidController instance = Get.find();

  RxList<MasjidModel> _masjids = RxList<MasjidModel>();
  List<MasjidModel> get masjids => _masjids.value;

  RxList<MasjidModel> favoritMasjid = RxList<MasjidModel>();
  List<MasjidModel> get favMasjids => favoritMasjid.value;

  RxList<MasjidModel> resultsList = RxList<MasjidModel>();
  List<MasjidModel> get filteredMasjid => resultsList.value;

  var _currMasjid = MasjidModel().obs;
  MasjidModel get currMasjid => _currMasjid.value;
  set currMasjid(MasjidModel value) => this._currMasjid.value = value;

  TextEditingController searchController = TextEditingController();

  var isSearching = false.obs;
  final box = GetStorage();

  var idFavorit = [
    "Null Safety",
  ].obs;

  var emptyValue = false.obs;
  var myMasjid = false.obs;

  List<String> get idFav => idFavorit;

  @override
  void onInit() async {
    super.onInit();
    // getInitialMasjid();
    _masjids.bindStream(MasjidModel().dao.masjidStream());
    searchController.addListener(_onSearchChanged);
    readStr();
  }

  @override
  void onClose() {
    super.onClose();
    searchController.clear();
  }

  clearController() {
    searchController.clear();
  }

  _onSearchChanged() {
    if (searchController.text == "") {
      isSearching.value = false;
    } else {
      isSearching.value = true;
    }
    searchResultsList();
  }

  searchResultsList() {
    List<MasjidModel> showResults = [];

    if (searchController.text != "") {
      for (var masjidSnapshot in masjids) {
        var nama = masjidSnapshot.nama!.toLowerCase();
        var alamat = masjidSnapshot.alamat!.toLowerCase();

        if (alamat.contains(searchController.text.toLowerCase()) ||
            nama.contains(searchController.text.toLowerCase())) {
          showResults.add(masjidSnapshot);
          emptyValue.value = false;
        } else {
          emptyValue.value = true;
        }
        // if (nama.contains(searchController.text.toLowerCase())) {
        //   showResults.add(masjidSnapshot);
        // }
      }
    } else {
      // showResults = masjids;
    }

    resultsList.value = showResults;
  }

  isMyFav(id) {
    return idFavorit.contains(id);
  }

  addFav(id) {
    idFavorit.contains(id) ? idFavorit.remove(id) : idFavorit.add(id);
    addStr();
    print(idFav);
  }

  addStr() {
    box.write('favMasjid', idFavorit);
    refreshFav();
  }

  deleteStr() {
    box.remove('favMasjid');
  }

  readStr() {
    var r = box.read('favMasjid');
    if (r != null) {
      idFavorit.value = List.from(r);
    }
    // print(r);
    // print([idFav, "p"]);
    refreshFav();
  }

  refreshFav() {
    // idFavorit.value = [];
    // print(idFav);
    favoritMasjid.bindStream(masjidFavoritStream());
  }

  Stream<List<MasjidModel>> masjidFavoritStream() {
    return firebaseFirestore
        .collection(masjidCollection)
        .where("id", whereIn: idFav)
        .snapshots()
        .map((QuerySnapshot query) {
      List<MasjidModel> retVal = [];
      query.docs.forEach((element) {
        retVal.add(MasjidModel().fromSnapshot(element));
      });
      return retVal;
    });
  }

  gotoDetail(MasjidModel dataMasjid) async {
    try {
      takmirC.getTakmirStream(dataMasjid);
      inventarisC.getInventarisStream(dataMasjid);
      kasC.getKasStream(dataMasjid);
      kategoriC.getKategoriStream(dataMasjid);
      kegiatanC.getKegiatanStream(dataMasjid);
      transaksiC.getTransaksiStream(dataMasjid);
    } catch (e) {
      toast(e.toString());
    } finally {
      await isMyMasjid(dataMasjid);
      _currMasjid.bindStream(dataMasjid.dao.streamDetailMasjid(dataMasjid.id!));
      await Get.toNamed(RouteName.detail, arguments: dataMasjid);
    }
  }

  isMyMasjid(MasjidModel masjid) {
    authController.user.masjid != null
        ? masjid.id == authController.user.masjid
            ? myMasjid.value = true
            : myMasjid.value = false
        : myMasjid.value = false;
  }
}
