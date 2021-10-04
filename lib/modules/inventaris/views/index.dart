import 'package:flutter/material.dart';
import 'package:mosq/modules/inventaris/controllers/inventaris_controller.dart';
import 'package:mosq/integrations/controllers.dart';
// import 'package:mosq/integrations/firestore.dart';
import 'package:mosq/main/utils/AppWidget.dart';
import 'package:mosq/modules/inventaris/models/inventaris_model.dart';
import 'package:mosq/modules/masjid/models/masjid_model.dart';
import 'package:mosq/screens/widgets/DeleteDialog.dart';
import 'package:mosq/screens/utils/MKColors.dart';
import 'package:mosq/screens/widgets/DismissibleBackground.dart';
// import 'package:mosq/screens/utils/MKImages.dart';
// import 'package:mosq/screens/utils/MKConstant.dart';
// import 'package:mosq/screens/utils/MKColors.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:get/get.dart';
import 'package:mosq/routes/route_name.dart';
import 'card.dart';

import 'package:mosq/main.dart';

class TMTabInventaris extends StatefulWidget {
  @override
  _TMTabInventarisState createState() => _TMTabInventarisState();

  final MasjidModel model;

  const TMTabInventaris(this.model);
}

class _TMTabInventarisState extends State<TMTabInventaris> {
  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    //
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  Widget generateItemList() {
    // final InventarisModel item;
    // final InventarisController inventarisC = Get.find();
    return Container(
      child: SingleChildScrollView(
          child: Column(
        children: [
          Obx(
            () => inventarisC.inventarises.isEmpty
                ? Container(
                    height: 200,
                    child: text("Masjid belum memiliki Inventaris").center(),
                    //     ElevatedButton(
                    //   child: text("ew"),
                    //   onPressed: inventarisC.tesBind(),
                    // )
                  )
                : ListView.builder(
                    padding: EdgeInsets.symmetric(),
                    scrollDirection: Axis.vertical,
                    itemCount: inventarisC.inventarises.length,
                    shrinkWrap: true,
                    physics: ScrollPhysics(),
                    itemBuilder: (context, index) {
                      InventarisModel dataInventaris =
                          inventarisC.inventarises[index];
                      // final item = inventarisC.inventarises[index];

                      return Obx(() => Column(children: [
                            Dismissible(
                              key: Key(dataInventaris.id!),
                              direction: masjidC.myMasjid.value
                                  ? DismissDirection.horizontal
                                  : DismissDirection.none,
                              child:
                                  // InventarisCard(inventarisC.inventariss[index]),
                                  InventarisCard(
                                inventaris: inventarisC.inventarises[index],
                              ),
                              background: slideRightBackground(),
                              secondaryBackground: slideLeftBackground(),
                              confirmDismiss: (direction) async {
                                final bool? res;
                                if (direction == DismissDirection.startToEnd) {
                                  try {
                                    res = false;
                                  } finally {
                                    Get.toNamed(
                                        // RouteName.edit_inventaris +
                                        //     '/${inventarisC.inventaris.inventarisID}',
                                        RouteName.edit_inventaris,
                                        arguments: dataInventaris);
                                    // );
                                  }
                                } else if (direction ==
                                    DismissDirection.endToStart) {
                                  return res = await showDialog(
                                      context: context,
                                      builder: (BuildContext context) =>
                                          CustomDelete(
                                            titleName: 'Inventaris',
                                            subtitleName: inventarisC
                                                    .inventarises[index].nama ??
                                                "",
                                          ));
                                } else
                                  res = false;
                                return res;
                              },
                              onDismissed: (direction) {
                                // inventarisC.inventariss.removeAt(index);
                                try {
                                  inventarisC.delete(dataInventaris);
                                } catch (e) {
                                  toast('Error Delete Data');
                                  rethrow;
                                }
                              },
                            ),
                            Divider()
                          ]));
                    }),
          ),
        ],
      )),
    );
  }

  @override
  Widget build(BuildContext context) {
    Get.put(InventarisController());
    return Stack(
      children: [
        generateItemList(),
        Container(
            alignment: Alignment.bottomRight,
            padding: EdgeInsets.only(right: 15, bottom: 15),
            child: Obx(() => masjidC.myMasjid.value
                ? FloatingActionButton(
                    child: Icon(
                      Icons.edit,
                      color: mkWhite,
                    ),
                    backgroundColor: mkColorPrimary,
                    onPressed: () {
                      // CustomDelete();
                      Get.toNamed(RouteName.new_inventaris,
                          arguments:
                              InventarisModel(dao: widget.model.inventarisDao));
                    })
                : SizedBox())),
      ],
    );
  }
}
