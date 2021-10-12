import 'dart:ffi';

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
import 'package:mosq/screens/utils/MKStrings.dart';
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

    return Stack(children: [
      Container(
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
      ),
    ]);
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
                    width: Get.width * 0.4,
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
                    padding: EdgeInsets.only(right: 10),
                    width: Get.width * 0.35,
                    child: Text(
                      "${currencyFormatter(dataTransaksi.jumlah)}",
                      textAlign: TextAlign.end,
                      textDirection: TextDirection.rtl,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          fontSize: 16,
                          fontFamily: fontSemibold,
                          color: textSecondaryColor),
                    ),
                    // text("${currencyFormatter(dataTransaksi.jumlah)}",
                    //     textColor: appStore.textSecondaryColor,
                    //     fontSize: textSizeMedium,
                    //     isLongText: true,
                    //     fontFamily: fontSemibold),
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

class FilterBottomSheetLayout extends StatefulWidget {
  TransaksiModel? transaksiModel;
  var onSave;

  FilterBottomSheetLayout({Key? key, this.transaksiModel, this.onSave})
      : super(key: key);

  @override
  FilterBottomSheetLayoutState createState() {
    return FilterBottomSheetLayoutState();
  }
}

class FilterBottomSheetLayoutState extends State<FilterBottomSheetLayout> {
  // List<int> selectedCategories = [];
  // List<String> selectedColors = [];
  // List<String> selectedSizes = [];
  // List<String> selectedBrands = [];

  @override
  Widget build(BuildContext context) {
    // var categoryList = widget.mProductAttributeModel!.categories;
    // var colorsList = widget.mProductAttributeModel!.color;
    // var sizesList = widget.mProductAttributeModel!.size;
    // var brandsList = widget.mProductAttributeModel!.brand;
    final bukuKasList = ListView.builder(
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        itemCount: kasC.kases.length,
        itemBuilder: (_, index) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: ChoiceChip(
              label: text(kasC.kases[index].nama,
                  textColor:
                      kasC.kases[index].isSelected ? mkColorPrimary : mkBlack),
              selected: kasC.kases[index].isSelected,
              onSelected: (selected) {
                setState(() {
                  kasC.kases[index].isSelected
                      ? kasC.kases[index].isSelected = false
                      : kasC.kases[index].isSelected = true;
                });
              },
              elevation: 2,
              backgroundColor: Colors.white10,
              selectedColor: mkTextColorGrey.withOpacity(0.1),
            ),
          );
        });

    // final tipeTransaksiList = ListView.builder(
    //     scrollDirection: Axis.horizontal,
    //     shrinkWrap: true,
    //     itemCount: transaksiC.tipeTransaksiList.length,
    //     itemBuilder: (_, index) {
    //       return Padding(
    //         padding: const EdgeInsets.all(8.0),
    //         child: ChoiceChip(
    //           label:
    //               text(transaksiC.tipeTransaksiList[index], textColor: mkBlack),
    //           // selected: transaksiC.tipeTransaksiList[index].isSelected,
    //           selected: transaksiC.tipeTransaksiList[index],
    //           onSelected: (selected) {
    //             setState(() {
    //               // transaksiC.tipeTransaksiList[index].isSelected
    //               //     ? transaksiC.tipeTransaksiList[index].isSelected = false
    //               //     : transaksiC.tipeTransaksiList[index].isSelected = true;
    //             });
    //           },
    //           elevation: 2,
    //           backgroundColor: Colors.white10,
    //           selectedColor: mkColorPrimary.withOpacity(0.5),
    //         ),
    //       );
    //     });

    final kategoriList = ListView.builder(
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        itemCount: kategoriC.kategories.length,
        itemBuilder: (_, index) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: ChoiceChip(
              label: text(kategoriC.kategories[index].nama,
                  textColor: kategoriC.kategories[index].isSelected
                      ? mkColorPrimary
                      : mkBlack),
              selected: kategoriC.kategories[index].isSelected,
              onSelected: (selected) {
                setState(() {
                  kategoriC.kategories[index].isSelected
                      ? kategoriC.kategories[index].isSelected = false
                      : kategoriC.kategories[index].isSelected = true;
                });
              },
              elevation: 2,
              backgroundColor: Colors.white10,
              selectedColor: mkTextColorGrey.withOpacity(0.1),
            ),
          );
        });

    return Scaffold(
      appBar: AppBar(
        backgroundColor: mkColorPrimary,
        title: text(mk_lbl_filter,
            textColor: mkWhite,
            fontSize: textSizeNormal,
            fontFamily: fontMedium),
        iconTheme: IconThemeData(color: mkWhite),
        actions: <Widget>[
          InkWell(
              child: Container(
                  alignment: Alignment.centerRight,
                  padding: EdgeInsets.only(right: 5),
                  child: text(mk_lbl_apply,
                      textColor: mkWhite,
                      fontFamily: fontMedium,
                      fontSize: textSizeLargeMedium)),
              onTap: () {
                finish(context);
              })
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(left: 10, top: 10),
              child: text("Buku Kas",
                  textColor: mkBlack,
                  fontFamily: fontMedium,
                  fontSize: textSizeLargeMedium),
            ),
            SizedBox(height: 10),
            Container(child: bukuKasList, height: 50),
            // Padding(
            //   padding: EdgeInsets.only(left: 10, top: 10),
            //   child: text("Tipe Transaksi",
            //       textColor: mkBlack,
            //       fontFamily: fontMedium,
            //       fontSize: textSizeLargeMedium),
            // ),
            // SizedBox(height: 10),
            // Container(child: productColorsListView, height: 50),
            Padding(
              padding: EdgeInsets.only(left: 10, top: 10),
              child: text("Kategori",
                  textColor: mkBlack,
                  fontFamily: fontMedium,
                  fontSize: textSizeLargeMedium),
            ),
            SizedBox(height: 10),
            Container(child: kategoriList, height: 50),
          ],
        ),
      ),
    );
  }
}
