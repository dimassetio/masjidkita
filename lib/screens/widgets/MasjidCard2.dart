import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mosq/integrations/controllers.dart';
import 'package:mosq/main/utils/AppWidget.dart';
import 'package:mosq/modules/profile/models/masjid_model.dart';
import 'package:mosq/routes/route_name.dart';
import 'package:mosq/screens/utils/MKColors.dart';
import 'package:mosq/screens/utils/MKConstant.dart';
import 'package:mosq/screens/utils/MKImages.dart';
import 'package:mosq/screens/widgets/like_button/like_button.dart';
import 'package:nb_utils/nb_utils.dart';
import '../../../main.dart';

class MasjidCard2 extends StatelessWidget {
  const MasjidCard2({
    Key? key,
    required this.dataMasjid,
    required this.width,
  }) : super(key: key);

  final MasjidModel dataMasjid;
  final double width;

  @override
  Widget build(BuildContext context) {
    return Container(
        // color: mkColorAccent,
        // padding: EdgeInsets.fromLTRB(16, 0, 16, 16),
        child: Column(
      children: <Widget>[
        Container(
          margin: EdgeInsets.symmetric(horizontal: 10),
          padding: EdgeInsets.only(right: 5),
          decoration: boxDecoration(
            radius: 10,
            // bgColor: mkColorPrimary,
            showShadow: true,
          ),
          child: Row(
            children: <Widget>[
              ClipRRect(
                child: dataMasjid.photoUrl != "" && dataMasjid.photoUrl != null
                    ? CachedNetworkImage(
                        placeholder: placeholderWidgetFn() as Widget Function(
                            BuildContext, String)?,
                        imageUrl: dataMasjid.photoUrl ?? "",
                        width: width / 3,
                        height: width / 3.2,
                        fit: BoxFit.fill,
                      )
                    : Image.asset(
                        mk_contoh_image,
                        width: width / 3,
                        height: width / 3.2,
                        fit: BoxFit.fill,
                      ),
                //     Image.asset(
                //   mk_contoh_image,
                //   width: width / 3,
                //   height: width / 3.2,
                //   fit: BoxFit.fill,
                // ),
                borderRadius: BorderRadius.circular(10),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(left: 10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          text(dataMasjid.nama,
                              textColor: appStore.textPrimaryColor,
                              fontSize: textSizeLargeMedium,
                              fontFamily: fontBold),
                          text(dataMasjid.alamat,
                              fontSize: textSizeMedium,
                              textColor: appStore.textPrimaryColor),
                          SizedBox(
                            height: 4,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Obx(() => LikeButton(
                                    size: 25,
                                    isLiked: listMasjidC.idFavorit
                                        .contains(dataMasjid.id),
                                    onTap: (isLiked) async {
                                      listMasjidC.addFav(dataMasjid.id);
                                      return !isLiked;
                                    },
                                  )),
                              IconButton(
                                icon: Icon(
                                  Icons.share,
                                  color: mkTextColorSecondary,
                                  size: 25,
                                ),
                                onPressed: () {
                                  // manMasjidC.deleteMasjid(dataMasjid.id);
                                  toast("On Progress");
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
        Divider()
      ],
    ));
  }
}
