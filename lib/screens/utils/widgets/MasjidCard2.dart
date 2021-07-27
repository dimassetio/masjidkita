import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:masjidkita/integrations/controllers.dart';
import 'package:masjidkita/main/utils/AppWidget.dart';
import 'package:masjidkita/routes/route_name.dart';
import 'package:masjidkita/screens/utils/MKColors.dart';
import 'package:masjidkita/screens/utils/MKImages.dart';
import 'package:masjidkita/screens/utils/widgets/like_button/like_button.dart';
import 'package:nb_utils/nb_utils.dart';
import '../../../main.dart';
import '../MKConstant.dart';

class MasjidCard2 extends StatelessWidget {
  const MasjidCard2({
    Key? key,
    required this.dataMasjid,
    required this.width,
  }) : super(key: key);

  final dataMasjid;
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
                child: Image.asset(
                  mk_contoh_image,
                  fit: BoxFit.fill,
                  width: width / 3,
                  height: width / 3.2,
                ),
                // child: CachedNetworkImage(
                //   placeholder: placeholderWidgetFn() as Widget Function(BuildContext, String)?,
                //   imageUrl:dataMasjid.image,
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
                                  toast("fitur on progress");
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
