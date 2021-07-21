import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get_storage/get_storage.dart';
import 'package:masjidkita/models/manMasjid.dart';
import 'package:get/get.dart';
import 'package:masjidkita/integrations/firestore.dart';

class InfoMasjidController extends GetxController {
  static InfoMasjidController instance = Get.find();

  RxList<ListMasjidModel> listMasjid = RxList<ListMasjidModel>();

  List<ListMasjidModel> get masjids => listMasjid.value;

  RxList<FavoritMasjidModel> favoritMasjid = RxList<FavoritMasjidModel>();
  List<FavoritMasjidModel> get favMasjids => favoritMasjid.value;

  final box = GetStorage();

  @override
  void onInit() {
    super.onInit();
    listMasjid.bindStream(masjidStream());
    // favoritMasjid.bindStream(masjidFavoritStream());
    // ever(idFavorit,
    //     (callback) => favoritMasjid.bindStream(masjidFavoritStream()));
  }

  // RxList idFavorit = [].obs;

  addStr() {
    box.write('favMasjid', idFavorit);
  }

  deleteStr() {}
  readStr() {
    var r = box.read('favMasjid');
    print(r);
  }

  var idFavorit = [
    "P",
  ].obs;

  List<String> get idFav => idFavorit;
  Stream<List<ListMasjidModel>> masjidStream() {
    return firebaseFirestore
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
  }

  refreshFav() {
    favoritMasjid.bindStream(masjidFavoritStream());
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
      print(idFavorit);
      print(idFav);
      return retVal;
    });
  }
}
