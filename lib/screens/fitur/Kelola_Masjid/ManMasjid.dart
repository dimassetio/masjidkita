import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:masjidkita/controllers/manMasjidController.dart';
import 'package:masjidkita/integrations/controllers.dart';
import 'package:masjidkita/main/main%20copy.dart';
import 'package:masjidkita/main/utils/AppWidget.dart';
import 'package:masjidkita/routes/route_name.dart';
import 'package:masjidkita/screens/fitur/Kelola_Masjid/Dialog/cekLog.dart';
import 'package:masjidkita/screens/fitur/Kelola_Masjid/KeMasjid.dart';
import 'package:masjidkita/screens/utils/MKColors.dart';
import 'package:masjidkita/screens/utils/MKConstant.dart';
import 'package:masjidkita/screens/utils/MKImages.dart';
import 'package:masjidkita/screens/utils/widgets/AddOrJoin.dart';
import 'package:masjidkita/screens/utils/widgets/UserTopBar.dart';
import 'package:nb_utils/nb_utils.dart';

class MMFitur {
  var name = "";
  var icon = "";
  Color? color;
  void Function()? route;
}

class ManMasjid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    changeStatusColor(mkWhite);
    final width = Get.width;
    var fitur1 = MMFitur();
    fitur1.name = "Informasi Masjid";
    fitur1.icon = mk_ic_mosque;
    fitur1.color = mkCat1;
    fitur1.route = () async {
      // await listMasjidC.bindListMasjid();

      // listMasjidC.masjids.isNotEmpty
      //     ?
      Get.toNamed(RouteName.mkdashboard);
      // : toast("Empty Masjid");
    };

    var fitur2 = MMFitur();
    fitur2.name = "Kelola Masjid";
    fitur2.icon = mk_ic_mosque_2;
    fitur2.color = mkCat6;
    fitur2.route = () async {
      await manMasjidC.testdata();
      if (authController.isLoggedIn.value == true) {
        manMasjidC.haveMasjid.value
            ? Get.toNamed(RouteName.kelolamasjid)
            :
            // toast("GaDue Masjid");

            showDialog(
                context: Get.context!,
                builder: (BuildContext context) => AddOrJoin(),
              );
      } else {
        showDialog(
          context: Get.context!,
          builder: (BuildContext context) => CekLogin(),
        );
      }
    };

    var fitur3 = MMFitur();
    fitur3.name = "Daftar Masjid Baru";
    fitur3.icon = mk_ic_add_mosque;
    fitur3.color = mkCat5;
    fitur3.route = () {
      Get.toNamed(RouteName.new_masjid);
    };

    List<MMFitur> fiturList = [fitur1, fitur2, fitur3];

    return Scaffold(
      backgroundColor: mkWhite,
      body: SafeArea(
        child: Stack(children: [
          Container(
            height: 200,
            color: mkColorPrimary,
          ),
          Column(
            // mainAxisAlignment: MainAxisAlignment.center,
            children: [
              UserTopBar(),
              Container(
                alignment: Alignment.center,
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                    color: mkWhite,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(24),
                        topRight: Radius.circular(24))),
                child: ListView.builder(
                  // itemCount: fiturName.length,
                  itemCount: fiturList.length,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: fiturList[index].route,
                      child: Container(
                        margin: EdgeInsets.all(10),
                        width: width,
                        padding: EdgeInsets.all(10),
                        decoration: boxDecoration(
                            bgColor: appStore.scaffoldBackground,
                            radius: 10,
                            showShadow: true),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              height: width / 7.5,
                              width: width / 7.5,
                              margin: EdgeInsets.only(right: 8),
                              padding: EdgeInsets.all(width / 30),
                              decoration: boxDecoration(
                                  bgColor: fiturList[index].color, radius: 10),
                              child: SvgPicture.asset(
                                fiturList[index].icon,
                                color: mkWhite,
                              ),
                            ),
                            text(
                              fiturList[index].name,
                              isCentered: true,
                              isLongText: true,
                              textColor: mkTextColorSecondary,
                            ),
                            Expanded(
                              child: Container(
                                  alignment: Alignment.centerRight,
                                  child: Icon(Icons.chevron_right)),
                            )
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              // Container(
              //   // color: mkCat1,
              //   child: ElevatedButton(
              //       onPressed: (listMasjidC.tesFav()), child: Text("tes")),
              // )
            ],
          ),
        ]),
      ),
    );
  }
}
