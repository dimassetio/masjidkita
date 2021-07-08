import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:masjidkita/main/utils/AppWidget.dart';
import 'package:masjidkita/screens/utils/MKImages.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../../main.dart';
import '../../MKConstant.dart';

class TabTakmir extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: ListView.builder(
          padding: EdgeInsets.symmetric(),
          scrollDirection: Axis.vertical,
          itemCount: 10,
          // itemCount: mListings.length,
          shrinkWrap: true,
          physics: ScrollPhysics(),
          itemBuilder: (context, index) {
            return Column(
              children: [
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 16, vertical: 3),
                  color: appStore.scaffoldBackground,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          CircleAvatar(
                            backgroundImage:
                                CachedNetworkImageProvider(mk_net_img),
                            radius: MediaQuery.of(context).size.width * 0.08,
                          ),
                          SizedBox(width: 16),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              text("Nama",
                                  textColor: appStore.textPrimaryColor,
                                  fontFamily: fontMedium),
                              SizedBox(width: 4),
                              text("Jabatan $index",
                                  textColor: appStore.textSecondaryColor),
                            ],
                          )
                        ],
                      ),
                    ],
                  ),
                ),
                Divider()
              ],
            );
          }),
    );
  }
}
