import 'package:get/get.dart';
import 'package:mosq/integrations/binding.dart';
import 'package:mosq/models/inventaris.dart';
import 'package:mosq/screens/MosqDashboard.dart';
import 'package:mosq/screens/MosqProfile.dart';
import 'package:mosq/screens/PageListMasjid.dart';
import 'package:mosq/screens/authentication/MKSignIn.dart';
import 'package:mosq/screens/authentication/MKSignUp.dart';
import 'package:mosq/screens/fitur/Kelola_Masjid/Tab_Inventaris/Form_Inventaris.dart';
import 'package:mosq/screens/fitur/Kelola_Masjid/Tab_Profile/Form_Profile.dart';
// import 'package:mosq/screens/PageSiMasjid.dart';
import 'package:mosq/screens/fitur/Kelola_Masjid/DetailMasjid.dart';
import 'package:mosq/screens/fitur/Kelola_Masjid/Tab_Inventaris/TMTabInventaris.dart';
import 'package:mosq/screens/fitur/Kelola_Masjid/Dialog/detailInventaris.dart';
import './route_name.dart';

class AppPage {
  static final pages = [
    GetPage(name: RouteName.home, page: () => MosqDashboard()),
    GetPage(name: RouteName.sign_in, page: () => T5SignIn()),
    GetPage(name: RouteName.sign_up, page: () => T5SignUp()),
    GetPage(name: RouteName.profile, page: () => MosqProfile()),
    GetPage(name: RouteName.form_profile + '/:id', page: () => FormProfile()),
    GetPage(name: RouteName.mkdashboard, page: () => PageListMasjid()),
    GetPage(name: RouteName.new_masjid, page: () => FormProfile()),
    GetPage(name: RouteName.new_inventaris, page: () => FormInventaris()),
    GetPage(name: RouteName.detail_inventaris, page: () => InventarisDetail()),
    GetPage(name: RouteName.edit_inventaris, page: () => FormInventaris()),
    GetPage(
        name: RouteName.list_masjid,
        page: () => PageListMasjid(),
        binding: ListMasjidBinding()),
    GetPage(
      name: RouteName.kelolamasjid,
      page: () => KeMasjid(),
      // binding: KeMasjidBinding(),
    ),
    GetPage(name: RouteName.detail, page: () => KeMasjid()),
    GetPage(
        name: RouteName.inventaris,
        page: () => TMTabInventaris(InventarisModel())),
  ];
}
