import 'package:flutter/material.dart';
import 'package:mosq/main.dart';
import 'package:mosq/main/utils/AppWidget.dart';
import 'package:mosq/screens/utils/MKColors.dart';
import 'package:nb_utils/nb_utils.dart';

class ImageSourceBottomSheet extends StatelessWidget {
  ImageSourceBottomSheet({
    // required this.isSaving,
    required this.fromGaleri,
    required this.fromCamera,
  });

  // final RxBool isSaving;
  final void Function() fromGaleri;
  final void Function() fromCamera;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 250.0,
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Upload Foto Masjid dari",
            style: boldTextStyle(color: appStore.textPrimaryColor),
          ),
          16.height,
          Divider(height: 5),
          GestureDetector(
            onTap: fromGaleri,
            child: Container(
              color: appStore.scaffoldBackground,
              padding: EdgeInsets.all(16),
              child: Row(
                children: [
                  Icon(
                    Icons.image_sharp,
                    color: mkColorPrimaryDark,
                  ),
                  text(
                    "Galeri",
                    textColor: mkColorPrimaryDark,
                  ),
                ],
              ),
            ),
          ),
          Divider(height: 5),
          GestureDetector(
            onTap: fromCamera
            // masjidC.uploadImage(true);

            ,
            child: Container(
              color: appStore.scaffoldBackground,
              padding: EdgeInsets.all(16),
              child: Row(
                children: [
                  Icon(
                    Icons.camera,
                    color: mkColorPrimaryDark,
                  ),
                  text(
                    "Kamera",
                    textColor: mkColorPrimaryDark,
                  ),
                ],
              ),
            ),
          ),
          8.height,
        ],
      ),
    );
  }
}
