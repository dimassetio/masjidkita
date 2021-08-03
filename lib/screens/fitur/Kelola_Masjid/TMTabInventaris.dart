import 'package:flutter/material.dart';
import 'package:masjidkita/constants/firebase.dart';
import 'package:masjidkita/controllers/inventarisController.dart';
import 'package:masjidkita/controllers/manMasjidController.dart';
import 'package:masjidkita/controllers/userController.dart';
import 'package:masjidkita/integrations/controllers.dart';
import 'package:masjidkita/integrations/firestore.dart';
import 'package:masjidkita/models/inventaris.dart';
import 'package:masjidkita/screens/fitur/Kelola_Masjid/Dialog/alertdeleteInventaris.dart';
import 'package:masjidkita/screens/utils/MKColors.dart';
import 'package:masjidkita/screens/utils/MKImages.dart';
import 'package:masjidkita/screens/utils/MKConstant.dart';
import 'package:masjidkita/services/database.dart';
import 'package:masjidkita/screens/utils/MKColors.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:get/get.dart';
import 'package:masjidkita/routes/route_name.dart';
import 'InventarisList.dart';

import '../../../../main.dart';

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

  Widget slideRightBackground() {
    return Container(
      color: Colors.green,
      child: Align(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            20.width,
            Icon(
              Icons.edit,
              color: Colors.white,
            ),
            Text(
              " Edit",
              style: primaryTextStyle(
                color: Colors.white,
              ),
              textAlign: TextAlign.left,
            ),
          ],
        ),
        alignment: Alignment.centerLeft,
      ),
    );
  }

  Widget slideLeftBackground() {
    return Container(
      color: Colors.red,
      child: Align(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Icon(
              Icons.delete,
              color: Colors.white,
            ),
            Text(
              " Delete",
              style: primaryTextStyle(
                color: Colors.white,
              ),
              textAlign: TextAlign.right,
            ),
            20.width,
          ],
        ),
        alignment: Alignment.centerRight,
      ),
    );
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
                    child: ElevatedButton(
                      onPressed: () {
                        inventarisC.tesBind();
                        // Get.toNamed(RouteName.new_inventaris);
                      },
                      child: Text(inventarisC.inventariss.length.toString(),
                          style: boldTextStyle(size: 18, color: Colors.white)),
                    ).center(),
                  )
                : ListView.builder(
                    padding: EdgeInsets.symmetric(),
                    scrollDirection: Axis.vertical,
                    itemCount: inventarisC.inventariss.length,
                    shrinkWrap: true,
                    physics: ScrollPhysics(),
                    itemBuilder: (_, index) {
                      final item = inventarisC.inventariss[index];
                      return Dismissible(
                        key: Key(item.inventarisID!),
                        child: InventarisCard(inventarisC.inventariss[index]),
                        background: slideRightBackground(),
                        secondaryBackground: slideLeftBackground(),
                        confirmDismiss: (direction) async {
                          final bool? res;
                          if (direction == DismissDirection.startToEnd) {
                            Get.toNamed(RouteName.edit_inventaris);
                            res = false;
                          } else if (direction == DismissDirection.endToStart) {
                            return res = await showDialog(
                                context: context,
                                builder: (BuildContext context) =>
                                    CustomDelete());
                          } else
                            res = false;
                          return res;
                        },
                        onDismissed: (direction) {
                          setState(() {
                            inventarisC.inventariss.removeAt(index);
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
                      );
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
