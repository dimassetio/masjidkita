import 'package:get/get.dart';
import 'package:masjidkita/integrations/binding.dart';
import 'package:masjidkita/main.dart';
import 'package:masjidkita/screens/DetailMasjid.dart';
import 'package:masjidkita/screens/MKSignUp.dart';
import 'package:masjidkita/screens/MKSignIn.dart';
import 'package:masjidkita/screens/MosqDashboard.dart';
import 'package:masjidkita/screens/MosqProfile.dart';
import 'package:masjidkita/screens/PageMasjid.dart';
import 'package:masjidkita/screens/PageListMasjid.dart';
import 'package:masjidkita/screens/fitur/Kelola_Masjid/KeMasjid.dart';
import 'package:masjidkita/screens/fitur/Kelola_Masjid/ManMasjid.dart';
import 'package:masjidkita/screens/utils/widgets/NewMasjid.dart';
import './route_name.dart';

class AppPage {
  static final pages = [
    GetPage(name: RouteName.home, page: () => MosqDashboard()),
    GetPage(name: RouteName.sign_in, page: () => T5SignIn()),
    GetPage(name: RouteName.sign_up, page: () => T5SignUp()),
    GetPage(name: RouteName.profile, page: () => MosqProfile()),
    GetPage(name: RouteName.mkdashboard, page: () => PageListMasjid()),
    GetPage(name: RouteName.man_masjid, page: () => ManMasjid()),
    GetPage(name: RouteName.new_masjid, page: () => NewMasjid()),
    GetPage(
        name: RouteName.list_masjid,
        page: () => PageListMasjid(),
        binding: ListMasjidBinding()),
    GetPage(
      name: RouteName.kelolamasjid,
      page: () => KeMasjid(),
      // binding: KeMasjidBinding(),
    ),
    GetPage(name: RouteName.detail, page: () => DetailMasjid()),
  ];
}
