import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mosq/integrations/controllers.dart';
import 'package:mosq/modules/inventaris/models/inventaris_model.dart';
import 'package:mosq/screens/utils/MKColors.dart';
import 'package:mosq/screens/utils/MKConstant.dart';
import 'package:mosq/screens/utils/MKImages.dart';
import 'package:mosq/screens/widgets/MosqTopBar.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:mosq/main/utils/AppWidget.dart';
import 'package:get/get.dart';
// import 'package:mosq/main/utils/T10Images.dart';
// import 'package:mosq/main/utils/T10Strings.dart';

import 'package:mosq/main.dart';

class InventarisDetail extends StatelessWidget {
  InventarisModel model = Get.arguments;
  @override
  Widget build(BuildContext context) {
    String? imageURL = model.url ?? mk_net_img;
    // String noImage = "https://i.postimg.cc/9M4hLrrJ/no-image.png";
    if (imageURL == "") {
      String? imageURL = "https://i.postimg.cc/9M4hLrrJ/no-image.png";
      print(imageURL);
    }
    changeStatusColor(appStore.appBarColor!);
    var width = Get.width;
    var height = Get.height;

    Widget mTag(var value) {
      return Container(
        decoration: boxDecoration(
            color: mk_view_color,
            bgColor: appStore.scaffoldBackground,
            showShadow: true),
        padding: EdgeInsets.fromLTRB(16, 4, 16, 4),
        child: text(value, textColor: mkTextColorSecondary),
      );
    }

    Widget mInfo() {
      return Container(
        margin: EdgeInsets.all(16),
        color: appStore.scaffoldBackground,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Divider(height: 1, color: mk_view_color),
            SizedBox(height: 16),
            Text("Rincian", style: primaryTextStyle(size: 18)),
            SizedBox(height: 16),
            Text("Harga barang (satuan): ${model.harga ?? "Harga"}",
                style: secondaryTextStyle()),
            SizedBox(height: 16),
            Text("Banyaknya stok: ${model.jumlah ?? "Jumlah"}",
                style: secondaryTextStyle()),
            SizedBox(height: 16),
            Divider(height: 1, color: mk_view_color),
            SizedBox(height: 16),
            Row(
              children: <Widget>[
                // FloatingActionButton.extended(
                //     heroTag: '5',
                //     label: Text(
                //       "Edit",
                //       style: primaryTextStyle(color: Colors.white),
                //     ),
                //     backgroundColor: Colors.orange,
                //     icon: Icon(
                //       Icons.edit,
                //       color: Colors.white,
                //     ),
                //     onPressed: () {
                //       Get.toNamed(RouteName.edit_inventaris);
                //       // Get.to(CustomDelete());
                //     }),
                // 10.width,
                // FloatingActionButton.extended(
                //     heroTag: '1',
                //     // heroTag: '5',
                //     label: Text(
                //       "Hapus",
                //       style: primaryTextStyle(color: Colors.white),
                //     ),
                //     backgroundColor: Colors.redAccent,
                //     icon: Icon(
                //       Icons.delete,
                //       color: Colors.white,
                //     ),
                //     onPressed: () {
                //       Get.to(() => CustomDelete());
                //       // Database().deleteInventaris(model.inventarisID);
                //     }),
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
            MosqTopBar("Detail Inventaris"),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.all(16),
                      child: Column(
                        children: <Widget>[
                          Container(
                            decoration: boxDecoration(radius: 20),
                            width: Get.width,
                            height: Get.width / 1.777,
                            child: model.url != ""
                                ? CachedNetworkImage(
                                    placeholder: placeholderWidgetFn() as Widget
                                        Function(BuildContext, String)?,
                                    imageUrl: "$imageURL",
                                    width: width,
                                    height: width * 0.7,
                                    fit: BoxFit.cover,
                                  )
                                : SvgPicture.asset(mk_no_image),
                          ),
                          SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              text("${model.nama ?? "Nama"}",
                                  fontFamily: fontBold,
                                  fontSize: textSizeNormal),
                              text("Rp. ${model.hargaTotal ?? "Harga Total"},-",
                                  fontFamily: fontMedium,
                                  fontSize: textSizeNormal),
                              // text(
                              //     "Harga satuan: ${model.harga}",
                              //     fontFamily: fontRegular,
                              //     fontSize: textSizeSmall),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              text("Kondisi ${model.kondisi ?? "Kondisi"}",
                                  textColor: mkTextColorSecondary),
                              // text(
                              //     "Banyaknya: ${model.jumlah}",
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
