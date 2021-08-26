import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mosq/models/masjid.dart';
import 'package:get/get.dart';
import 'package:mosq/integrations/firestore.dart';

class ListMasjidController extends GetxController {
  static ListMasjidController instance = Get.find();

  RxList<MasjidModel> listMasjid = RxList<MasjidModel>();
  List<MasjidModel> get masjids => listMasjid.value;

  // Rx<MasjidModel> selectMasjid = MasjidModel().obs;
  // MasjidModel get selected => selectMasjid.value;

  RxList<MasjidModel> favoritMasjid = RxList<MasjidModel>();
  List<MasjidModel> get favMasjids => favoritMasjid.value;

  RxList<MasjidModel> resultsList = RxList<MasjidModel>();
  List<MasjidModel> get filteredMasjid => resultsList.value;

  TextEditingController searchController = TextEditingController();
  // Rx<TextEditingController> rxSearchController = TextEditingController().obs;
  // TextEditingController get searchController => rxSearchController.value;
  // set searchController(TextEditingController value) =>
  //     this.rxSearchController.value = value;

  var isSearching = false.obs;
  final box = GetStorage();

  // selectById(String id) {
  //   selectMasjid.value = listMasjid.firstWhere((element) => element.id == id);
  // }

  var idFavorit = [
    "Null Safety",
  ].obs;

  var emptyValue = false.obs;

  List<String> get idFav => idFavorit;

  @override
  void onInit() async {
    super.onInit();
    // getInitialMasjid();
    listMasjid.bindStream(masjidStream());
    searchController.addListener(_onSearchChanged);
    readStr();
    // favoritMasjid.bindStream(masjidFavoritStream());
    // ever(listMasjid, )
    // ever(idFavorit,
    //     (callback) => favoritMasjid.bindStream(masjidFavoritStream()));
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

  // RxList idFavorit = [].obs;
  // getIdFavorit() {
  //   idFavorit.value = box.read('favMasjid');
  // }

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

  // getInitialMasjid() async {
  //   await firebaseFirestore
  //       .collection(masjidCollection)
  //       .orderBy('nama')
  //       .get()
  //       .then((value) => value.docs.forEach((element) {
  //             listMasjid.add(MasjidModel.fromDocumentSnapshot(element));
  //           }));
  //   searchResultsList();
  // }

  Stream<List<MasjidModel>> masjidStream() async* {
    yield* firebaseFirestore
        .collection(masjidCollection)
        .orderBy('nama')
        .snapshots()
        .map((QuerySnapshot query) {
      List<MasjidModel> retVal = [];
      query.docs.forEach((element) {
        retVal.add(MasjidModel.fromSnapshot(element));
      });
      return retVal;
    });
    searchResultsList();
  }

  Stream<List<MasjidModel>> masjidFavoritStream() {
    // var idFav = idFavorit.value;
    return firebaseFirestore
        .collection(masjidCollection)
        .where("id", whereIn: idFav)
        .snapshots()
        .map((QuerySnapshot query) {
      List<MasjidModel> retVal = [];
      query.docs.forEach((element) {
        retVal.add(MasjidModel.fromSnapshot(element));
      });
      return retVal;
    });
  }
}
