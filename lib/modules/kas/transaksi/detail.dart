import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mosq/helpers/formatter.dart';
import 'package:mosq/main.dart';
import 'package:mosq/modules/kas/models/transaksi_model.dart';
import 'package:mosq/screens/utils/MKColors.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:mosq/main/utils/AppWidget.dart';

// ignore: must_be_immutable
class DetailTransaksi extends StatelessWidget {
  TransaksiModel model = Get.arguments;
  @override
  Widget build(BuildContext context) {
    String? keterangan = model.keterangan;
    if (keterangan == "") {
      keterangan = "Tidak ada";
    }
    String? url = model.photoUrl;
    if (url.isEmptyOrNull) {
      url = "https://i.postimg.cc/9M4hLrrJ/no-image.png";
    }
    String? tipeTransaksi;
    if (model.tipeTransaksi == 20) {
      tipeTransaksi = "Pengeluaran";
    } else if (model.tipeTransaksi == 10) {
      tipeTransaksi = "Pemasukan";
    }
    var jumlah = currencyFormatter(model.jumlah);
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: appStore.appBarColor,
        leading: BackButton(color: mkBlack),
        title: appBarTitleWidget(context, 'Detail Transaksi'),
        // actions: actions,
      ),
      body: Column(
        children: <Widget>[
          SizedBox(height: 10),
          listItemContainer("ID Transaksi", "${model.id}"),
          listItemContainer("Kategori Transaksi", "${model.kategori}"),
          listItemContainer("Tanggal Transaksi", "${model.tanggal}"),
          listItemContainer("Jenis", "$tipeTransaksi"),
          listItemContainer("Nominal Transaksi", "$jumlah"),
          listItemContainer("Keterangan", "$keterangan"),
        ],
      ),
    );
  }
}

Widget listItemContainer(String title, String value) => Container(
      margin: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      padding: EdgeInsets.symmetric(vertical: 10.0),
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(height: 5),
          Text(
            title,
            style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Color.fromRGBO(196, 196, 196, 1)),
          ),
          SizedBox(height: 6),
          Text(
            value,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 5),
        ],
      ),
      decoration: BoxDecoration(
          border: new Border(
              bottom: new BorderSide(width: 1.0, color: mkColorPrimary))),
    );
