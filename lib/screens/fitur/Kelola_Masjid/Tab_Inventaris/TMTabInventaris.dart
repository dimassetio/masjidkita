import 'package:flutter/material.dart';
import 'package:mosq/controllers/inventarisController.dart';
import 'package:mosq/integrations/controllers.dart';
// import 'package:mosq/integrations/firestore.dart';
import 'package:mosq/main/utils/AppWidget.dart';
import 'package:mosq/models/inventaris.dart';
import 'package:mosq/screens/fitur/Kelola_Masjid/Dialog/alertdeleteInventaris.dart';
import 'package:mosq/screens/utils/MKColors.dart';
import 'package:mosq/screens/widgets/DismissibleBackground.dart';
// import 'package:mosq/screens/utils/MKImages.dart';
// import 'package:mosq/screens/utils/MKConstant.dart';
// import 'package:mosq/screens/utils/MKColors.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:get/get.dart';
import 'package:mosq/routes/route_name.dart';
import 'InventarisList.dart';

import '../../../../../main.dart';

class TMTabInventaris extends StatefulWidget {
  @override
  _TMTabInventarisState createState() => _TMTabInventarisState();
  final InventarisModel inventaris;
  // final UserModel user;
  // final ManMasjidModel masjid;
  TMTabInventaris(
    this.inventaris,
    // this.user,
    // this.masjid,
  );
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
    final InventarisController inventarisC = Get.find();
    return Container(
      child: SingleChildScrollView(
          child: Column(
        children: [
          Obx(
            () => inventarisC.inventariss.isEmpty
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
                    itemCount: inventarisC.inventariss.length,
                    shrinkWrap: true,
                    physics: ScrollPhysics(),
                    itemBuilder: (_, index) {
                      final item = inventarisC.inventariss[index];
                      return Obx(() => manMasjidC.myMasjid.value
                          ? Dismissible(
                              key: Key(item.inventarisID!),
                              child: InventarisCard(
                                  inventarisC.inventariss[index]),
                              background: slideRightBackground(),
                              secondaryBackground: slideLeftBackground(),
                              confirmDismiss: (direction) async {
                                final bool? res;
                                if (direction == DismissDirection.startToEnd) {
                                  try {
                                    await inventarisC.getInventarisModel(
                                        inventarisC.inventariss[index]
                                                .inventarisID ??
                                            "");
                                    print(inventarisC
                                        .inventariss[index].inventarisID);
                                    res = false;
                                  } finally {
                                    Get.toNamed(RouteName.edit_inventaris +
                                        '/${inventarisC.inventaris.inventarisID}');
                                  }
                                } else if (direction ==
                                    DismissDirection.endToStart) {
                                  return res = await showDialog(
                                      context: context,
                                      builder: (BuildContext context) =>
                                          CustomDelete(
                                            titleName: 'Inventaris',
                                            subtitleName: item.nama!,
                                          ));
                                } else
                                  res = false;
                                return res;
                              },
                              onDismissed: (direction) {
                                setState(() async {
                                  // inventarisC.inventariss.removeAt(index);
                                  try {
                                    await inventarisC.deleteInventaris(
                                        item.inventarisID, item.url);
                                    // finish(context);
                                  } catch (e) {
                                    toast('Error Delete Data');
                                  }
                                });
                                // if (direction == DismissDirection.startToEnd) {
                                // ScaffoldMessengerState().showSnackBar(
                                //     SnackBar(content: Text("Swipe to left")));
                                //   setState(() {
                                //     inventarisC.inventariss.removeAt(index);
                                //     Get.toNamed(RouteName.detail_inventaris);
                                //   });
                                // } else if (direction == DismissDirection.endToStart) {
                                // userList.removeAt(index);d
                                // ScaffoldMessengerState().showSnackBar(
                                //     SnackBar(content: Text("Swipe to right")));

                                // Get.to(() => CustomDelete());
                                // }
                              },
                            )
                          : SizedBox());
                    }),
          ),
        ],
      )),
    );
  }

  @override
  Widget build(BuildContext context) {
    // var visible;
    // if (manMasjidC.deMasjid.id == authControl) {
    //   visible = true;
    // } else {
    //   visible = false;
    // }
    Get.put(InventarisController());
    return Stack(
      children: [
        generateItemList(),
        Container(
            alignment: Alignment.bottomRight,
            padding: EdgeInsets.only(right: 15, bottom: 15),
            child: Obx(() => manMasjidC.myMasjid.value
                ? FloatingActionButton(
                    // heroTag: '1',
                    // heroTag: '5',
                    // label: Text(
                    //   "Add",
                    //   style: primaryTextStyle(color: Colors.white),
                    // ),
                    child: Icon(
                      Icons.edit,
                      color: mkWhite,
                    ),
                    backgroundColor: mkColorPrimary,
                    onPressed: () {
                      // CustomDelete();
                      Get.toNamed(RouteName.new_inventaris);
                    })
                : SizedBox())),
      ],
    );
  }
}
