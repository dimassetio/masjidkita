import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:masjidkita/main/utils/AppWidget.dart';
import 'package:masjidkita/screens/utils/widgets/MasjidCarouselSlider.dart';

import '../../../../main.dart';

// ignore: must_be_immutable
class GaleriSlider extends StatelessWidget {
  List mSliderList;

  GaleriSlider(this.mSliderList);

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    width = width - 50;

    return MasjidCarouselSlider(
      viewportFraction: 0.9,
      enlargeCenterPage: true,
      scrollDirection: Axis.horizontal,
      items: mSliderList.map((slider) {
        return Builder(
          builder: (BuildContext context) {
            return Container(
              decoration: boxDecoration(
                  radius: 16,
                  showShadow: true,
                  bgColor: appStore.scaffoldBackground),
              width: MediaQuery.of(context).size.width,
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(16.0)),
                child: Image.asset(slider.image,
                    // placeholder: placeholderWidgetFn() as Widget Function(
                    //     BuildContext, String)?,
                    height: 180,
                    width: width,
                    fit: BoxFit.cover),
              ),
            );
          },
        );
      }).toList(),
    );
  }
}
