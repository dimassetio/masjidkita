import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
// import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:masjidkita/integrations/controllers.dart';
import 'package:masjidkita/main/utils/AppConstant.dart';
// import 'package:masjidkita/controllers/manMasjidController.dart';
import 'package:masjidkita/main/utils/AppWidget.dart';
import 'package:masjidkita/routes/route_name.dart';
import 'package:masjidkita/screens/utils/MKColors.dart';
import 'package:masjidkita/screens/utils/MKStrings.dart';
import 'package:masjidkita/screens/utils/widgets/BottomNav.dart';
import 'package:masjidkita/screens/utils/widgets/FiturGridList.dart';
import 'package:masjidkita/screens/utils/widgets/KegiatanSlider.dart';
import 'package:masjidkita/screens/utils/widgets/MasjidList.dart';
import 'package:masjidkita/screens/utils/widgets/MasjidSlider.dart';
import 'package:masjidkita/screens/utils/widgets/UserTopBar.dart';
import 'package:nb_utils/nb_utils.dart';

// import 'package:masjidkita/theme5/utils/widgets/T5Slider.dart';

import '../../main.dart';

class MosqDashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    changeStatusColor(mkColorPrimary);
    var width = Get.width;
    width = width - 50;
    final GlobalKey<ScaffoldState> _scaffoldKey =
        new GlobalKey<ScaffoldState>();

    return Scaffold(
      // backgroundColor: mkColorPrimary,
      key: _scaffoldKey,
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              actions: [
                IconButton(
                    onPressed: () {
                      toast("Go to Login");
                    },
                    icon: Icon(
                      Icons.person,
                      color:
                          appStore.isDarkModeOn ? appStore.iconColor : mkWhite,
                    ))
              ],
              expandedHeight: 200.0,
              floating: true,
              pinned: true,
              snap: false,
              elevation: 50,
              backgroundColor: mkColorPrimary,
              flexibleSpace: FlexibleSpaceBar(
                // centerTitle: true,
                // title: Text('Mosq', style: primaryTextStyle(color: white)),
                background: GestureDetector(
                    onTap: () {
                      toast("go to adzan page");
                    },
                    child: Container(
                        // alignment: Alignment.center,
                        padding: EdgeInsets.fromLTRB(
                            Get.width / 20, Get.width / 10, Get.width / 20, 0),
                        color: mkColorPrimary,
                        child: Column(
                          // crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Align(
                              alignment: Alignment.centerLeft,
                              child: text("09:00:00",
                                  textColor: mkWhite,
                                  fontSize: textSizeLargeMedium),
                            ),
                            text("Dzuhur", textColor: mkWhite),
                            text(
                              "11:36",
                              textColor: mkWhite,
                              fontSize: textSizeXXLarge,
                            ),
                            text(
                              "2 jam 36 menit lagi",
                              textColor: mkWhite,
                              fontSize: textSizeMedium,
                            ),
                          ],
                        ))),
              ),
            )
          ];
        },
        body: Stack(children: [
          Container(
            // margin: EdgeInsets.only(top: 100),
            padding: EdgeInsets.only(top: 28),
            alignment: Alignment.topLeft,
            // height: MediaQuery.of(context).size.height - 100,
            decoration: BoxDecoration(
                color: mkWhite2,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(24),
                    topRight: Radius.circular(24))),
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Container(
                    alignment: Alignment.topLeft,
                    padding: EdgeInsets.only(left: 15, bottom: 5),
                    child: Text(
                      mk_masjid_fav,
                      style: TextStyle(fontSize: 18),
                    ),
                  ),

                  Obx(
                    () => listMasjidC.favMasjids.isEmpty
                        ? text(mk_masjid_fav_null,
                            isLongText: true, isCentered: true)
                        : MasjidSliderWidget(
                            listMasjidC.favMasjids,
                            infinite: false,
                          ),
                  ),
                  // SizedBox(height: 40),
                  Divider(),
                  Container(
                    alignment: Alignment.topLeft,
                    padding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                    child: Text(
                      mk_kegiatan_masjid,
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                  Obx(
                    () => KegiatanSliderWidget(
                      listMasjidC.masjids,
                      infinite: false,
                    ),
                  ),
                  text("Testing Masjid Favorit"),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        IconButton(
                            onPressed: () {
                              listMasjidC.readStr();
                            },
                            icon: Icon(Icons.refresh)),
                        TextButton(
                            onPressed: () => listMasjidC
                                .addFav("Atrwobk1pnUz4wKdYct5kTkKxTd2"),
                            child: text("Masjid 1")),
                        TextButton(
                            onPressed: () => listMasjidC
                                .addFav("bLmwedXB1IRjpJIz9IE0vjjfDHe2"),
                            child: text("Masjid 2")),
                      ]),
                ],
              ),
            ),
          ),
          BottomNav()
        ]),
      ),
    );
  }
}
