import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mosq/main.dart';
import 'package:mosq/main/utils/AppWidget.dart';
import 'package:mosq/screens/utils/MKColors.dart';
import 'package:mosq/screens/utils/MKConstant.dart';
import 'package:nb_utils/nb_utils.dart';

class ConfirmDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    FocusScopeNode currentFocus = FocusScope.of(context);

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
            24.height,
            Text("Perubahan belum tersimpan",
                style:
                    boldTextStyle(color: appStore.textPrimaryColor, size: 18)),
            16.height,
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: text(
                  "Perubahan anda belum tersimpan. Lanjut keluar halaman?",
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
                                  text: "Tidak",
                                  style: TextStyle(
                                      fontSize: 16.0,
                                      color: mkColorPrimary,
                                      fontFamily: fontRegular)),
                            ],
                          ),
                        ),
                      ),
                    ).onTap(() {
                      Get.back(result: false);
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
                                      child: Icon(Icons.check,
                                          color: Colors.white, size: 18))),
                              TextSpan(
                                  text: "Ya",
                                  style: TextStyle(
                                      fontSize: 16.0,
                                      color: Colors.white,
                                      fontFamily: fontRegular)),
                            ],
                          ),
                        ),
                      ),
                    ).onTap(() {
                      // FocusScope.of(context).unfocus();
                      // finish(context);
                      Get.back(result: true);
                      // return true;
                      // Navigator.of(context).pop();
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
