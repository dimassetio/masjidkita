import 'dart:io';
import 'package:flutter/material.dart';
import 'package:mosq/integrations/controllers.dart';
import 'package:get/get.dart';
import 'package:mosq/modules/kas/periode/periode_model.dart';
import 'package:mosq/modules/masjid/models/masjid_model.dart';
import 'package:mosq/modules/kas/buku/kas_model.dart';
import 'package:nb_utils/nb_utils.dart';

class KasController extends GetxController {
  static KasController instance = Get.find();

  var isSaving = false.obs;

  RxList<KasModel> kasList = RxList<KasModel>();
  List<KasModel> get kases => kasList.value;

  Rx<KasModel> _kasModel = KasModel().obs;

  KasModel get kas => _kasModel.value;

  TextEditingController nama = TextEditingController();
  TextEditingController saldoAwal = TextEditingController();
  TextEditingController saldo = TextEditingController();
  TextEditingController deskripsi = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    // kasList.bindStream(kasStream());
  }

  // Stream<List<kasModel>> kasStream(String masjidID) async* {
  //   yield* collections(masjidID).snapshots().map((QuerySnapshot query) {
  //     List<kasModel> retVal = [];
  //     query.docs.forEach((element) {
  //       retVal.add(kasModel().fromSnapshot(element));
  //     });
  //     return retVal;
  //   });
  // }

  getKasStream(MasjidModel model) {
    // kasList.bindStream(kasStream(model.id!));
    kasList.bindStream(model.kasDao!.kasStream(model));
  }

  Future delete(KasModel model) async {
    // if (model.photoUrl.isEmptyOrNull) {
    //   return await model.delete();
    // } else
    //   return await model.deleteWithDetails();
    return await model.delete();
  }

  saveKas(KasModel model) async {
    isSaving.value = true;

    int saldoAwalInt =
        saldoAwal.text.replaceAll('Rp', '').replaceAll('.', '').toInt();
    // var streamSaldo = 0.obs;
    // streamSaldo
    //     .bindStream(masjidC.currMasjid.transaksiDao!.getSumTransaksi(model));

    model.nama = nama.text;
    model.saldoAwal = saldoAwalInt;
    model.tanggalAwal = DateTime.now();
    int sumSaldo = 0;
    if (model.id != null) {
      sumSaldo =
          await masjidC.currMasjid.transaksiDao!.calculateTransaksi(model);
    }
    sumSaldo = sumSaldo + model.saldoAwal!;
    model.saldo = sumSaldo;
    model.deskripsi = deskripsi.text;

    PeriodeModel periode = PeriodeModel(
        saldoAwal: model.saldoAwal, tanggalAwal: model.tanggalAwal);
    try {
      await model.saveWithDetails(periode);
      // await model.save();
      // print(model.toSnapshot());

      // PeriodeModel().fromKas(model).save();
    } on SocketException catch (_) {
      showDialog(
          context: Get.context!,
          builder: (context) => AlertDialog(
                title: Text("Connection Error !"),
                content: Text("Please connect to the internet."),
              ));
    } catch (e) {
      print(e);
      toast("Error Saving Data");
    } finally {
      toast("Data Berhasil Diperbarui");
    }
    isSaving.value = false;
    Get.back();
  }

  checkControllers(var model) {
    if (model.id.isEmptyOrNull) {
      if (nama.text.isNotEmpty ||
          deskripsi.text.isNotEmpty ||
          saldoAwal.text.isNotEmpty ||
          saldo.text.isNotEmpty) return true;
    } else {
      if (nama.text != model.nama || deskripsi.text != model.deskripsi)
        return true;
    }
  }

  clear() {
    nama.clear();
    saldoAwal.clear();
    saldo.clear();
    deskripsi.clear();
  }
}
