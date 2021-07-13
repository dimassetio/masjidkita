// import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:masjidkita/controllers/keMasjidController.dart';
import 'package:masjidkita/integrations/controllers.dart';
import 'package:masjidkita/routes/route_name.dart';
import 'package:masjidkita/screens/fitur/Kelola_Masjid/Dialog/FormNama.dart';
import 'package:masjidkita/screens/fitur/Kelola_Masjid/Dialog/cekLog.dart';
import 'package:masjidkita/screens/utils/widgets/FiturGridList.dart';
import 'package:nb_utils/nb_utils.dart';

class FiturController extends GetxController {
  fiturRouting(int index) {
    switch (index) {
      case 0:
        Get.toNamed(RouteName.mkdashboard);
        break;
      case 1:
        // Get.toNamed(RouteName.kelolamasjid);
        if (authController.isLoggedIn.value == true) {
          // Get.toNamed(RouteName.kelolamasjid);
          Get.put(KeMasjidController());
        } else {
          showDialog(
            context: Get.context!,
            builder: (BuildContext context) => CekLogin(),
          );
        }
        break;
      default:
        toast("Fitur on Progress");
        break;
    }
  }
}
