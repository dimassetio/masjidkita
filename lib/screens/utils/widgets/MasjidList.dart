import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:masjidkita/main/utils/AppWidget.dart';
import 'package:cached_network_image/src/cached_image_widget.dart';
import 'package:masjidkita/routes/route_name.dart';
import '../../../main.dart';
import '../MKConstant.dart';
import '../MKColors.dart';
import 'MasjidCard.dart';

class MasjidListing extends StatelessWidget {
  const MasjidListing({
    Key? key,
    required this.mListings,
    required this.width,
  }) : super(key: key);

  final List mListings;
  final double width;

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
              onTap: () {
                Get.toNamed(RouteName.detail);
              },
              child: Container(
                margin: EdgeInsets.only(left: 16, right: 16, bottom: 16),
                width: width,
                decoration: boxDecoration(
                    radius: 16,
                    showShadow: true,
                    bgColor: appStore.scaffoldBackground),
                child: MasjidCard(dataMasjid: dataMasjid, width: width),
              ),
            );
          }),
    );
  }
}
