import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:masjidkita/integrations/controllers.dart';
import 'package:masjidkita/main/utils/AppWidget.dart';
import 'package:masjidkita/routes/route_name.dart';
import 'package:masjidkita/screens/utils/MKImages.dart';
import 'package:masjidkita/screens/utils/widgets/MasjidCarouselSlider.dart';
import 'package:masjidkita/screens/utils/widgets/like_button/like_button.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../main.dart';
import '../MKColors.dart';
import '../MKConstant.dart';

// ignore: must_be_immutable
class MasjidSliderWidget extends StatelessWidget {
  List mSliderList;
  bool infinite;

  MasjidSliderWidget(this.mSliderList, {this.infinite: true});

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    width = width - 50;
    print(infinite);

    return MasjidCarouselSlider(
      viewportFraction: 0.9,
      enlargeCenterPage: true,
      scrollDirection: Axis.horizontal,
      enableInfiniteScroll: false,
      items: mSliderList.map((slider) {
        return Builder(
          builder: (BuildContext context) {
            return Container(
              decoration: boxDecoration(
                  radius: 16,
                  showShadow: true,
                  bgColor: appStore.scaffoldBackground),
              width: Get.width,
              child: GestureDetector(
                onTap: () async {
                  manMasjidC.gotoDetail(slider.id);
                  // await manMasjidC.getDetailMasjid(slider.id);
                  // Get.toNamed(RouteName.detail);
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(16.0),
                          topRight: Radius.circular(16.0),
                        ),
                        child: Image.network(
                          slider.photoUrl ?? "",
                          height: 180,
                          width: width,
                          fit: BoxFit.cover,
                          loadingBuilder: (BuildContext context, Widget child,
                              ImageChunkEvent? loadingProgress) {
                            if (loadingProgress == null) {
                              return child;
                            }
                            return Center(
                              child: CircularProgressIndicator(
                                value: loadingProgress.expectedTotalBytes !=
                                        null
                                    ? loadingProgress.cumulativeBytesLoaded /
                                        loadingProgress.expectedTotalBytes!
                                    : null,
                              ),
                            );
                          },
                          errorBuilder: (BuildContext context, Object exception,
                              StackTrace? stackTrace) {
                            return Image.asset(mk_contoh_image,
                                height: 180, width: width, fit: BoxFit.cover);
                          },
                        ),
                      ),
                    ),
                    Container(
                      width: width,
                      padding: EdgeInsets.fromLTRB(16, 0, 16, 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Container(
                            width: width - 115,
                            // color: mkCat1,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                text(slider.nama,
                                    textColor: appStore.textPrimaryColor,
                                    fontSize: textSizeLargeMedium,
                                    fontFamily: fontMedium),
                                text(
                                  slider.alamat,
                                ),
                              ],
                            ),
                          ),
                          LikeButton(
                            size: 25,
                            isLiked: listMasjidC.idFavorit.contains(slider.id),
                            onTap: (isLiked) async {
                              listMasjidC.addFav(slider.id);
                              return !isLiked;
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      }).toList(),
    );
  }
}
