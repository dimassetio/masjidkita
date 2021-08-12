import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
// import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:mosq/integrations/controllers.dart';
import 'package:mosq/main/utils/AppConstant.dart';
// import 'package:mosq/controllers/manMasjidController.dart';
import 'package:mosq/main/utils/AppWidget.dart';
import 'package:mosq/routes/route_name.dart';
import 'package:mosq/screens/utils/MKColors.dart';
import 'package:mosq/screens/utils/MKStrings.dart';
import 'package:mosq/screens/widgets/BottomNav.dart';
import 'package:mosq/screens/widgets/ConfirmLogout.dart';
import 'package:mosq/screens/widgets/KegiatanSlider.dart';
import 'package:mosq/screens/widgets/MasjidSlider.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:showcaseview/showcaseview.dart';

// import 'package:mosq/theme5/widgets/T5Slider.dart';

import '../../main.dart';

class MosqDashboard extends StatefulWidget {
  const MosqDashboard({Key? key}) : super(key: key);

  @override
  _MosqDashboardState createState() => _MosqDashboardState();
}

// class MosqDashboardDashboard extends StatelessWidget {
class _MosqDashboardState extends State<MosqDashboard> {
  late BuildContext myContext;

  GlobalKey scOne = GlobalKey();
  GlobalKey scTwo = GlobalKey();
  GlobalKey scThree = GlobalKey();

  @override
  void initState() {
    super.initState();
    // WidgetsBinding.instance!.addPostFrameCallback((_) {
    //   Future.delayed(Duration(milliseconds: 5000), () {
    //     print("puntent");
    //     ShowCaseWidget.of(context)!.startShowCase([authController.scOne]);
    //   });
    // });

    WidgetsBinding.instance!.addPostFrameCallback((_) {
      Future.delayed(
          Duration(milliseconds: 200),
          () => authController.isFirstLaunch.value
              ? ShowCaseWidget.of(myContext)!.startShowCase([scOne, scTwo])
              : null);
    });
  }

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
        body: ShowCaseWidget(
          builder: Builder(
            builder: (BuildContext context) {
              return NestedScrollView(
                headerSliverBuilder:
                    (BuildContext context, bool innerBoxIsScrolled) {
                  myContext = context;

                  return <Widget>[
                    SliverAppBar(
                      actions: [
                        Showcase(
                            key: scOne,
                            child: Obx(
                              () => IconButton(
                                  onPressed: () {
                                    print(authController.isLoggedIn.value);
                                    authController.isLoggedIn.value
                                        ? showDialog(
                                            context: context,
                                            builder: (BuildContext context) =>
                                                ConfirmLogout())
                                        // authController.signOut()
                                        : Get.toNamed(RouteName.sign_in);
                                  },
                                  icon: Icon(
                                    authController.isLoggedIn.value
                                        ? Icons.logout
                                        : Icons.person,
                                    color: appStore.isDarkModeOn
                                        ? appStore.iconColor
                                        : mkWhite,
                                  )),
                            ),
                            title: 'Login',
                            description:
                                'Jika anda seorang pengurus masjid dan ingin membuka halaman pengelola masjid, silahkan mendaftar atau login ke akun yang sudah anda buat')
                      ],
                      expandedHeight: 200.0,
                      floating: true,
                      pinned: true,
                      snap: false,
                      elevation: 50,
                      backgroundColor: mkColorPrimary,
                      flexibleSpace: FlexibleSpaceBar(
                        // centerTitle: true,
                        // title: Text('MosqDashboard', style: primaryTextStyle(color: white)),
                        background: GestureDetector(
                            onTap: () {
                              toast("go to adzan page");
                            },
                            child: Container(
                                // alignment: Alignment.center,
                                padding: EdgeInsets.fromLTRB(Get.width / 20,
                                    Get.width / 10, Get.width / 20, 0),
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
                          // Experimen
                          text('testing', fontSize: textSizeSMedium),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              // Obx(
                              //   () => text(
                              //       "is FL : ${authController.isFirstLaunch.value}"),
                              // ),
                              TextButton.icon(
                                  label: text("First Launch Status",
                                      fontSize: textSizeSMedium),
                                  onPressed: () async {
                                    await authController.box
                                        .remove('first_launch');
                                  },
                                  icon: Icon(Icons.delete)),
                              TextButton.icon(
                                  label: text("ToolTip"),
                                  onPressed: () {
                                    // authController.box.remove('first_launch');
                                    ShowCaseWidget.of(context)!
                                        .startShowCase([scOne, scTwo]);
                                    print("P!");
                                  },
                                  icon: Icon(Icons.play_circle)),
                            ],
                          ),
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
                                ? Showcase(
                                    overlayPadding: EdgeInsets.symmetric(
                                        vertical: 10, horizontal: -5),
                                    key: scTwo,
                                    title: 'Masjid Favorit',
                                    description:
                                        'Tambahkan satu atau beberapa masjid yang sering anda lihat untuk mempermudah anda ketika ingin melihatnya lagi',
                                    child: Column(
                                      children: [
                                        text(mk_masjid_fav_null,
                                            isLongText: true, isCentered: true),
                                        SizedBox(height: 5),
                                        FloatingActionButton.extended(
                                            heroTag: '5',
                                            label: Text(
                                              mk_lbl_search,
                                              style: primaryTextStyle(
                                                  color: Colors.white),
                                            ),
                                            backgroundColor: mkColorPrimary,
                                            icon: Icon(
                                              Icons.search,
                                              color: Colors.white,
                                            ),
                                            onPressed: () {
                                              Get.toNamed(
                                                  RouteName.list_masjid);
                                            }),
                                        10.height // ElevatedButton(
                                        //     onPressed: () {},
                                        //     child: Row(
                                        //       children: [
                                        //         Icon(Icons.search),
                                        //         text("Cari Masjid")
                                        //       ],
                                        //     ))
                                      ],
                                    ),
                                  )
                                : MasjidSliderWidget(
                                    listMasjidC.favMasjids,
                                    infinite: false,
                                  ),
                          ),
                          // SizedBox(height: 40),
                          Divider(),
                          Container(
                            alignment: Alignment.topLeft,
                            padding: EdgeInsets.symmetric(
                                vertical: 15, horizontal: 15),
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
                        ],
                      ),
                    ),
                  ),
                  BottomNav()
                ]),
              );
            },
          ),
        ));
  }
}
