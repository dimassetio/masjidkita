import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';

import 'package:get/get.dart';
import 'package:masjidkita/integrations/controllers.dart';

import 'package:masjidkita/main/utils/AppWidget.dart';
import 'package:masjidkita/screens/fitur/Kelola_Masjid/ManMasjid.dart';
import 'package:masjidkita/screens/utils/MKColors.dart';
import 'package:masjidkita/screens/utils/MKConstant.dart';
import 'package:masjidkita/screens/fitur/Kelola_Masjid/Dialog/FormBangunan.dart';
import 'package:masjidkita/screens/fitur/Kelola_Masjid/Dialog/FormDeskripsi.dart';
import 'package:masjidkita/screens/fitur/Kelola_Masjid/Dialog/FormLokasi.dart';
import 'package:masjidkita/screens/fitur/Kelola_Masjid/Dialog/FormNama.dart';
import 'package:masjidkita/screens/fitur/Kelola_Masjid/Dialog/FormSosmed.dart';
import 'package:masjidkita/screens/utils/MKImages.dart';
import 'package:masjidkita/screens/utils/MKStrings.dart';
import 'package:nb_utils/nb_utils.dart';
import '../../../../main.dart';

class TMTabProfile extends StatelessWidget {
  // late T9BadgeModel model;

  // TabProfile(T9BadgeModel model, int pos) {
  //   this.model = model;
  // }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16),
      child: SingleChildScrollView(
        child: Column(children: [
          // Description
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10),
            alignment: Alignment.topLeft,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Obx(() => Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Divider(),
                        text(manMasjidC.keMasjid.nama ?? "Nama Masjid",
                            textColor: appStore.textPrimaryColor,
                            fontFamily: fontBold,
                            fontSize: textSizeLargeMedium),
                        SizedBox(height: 5),
                        Row(
                          children: [
                            Icon(Icons.pin_drop_outlined,
                                color: mkColorPrimary),
                            text(manMasjidC.keMasjid.alamat ?? "Alamat",
                                isLongText: true, fontSize: textSizeMedium),
                          ],
                        ),
                        SizedBox(height: 5)
                      ],
                    )),
                GestureDetector(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) => FormNama(),
                      );
                    },
                    child: Icon(Icons.edit)),
              ],
            ),
          ),
          // Deskripsi
          ExpansionTile(
            iconColor: mkColorPrimary,
            tilePadding: EdgeInsets.only(right: 10),
            // collapsedTextColor: Colors.amber,
            // backgroundColor: Colors.blue,
            // initiallyExpanded: true,
            leading: Icon(Icons.arrow_drop_down),
            trailing: GestureDetector(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) => FormDeskripsi(),
                  );
                },
                child: Icon(
                  Icons.edit,
                  color: appStore.textPrimaryColor,
                )),
            childrenPadding: EdgeInsets.all(10),
            textColor: mkColorPrimary,
            title: Text(
              mk_lbl_deskripsi,
              style: TextStyle(
                  fontSize: textSizeLargeMedium, fontFamily: fontBold),
            ),
            children: <Widget>[
              Obx(() => text(manMasjidC.keMasjid.deskripsi ?? "-",
                  fontSize: textSizeMedium, isLongText: true))
            ],
          ),

          // Lokasi
          ExpansionTile(
            tilePadding: EdgeInsets.only(right: 10),
            // collapsedTextColor: Colors.amber,
            // backgroundColor: Colors.blue,
            // initiallyExpanded: true,
            childrenPadding: EdgeInsets.all(10),
            textColor: mkColorPrimary,
            leading: Icon(Icons.arrow_drop_down),
            trailing: GestureDetector(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) => FormLokasi(),
                  );
                },
                child: Icon(
                  Icons.edit,
                  color: appStore.textPrimaryColor,
                )),

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
                  Obx(() => text(
                        manMasjidC.keMasjid.kecamatan ?? mk_null,
                        // textColor: mkTextColorSecondary,
                        fontSize: textSizeMedium,
                      )),
                  text(
                    mk_kode_pos,
                    textColor: mkTextColorSecondary,
                    fontSize: textSizeMedium,
                  ),
                  Obx(() => text(
                        manMasjidC.keMasjid.kodePos ?? mk_null,
                        // textColor: mkTextColorSecondary,
                        fontSize: textSizeMedium,
                      )),
                  text(
                    mk_kota,
                    textColor: mkTextColorSecondary,
                    fontSize: textSizeMedium,
                  ),
                  Obx(() => text(
                        manMasjidC.keMasjid.kota ?? mk_null,
                        // textColor: mkTextColorSecondary,
                        fontSize: textSizeMedium,
                      )),
                  text(
                    mk_provinsi,
                    textColor: mkTextColorSecondary,
                    fontSize: textSizeMedium,
                  ),
                  Obx(() => text(
                        manMasjidC.keMasjid.provinsi ?? mk_null,
                        // textColor: mkTextColorSecondary,
                        fontSize: textSizeMedium,
                      )),
                ],
              ),
            ],
          ),
          // Bangunan
          ExpansionTile(
            tilePadding: EdgeInsets.only(right: 10),
            // collapsedTextColor: Colors.amber,
            // backgroundColor: Colors.blue,
            // initiallyExpanded: true,
            childrenPadding: EdgeInsets.all(10),
            textColor: mkColorPrimary,
            leading: Icon(Icons.arrow_drop_down),
            trailing: GestureDetector(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) => FormBangunan(),
                  );
                },
                child: Icon(
                  Icons.edit,
                  color: appStore.textPrimaryColor,
                )),

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
                  Obx(() => text(
                        manMasjidC.keMasjid.tahun ?? mk_null,
                        // textColor: mkTextColorSecondary,
                        fontSize: textSizeMedium,
                      )),
                  text(
                    mk_LT,
                    textColor: mkTextColorSecondary,
                    fontSize: textSizeMedium,
                  ),
                  Obx(() => text(
                        manMasjidC.keMasjid.luasTanah ?? mk_null,
                        // textColor: mkTextColorSecondary,
                        fontSize: textSizeMedium,
                      )),
                  text(
                    mk_LB,
                    textColor: mkTextColorSecondary,
                    fontSize: textSizeMedium,
                  ),
                  Obx(() => text(
                        manMasjidC.keMasjid.luasBangunan ?? mk_null,
                        // textColor: mkTextColorSecondary,
                        fontSize: textSizeMedium,
                      )),
                  text(
                    mk_status_tanah,
                    textColor: mkTextColorSecondary,
                    fontSize: textSizeMedium,
                  ),
                  Obx(() => text(
                        manMasjidC.keMasjid.statusTanah ?? mk_null,
                        // textColor: mkTextColorSecondary,
                        fontSize: textSizeMedium,
                      )),
                  text(
                    mk_legalitas,
                    textColor: mkTextColorSecondary,
                    fontSize: textSizeMedium,
                  ),
                  Obx(() => text(
                        manMasjidC.keMasjid.legalitas ?? mk_null,
                        // textColor: mkTextColorSecondary,
                        fontSize: textSizeMedium,
                      )),
                ],
              ),
            ],
          ),
          SizedBox(height: 10),
          text("Akun Sosial Media", fontFamily: fontSemibold),
          SosmedRow(),
        ]),
      ),
    );
  }
}

class SosmedRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder: (BuildContext context) => FormSosmed(),
        );
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
