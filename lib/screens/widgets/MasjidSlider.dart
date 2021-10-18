import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mosq/integrations/controllers.dart';
import 'package:mosq/main/utils/AppWidget.dart';
import 'package:mosq/modules/masjid/models/masjid_model.dart';
import 'package:mosq/screens/utils/MKConstant.dart';
import 'package:mosq/screens/utils/MKImages.dart';
import 'package:mosq/screens/widgets/MasjidCarouselSlider.dart';
import 'package:mosq/screens/widgets/like_button/like_button.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../main.dart';

// ignore: must_be_immutable
class MasjidSliderWidget extends StatelessWidget {
  List<MasjidModel> mSliderList;
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
                  masjidC.gotoDetail(slider);
                  // await masjidC.getDetailMasjid(slider.id);
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
                        child: slider.photoUrl != "" && slider.photoUrl != null
                            ? CachedNetworkImage(
                                // imageBuilder: (context, imageProvider) => ,
                                placeholder: placeholderWidgetFn() as Widget
                                    Function(BuildContext, String)?,
                                imageUrl: slider.photoUrl ?? "",
                                height: 180,
                                width: width,
                                fit: BoxFit.cover,
                              )
                            : Image.asset(
                                mk_contoh_image,
                                height: 180,
                                width: width,
                                fit: BoxFit.cover,
                              ),
                        // Image.network(
                        //   slider.photoUrl ?? "",
                        //   height: 180,
                        //   width: width,
                        //   fit: BoxFit.cover,
                        //   loadingBuilder: (BuildContext context, Widget child,
                        //       ImageChunkEvent? loadingProgress) {
                        //     if (loadingProgress == null) {
                        //       return child;
                        //     }
                        //     return Center(
                        //       child: CircularProgressIndicator(
                        //         value: loadingProgress.expectedTotalBytes !=
                        //                 null
                        //             ? loadingProgress.cumulativeBytesLoaded /
                        //                 loadingProgress.expectedTotalBytes!
                        //             : null,
                        //       ),
                        //     );
                        //   },
                        //   errorBuilder: (BuildContext context, Object exception,
                        //       StackTrace? stackTrace) {
                        //     return Image.asset(mk_contoh_image,
                        //         height: 180, width: width, fit: BoxFit.cover);
                        //   },
                        // ),
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
                            isLiked: masjidC.idFavorit.contains(slider.id),
                            onTap: (isLiked) async {
                              masjidC.addFav(slider.id);
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