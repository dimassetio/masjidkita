import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:masjidkita/controllers/inventarisController.dart';
import 'package:masjidkita/integrations/controllers.dart';
import 'package:masjidkita/models/inventaris.dart';
import 'package:masjidkita/routes/route_name.dart';
import 'package:masjidkita/screens/fitur/Kelola_Masjid/Dialog/alertdeleteInventaris.dart';
import 'package:masjidkita/services/database.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:masjidkita/main/utils/AppWidget.dart';
import 'package:masjidkita/main/utils/T10Colors.dart';
import 'package:masjidkita/main/utils/T10Constant.dart';
import 'package:masjidkita/main/utils/T10Widget.dart';
// import 'package:masjidkita/main/utils/T10Images.dart';
// import 'package:masjidkita/main/utils/T10Strings.dart';

import 'package:masjidkita/main.dart';

class InventarisDetail extends StatelessWidget {
  final InventarisModel inventaris = InventarisModel();
  @override
  Widget build(BuildContext context) {
    changeStatusColor(appStore.appBarColor!);
    var width = MediaQuery.of(context).size.width;

    Widget mTag(var value) {
      return Container(
        decoration: boxDecoration(
            color: t10_view_color,
            bgColor: appStore.scaffoldBackground,
            showShadow: true),
        padding: EdgeInsets.fromLTRB(spacing_standard_new, spacing_control,
            spacing_standard_new, spacing_control),
        child: text(value, textColor: t10_textColorSecondary),
      );
    }

    Widget mInfo() {
      return Container(
        margin: EdgeInsets.all(spacing_standard_new),
        color: appStore.scaffoldBackground,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Divider(height: 1, color: t10_view_color),
            SizedBox(height: spacing_standard_new),
            Text("Rincian", style: primaryTextStyle(size: 18)),
            SizedBox(height: spacing_standard_new),
            Text("Harga barang (satuan): ${inventarisC.inventaris.harga}",
                style: secondaryTextStyle()),
            SizedBox(height: spacing_standard_new),
            Text("Banyaknya stok: ${inventarisC.inventaris.jumlah}",
                style: secondaryTextStyle()),
            SizedBox(height: spacing_standard_new),
            Divider(height: 1, color: t10_view_color),
            SizedBox(height: spacing_standard_new),
            Row(
              children: <Widget>[
                FloatingActionButton.extended(
                    heroTag: '5',
                    label: Text(
                      "Edit",
                      style: primaryTextStyle(color: Colors.white),
                    ),
                    backgroundColor: Colors.orange,
                    icon: Icon(
                      Icons.edit,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      Get.toNamed(RouteName.edit_inventaris);
                    }),
                10.width,
                FloatingActionButton.extended(
                    heroTag: '1',
                    // heroTag: '5',
                    label: Text(
                      "Delete",
                      style: primaryTextStyle(color: Colors.white),
                    ),
                    backgroundColor: Colors.redAccent,
                    icon: Icon(
                      Icons.delete,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      // CustomDelete();
                      Database().deleteInventaris(inventaris.inventarisID);
                    }),
              ],
            )
          ],
        ),
      );
    }

    return Scaffold(
      backgroundColor: appStore.scaffoldBackground,
      body: SafeArea(
        child: Column(
          children: <Widget>[
            T10TopBar("Detail Inventaris"),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.all(spacing_standard_new),
                      child: Column(
                        children: <Widget>[
                          // CachedNetworkImage(
                          //   placeholder: placeholderWidgetFn() as Widget
                          //       Function(BuildContext, String)?,
                          //   imageUrl: "${inventarisC.inventaris.url}",
                          //   width: width,
                          //   height: width * 0.4,
                          //   fit: BoxFit.fill,
                          // ),
                          SizedBox(height: spacing_standard_new),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              text("${inventarisC.inventaris.nama}",
                                  fontFamily: fontMedium,
                                  fontSize: textSizeNormal),
                              text("Rp. ${inventarisC.inventaris.hargaTotal},-",
                                  fontFamily: fontMedium,
                                  fontSize: textSizeNormal),
                              // text(
                              //     "Harga satuan: ${inventarisC.inventaris.harga}",
                              //     fontFamily: fontRegular,
                              //     fontSize: textSizeSmall),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              text("Kondisi ${inventarisC.inventaris.kondisi}",
                                  textColor: t10_textColorSecondary),
                              // text(
                              //     "Banyaknya: ${inventarisC.inventaris.jumlah}",
                              //     textColor: t10_textColorSecondary),
                            ],
                          )
                        ],
                      ),
                    ),
                    // DefaultTabController(
                    //   child: TabBar(
                    //     unselectedLabelColor: t10_textColorSecondary,
                    //     indicatorColor: t10_colorPrimary,
                    //     labelColor: t10_colorPrimary,
                    //     tabs: <Widget>[
                    //       Padding(
                    //         padding: EdgeInsets.fromLTRB(0, 8, 0, 8),
                    //         child: text("Mbo"),
                    //       ),
                    //       Padding(
                    //         padding: EdgeInsets.fromLTRB(0, 8, 0, 8),
                    //         child: text("Mbo"),
                    //       ),
                    //       Padding(
                    //         padding: EdgeInsets.fromLTRB(0, 8, 0, 8),
                    //         child: text("Mbo"),
                    //       ),
                    //     ],
                    //   ),
                    //   length: 3,
                    // ),
                    mInfo()
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
