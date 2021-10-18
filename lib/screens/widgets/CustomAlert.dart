import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:mosq/integrations/controllers.dart';
import 'package:mosq/modules/inventaris/models/inventaris_model.dart';
import 'package:mosq/screens/utils/MKColors.dart';
import 'package:mosq/screens/utils/MKConstant.dart';
import 'package:mosq/screens/utils/MKImages.dart';
import 'package:mosq/screens/utils/MKStrings.dart';
import 'package:nb_utils/nb_utils.dart';

import 'package:mosq/main/utils/AppWidget.dart';
import 'package:mosq/main.dart';

class CustomAlert extends StatelessWidget {
  CustomAlert({
    required this.title,
    required this.subtitle,
    required this.action,
  });
  final String title;
  final String action;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      child: Container(
        decoration: new BoxDecoration(
          color: appStore.scaffoldBackground,
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
                color: Colors.black26,
                blurRadius: 10.0,
                offset: const Offset(0.0, 10.0)),
          ],
        ),
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            24.height,
            ClipRRect(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(8), topRight: Radius.circular(8)),
              child: SvgPicture.asset(
                mk_alert_svg,
                height: 120,
                width: Get.width,
                fit: BoxFit.cover,
              ),
              // Image(
              //     width: MediaQuery.of(context).size.width,
              //     // image: AssetImage('images/widgets/widget_delete.jpg'),
              //     height: 120,
              //     fit: BoxFit.cover),
            ),
            24.height,
            Text('$title',
                style:
                    boldTextStyle(color: appStore.textPrimaryColor, size: 18)),
            16.height,
            Padding(
              padding: const EdgeInsets.only(left: 16, right: 16),
              child: text(" $subtitle ",
                  textColor: textSecondaryColor,
                  isCentered: true,
                  isLongText: true,
                  fontSize: textSizeSMedium),
            ),
            24.height,
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                    onPressed: () {
                      // return false;
                    },
                    child: text('Batal',
                        textColor: mkWhite,
                        fontSize: textSizeSMedium,
                        fontFamily: fontRegular)),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: InkWell(
                    child: Container(
                      padding: EdgeInsets.all(8),
                      decoration:
                          boxDecoration(radius: 8, bgColor: mkColorPrimary),
                      child: Center(
                        child: Text(
                          action,
                          style: TextStyle(
                              fontSize: 16.0,
                              color: mkWhite,
                              fontFamily: fontRegular),
                        ),
                      ),
                    ).onTap(() {
                      finish(context);
                      return false;
                    }),
                  ),
                ),
              ],
            ),
            24.height,
          ],
        ),
      ),
    );
  }
}
