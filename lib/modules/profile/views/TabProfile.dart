import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:mosq/integrations/controllers.dart';

import 'package:mosq/main/utils/AppWidget.dart';
import 'package:mosq/modules/masjid/models/masjid_model.dart';
import 'package:mosq/routes/route_name.dart';
import 'package:mosq/screens/utils/MKColors.dart';
import 'package:mosq/screens/utils/MKConstant.dart';
import 'package:mosq/screens/utils/MKImages.dart';
import 'package:mosq/screens/utils/MKStrings.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:mosq/main.dart';

class TMTabProfile extends StatelessWidget {
  // late T9BadgeModel model;

  const TMTabProfile(this.model);
  final MasjidModel model;

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Container(
        margin: EdgeInsets.symmetric(horizontal: 16),
        child: SingleChildScrollView(
          child: Column(children: [
            // Description
            Container(
                padding: EdgeInsets.symmetric(horizontal: 10),
                alignment: Alignment.topLeft,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Divider(),
                    text(model.nama ?? "Nama Masjid",
                        textColor: appStore.textPrimaryColor,
                        fontFamily: fontBold,
                        fontSize: textSizeLargeMedium),
                    SizedBox(height: 5),
                    Row(
                      children: [
                        Icon(Icons.pin_drop_outlined, color: mkColorPrimary),
                        text(model.alamat ?? "Alamat",
                            isLongText: true, fontSize: textSizeMedium),
                      ],
                    ),
                    SizedBox(height: 5)
                  ],
                )),
            // ),
            // Deskripsi
            ExpansionTile(
              iconColor: mkColorPrimary,
              tilePadding: EdgeInsets.only(right: 10),
              // collapsedTextColor: Colors.amber,
              // backgroundColor: Colors.blue,
              initiallyExpanded: true,
              // leading: Icon(Icons.arrow_drop_down),

              childrenPadding: EdgeInsets.all(10),
              textColor: mkColorPrimary,
              title: Text(
                mk_lbl_deskripsi,
                style: TextStyle(
                    fontSize: textSizeLargeMedium, fontFamily: fontBold),
              ),
              children: <Widget>[
                text(model.deskripsi ?? "-",
                    fontSize: textSizeMedium, isLongText: true)
              ],
            ),

            // Lokasi
            ExpansionTile(
              tilePadding: EdgeInsets.only(right: 10),
              // collapsedTextColor: Colors.amber,
              // backgroundColor: Colors.blue,
              initiallyExpanded: true,
              childrenPadding: EdgeInsets.all(10),
              textColor: mkColorPrimary,

              title: Text(
                mk_lbl_lokasi,
                style: TextStyle(
                    fontSize: textSizeLargeMedium, fontFamily: fontBold),
              ),
              iconColor: mkColorPrimary,
              children: <Widget>[
                GridView(
                  scrollDirection: Axis.vertical,
                  padding: EdgeInsets.all(5),
                  shrinkWrap: true,
                  physics: ScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    // crossAxisSpacing: 5,
                    // mainAxisSpacing: 1,
                    childAspectRatio: 5,
                  ),
                  children: [
                    text(
                      mk_kecamatan,
                      textColor: mkTextColorSecondary,
                      fontSize: textSizeMedium,
                    ),
                    text(
                      model.kecamatan ?? mk_null,
                      // textColor: mkTextColorSecondary,
                      fontSize: textSizeMedium,
                    ),
                    text(
                      mk_kode_pos,
                      textColor: mkTextColorSecondary,
                      fontSize: textSizeMedium,
                    ),
                    text(
                      model.kodePos ?? mk_null,
                      // textColor: mkTextColorSecondary,
                      fontSize: textSizeMedium,
                    ),
                    text(
                      mk_kota,
                      textColor: mkTextColorSecondary,
                      fontSize: textSizeMedium,
                    ),
                    text(
                      model.kota ?? mk_null,
                      // textColor: mkTextColorSecondary,
                      fontSize: textSizeMedium,
                    ),
                    text(
                      mk_provinsi,
                      textColor: mkTextColorSecondary,
                      fontSize: textSizeMedium,
                    ),
                    text(
                      model.provinsi ?? mk_null,
                      // textColor: mkTextColorSecondary,
                      fontSize: textSizeMedium,
                    ),
                  ],
                ),
              ],
            ),
            // Bangunan
            ExpansionTile(
              tilePadding: EdgeInsets.only(right: 10),
              // collapsedTextColor: Colors.amber,
              // backgroundColor: Colors.blue,
              initiallyExpanded: true,
              childrenPadding: EdgeInsets.all(10),
              textColor: mkColorPrimary,
              // leading: Icon(Icons.arrow_drop_down),

              title: Text(
                mk_info_bangunan,
                style: TextStyle(
                    fontSize: textSizeLargeMedium, fontFamily: fontBold),
              ),
              iconColor: mkColorPrimary,
              children: <Widget>[
                GridView(
                  scrollDirection: Axis.vertical,
                  padding: EdgeInsets.all(5),
                  shrinkWrap: true,
                  physics: ScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    // crossAxisSpacing: 5,
                    // mainAxisSpacing: 1,
                    childAspectRatio: 5,
                  ),
                  children: [
                    text(
                      mk_tahun,
                      textColor: mkTextColorSecondary,
                      fontSize: textSizeMedium,
                    ),
                    text(
                      model.tahun ?? mk_null,
                      // textColor: mkTextColorSecondary,
                      fontSize: textSizeMedium,
                    ),
                    text(
                      mk_LT,
                      textColor: mkTextColorSecondary,
                      fontSize: textSizeMedium,
                    ),
                    text(
                      "${model.luasTanah} M\u00B2",
                      // textColor: mkTextColorSecondary,
                      fontSize: textSizeMedium,
                    ),
                    text(
                      mk_LB,
                      textColor: mkTextColorSecondary,
                      fontSize: textSizeMedium,
                    ),
                    text(
                      "${model.luasBangunan ?? 0} M\u00B2",
                      // textColor: mkTextColorSecondary,
                      fontSize: textSizeMedium,
                    ),
                    text(
                      mk_status_tanah,
                      textColor: mkTextColorSecondary,
                      fontSize: textSizeMedium,
                    ),
                    text(
                      model.statusTanah ?? mk_null,
                      // textColor: mkTextColorSecondary,
                      fontSize: textSizeMedium,
                    ),
                    text(
                      mk_legalitas,
                      textColor: mkTextColorSecondary,
                      fontSize: textSizeMedium,
                    ),
                    text(
                      model.legalitas ?? mk_null,
                      // textColor: mkTextColorSecondary,
                      fontSize: textSizeMedium,
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 10),
            // text("Akun Sosial Media", fontFamily: fontSemibold),
            // SosmedRow(),
            // IconButton(
            //     onPressed: () {
            //       showDialog(
            //           context: context,
            //           builder: (BuildContext context) => FormNama());
            //     },
            //     icon: Icon(Icons.edit))
          ]),
        ),
      ),
      Container(
          alignment: Alignment.bottomRight,
          padding: EdgeInsets.only(right: 15, bottom: 15),
          child: Obx(() => masjidC.myMasjid.value
              ? FloatingActionButton(
                  onPressed: () {
                    Get.toNamed(RouteName.form_profile + '/${model.id}',
                        arguments: model);
                  },
                  child: Icon(
                    Icons.edit,
                    color: mkWhite,
                  ),
                  backgroundColor: mkColorPrimary,
                )
              : SizedBox())),
    ]);
  }
}

class SosmedRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: () {
        // showDialog(
        //   context: context,
        //   builder: (BuildContext context) => FormSosmed(),
        // );
      },
      child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        Container(
          width: width / 7,
          height: width / 7,
          padding: EdgeInsets.all(width / 30),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
          ),
          child: Image.asset(
            mk_ic_fb,
            fit: BoxFit.cover,
          ),
        ),
        Container(
          width: width / 7,
          height: width / 7,
          padding: EdgeInsets.all(width / 30),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
          ),
          child: GestureDetector(
            onTap: () {
              toast("value");
            },
            child: Image.asset(
              mk_ic_ig,
              fit: BoxFit.cover,
            ),
          ),
        ),
        Container(
          width: width / 7,
          height: width / 7,
          padding: EdgeInsets.all(width / 30),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
          ),
          child: Image.asset(
            mk_ic_wa,
            fit: BoxFit.cover,
          ),
        ),
        Container(
          width: width / 7,
          height: width / 7,
          padding: EdgeInsets.all(width / 30),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
          ),
          child: Image.asset(
            mk_ic_twitter,
            fit: BoxFit.cover,
          ),
        ),
        Container(
          width: width / 7,
          height: width / 7,
          padding: EdgeInsets.all(width / 30),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
          ),
          child: Image.asset(
            mk_ic_gmail,
            fit: BoxFit.cover,
          ),
        ),
      ]),
    );
  }
}
