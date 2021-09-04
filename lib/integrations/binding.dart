import 'package:flutter/material.dart';
import 'package:get/get.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:mosq/controllers/authController.dart';
import 'package:mosq/modules/inventaris/controllers/inventaris_controller.dart';
import 'package:mosq/controllers/kegiatanController.dart';
import 'package:mosq/modules/kas/controllers/kas_controller.dart';
import 'package:mosq/modules/masjid/controllers/masjid_controller.dart';
import 'package:mosq/modules/takmir/controllers/takmir_controller.dart';

class InitBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(AuthController(), permanent: true);
    Get.lazyPut(() => MasjidController());
    Get.lazyPut(() => InventarisController(), fenix: true);
    Get.lazyPut(() => KegiatanController(), fenix: true);
    Get.lazyPut(() => TakmirController(), fenix: true);
    Get.lazyPut(() => KasController(), fenix: true);
  }
}

class ListMasjidBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(MasjidController());
  }
}

class DetailMasjidBinding extends Bindings {
  @override
  void dependencies() {
    Get.find<InventarisController>();
    Get.find<TakmirController>();
    Get.find<KasController>();
  }
}
