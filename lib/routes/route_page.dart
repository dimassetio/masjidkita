import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mosq/integrations/binding.dart';
import 'package:mosq/modules/inventaris/models/inventaris_model.dart';
import 'package:mosq/modules/profile/views/Form_Profile.dart';
import 'package:mosq/screens/MosqDashboard.dart';
import 'package:mosq/screens/MosqProfile.dart';
import 'package:mosq/modules/masjid/views/index.dart';
import 'package:mosq/screens/authentication/MKSignIn.dart';
import 'package:mosq/screens/authentication/MKSignUp.dart';
import 'package:mosq/screens/fitur/Kelola_Masjid/Tab_Kegiatan/Form_Kegiatan.dart';
import 'package:mosq/modules/inventaris/views/Form_Inventaris.dart';
import 'package:mosq/screens/fitur/Kelola_Masjid/Tab_Kegiatan/TMTabKegiatan.dart';
// import 'package:mosq/screens/PageSiMasjid.dart';
import 'package:mosq/modules/masjid/views/show.dart';
import 'package:mosq/screens/fitur/Kelola_Masjid/Dialog/detailInventaris.dart';
import 'package:mosq/modules/takmir/views/detail.dart';
import 'package:mosq/modules/takmir/views/form_takmir.dart';
import './route_name.dart';

class AppPage {
  static final pages = [
    GetPage(name: RouteName.home, page: () => MosqDashboard()),
    GetPage(name: RouteName.sign_in, page: () => MKSignIn()),
    GetPage(name: RouteName.sign_up, page: () => MKSignUp()),
    GetPage(name: RouteName.profile, page: () => MosqProfile()),
    GetPage(name: RouteName.form_profile + '/:id', page: () => FormMasjid()),
    GetPage(name: RouteName.mkdashboard, page: () => PageListMasjid()),
    GetPage(name: RouteName.new_masjid, page: () => FormMasjid()),
    GetPage(name: RouteName.new_inventaris, page: () => FormInventaris()),
    GetPage(name: RouteName.new_kegiatan, page: () => FormKegiatan()),
    GetPage(name: RouteName.detail_inventaris, page: () => InventarisDetail()),
    // GetPage(
    //     name: RouteName.edit_inventaris + '/:id', page: () => FormInventaris()),
    GetPage(name: RouteName.edit_inventaris, page: () => FormInventaris()),
    GetPage(
        name: RouteName.list_masjid,
        page: () => PageListMasjid(),
        binding: ListMasjidBinding()),
    GetPage(
      name: RouteName.detail,
      page: () => DetailMasjid(),
    ),
    // GetPage(
    //     name: RouteName.inventaris,
    //     page: () => TMTabInventaris()),
    GetPage(name: RouteName.detail_kegiatan, page: () => TMTabKegiatan()),
    GetPage(name: RouteName.new_takmir, page: () => FormTakmir()),
    GetPage(name: RouteName.detail_takmir, page: () => DetailTakmir()),
    GetPage(
      name: RouteName.edit_takmir,
      page: () => FormTakmir(),
    ),
  ];
}
