import 'dart:collection';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mosq/integrations/controllers.dart';
import 'package:mosq/integrations/firestore.dart';
import 'package:get/get.dart';
import 'package:mosq/modules/kas/buku/kas_database.dart';
import 'package:mosq/modules/kas/kategori/kategori_model.dart';
import 'package:mosq/modules/kas/buku/kas_model.dart';
import 'package:mosq/modules/masjid/models/masjid_model.dart';
import 'package:mosq/modules/kas/transaksi/transaksi_model.dart';
import 'package:mosq/screens/utils/MKColors.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

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
    // if (model.url.isEmptyOrNull) {
    //   return await model.delete();
    // } else
    //   return await model.deleteWithDetails();
    await model.delete();
    updateKasModel(model);
  }

  // updateKas(KasModel model) async {
  //   await model.sav
  // }

  KasModel? kasModel;
  KategoriModel? kategoriModel;
  KategoriModel? mKategori(String? id) =>
      kategoriC.filteredKategories.firstWhere((element) => element.id == id);
  var sumTransaksi = 0.obs;

  saveTransaksi(TransaksiModel model, {String? path}) async {
    isSaving.value = true;
    // int sisaSaldo = kasModel.saldo!;
    // sumTransaksi
    //     .bindStream(masjidC.currMasjid.transaksiDao!.getSumTransaksi(kasModel));
    // sumTransaksi.value = model.transaksiDao!.getSumTransaksi(model, kasModel);
    int jumlahInt =
        jumlah.text.replaceAll('Rp', '').replaceAll('.', '').toInt();

    model.tipeTransaksi = tipeTransaksi;
    model.fromKas = kasModel?.id;
    if (kategoriModel != null) {
      model.kategori = kategoriModel?.nama;
      model.kategoriID = kategoriModel?.id;
    }
    model.photoUrl = path;
    model.jumlah = jumlahInt;
    model.keterangan = keterangan.text;
    model.toKas = toKas;
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
    KasModel kas =
        await KasModel(id: model.fromKas, dao: masjidC.currMasjid.kasDao)
            .find();
    try {
      totalNow = await model.dao!.calculateTransaksi(kas) + kas.saldoAwal;
      firebaseFirestore.runTransaction((transaction) async {
        DocumentReference docRef = kas.dao!.db.doc(kas.id);

        transaction.update(docRef, {'saldo': totalNow});
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
    kategori = null;
    tipeTransaksi = null;
  }
}
