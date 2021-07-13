import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:masjidkita/integrations/controllers.dart';
import 'package:masjidkita/integrations/firestore.dart';
import 'package:masjidkita/main/utils/AppWidget.dart';
import 'package:masjidkita/routes/route_name.dart';
import 'package:masjidkita/screens/utils/MKColors.dart';
import 'package:masjidkita/screens/utils/MKConstant.dart';
import 'package:masjidkita/screens/utils/MKImages.dart';
import 'package:masjidkita/screens/utils/widgets/ConfirmLogout.dart';
import 'package:masjidkita/screens/utils/widgets/FiturGridList.dart';
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
                Container(
                    height: 70,
                    margin: EdgeInsets.all(16),
                    child: Obx(
                      () => Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              CircleAvatar(
                                // backgroundImage:
                                //     CachedNetworkImageProvider(mk_net_img),
                                radius: 25,
                              ),
                              SizedBox(width: 16),
                              text(
                                  authController.userModel.value.name ??
                                      "Guest",
                                  textColor: mkWhite,
                                  fontSize: textSizeNormal,
                                  fontFamily: fontMedium)
                            ],
                          ),
                          IconButton(
                            onPressed: () {
                              authController.isLoggedIn.value
                                  ? showDialog(
                                      context: context,
                                      builder: (BuildContext context) =>
                                          ConfirmLogout())
                                  : Get.toNamed(RouteName.sign_in);
                              // print("P");
                            },
                            icon: Icon(authController.isLoggedIn.value
                                ? Icons.logout
                                : Icons.login),
                            color: mkWhite,
                          )
                          // GestureDetector(
                          //   onTap: () {
                          //     toast("xcvxcxv ");
                          //     Get.toNamed(RouteName.sign_in);
                          //   },
                          // //   child: Icon(Icons.login, size: 25, color: mkWhite),
                          // )
                        ],
                      ),
                    )),
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
                      Obx(
                        () => Text("Is Logged In = " +
                            authController.isLoggedIn.toString()),
                      ),
                      ElevatedButton(
                          onPressed: () {}, child: Text("Test Controller"))
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
