import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:masjidkita/integrations/controllers.dart';
import 'package:masjidkita/main/utils/AppConstant.dart';
// import 'package:masjidkita/controllers/manMasjidController.dart';
import 'package:masjidkita/main/utils/AppWidget.dart';
import 'package:masjidkita/routes/route_name.dart';
import 'package:masjidkita/screens/utils/MKColors.dart';
import 'package:masjidkita/screens/utils/widgets/FiturGridList.dart';
import 'package:masjidkita/screens/utils/widgets/UserTopBar.dart';
import 'package:nb_utils/nb_utils.dart';

// import 'package:masjidkita/theme5/utils/widgets/T5Slider.dart';

import '../../main.dart';

class MosqDashboard extends StatefulWidget {
  static var tag = "/MosqDashboard";

  @override
  MosqDashboardState createState() => MosqDashboardState();
}

class MosqDashboardState extends State<MosqDashboard> {
  bool passwordVisible = false;
  bool isRemember = false;
  var currentIndexPage = 0;
  List<MQCategory>? mFavouriteList;
  // List<T5Slider>? mSliderList;

  @override
  void initState() {
    super.initState();
    passwordVisible = false;
    mFavouriteList = getCategoryItems();
    // mSliderList = getSliders();
  }

  void changeSldier(int index) {
    setState(() {
      currentIndexPage = index;
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
      body: SafeArea(
        child: Stack(children: [
          Container(
            height: 200,
            color: mkColorPrimary,
          ),
          SingleChildScrollView(
            child: Column(
              children: <Widget>[
                UserTopBar(),
                Container(
                  padding: EdgeInsets.only(top: 28),
                  alignment: Alignment.topLeft,
                  decoration: BoxDecoration(
                      color: appStore.scaffoldBackground,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(24),
                          topRight: Radius.circular(24))),
                  child: Column(
                    children: <Widget>[
                      //     // T5SliderWidget(mSliderList),
                      SizedBox(height: 20),
                      Padding(
                        padding: EdgeInsets.all(24.0),
                        child: MQGridListing(mFavouriteList, false),
                      ),
                      // Obx(
                      //   () => Text(
                      //       "Has Masjid = " + manMasjidC.haveMasjid.toString()),
                      // ),
                      // Obx(
                      //   () =>
                      //       Text("Nama " + manMasjidC.keMasjid.nama.toString()),
                      // ),
                      // Obx(
                      //   () => Text("Id " + manMasjidC.keMasjid.id.toString()),
                      // ),
                      // Obx(
                      //   () => Text("User " + authController.user.id.toString()),
                      // ),
                      Switch(
                          value: appStore.isDarkModeOn,
                          onChanged: (bool newValue) {
                            appStore.toggleDarkMode();
                          }),
                      ElevatedButton(
                          onPressed: () {
                            manMasjidC.testdata();
                            Get.toNamed(RouteName.home);
                          },
                          child: Icon(Icons.refresh))
                    ],
                  ),
                ),
              ],
            ),
          ),
          // ),
        ]),
      ),
      // bottomNavigationBar: T5BottomBar(),
    );
  }
}
