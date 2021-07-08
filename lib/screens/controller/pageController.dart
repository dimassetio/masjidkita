import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:masjidkita/screens/PageHome.dart';
import 'package:masjidkita/screens/PageMasjid.dart';
import 'package:masjidkita/screens/PageProfile.dart';
import 'package:masjidkita/screens/model/MasjidModels.dart';
import 'package:masjidkita/screens/utils/MKImages.dart';

class PagexController extends GetxController {
  var page = 0.obs;
  var mListing = [].obs;
  @override
  void onInit() {
    mListing.value = getList();
  }

  getPage() {
    switch (page.value) {
      case 0:
        return PageHome();
      case 1:
        return PageMasjid();
      case 2:
        return PageProfile();
      default:
        return Center(child: CircularProgressIndicator());
    }
  }

  List<MasjidCardModel> getList() {
    List<MasjidCardModel> list = [];
    MasjidCardModel model = MasjidCardModel();
    model.nama = "Nama Masjid";
    model.image = mk_contoh_image;
    model.kota = "Kota";

    MasjidCardModel model1 = MasjidCardModel();
    model1.nama = "Nama Masjid";
    model1.kota = "Kota";
    model1.image = mk_contoh_image;

    MasjidCardModel model2 = MasjidCardModel();
    model2.nama = "Nama Masjid";
    model2.kota = "Kota";
    model2.image = mk_contoh_image;

    MasjidCardModel model3 = MasjidCardModel();
    model3.nama = "Nama Masjid";
    model3.kota = "Kota";
    model3.image = mk_contoh_image;

    MasjidCardModel model4 = MasjidCardModel();
    model4.nama = "Nama Masjid";
    model4.kota = "Kota";
    model4.image = mk_contoh_image;

    list.add(model);
    list.add(model1);
    list.add(model3);
    list.add(model2);
    list.add(model4);

    return list;
  }
}
