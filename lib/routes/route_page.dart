import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mosq/integrations/binding.dart';
import 'package:mosq/models/inventaris.dart';
import 'package:mosq/screens/MosqDashboard.dart';
import 'package:mosq/screens/MosqProfile.dart';
import 'package:mosq/screens/PageListMasjid.dart';
import 'package:mosq/screens/authentication/MKSignIn.dart';
import 'package:mosq/screens/authentication/MKSignUp.dart';
import 'package:mosq/screens/fitur/Kelola_Masjid/Tab_Kegiatan/Form_Kegiatan.dart';
import 'package:mosq/screens/fitur/Kelola_Masjid/Tab_Inventaris/Form_Inventaris.dart';
import 'package:mosq/screens/fitur/Kelola_Masjid/Tab_Kegiatan/TMTabKegiatan.dart';
import 'package:mosq/screens/fitur/Kelola_Masjid/Tab_Profile/create.dart';
import 'package:mosq/screens/fitur/Kelola_Masjid/Tab_Profile/edit.dart';
// import 'package:mosq/screens/PageSiMasjid.dart';
import 'package:mosq/screens/fitur/Kelola_Masjid/DetailMasjid.dart';
import 'package:mosq/screens/fitur/Kelola_Masjid/Tab_Inventaris/TMTabInventaris.dart';
import 'package:mosq/screens/fitur/Kelola_Masjid/Dialog/detailInventaris.dart';
import 'package:mosq/screens/fitur/Kelola_Masjid/Tab_Takmir/detail.dart';
import 'package:mosq/screens/fitur/Kelola_Masjid/Tab_Takmir/form_takmir.dart';
import './route_name.dart';

class AppPage {
  static final pages = [
    GetPage(name: RouteName.home, page: () => MosqDashboard()),
    GetPage(name: RouteName.sign_in, page: () => MKSignIn()),
    GetPage(name: RouteName.sign_up, page: () => MKSignUp()),
    GetPage(name: RouteName.profile, page: () => MosqProfile()),
    GetPage(name: RouteName.form_profile + '/:id', page: () => EditProfile()),
    GetPage(name: RouteName.mkdashboard, page: () => PageListMasjid()),
    GetPage(name: RouteName.new_masjid, page: () => NewProfile()),
    GetPage(name: RouteName.new_inventaris, page: () => FormInventaris()),
    GetPage(name: RouteName.new_kegiatan, page: () => FormKegiatan()),
    GetPage(name: RouteName.detail_inventaris, page: () => InventarisDetail()),
    GetPage(
        name: RouteName.edit_inventaris + '/:id', page: () => FormInventaris()),
    GetPage(
        name: RouteName.list_masjid,
        page: () => PageListMasjid(),
        binding: ListMasjidBinding()),
    GetPage(
      name: RouteName.detail,
      page: () => KeMasjid(),
    ),
    GetPage(
        name: RouteName.inventaris,
        page: () => TMTabInventaris(InventarisModel())),
    GetPage(name: RouteName.detail_kegiatan, page: () => TMTabKegiatan()),
    GetPage(name: RouteName.new_takmir, page: () => FormTakmir()),
    GetPage(name: RouteName.detail_takmir, page: () => DetailTakmir()),
    GetPage(
      name: RouteName.edit_takmir,
      page: () => FormTakmir(),
    ),
  ];
}
