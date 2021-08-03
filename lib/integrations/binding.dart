import 'package:flutter/material.dart';
import 'package:get/get.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:masjidkita/controllers/authController.dart';
import 'package:masjidkita/controllers/inventarisController.dart';
import 'package:masjidkita/controllers/kegiatanController.dart';
import 'package:masjidkita/controllers/listMasjidController.dart';
import 'package:masjidkita/controllers/manMasjidController.dart';

class InitBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(AuthController(), permanent: true);
    Get.lazyPut(() => ManMasjidController());
    Get.lazyPut(() => ManMasjidController());
    Get.lazyPut(() => ListMasjidController());
    Get.lazyPut(() => InventarisController());
    Get.lazyPut(() => KegiatanController());
  }
}

class ListMasjidBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(ListMasjidController());
    Get.put(InventarisController());
  }
}
