import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:masjidkita/integrations/controllers.dart';
import 'package:masjidkita/main/utils/AppWidget.dart';
import 'package:cached_network_image/src/cached_image_widget.dart';
import 'package:masjidkita/routes/route_name.dart';
import 'package:masjidkita/screens/utils/widgets/MasjidCard2.dart';
import '../../../main.dart';
import '../MKConstant.dart';
import '../MKColors.dart';
import 'MasjidCard.dart';

class MasjidListing extends StatelessWidget {
  MasjidListing({
    Key? key,
    required this.mListings,
  }) : super(key: key);

  final List mListings;
  final width = Get.width;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView.builder(
          scrollDirection: Axis.vertical,
          // itemCount: 5,
          itemCount: mListings.length,
          shrinkWrap: true,
          physics: ScrollPhysics(),
          itemBuilder: (context, index) {
            var dataMasjid = mListings[index];
            return GestureDetector(
              onTap: () async {
                await manMasjidC.getDetailMasjid(dataMasjid.id);
                Get.toNamed(RouteName.detail);
              },
              child: MasjidCard2(dataMasjid: dataMasjid, width: width),
            );
          }),
    );
  }
}
