import 'package:flutter/material.dart';
import 'package:get/get.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:masjidkita/controllers/authController.dart';
import 'package:masjidkita/controllers/fiturController.dart';
import 'package:masjidkita/controllers/infoMasjidController.dart';
import 'package:masjidkita/controllers/manMasjidController.dart';
import 'package:masjidkita/integrations/controllers.dart';
import 'package:masjidkita/routes/route_name.dart';
import 'package:masjidkita/screens/fitur/Kelola_Masjid/Dialog/cekLog.dart';
import 'package:masjidkita/screens/fitur/Kelola_Masjid/ManMasjid.dart';
import 'package:masjidkita/screens/utils/widgets/AddOrJoin.dart';

class InitBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(AuthController(), permanent: true);
    Get.lazyPut(() => FiturController());
    Get.lazyPut(() => ManMasjidController());
    Get.lazyPut(() => ManMasjidController());
    Get.lazyPut(() => InfoMasjidController());
  }
}

class InfoMasjidBinding extends Bindings {
  @override
  void dependencies() {
    Get.find<InfoMasjidController>();
  }
}
