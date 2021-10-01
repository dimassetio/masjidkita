import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:mosq/integrations/controllers.dart';
import 'package:mosq/main.dart';
import 'package:mosq/main/utils/AppWidget.dart';
import 'package:mosq/modules/kas/buku/models/kas_model.dart';
import 'package:mosq/modules/masjid/models/masjid_model.dart';
import 'package:mosq/routes/route_name.dart';
import 'package:mosq/screens/utils/MKColors.dart';
import 'package:mosq/screens/utils/MKConstant.dart';
import 'package:mosq/screens/utils/MKImages.dart';
import 'package:mosq/screens/utils/MKStrings.dart';
import 'package:mosq/screens/widgets/ConfirmLogout.dart';
import 'package:nb_utils/nb_utils.dart';

class MosQDrawer extends StatelessWidget {
  MosQDrawer(this.model);
  MasjidModel model;

  var _selectedItem = 0.obs;
  int get selectedItem => _selectedItem.value;
  set selectedItem(int value) => this._selectedItem.value = value;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.85,
      height: MediaQuery.of(context).size.height,
      child: Obx(
        () => Drawer(
          elevation: 8,
          child: Container(
            color: appStore.scaffoldBackground,
            child: SingleChildScrollView(
              child: Container(
                width: MediaQuery.of(context).size.width,
                color: appStore.scaffoldBackground,
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(top: 70, right: 20),
                      child: Container(
                        padding: EdgeInsets.fromLTRB(20, 40, 20, 40),
                        decoration: BoxDecoration(
                            color: mkColorPrimary,
                            borderRadius: BorderRadius.only(
                                bottomRight: Radius.circular(24.0),
                                topRight: Radius.circular(24.0))),
                        /*User Profile*/
                        child: Row(
                          children: <Widget>[
                            CircleAvatar(
                                backgroundImage: AssetImage(mk_profile_pic),
                                radius: 40),
                            SizedBox(width: 16),
                            Expanded(
                              child: Container(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Text(
                                        authController.user.name ?? mk_lbl_nama,
                                        style: boldTextStyle(
                                            color: white, size: 20)),
                                    SizedBox(height: 8),
                                    Text(
                                        authController.user.email ??
                                            mk_lbl_email,
                                        style: primaryTextStyle(color: white)),
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 30),
                    getDrawerItem(mk_user, mk_lbl_profil, 1),
                    ExpansionTile(
                      title: Align(
                        alignment: Alignment(-1.3, 0),
                        child:
                            Text(mk_lbl_kas, style: primaryTextStyle(size: 18)),
                      ),
                      leading: Icon(
                        Icons.library_books,
                        size: 20,
                      ),
                      childrenPadding: EdgeInsets.only(left: 20),
                      children: [
                        getDrawerItem(mk_report, mk_lbl_Kategori_transaksi, 2,
                            ontap: () {
                          Get.toNamed(RouteName.kategori, arguments: model);
                        }),
                        // getDrawerItem(mk_report, 'Tes ' + mk_lbl_transaksi, 2,
                        //     ontap: () {
                        //   Get.toNamed(RouteName.tes_transaksi,
                        //       arguments: model);
                        // }),
                        getDrawerItem(mk_report, 'Buku Kas Baru', 3, ontap: () {
                          Get.toNamed(RouteName.new_kas,
                              arguments: KasModel(dao: model.kasDao));
                        }),
                      ],
                    ),
                    16.height,
                    Divider(height: 1),
                    16.height,
                    getDrawerItem(mk_settings, mk_lbl_settings, 4),
                    getDrawerItem(mk_logout, mk_log_out, 5, ontap: () {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) => ConfirmLogout());
                    }),
                    16.height,
                    Divider(height: 1),
                    16.height,
                    getDrawerItem(mk_share, mk_lbl_share_and_invite, 6),
                    SizedBox(height: 30),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget getDrawerItem(String icon, String name, int pos,
      {void Function()? ontap}) {
    void Function() defaultOnTap = () {
      selectedItem = pos;
    };
    return ListTile(
      onTap: ontap ?? defaultOnTap,
      tileColor: mkColorAccent,
      leading: SvgPicture.asset(icon,
          width: 20, height: 20, color: appStore.iconColor),
      title: Align(
        alignment: Alignment(-1.2, 0),
        child: Text(name,
            style: primaryTextStyle(
                color: selectedItem == pos
                    ? mkColorPrimaryDark
                    : appStore.textPrimaryColor,
                size: 18)),
      ),
    );
  }
}
