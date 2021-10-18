import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mosq/integrations/binding.dart';
import 'package:mosq/modules/kas/kategori/views/index.dart';
import 'package:mosq/modules/kas/transaksi/views/all_transaksi.dart';
import 'package:mosq/modules/kas/transaksi/views/detail.dart';
import 'package:mosq/modules/kas/buku/views/show_kas.dart';
import 'package:mosq/modules/kas/buku/views/form_kas.dart';
import 'package:mosq/modules/kas/kategori/views/form_kategori.dart';
import 'package:mosq/modules/kas/transaksi/views/form_transaksi.dart';
import 'package:mosq/modules/kegiatan/views/show.dart';
import 'package:mosq/modules/kegiatan/views/show.dart';
import 'package:mosq/modules/kas/buku/views/form_kas.dart';
import 'package:mosq/modules/profile/views/Form_Profile.dart';
import 'package:mosq/modules/takmir/views/form_takmir.dart';
import 'package:mosq/screens/MosqDashboard.dart';
import 'package:mosq/screens/MosqProfile.dart';
import 'package:mosq/modules/masjid/views/index.dart';
import 'package:mosq/screens/authentication/MKSignIn.dart';
import 'package:mosq/screens/authentication/MKSignUp.dart';
import 'package:mosq/modules/inventaris/views/form.dart';
import 'package:mosq/modules/masjid/views/show.dart';
import 'package:mosq/modules/inventaris/views/show.dart';
import 'package:mosq/modules/takmir/views/show.dart';
import 'package:mosq/modules/kegiatan/views/form_kegiatan.dart';
import 'package:mosq/screens/authentication/Verification.dart';
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
    GetPage(name: RouteName.edit_kegiatan, page: () => FormKegiatan()),
    GetPage(name: RouteName.detail_inventaris, page: () => InventarisDetail()),
    GetPage(name: RouteName.edit_inventaris, page: () => FormInventaris()),
    GetPage(name: RouteName.new_kas, page: () => FormKas()),
    GetPage(name: RouteName.edit_kas, page: () => FormKas()),
    GetPage(name: RouteName.transaksi, page: () => Transaksies()),
    GetPage(name: RouteName.new_transaksi, page: () => FormTransaksi()),
    GetPage(name: RouteName.edit_transaksi, page: () => FormTransaksi()),
    GetPage(name: RouteName.kategori, page: () => KategoriIndex()),
    GetPage(name: RouteName.detail_transaksi, page: () => DetailTransaksi()),
    GetPage(name: RouteName.new_kategori, page: () => FormKategori()),
    GetPage(name: RouteName.edit_kategori, page: () => FormKategori()),
    GetPage(name: RouteName.dashboard_kas, page: () => DashboardKas()),
    GetPage(
        name: RouteName.list_masjid,
        page: () => PageListMasjid(),
        binding: ListMasjidBinding()),
    GetPage(
      name: RouteName.detail,
      page: () => DetailMasjid(),
    ),
    GetPage(name: RouteName.detail_kegiatan, page: () => DetailKegiatan()),
    GetPage(name: RouteName.new_takmir, page: () => FormTakmir()),
    GetPage(name: RouteName.detail_takmir, page: () => DetailTakmir()),
    GetPage(
      name: RouteName.edit_takmir,
      page: () => FormTakmir(),
    ),
    GetPage(name: RouteName.verification, page: () => Verification()),
    // GetPage(name: RouteName.new_kas, page: () => FormKas()),
  ];
}
