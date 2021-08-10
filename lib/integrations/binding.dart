import 'package:flutter/material.dart';
import 'package:get/get.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:mosq/controllers/authController.dart';
import 'package:mosq/controllers/inventarisController.dart';
import 'package:mosq/controllers/kegiatanController.dart';
import 'package:mosq/controllers/listMasjidController.dart';
import 'package:mosq/controllers/manMasjidController.dart';

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
