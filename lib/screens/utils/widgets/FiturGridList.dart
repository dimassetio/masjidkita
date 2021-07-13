import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:masjidkita/main/utils/AppWidget.dart';
import 'package:masjidkita/routes/route_name.dart';
import 'package:masjidkita/controllers/fiturController.dart';
import 'package:masjidkita/screens/fitur/Kelola_Masjid/Dialog/cekLog.dart';
import 'package:masjidkita/screens/utils/MKColors.dart';
import 'package:masjidkita/screens/utils/MKConstant.dart';
import 'package:masjidkita/screens/utils/MKImages.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../main.dart';
// import '../T5Colors.dart';
// import '../T5Constant.dart';

// ignore: must_be_immutable

class MQCategory {
  var name = "";
  Color? color;
  // Function routeName = () {};
  var icon = "";
}

class MQGridListing extends StatelessWidget {
  List<MQCategory>? mFavouriteList;
  var isScrollable = false;

  MQGridListing(this.mFavouriteList, this.isScrollable);

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    final fiturC = Get.find<FiturController>();

    return GridView.builder(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        physics:
            isScrollable ? ScrollPhysics() : NeverScrollableScrollPhysics(),
        itemCount: mFavouriteList!.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3, crossAxisSpacing: 16, mainAxisSpacing: 16),
        itemBuilder: (BuildContext context, int index) {
          return GestureDetector(
            onTap: () {
              fiturC.fiturRouting(index);
              print(index);
            },
            child: Container(
              alignment: Alignment.center,
              decoration: boxDecoration(
                  radius: 10,
                  showShadow: true,
                  bgColor: appStore.scaffoldBackground),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    height: width / 7.5,
                    width: width / 7.5,
                    margin: EdgeInsets.only(bottom: 4, top: 8),
                    padding: EdgeInsets.all(width / 30),
                    decoration: boxDecoration(
                        bgColor: mFavouriteList![index].color, radius: 10),
                    child: SvgPicture.asset(
                      mFavouriteList![index].icon,
                      color: mkWhite,
                    ),
                  ),
                  text(mFavouriteList![index].name,
                      textColor: appStore.textSecondaryColor,
                      fontSize: textSizeMedium)
                ],
              ),
            ),
          );
        });
  }
}

List<MQCategory> getCategoryItems() {
  List<MQCategory> list = [];

  var category1 = MQCategory();
  category1.name = "Si Masjid";
  category1.color = mkCat1;
  category1.icon = mk_ic_mosque_2;
  // category1.routeName = ;
  list.add(category1);

  var category2 = MQCategory();
  category2.name = "Kelola Masjid";
  category2.color = mkCat2;
  category2.icon = mk_ic_mosque;
  // category2.routeName = RouteName.kelolamasjid;
  list.add(category2);

  var category3 = MQCategory();
  category3.name = "Tasbih ";
  category3.color = mkCat3;
  category3.icon = mk_ic_tasbih;
  list.add(category3);

  var category4 = MQCategory();
  category4.name = "Adzan";
  category4.color = mkCat4;
  category4.icon = mk_ic_adzan;
  list.add(category4);

  var category5 = MQCategory();
  category5.name = "Alqur'an";
  category5.color = mkCat5;
  category5.icon = mk_ic_quran;
  list.add(category5);

  var category = MQCategory();
  category.name = "More";
  category.color = mkCat6;
  category.icon = t5_circle;
  list.add(category);
  return list;
}
