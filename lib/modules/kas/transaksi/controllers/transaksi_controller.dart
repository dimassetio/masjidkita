import 'dart:collection';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
// import 'package:mobx/mobx.dart';
import 'package:mosq/integrations/controllers.dart';
import 'package:mosq/integrations/firestore.dart';
import 'package:get/get.dart';
// import 'package:mosq/modules/kas/buku/databases/kas_database.dart';
import 'package:mosq/modules/kas/kategori/models/kategori_model.dart';
import 'package:mosq/modules/kas/buku/models/kas_model.dart';
import 'package:mosq/modules/masjid/models/masjid_model.dart';
import 'package:mosq/screens/utils/MKColors.dart';
import 'package:mosq/modules/kas/transaksi/models/transaksi_model.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:image_picker/image_picker.dart';
// import 'package:firebase_storage/firebase_storage.dart';

class TransaksiController extends GetxController {
  static TransaksiController instance = Get.find();

  final ImagePicker _picker = ImagePicker();
  XFile? pickedImage;
  var isSaving = false.obs;

  RxList<TransaksiModel> transaksiList = RxList<TransaksiModel>();
  List<TransaksiModel> get transaksies => transaksiList.value;

  Rx<TransaksiModel> _transaksiModel = TransaksiModel().obs;

  TransaksiModel get transaksi => _transaksiModel.value;

  List<KasModel> fromKases = kasC.kases;

  var _date = DateTime.now().obs;
  DateTime get selectedDate => _date.value;
  set selectedDate(DateTime value) => this._date.value = value;

  Future<void> selectDate(BuildContext context) async {
    var result = await showDatePicker(
        context: context,
        builder: (BuildContext context, Widget? child) {
          return Theme(
            data: ThemeData(colorScheme: mkColorScheme),
            child: child!,
          );
        },
        initialDate: selectedDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (result is DateTime) {
      selectedDate = result;
    }
  }

  TextEditingController jumlah = TextEditingController();
  TextEditingController keterangan = TextEditingController();

  String? kategoriID;
  String? kategori;
  String? fromKas;
  String? toKas;
  int? tipeTransaksi;

  @override
  void onInit() {
    super.onInit();
  }

  getTransaksiStream(MasjidModel model) {
    // kasList.bindStream(kasStream(model.id!));
    transaksiList.bindStream(model.transaksiDao!.transaksiStream(model));
  }

  Future delete(TransaksiModel model) async {
    kasModel = await KasModel(id: model.fromKas, dao: masjidC.currMasjid.kasDao)
        .find();
    !model.toKas.isEmptyOrNull
        ? toKasModel =
            await KasModel(id: model.toKas, dao: masjidC.currMasjid.kasDao)
                .find()
        : null;
    if (model.photoUrl.isEmptyOrNull) {
      await model.delete();
    } else {
      await model.deleteWithDetails();
    }
    await updateKasModel(model);

    kasModel = null;
    toKasModel = null;
  }

  // updateKas(KasModel model) async {
  //   await model.sav
  // }

  KasModel? kasModel;
  KategoriModel? kategoriModel;
  KategoriModel? mKategori(String? id) =>
      kategoriC.filteredKategories.firstWhere((element) => element.id == id);

  KasModel? toKasModel;
  var sumTransaksi = 0.obs;

  saveTransaksi(TransaksiModel model, {String? path}) async {
    isSaving.value = true;
    // int sisaSaldo = kasModel.saldo!;
    // sumTransaksi
    //     .bindStream(masjidC.currMasjid.transaksiDao!.getSumTransaksi(kasModel));
    // sumTransaksi.value = model.transaksiDao!.getSumTransaksi(model, kasModel);
    int jumlahInt =
        jumlah.text.replaceAll('Rp', '').replaceAll('.', '').toInt();

    // int? kategori = model.tipeTransaksi;

    // if (kategori == 10) {
    //   model.kategori = "Pemasukan";
    // } else if (kategori == 20) {
    //   model.kategori = "Pengeluaran";
    // } else if (kategori == 30) {
    //   model.kategori = "Mutasi";
    // }
    //  else {
    //   model.kategori = "error";
    // }

    model.tipeTransaksi = tipeTransaksi;

    model.fromKas = kasModel?.id;
    if (kategoriModel != null) {
      model.kategori = kategoriModel?.nama;
      model.kategoriID = kategoriModel?.id;
    }
    model.kategoriID = kategoriModel?.id;
    model.kategori = kategoriModel?.nama ?? "Mutasi";

    model.photoUrl = path;
    model.jumlah = jumlahInt;
    model.keterangan = keterangan.text;
    model.toKas = toKasModel?.id;
    model.tanggal = DateTime.now();
    model.tanggal = selectedDate;
    File? foto;
    if (!path.isEmptyOrNull) {
      foto = File(path ?? '');
    }
    try {
      foto == null ? await model.save() : await model.saveWithDetails(foto);
    } catch (e) {
      toast(e.toString());
      isSaving.value = false;
      print("error e iku  $e");
      // rethrow;
    }
    await updateKasModel(model);
    isSaving.value = false;
    Get.back();
  }

  updateKasModel(TransaksiModel model) async {
    int? totalNow;
    int? totalNowTo;

    try {
      totalNow = await model.dao!.calculateTransaksi(kasModel ?? KasModel()) +
          kasModel?.saldoAwal;
      if (toKasModel != null) {
        totalNowTo = await model.dao!.calculateTransaksi(toKasModel!) +
            toKasModel!.saldoAwal;
      }
      // if (model.tipeTransaksi == 30) {
      // }
      await firebaseFirestore.runTransaction((transaction) async {
        DocumentReference docRef = kasModel!.dao!.db.doc(kasModel!.id);

        //
        transaction.update(docRef, {'saldo': totalNow});

        if (toKasModel != null) {
          DocumentReference docRefTo = kasModel!.dao!.db.doc(toKasModel!.id);
          transaction.update(docRefTo, {'saldo': totalNowTo});
        }
      });
    } catch (e) {
      print('transaksi error');
    } finally {
      print('transaksi sukses');
    }
  }

  checkControllers(TransaksiModel model, String? foto) {
    if (model.id.isEmptyOrNull) {
      if (jumlah.text.isNotEmpty ||
          keterangan.text.isNotEmpty ||
          kategori.isEmptyOrNull ||
          tipeTransaksi == null ||
          // selectedDate != DateTime.now() ||
          !foto.isEmptyOrNull) return true;
    } else {
      if (keterangan.text != model.keterangan ||
          kategori != model.kategori ||
          tipeTransaksi != model.tipeTransaksi ||
          !foto.isEmptyOrNull) return true;
    }
    return false;
  }

  clear() {
    jumlah.clear();
    selectedDate = DateTime.now();
    keterangan.clear();
    kategoriModel = null;
    kasModel = null;
    toKasModel = null;
    kategori = null;
    tipeTransaksi = null;
  }
}
