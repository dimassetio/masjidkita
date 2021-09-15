import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:mosq/main.dart';
import 'package:mosq/main/utils/AppWidget.dart';
import 'package:mosq/screens/widgets/ImageSourceBottomSheet.dart';
import 'package:mosq/screens/utils/MKColors.dart';
import 'package:mosq/screens/utils/MKConstant.dart';
import 'package:mosq/screens/utils/MKImages.dart';
import 'package:image_picker/image_picker.dart';

class MqFormFoto extends StatelessWidget {
  String oldPath = '';
  String defaultPath;
  MqFormFoto({
    this.oldPath = '',
    this.defaultPath = mk_no_image,
  });
  final ImagePicker _picker = ImagePicker();
  var xfoto = ''.obs;
  String get newPath => xfoto.value;

  getImage(bool isCam) async {
    var result = await _picker.pickImage(
        source: isCam ? ImageSource.camera : ImageSource.gallery);
    // if (result is XFile) {
    //   xfoto.value = result.path;
    // }
    if (result is XFile) {
      xfoto.value = result.path;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Obx(
          () => Container(
            alignment: Alignment.center,
            margin: EdgeInsets.only(bottom: 16),
            width: Get.width,
            height: Get.width / 1.7,
            child: ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              child: newPath.isNotEmpty
                  ? Image.file(File(newPath))
                  : oldPath.isNotEmpty
                      ? CachedNetworkImage(
                          placeholder: placeholderWidgetFn() as Widget Function(
                              BuildContext, String)?,
                          imageUrl: oldPath,
                          fit: BoxFit.cover,
                        )
                      : SvgPicture.asset(
                          defaultPath,
                        ),
            ),
          ),
        ),
        ElevatedButton(
          child: text("Upload Foto",
              textColor: mkWhite, fontSize: textSizeSMedium),
          onPressed: () {
            showModalBottomSheet(
                context: context,
                backgroundColor: appStore.scaffoldBackground,
                shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.vertical(top: Radius.circular(25.0)),
                ),
                builder: (builder) {
                  FocusScopeNode currentFocus = FocusScope.of(context);
                  return ImageSourceBottomSheet(fromCamera: () async {
                    await getImage(true);
                    Get.back();
                    if (!currentFocus.hasPrimaryFocus) {
                      currentFocus.unfocus();
                    }
                  }, fromGaleri: () async {
                    await getImage(false);
                    Get.back();
                    if (!currentFocus.hasPrimaryFocus) {
                      currentFocus.unfocus();
                    }
                  });
                });
          },
        ),
      ],
    );
  }
}
