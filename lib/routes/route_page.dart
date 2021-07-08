import 'package:get/get.dart';
import 'package:masjidkita/screens/DetailMasjid.dart';
import 'package:masjidkita/screens/MKDashboard.dart';
import 'package:masjidkita/screens/MKSignUp.dart';
import 'package:masjidkita/screens/MKSignIn.dart';
import './route_name.dart';

class AppPage {
  static final pages = [
    GetPage(name: RouteName.sign_in, page: () => T5SignIn()),
    GetPage(name: RouteName.sign_up, page: () => T5SignUp()),
    GetPage(name: RouteName.dashboard, page: () => MKDashboard()),
    GetPage(name: RouteName.detail, page: () => DetailMasjid()),
  ];
}
