import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mosq/integrations/controllers.dart';
import 'package:mosq/models/inventaris.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:mosq/main/utils/AppConstant.dart';
import 'package:mosq/main/utils/AppWidget.dart';
import 'package:mosq/main.dart';

class CustomDelete extends StatelessWidget {
  // final InventarisModel inventaris = InventarisModel();
  // CustomDelete(int index);
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
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ClipRRect(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(8), topRight: Radius.circular(8)),
              child: Image(
                  width: MediaQuery.of(context).size.width,
                  image: AssetImage('images/widgets/widget_delete.jpg'),
                  height: 120,
                  fit: BoxFit.cover),
            ),
            24.height,
            Text('Hapus inventaris?',
                style:
                    boldTextStyle(color: appStore.textPrimaryColor, size: 18)),
            16.height,
            Padding(
              padding: const EdgeInsets.only(left: 16, right: 16),
              child: Text(
                  "This will also permanently delete file inside the folder",
                  style:
                      secondaryTextStyle(color: appStore.textSecondaryColor)),
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
                          color: Colors.blueAccent,
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
                                          color: Colors.blueAccent, size: 18))),
                              TextSpan(
                                  text: "Cancel",
                                  style: TextStyle(
                                      fontSize: 16.0,
                                      color: Colors.blueAccent,
                                      fontFamily: fontRegular)),
                            ],
                          ),
                        ),
                      ),
                    ).onTap(() {
                      finish(context);
                      return false;
                    }),
                  ),
                  16.width,
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.all(8),
                      decoration:
                          boxDecoration(bgColor: Colors.blueAccent, radius: 8),
                      child: Center(
                        child: RichText(
                          text: TextSpan(
                            children: [
                              WidgetSpan(
                                  child: Padding(
                                      padding: EdgeInsets.only(right: 8.0),
                                      child: Icon(Icons.delete,
                                          color: Colors.white, size: 18))),
                              TextSpan(
                                  text: "Delete",
                                  style: TextStyle(
                                      fontSize: 16.0,
                                      color: Colors.white,
                                      fontFamily: fontRegular)),
                            ],
                          ),
                        ),
                      ),
                    ).onTap(() async {
                      // Database().deleteInventaris(
                      //   inventaris.inventarisID,
                      //   // inventaris.foto
                      // );
                      // inventarisC.deleteInventaris(
                      //     inventarisC.inventaris.inventarisID);
                      // inventarisC.inventariss.removeAt(index);

                      await inventarisC.deleteInventaris(
                          inventarisC.inventaris.inventarisID,
                          inventarisC.inventaris.url);
                      finish(context);

                      return true;
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
