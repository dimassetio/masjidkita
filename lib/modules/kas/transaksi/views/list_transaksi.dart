import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mosq/helpers/formatter.dart';
import 'package:mosq/integrations/controllers.dart';
import 'package:mosq/main.dart';
import 'package:mosq/main/utils/AppWidget.dart';
import 'package:mosq/modules/kas/buku/models/kas_model.dart';
import 'package:mosq/modules/kas/kategori/databases/kategori_database.dart';
import 'package:mosq/modules/kas/transaksi/models/transaksi_model.dart';
import 'package:mosq/routes/route_name.dart';
import 'package:mosq/screens/widgets/DeleteDialog.dart';
import 'package:mosq/screens/utils/MKColors.dart';
import 'package:mosq/screens/utils/MKConstant.dart';
import 'package:mosq/screens/utils/MKWidget.dart';
import 'package:mosq/screens/widgets/DismissibleBackground.dart';
import 'package:nb_utils/nb_utils.dart';

class TransaksiKas extends StatelessWidget {
  TransaksiKas({required this.transaksies, this.length = 5});
  // final TransaksiModel model = Get.arguments;
  final List<TransaksiModel> transaksies;
  int length = 5;
  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width - 10;

    return Container(
      width: width,
      child: ListView.builder(
          padding: EdgeInsets.symmetric(),
          scrollDirection: Axis.vertical,
          itemCount: transaksies.length < 5 ? transaksies.length : length,
          shrinkWrap: true,
          physics: ScrollPhysics(),
          itemBuilder: (context, index) {
            return TransaksiList(dataTransaksi: transaksies[index]);
          }),
    );
  }
}

class TransaksiList extends StatelessWidget {
  const TransaksiList({required this.dataTransaksi});
  final TransaksiModel dataTransaksi;
  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(dataTransaksi.id!),
      direction: masjidC.myMasjid.value
          ? DismissDirection.horizontal
          : DismissDirection.none,
      background: slideRightBackground(),
      secondaryBackground: slideLeftBackground(),
      confirmDismiss: (direction) async {
        final bool? res;

        if (direction == DismissDirection.startToEnd) {
          try {
            res = false;
          } finally {
            Get.toNamed(RouteName.edit_transaksi, arguments: dataTransaksi);
          }
        } else if (direction == DismissDirection.endToStart) {
          return res = await showDialog(
              context: context,
              builder: (BuildContext context) => CustomDelete(
                    titleName: 'Transaksi',
                    subtitleName: dataTransaksi.kategori ?? "",
                  ));
        } else
          res = false;
        return res;
      },
      onDismissed: (direction) {
        try {
          transaksiC.delete(dataTransaksi);
        } catch (e) {
          toast('Error Delete Data');
          rethrow;
        }
      },
      child: InkWell(
        onTap: () async {
          try {
            KasModel kas = await KasModel(
                    id: dataTransaksi.fromKas, dao: masjidC.currMasjid.kasDao)
                .find();
            KasModel? toKas = await KasModel(
                    id: dataTransaksi.toKas, dao: masjidC.currMasjid.kasDao)
                .find();
            Get.toNamed(RouteName.detail_transaksi,
                arguments: [dataTransaksi, kas, toKas]);
          } catch (e) {
            Get.snackbar('Error', 'Please Check Your Connection and Try Again');
          }
        },
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.symmetric(vertical: 18),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  TipeTransaksiIcon(
                      tipeTransaksi: dataTransaksi.tipeTransaksi!),
                  Container(
                    width: Get.width * 0.5,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        text("${dataTransaksi.kategori}",
                            textColor: appStore.textPrimaryColor,
                            fontSize: textSizeMedium,
                            fontFamily: fontSemibold),
                        text(dateFormatter(dataTransaksi.tanggal),
                            fontSize: textSizeSMedium)
                      ],
                    ),
                  ),
                  Container(
                    alignment: Alignment.centerRight,
                    width: Get.width * 0.25,
                    child:
                        // text("${dataTransaksi.fromKas}",
                        text("${currencyFormatter(dataTransaksi.jumlah)}",
                            textColor: appStore.textSecondaryColor,
                            fontSize: textSizeMedium,
                            isLongText: true,
                            fontFamily: fontSemibold),
                  )
                ],
              ),
            ),
            Divider(height: 0.5)
          ],
        ),
      ),
    );
  }
}
