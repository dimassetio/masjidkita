// import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:masjidkita/controllers/manMasjidController.dart';
import 'package:masjidkita/integrations/controllers.dart';
import 'package:masjidkita/routes/route_name.dart';
import 'package:masjidkita/screens/fitur/Kelola_Masjid/Dialog/FormNama.dart';
import 'package:masjidkita/screens/fitur/Kelola_Masjid/Dialog/cekLog.dart';
import 'package:masjidkita/screens/fitur/Kelola_Masjid/ManMasjid.dart';
import 'package:masjidkita/screens/utils/widgets/AddOrJoin.dart';
import 'package:masjidkita/screens/utils/widgets/FiturGridList.dart';
import 'package:nb_utils/nb_utils.dart';

class FiturController extends GetxController {
  fiturRouting(int index) {
    switch (index) {
      case 0:
        Get.toNamed(RouteName.man_masjid);
        break;
      case 1:
        if (authController.isLoggedIn.value == true) {
          manMasjidC.testdata();
          manMasjidC.haveMasjid.value
              ? Get.toNamed(RouteName.kelolamasjid)
              :
              // toast("GaDue Masjid");
              showDialog(
                  context: Get.context!,
                  builder: (BuildContext context) => AddOrJoin(),
                );
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
