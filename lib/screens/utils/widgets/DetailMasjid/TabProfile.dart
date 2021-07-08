import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'package:get/get.dart';
import 'package:masjidkita/main/utils/AppWidget.dart';
import 'package:nb_utils/nb_utils.dart';
import '../../../../main.dart';
import '../../MKConstant.dart';
import '../../MKImages.dart';
import '../../MKColors.dart';

class TabProfile extends StatelessWidget {
  // late T9BadgeModel model;

  // TabProfile(T9BadgeModel model, int pos) {
  //   this.model = model;
  // }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16),
      child: SingleChildScrollView(
        child: Column(children: [
          // Description
          Container(
            alignment: Alignment.topLeft,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Divider(),
                text("Nama Masjid",
                    textColor: appStore.textPrimaryColor,
                    fontFamily: fontBold,
                    fontSize: textSizeLargeMedium),
                Row(
                  children: [
                    Icon(Icons.pin_drop_outlined, color: mkColorPrimary),
                    text("Alamat", isLongText: true, fontSize: textSizeMedium),
                  ],
                ),
                SizedBox(height: 5)
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
            childrenPadding: EdgeInsets.all(10),
            textColor: mkColorPrimary,
            title: Text(
              "Deskripsi",
              style: TextStyle(
                  fontSize: textSizeLargeMedium, fontFamily: fontBold),
            ),
            children: <Widget>[
              text('Lorem ipsum dolor sit amet consectetur adipisicing elit.',
                  fontSize: textSizeMedium, isLongText: true)
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

            title: Text(
              "Lokasi",
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
                    "Kecamatan",
                    textColor: mkTextColorSecondary,
                    fontSize: textSizeMedium,
                  ),
                  text(
                    "Dampit",
                    // textColor: mkTextColorSecondary,
                    fontSize: textSizeMedium,
                  ),
                  text(
                    "Kode Pos",
                    textColor: mkTextColorSecondary,
                    fontSize: textSizeMedium,
                  ),
                  text(
                    "65181",
                    // textColor: mkTextColorSecondary,
                    fontSize: textSizeMedium,
                  ),
                  text(
                    "Kota",
                    textColor: mkTextColorSecondary,
                    fontSize: textSizeMedium,
                  ),
                  text(
                    "Kab. Malang",
                    // textColor: mkTextColorSecondary,
                    fontSize: textSizeMedium,
                  ),
                  text(
                    "Provinsi",
                    textColor: mkTextColorSecondary,
                    fontSize: textSizeMedium,
                  ),
                  text(
                    "Jawa Timur",
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
            // initiallyExpanded: true,
            childrenPadding: EdgeInsets.all(10),
            textColor: mkColorPrimary,

            title: Text(
              "Informasi Bangunan",
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
                    "Tahun Berdiri",
                    textColor: mkTextColorSecondary,
                    fontSize: textSizeMedium,
                  ),
                  text(
                    "1999",
                    // textColor: mkTextColorSecondary,
                    fontSize: textSizeMedium,
                  ),
                  text(
                    "Luas Tanah",
                    textColor: mkTextColorSecondary,
                    fontSize: textSizeMedium,
                  ),
                  text(
                    "356 m2",
                    // textColor: mkTextColorSecondary,
                    fontSize: textSizeMedium,
                  ),
                  text(
                    "Luas Bangunan",
                    textColor: mkTextColorSecondary,
                    fontSize: textSizeMedium,
                  ),
                  text(
                    "267 m2",
                    // textColor: mkTextColorSecondary,
                    fontSize: textSizeMedium,
                  ),
                  text(
                    "Status Tanah",
                    textColor: mkTextColorSecondary,
                    fontSize: textSizeMedium,
                  ),
                  text(
                    "Milik Bersama",
                    // textColor: mkTextColorSecondary,
                    fontSize: textSizeMedium,
                  ),
                  text(
                    "Legalitas",
                    textColor: mkTextColorSecondary,
                    fontSize: textSizeMedium,
                  ),
                  text(
                    "Sah",
                    // textColor: mkTextColorSecondary,
                    fontSize: textSizeMedium,
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
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
                child: Image.asset(
                  mk_ic_ig,
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
            ],
          ),
        ]),
      ),
    );
  }
}
