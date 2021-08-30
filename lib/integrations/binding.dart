import 'package:flutter/material.dart';
import 'package:get/get.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:mosq/controllers/authController.dart';
import 'package:mosq/modules/inventaris/controllers/inventarisController.dart';
import 'package:mosq/controllers/kegiatanController.dart';
import 'package:mosq/controllers/takmirController.dart';

class InitBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(AuthController(), permanent: true);
    Get.lazyPut(() => InventarisController(), fenix: true);
    Get.lazyPut(() => KegiatanController(), fenix: true);
    Get.lazyPut(() => TakmirController(), fenix: true);
  }
}

class ListMasjidBinding extends Bindings {
  @override
  void dependencies() {
    // Get.put(MasjidController());
  }
}

class DetailMasjidBinding extends Bindings {
  @override
  void dependencies() {
    Get.find<InventarisController>();
    Get.find<TakmirController>();
  }
}
