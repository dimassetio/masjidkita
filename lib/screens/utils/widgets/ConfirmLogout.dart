import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:masjidkita/integrations/controllers.dart';
import 'package:masjidkita/main.dart';
import 'package:masjidkita/main/utils/AppWidget.dart';
import 'package:masjidkita/routes/route_name.dart';
import 'package:masjidkita/screens/utils/MKColors.dart';
import 'package:masjidkita/screens/utils/MKConstant.dart';
import 'package:masjidkita/screens/utils/MKStrings.dart';
import 'package:nb_utils/nb_utils.dart';

class ConfirmLogout extends StatelessWidget {
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
        width: Get.width,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            // ClipRRect(
            //   borderRadius: BorderRadius.only(
            //       topLeft: Radius.circular(8), topRight: Radius.circular(8)),
            //   child: Image(
            //       width: MediaQuery.of(context).size.width,
            //       image: AssetImage(
            //           'images/widgets/materialWidgets/mwDialogAlertPanelWidgets/widget_delete.jpg'),
            //       height: 120,
            //       fit: BoxFit.cover),
            // ),
            24.height,
            Text(mk_log_out,
                style:
                    boldTextStyle(color: appStore.textPrimaryColor, size: 18)),
            16.height,
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: text(mk_log_out_desc,
                  textColor: mkTextColorSecondary,
                  fontSize: textSizeSMedium,
                  isLongText: true,
                  isCentered: true),
            ),
            16.height,
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.all(8),
                      decoration: boxDecoration(
                          color: mkColorPrimary,
                          radius: 8,
                          bgColor: appStore.scaffoldBackground),
                      child: Center(
                        child: RichText(
                          text: TextSpan(
                            children: [
                              WidgetSpan(
                                  child: Padding(
                                      padding: EdgeInsets.only(right: 8.0),
                                      child: Icon(Icons.close,
                                          color: mkColorPrimary, size: 18))),
                              TextSpan(
                                  text: mk_lbl_batal,
                                  style: TextStyle(
                                      fontSize: 16.0,
                                      color: mkColorPrimary,
                                      fontFamily: fontRegular)),
                            ],
                          ),
                        ),
                      ),
                    ).onTap(() {
                      finish(context);
                    }),
                  ),
                  16.width,
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.all(8),
                      decoration:
                          boxDecoration(bgColor: mkColorPrimary, radius: 8),
                      child: Center(
                        child: RichText(
                          text: TextSpan(
                            children: [
                              WidgetSpan(
                                  child: Padding(
                                      padding: EdgeInsets.only(right: 8.0),
                                      child: Icon(Icons.logout,
                                          color: Colors.white, size: 18))),
                              TextSpan(
                                  text: mk_ya,
                                  style: TextStyle(
                                      fontSize: 16.0,
                                      color: Colors.white,
                                      fontFamily: fontRegular)),
                            ],
                          ),
                        ),
                      ),
                    ).onTap(() {
                      authController.signOut();
                      finish(context);
                    }),
                  )
                ],
              ),
            ),
            16.height,
          ],
        ),
      ),
    );
  }
}
