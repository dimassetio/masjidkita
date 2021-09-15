import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:mosq/main/utils/AppWidget.dart';
import 'package:mosq/screens/utils/MKImages.dart';

class MqFoto extends StatelessWidget {
  String oldPath = '';
  String newPath;
  String defaultPath;
  MqFoto({
    this.oldPath = '',
    this.newPath = '',
    this.defaultPath = mk_no_image,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      margin: EdgeInsets.only(bottom: 16),
      // decoration: boxDecoration(
      //     radius: 10.0, showShadow: true, color: mkColorPrimary),
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
    );
  }
}
