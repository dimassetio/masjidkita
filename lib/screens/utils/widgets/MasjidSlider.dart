import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:masjidkita/main/utils/AppWidget.dart';
import 'package:masjidkita/screens/utils/widgets/MasjidCarouselSlider.dart';

import '../../../main.dart';
import '../MKColors.dart';
import '../MKConstant.dart';

// ignore: must_be_immutable
class MasjidSliderWidget extends StatelessWidget {
  List mSliderList;

  MasjidSliderWidget(this.mSliderList);

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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(16.0),
                        topRight: Radius.circular(16.0),
                      ),
                      child: Image.asset(slider.image,
                          // placeholder: placeholderWidgetFn() as Widget Function(
                          //     BuildContext, String)?,
                          height: 180,
                          width: width,
                          fit: BoxFit.cover),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(16, 0, 16, 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            text(slider.nama,
                                textColor: appStore.textPrimaryColor,
                                fontSize: textSizeLargeMedium,
                                fontFamily: fontMedium),
                            RichText(
                              text: TextSpan(
                                style: Theme.of(context).textTheme.bodyText2,
                                children: [
                                  WidgetSpan(
                                    child: Padding(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 4.0),
                                      // child: Icon(
                                      //   Icons.access_time,
                                      //   color: mkicon_color,
                                      //   size: 16,
                                      // ),
                                    ),
                                  ),
                                  TextSpan(
                                      text: slider.kota,
                                      style: TextStyle(
                                          fontSize: textSizeSMedium,
                                          color: mkColorPrimary)),
                                ],
                              ),
                            )
                          ],
                        ),
                        text(slider.kota),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      }).toList(),
    );
  }
}
