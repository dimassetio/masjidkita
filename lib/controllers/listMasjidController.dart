import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:masjidkita/models/manMasjid.dart';
import 'package:get/get.dart';
import 'package:masjidkita/integrations/firestore.dart';
import 'package:masjidkita/screens/utils/MKStrings.dart';
import 'package:nb_utils/nb_utils.dart';

class ListMasjidController extends GetxController {
  static ListMasjidController instance = Get.find();

  RxList<ListMasjidModel> listMasjid = RxList<ListMasjidModel>();
  List<ListMasjidModel> get masjids => listMasjid.value;

  // Rx<ListMasjidModel> selectMasjid = ListMasjidModel().obs;
  // ListMasjidModel get selected => selectMasjid.value;

  RxList<FavoritMasjidModel> favoritMasjid = RxList<FavoritMasjidModel>();
  List<FavoritMasjidModel> get favMasjids => favoritMasjid.value;

  RxList<ListMasjidModel> resultsList = RxList<ListMasjidModel>();
  List<ListMasjidModel> get filteredMasjid => resultsList.value;

  Rx<TextEditingController> rxSearchController = TextEditingController().obs;
  TextEditingController get searchController => rxSearchController.value;
  set searchController(TextEditingController value) =>
      this.rxSearchController.value = value;

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
    getInitialMasjid();
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
    searchResultsList();
  }

  searchResultsList() {
    List<ListMasjidModel> showResults = [];

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

  getInitialMasjid() async {
    await firebaseFirestore
        .collection(masjidCollection)
        .orderBy('nama')
        .get()
        .then((value) => value.docs.forEach((element) {
              listMasjid.add(ListMasjidModel.fromDocumentSnapshot(element));
            }));
    searchResultsList();
  }

  Stream<List<ListMasjidModel>> masjidStream() async* {
    yield* firebaseFirestore
        .collection(masjidCollection)
        .orderBy('nama')
        .snapshots()
        .map((QuerySnapshot query) {
      List<ListMasjidModel> retVal = [];
      query.docs.forEach((element) {
        retVal.add(ListMasjidModel.fromDocumentSnapshot(element));
      });
      return retVal;
    });
    searchResultsList();
  }

  Stream<List<FavoritMasjidModel>> masjidFavoritStream() {
    // var idFav = idFavorit.value;
    return firebaseFirestore
        .collection(masjidCollection)
        .where("id", whereIn: idFav)
        .snapshots()
        .map((QuerySnapshot query) {
      List<FavoritMasjidModel> retVal = [];
      query.docs.forEach((element) {
        retVal.add(FavoritMasjidModel.fromDocumentSnapshot(element));
      });
      return retVal;
    });
  }
}
