import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:masjidkita/integrations/controllers.dart';
import 'package:masjidkita/main.dart';
import 'package:masjidkita/main/utils/AppWidget.dart';
import 'package:masjidkita/screens/utils/MKColors.dart';
import 'package:nb_utils/nb_utils.dart';

class ImageSourceBottomSheet extends StatelessWidget {
  ImageSourceBottomSheet({
    required this.isLoading,
    required this.uploadPrecentage,
    required this.isSaving,
    required this.fromGaleri,
    required this.fromCamera,
  });
  final bool isLoading;
  final double uploadPrecentage;
  final bool isSaving;
  final void Function() fromGaleri;
  final void Function() fromCamera;

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 250.0,
        padding: EdgeInsets.all(16),
        child: Obx(
          () => isLoading
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // CircularProgressIndicator(),
                    SizedBox(
                      height: 5,
                    ),
                    text("Uploading"),
                    SizedBox(
                      height: 10,
                    ),
                    LinearProgressIndicator(
                      color: mkColorPrimary,
                      valueColor: AlwaysStoppedAnimation<Color>(mkColorPrimary),
                      value: uploadPrecentage,
                      // semanticsLabel:
                      //     '${(manMasjidC.uploadPrecentage.value * 100).toInt()}%',
                    ),
                    text("${(uploadPrecentage * 100).toInt()} %"),
                  ],
                )
              : Column(
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
                              color: isSaving
                                  ? mkColorPrimaryLight
                                  : mkColorPrimaryDark,
                            ),
                            text(
                              "Galeri",
                              textColor: isSaving
                                  ? mkColorPrimaryLight
                                  : mkColorPrimaryDark,
                            ),
                          ],
                        ),
                      ),
                    ),
                    Divider(height: 5),
                    GestureDetector(
                      onTap: fromCamera
                      // manMasjidC.uploadImage(true);

                      ,
                      child: Container(
                        color: appStore.scaffoldBackground,
                        padding: EdgeInsets.all(16),
                        child: Row(
                          children: [
                            Icon(
                              Icons.camera,
                              color: manMasjidC.isSaving.value
                                  ? mkColorPrimaryLight
                                  : mkColorPrimaryDark,
                            ),
                            text(
                              "Kamera",
                              textColor: manMasjidC.isSaving.value
                                  ? mkColorPrimaryLight
                                  : mkColorPrimaryDark,
                            ),
                          ],
                        ),
                      ),
                    ),
                    8.height,
                  ],
                ),
        ));
  }
}
