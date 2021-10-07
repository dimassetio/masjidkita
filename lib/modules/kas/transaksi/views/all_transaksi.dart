import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mosq/helpers/formatter.dart';
import 'package:mosq/integrations/controllers.dart';
import 'package:mosq/main.dart';
import 'package:mosq/main/utils/AppWidget.dart';
import 'package:mosq/modules/kas/buku/models/kas_model.dart';
import 'package:mosq/modules/kas/transaksi/models/transaksi_model.dart';
import 'package:mosq/modules/kas/transaksi/views/list_transaksi.dart';
import 'package:mosq/modules/masjid/models/masjid_model.dart';
import 'package:mosq/routes/route_name.dart';
import 'package:mosq/screens/utils/MKColors.dart';
import 'package:mosq/screens/utils/MKConstant.dart';
import 'package:mosq/screens/utils/MKStrings.dart';
import 'package:mosq/screens/utils/MKWidget.dart';
import 'package:mosq/screens/widgets/DeleteDialog.dart';
import 'package:mosq/screens/widgets/DismissibleBackground.dart';
import 'package:nb_utils/nb_utils.dart';

// ignore: must_be_immutable
class Transaksies extends StatelessWidget {
  MasjidModel model = Get.arguments ?? MasjidModel();

  void showFilter(context) {
    // if (mProductModel.isEmpty) return;
    // void onSave(List<int> category, List<String> size, List<String> color, List<String> brand) {
    //   Map request = {
    //     'category': category.toSet().toList(),
    //     'size': size.toSet().toList(),
    //     'color': color.toSet().toList(),
    //     'brand': brand.toSet().toList(),
    //   };
    //   if (category.length < 1) request.remove('category');
    //   if (size.length < 1) request.remove('size');
    //   if (color.length < 1) request.remove('color');
    //   if (brand.length < 1) request.remove('brand');
    // }

    Navigator.of(context).push(new MaterialPageRoute<Null>(
        builder: (BuildContext context) {
          return FilterBottomSheetLayout();
        },
        fullscreenDialog: true));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: appStore.appBarColor,
        leading: BackButton(color: mkBlack),
        title: appBarTitleWidget(context, 'List Transaksi ${model.nama}'),
      ),
      body: Stack(
        children: [
          Padding(
            padding: EdgeInsets.all(10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.only(left: 16, right: 5),
                  height: 34,
                  margin: EdgeInsets.only(left: 0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: Colors.grey.withAlpha(50)),
                  ),
                  child: DropdownButton(
                    value: 'Weekly',
                    underline: SizedBox(),
                    items: <String>['Daily', 'Weekly', 'Monthly', 'Yearly']
                        .map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value, style: TextStyle(fontSize: 14)),
                      );
                    }).toList(),
                    onChanged: (dynamic value) {
                      print(value);
                    },
                  ),
                ),
                IconButton(
                    onPressed: () => showFilter(context),
                    icon: Icon(Icons.filter_list)),
              ],
            ),
          ),
          SizedBox(height: 15),
          Padding(
            padding: EdgeInsets.only(top: 45),
            child: Obx(
              () => transaksiC.transaksies.isEmpty
                  ? Center(
                      child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: text(
                          'Masjid ini belum memiliki kategori transaksi',
                          isLongText: true,
                          isCentered: true),
                    ))
                  : ListView.builder(
                      padding: EdgeInsets.symmetric(),
                      scrollDirection: Axis.vertical,
                      itemCount: transaksiC.transaksies.length,
                      shrinkWrap: true,
                      physics: ScrollPhysics(),
                      itemBuilder: (context, index) {
                        return TransaksiesAll(
                          transaksies: transaksiC.transaksies,
                        );
                      },
                    ),
            ),
          )
        ],
      ),
    );
  }
}

class TransaksiesAll extends StatelessWidget {
  TransaksiesAll({required this.transaksies});
  // final TransaksiModel model = Get.arguments;
  final List<TransaksiModel> transaksies;

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width - 10;

    return Container(
      width: width,
      child: ListView.builder(
          padding: EdgeInsets.symmetric(),
          scrollDirection: Axis.vertical,
          itemCount: transaksies.length,
          shrinkWrap: true,
          physics: ScrollPhysics(),
          itemBuilder: (context, index) {
            return TransaksiKas(dataTransaksi: transaksies[index]);
          }),
    );
  }
}

class TransaksiKas extends StatelessWidget {
  const TransaksiKas({required this.dataTransaksi});
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
            // );
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
          KasModel kas = await KasModel(
                  id: dataTransaksi.fromKas, dao: masjidC.currMasjid.kasDao)
              .find();
          Get.toNamed(RouteName.detail_transaksi,
              arguments: [dataTransaksi, kas]);
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
                    alignment: Alignment.center,
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
