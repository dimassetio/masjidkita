import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:masjidkita/main/utils/AppWidget.dart';
import 'package:masjidkita/routes/route_name.dart';
import 'package:masjidkita/screens/utils/MKColors.dart';
import 'package:masjidkita/screens/utils/MKStrings.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:masjidkita/main.dart';

class BottomNav extends StatelessWidget {
  const BottomNav({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        // color: mkCat1,
        alignment: Alignment.bottomCenter,
        child: Container(
            height: 75,
            width: Get.width,
            decoration: boxDecoration(
              showShadow: true,
              radius: 20,
              // bgColor: mkCat2,
            ),
            padding: EdgeInsets.fromLTRB(10, 0, 10, 10),
            margin: EdgeInsets.all(20),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    height: 2,
                    width: Get.width / 5,
                    color: mkColorPrimary,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      NavButton(Icons.search, RouteName.list_masjid),
                      NavButton(Icons.person, RouteName.profile),
                      NavButton(Icons.settings, RouteName.list_masjid),
                    ],
                  ),
                ]))
        // Dismissible(
        //   key: key ?? Key(''),
        //   direction: DismissDirection.up,
        //   confirmDismiss: (direction) {
        //     return mCornerBottomSheet(context);
        //   },
        //   child: Container(
        //       height: 75,
        //       width: Get.width,
        //       decoration: boxDecoration(
        //         showShadow: true,
        //         radius: 20,
        //         // bgColor: mkCat2,
        //       ),
        //       padding: EdgeInsets.fromLTRB(10, 0, 10, 10),
        //       margin: EdgeInsets.all(20),
        //       child: Column(children: [
        //         Container(
        //           height: 2,
        //           width: Get.width / 5,
        //           color: mkColorPrimary,
        //         ),
        //         Row(
        //           crossAxisAlignment: CrossAxisAlignment.center,
        //           mainAxisAlignment: MainAxisAlignment.spaceAround,
        //           children: [
        //             IconButton(onPressed: () {}, icon: Icon(Icons.mail)),
        //             IconButton(onPressed: () {}, icon: Icon(Icons.settings)),
        //             IconButton(onPressed: () {}, icon: Icon(Icons.person)),
        //           ],
        //         ),
        //       ])),
        // )
        );
  }
}

class NavButton extends StatelessWidget {
  IconData icon;
  String routeName;

  NavButton(this.icon, this.routeName);

  @override
  Widget build(BuildContext context) {
    return IconButton(
        color: mkColorPrimary,
        iconSize: 30,
        onPressed: () {
          Get.toNamed(routeName);
        },
        icon: Icon(icon));
  }
}

mCornerBottomSheet(BuildContext aContext) {
  showModalBottomSheet(
      context: aContext,
      backgroundColor: appStore.scaffoldBackground,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
      ),
      builder: (builder) {
        return Container(
          height: 250.0,
          margin: EdgeInsets.all(20),
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Information",
                style: boldTextStyle(color: appStore.textPrimaryColor),
              ),
              16.height,
              Divider(height: 5, color: mkTextColorSecondary.withOpacity(0.5)),
              16.height,
              Text(mk_long_text,
                  style:
                      secondaryTextStyle(color: appStore.textSecondaryColor)),
              8.height,
            ],
          ),
        );
      });
}



      //   DraggableScrollableSheet(
      //     // expand: false,
      //     initialChildSize: 0.1,
      //     minChildSize: 0.1,
      //     maxChildSize: 0.5,
      //     builder: (context, scrollController) {
      //       return Container(
      //           color: mkCat3,
      //           text("halo"): GridView.builder(
      //               scrollDirection: Axis.vertical,
      //               shrinkWrap: true,
      //               controller: scrollController,
      //               // physics: NeverScrollableScrollPhysics(),
      //               //     isScrollable ? ScrollPhysics() : NeverScrollableScrollPhysics(),
      //               itemCount: 6,
      //               gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
      //                   crossAxisCount: 3,
      //                   crossAxisSpacing: 0,
      //                   mainAxisSpacing: 0,
      //                   childAspectRatio: 1),
      //               itemBuilder: (BuildContext context, int index) {
      //                 return GestureDetector(
      //                   onTap: () {
      //                     // fiturC.fiturRouting(index);
      //                     print(index);
      //                   },
      //                   child: Container(
      //                     alignment: Alignment.center,
      //                     color: mkWhite,
      //                     child: Column(
      //                       mainAxisAlignment: MainAxisAlignment.start,
      //                       children: <Widget>[
      //                         Container(
      //                           height: Get.width * 0.1,
      //                           width: Get.width * 0.1,
      //                           margin: EdgeInsets.only(bottom: 4, top: 8),
      //                           padding: EdgeInsets.all(Get.width / 30),
      //                           decoration:
      //                               boxDecoration(bgColor: mkCat1, radius: 10),
      //                           // child: SvgPicture.asset(
      //                           //   mFavouriteList![index].icon,
      //                           //   color: mkWhite,
      //                         ),
      //                         text("fiturName", fontSize: textSizeSMedium),
      //                       ],
      //                     ),
      //                   ),
      //                 );
      //               })
      //           // ListView.builder(
      //           //   // shrinkWrap: true,
      //           //   controller: scrollController,
      //           //   itemBuilder: (context, index) {

      //           //     return Column(
      //           //       children: [
      //           //         Row(
      //           //           mainAxisAlignment: MainAxisAlignment.spaceAround,
      //           //           children: [
      //           //             Icon(Icons.ac_unit),
      //           //             Icon(Icons.ac_unit),
      //           //             Icon(Icons.ac_unit),
      //           //           ],
      //           //         ),
      //           //         Container(
      //           //           height: 10,
      //           //           width: 10,
      //           //           color: mkCat1,
      //           //         )
      //           //       ],
      //           //     );
      //           //   },
      //           //   itemCount: 20,
      //           // ),
      //           );
      //     },
      //   ),
      // ),