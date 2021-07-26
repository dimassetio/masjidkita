import 'package:get/get.dart';
import 'package:masjidkita/integrations/binding.dart';
import 'package:masjidkita/main.dart';
import 'package:masjidkita/models/inventaris.dart';
import 'package:masjidkita/screens/DetailMasjid.dart';
import 'package:masjidkita/screens/MKSignUp.dart';
import 'package:masjidkita/screens/MKSignIn.dart';
import 'package:masjidkita/screens/MosqDashboard.dart';
import 'package:masjidkita/screens/MosqProfile.dart';
import 'package:masjidkita/screens/PageMasjid.dart';
import 'package:masjidkita/screens/PageSiMasjid.dart';
import 'package:masjidkita/screens/fitur/Kelola_Masjid/Dialog/FormAddInventaris.dart';
import 'package:masjidkita/screens/fitur/Kelola_Masjid/KeMasjid.dart';
import 'package:masjidkita/screens/fitur/Kelola_Masjid/ManMasjid.dart';
import 'package:masjidkita/screens/utils/widgets/NewMasjid.dart';
import 'package:masjidkita/screens/fitur/Kelola_Masjid/TMTabInventaris.dart';
import 'package:masjidkita/screens/fitur/Kelola_Masjid/Dialog/detailInventaris.dart';
import 'package:masjidkita/screens/fitur/Kelola_Masjid/Dialog/editInventaris.dart';
import './route_name.dart';

class AppPage {
  static final pages = [
    GetPage(name: RouteName.home, page: () => MosqDashboard()),
    GetPage(name: RouteName.sign_in, page: () => T5SignIn()),
    GetPage(name: RouteName.sign_up, page: () => T5SignUp()),
    GetPage(name: RouteName.profile, page: () => MosqProfile()),
    GetPage(name: RouteName.mkdashboard, page: () => PageSiMasjid()),
    GetPage(name: RouteName.man_masjid, page: () => ManMasjid()),
    GetPage(name: RouteName.new_masjid, page: () => NewMasjid()),
    GetPage(name: RouteName.new_inventaris, page: () => AddInventarisPage()),
    GetPage(name: RouteName.detail_inventaris, page: () => InventarisDetail()),
    GetPage(name: RouteName.edit_inventaris, page: () => InventarisEdit()),
    GetPage(
        name: RouteName.info_masjid,
        page: () => PageSiMasjid(),
        binding: InfoMasjidBinding()),
    GetPage(
      name: RouteName.kelolamasjid,
      page: () => KeMasjid(),
      // binding: KeMasjidBinding(),
    ),
    GetPage(name: RouteName.detail, page: () => DetailMasjid()),
    GetPage(
        name: RouteName.inventaris,
        page: () => TMTabInventaris(InventarisModel())),
  ];
}
