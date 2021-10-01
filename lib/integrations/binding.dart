import 'package:flutter/material.dart';
import 'package:get/get.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:mosq/controllers/authController.dart';
import 'package:mosq/modules/inventaris/controllers/inventaris_controller.dart';
import 'package:mosq/modules/kas/buku/controllers/kas_controller.dart';
import 'package:mosq/modules/kas/transaksi/controllers/transaksi_controller.dart';
import 'package:mosq/modules/kas/kategori/controllers/kategori_controller.dart';
import 'package:mosq/modules/kegiatan/controllers/kegiatan_controller.dart';
import 'package:mosq/modules/masjid/controllers/masjid_controller.dart';
import 'package:mosq/modules/profile/controllers/profile_controller.dart';
import 'package:mosq/modules/takmir/controllers/takmir_controller.dart';

class InitBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(AuthController(), permanent: true);
    Get.lazyPut(() => MasjidController());
    Get.lazyPut(() => KasController());
    Get.lazyPut(() => TransaksiController());
    Get.lazyPut(() => InventarisController());
    Get.lazyPut(() => KegiatanController());
    Get.lazyPut(() => KategoriController());
    Get.lazyPut(() => TakmirController());
    Get.lazyPut(() => ProfilController());
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
    Get.find<TransaksiController>();
    Get.find<KategoriController>();
  }
}
