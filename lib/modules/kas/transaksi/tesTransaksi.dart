import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mosq/helpers/formatter.dart';
import 'package:mosq/integrations/controllers.dart';
import 'package:mosq/integrations/firestore.dart';
import 'package:mosq/main.dart';
import 'package:mosq/main/utils/AppWidget.dart';
import 'package:mosq/modules/kas/models/kas_model.dart';
import 'package:mosq/modules/kas/models/transaksi_model.dart';
import 'package:mosq/modules/masjid/models/masjid_model.dart';
import 'package:mosq/screens/utils/MKColors.dart';
import 'package:mosq/screens/utils/MKConstant.dart';
import 'package:mosq/screens/utils/MKStrings.dart';
import 'package:mosq/screens/utils/MKWidget.dart';
import 'package:mosq/screens/widgets/ButtonForm.dart';
import 'package:nb_utils/nb_utils.dart';

class TesTransaksi extends StatelessWidget {
  MasjidModel model = Get.arguments ?? MasjidModel();
  TextEditingController jumlahC = TextEditingController();
  int? jenisTransaksi;

  RxList<TransaksiModel> _allTransaksi = RxList<TransaksiModel>();
  List<TransaksiModel> get allTransaksi => _allTransaksi.value;

  var sumTransaksi = 0.obs;

  KasModel dummyKas = kasC.kases.first;

  transaksi(KasModel kasModel) {
    int sisaSaldo = kasModel.saldo!;
    sumTransaksi
        .bindStream(model.transaksiDao!.getSumTransaksi(model, kasModel));
    // sumTransaksi.value = model.transaksiDao!.getSumTransaksi(model, kasModel);

    var transaksimodel = TransaksiModel(
      dao: model.transaksiDao!,
      tipeTransaksi: jenisTransaksi,
      fromKas: dummyKas.id,
      jumlah: jumlahC.text.toInt(),
    );
    int? totalNow;
    int jumlah = transaksimodel.jumlah ?? 0;
    if (transaksimodel.tipeTransaksi == 20) {
      transaksimodel.jumlah = 0 - transaksimodel.jumlah!;
    }
    totalNow = dummyKas.saldoAwal! + sumTransaksi.value + jumlah;
    try {
      firebaseFirestore.runTransaction((transaction) async {
        CollectionReference colRef = kasModel.dao!.db;

        transaction.update(colRef.doc(kasModel.id), {'saldo': totalNow});
      });
    } catch (e) {
      print('transaksi error');
    } finally {
      transaksimodel.save();
      print('transaksi sukses');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: appStore.appBarColor,
        leading: BackButton(),
        title: appBarTitleWidget(context, 'Kategori Transaksi'),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            physics: ScrollPhysics(),
            child: Container(
              child: GestureDetector(
                onTap: () {
                  FocusScopeNode currentFocus = FocusScope.of(context);

                  if (!currentFocus.hasPrimaryFocus) {
                    currentFocus.unfocus();
                  }
                },
                child: Obx(
                  () => Column(
                    children: [
                      kasC.kases.isEmpty
                          ? Center(
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 16),
                                child: text('Masjid ini belum memiliki Kas',
                                    isLongText: true, isCentered: true),
                              ),
                            )
                          : ListView.builder(
                              padding: EdgeInsets.symmetric(),
                              scrollDirection: Axis.vertical,
                              itemCount: kasC.kases.length,
                              shrinkWrap: true,
                              physics: ScrollPhysics(),
                              itemBuilder: (context, index) {
                                return kasCard(
                                  model: kasC.kases[index],
                                );
                              },
                            ),
                      text('Total Transaksi : ' +
                          currencyFormatter(sumTransaksi.value)),
                      text('Sisa Saldo : ' +
                          currencyFormatter(
                              sumTransaksi.value + dummyKas.saldoAwal!)),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.all(16),
            height: Get.height,
            alignment: Alignment.bottomCenter,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                DropdownButtonFormField<int>(
                    // value: transaksiC.kategori,
                    decoration: InputDecoration(
                      labelText: mk_lbl_jenis_transaksi,
                      hintStyle: secondaryTextStyle(),
                      labelStyle: secondaryTextStyle(),
                      hintText: mk_lbl_enter + mk_lbl_jenis_transaksi,
                      icon: Icon(Icons.change_circle_outlined,
                          color: transaksiC.isSaving.value
                              ? mkColorPrimaryLight
                              : mkColorPrimaryDark),
                    ),
                    onChanged: (newValue) {
                      jenisTransaksi = newValue;
                    },
                    items: [
                      DropdownMenuItem<int>(
                        value: 30,
                        child: Tooltip(
                          message: 'Mutasi',
                          child: Container(
                            margin: EdgeInsets.only(left: 4, right: 4),
                            child: Text('Mutasi', style: primaryTextStyle()),
                          ),
                        ),
                      ),
                      DropdownMenuItem<int>(
                        value: 10,
                        child: Tooltip(
                          message: 'Pemasukan',
                          child: Container(
                            margin: EdgeInsets.only(left: 4, right: 4),
                            child: Text('Pemasukan', style: primaryTextStyle()),
                          ),
                        ),
                      ),
                      DropdownMenuItem<int>(
                        value: 20,
                        child: Tooltip(
                          message: 'Pengeluaran',
                          child: Container(
                            margin: EdgeInsets.only(left: 4, right: 4),
                            child:
                                Text('Pengeluaran', style: primaryTextStyle()),
                          ),
                        ),
                      ),
                    ]),
                EditText(
                  // isEnabled: false,
                  icon: Icon(
                    Icons.monetization_on_outlined,
                    color: mkColorPrimaryDark,
                  ),
                  mController: jumlahC,
                  label: 'Jumlah',
                  keyboardType: TextInputType.number,
                ),
                ButtonForm(
                    tapFunction: () {
                      transaksi(dummyKas);
                      toast('tapped');
                    },
                    isSaving: transaksiC.isSaving),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class kasCard extends StatelessWidget {
  kasCard({required this.model});
  KasModel model;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          title: text(model.nama ?? "Nama Kategori"),
          subtitle: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              text('Awal ' + currencyFormatter(model.saldoAwal ?? 0),
                  fontSize: textSizeSMedium),
              text('Sisa ' + currencyFormatter(model.saldo),
                  fontSize: textSizeSMedium),
            ],
          ),
        ),
        Divider(
          color: mk_view_color,
          height: 1,
        )
      ],
    );
  }
}
