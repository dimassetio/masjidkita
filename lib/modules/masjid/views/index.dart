import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
// import 'package:mosq/integrations/controllers.dart';
import 'package:mosq/main.dart';
import 'package:mosq/main/utils/AppWidget.dart';
import 'package:mosq/modules/masjid/controllers/masjid_controller.dart';
import 'package:mosq/screens/utils/MKColors.dart';
import 'package:mosq/screens/utils/MKStrings.dart';
import 'package:mosq/screens/utils/MKImages.dart';
import 'package:mosq/screens/widgets/MasjidSlider.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:mosq/screens/widgets/MasjidList.dart';

class PageListMasjid extends GetView<MasjidController> {
  const PageListMasjid({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      // appBar: AppBar(
      //   leading: BackButton(
      //     onPressed: () {
      //       Get.back();
      //     },
      //   ),
      // ),
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [mkColorPrimary, mkColorSecondary])),
            ),
            Column(
              children: [
                // Search Bar
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        margin: EdgeInsets.only(left: 16),
                        child: GestureDetector(
                          onTap: () {
                            Get.back();
                            controller.clearController();
                          },
                          child: CircleAvatar(
                              backgroundColor: Colors.white30,
                              child: Icon(
                                Icons.arrow_back_ios_new,
                                color: mkWhite,
                              )),
                        ),
                      ),
                      Container(
                        height: 70,
                        width: width - 100,
                        margin: EdgeInsets.all(16),
                        child: Stack(
                          alignment: Alignment.centerRight,
                          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            TextField(
                              controller: controller.searchController,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: mkWhite,
                                hintText: mk_lbl_search,
                                contentPadding: EdgeInsets.only(
                                    left: 26.0,
                                    bottom: 8.0,
                                    top: 8.0,
                                    right: 50.0),
                                focusedBorder: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: mkWhite, width: 0.5),
                                    borderRadius: BorderRadius.circular(26)),
                                enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: mk_view_color, width: 0.5),
                                    borderRadius: BorderRadius.circular(26)),
                              ),
                            ),
                            Obx(
                              () => controller.isSearching.value
                                  ? GestureDetector(
                                      onTap: () {
                                        controller.searchController.clear();
                                        FocusScopeNode currentFocus =
                                            FocusScope.of(context);

                                        if (!currentFocus.hasPrimaryFocus) {
                                          currentFocus.unfocus();
                                        }
                                      },
                                      child: Padding(
                                          padding: EdgeInsets.only(right: 16.0),
                                          child: Icon(Icons.cancel,
                                              color: mkColorPrimary)),
                                    )
                                  : Padding(
                                      padding: EdgeInsets.only(right: 16.0),
                                      child: SvgPicture.asset(mk_ic_search,
                                          color: mkColorPrimary)),
                            )
                          ],
                        ),
                      ),
                    ]),

                15.height,
                // Obx(() =>
                //     text(masjidC.deMasjid.nama ?? "kosong")), // Main Column
                Expanded(
                  child: Container(
                    // margin: EdgeInsets.only(top: 100),
                    padding: EdgeInsets.only(top: 28),
                    alignment: Alignment.topLeft,
                    height: MediaQuery.of(context).size.height - 100,
                    decoration: BoxDecoration(
                        color: appStore.scaffoldBackground,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(24),
                            topRight: Radius.circular(24))),
                    child: SingleChildScrollView(
                      child: Obx(
                        () => controller.isSearching.value
                            // If Searching
                            ? Column(
                                children: [
                                  controller.isSearching.value
                                      ? Container(
                                          alignment: Alignment.topLeft,
                                          padding: EdgeInsets.only(
                                              left: 15, bottom: 5),
                                          child: Text(
                                            "${controller.filteredMasjid.length} Masjid ditemukan, dari total ${controller.masjids.length}",
                                            style: TextStyle(fontSize: 18),
                                          ),
                                        )
                                      : Container(),
                                  MasjidListing(
                                    mListings: controller.filteredMasjid,
                                  ),
                                ],
                              )
                            // If not Searching
                            : Column(
                                children: <Widget>[
                                  Container(
                                    alignment: Alignment.topLeft,
                                    padding:
                                        EdgeInsets.only(left: 15, bottom: 5),
                                    child: Text(
                                      mk_masjid_fav,
                                      style: TextStyle(fontSize: 18),
                                    ),
                                  ),

                                  Obx(
                                    () => controller.favMasjids.isEmpty
                                        ? text(mk_masjid_fav_null,
                                            isLongText: true, isCentered: true)
                                        : MasjidSliderWidget(
                                            controller.favMasjids),
                                  ),
                                  // SizedBox(height: 40),
                                  Container(
                                    alignment: Alignment.topLeft,
                                    padding: EdgeInsets.symmetric(
                                        vertical: 15, horizontal: 15),
                                    child: Text(
                                      mk_list_masjid,
                                      style: TextStyle(fontSize: 18),
                                    ),
                                  ),
                                  Obx(
                                    () => MasjidListing(
                                      mListings: controller.masjids,
                                    ),
                                  ),
                                ],
                              ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
