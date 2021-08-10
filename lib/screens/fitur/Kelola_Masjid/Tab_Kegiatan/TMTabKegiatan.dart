import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mosq/integrations/controllers.dart';
import 'package:mosq/main/utils/AppConstant.dart';
import 'package:mosq/main/utils/AppWidget.dart';
import 'package:mosq/screens/widgets/KegiatanCard.dart';
// import 'package:mosq/screens/widgets/KegiatanSlider.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../../main.dart';

class TMTabKegiatan extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Container(
        height: Get.height,
        child: SingleChildScrollView(
          child: Obx(
            () => ListView.builder(
                padding: EdgeInsets.symmetric(),
                scrollDirection: Axis.vertical,
                itemCount: kegiatanC.kegiatans.length,
                // itemCount: mListings.length,
                shrinkWrap: true,
                physics: ScrollPhysics(),
                itemBuilder: (context, index) {
                  return KegiatanCard(
                    width: Get.width,
                    dataKegiatan: kegiatanC.kegiatans[index],
                  );
                }),
          ),
        ),
      ),
    ]);
  }
}
