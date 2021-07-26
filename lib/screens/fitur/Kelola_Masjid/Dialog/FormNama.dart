import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:masjidkita/integrations/controllers.dart';
import 'package:masjidkita/main.dart';
import 'package:masjidkita/main/utils/AppWidget.dart';
import 'package:masjidkita/routes/route_name.dart';
import 'package:masjidkita/screens/fitur/Kelola_Masjid/ManMasjid.dart';
import 'package:masjidkita/screens/utils/MKColors.dart';
import 'package:masjidkita/screens/utils/MKStrings.dart';
import 'package:nb_utils/nb_utils.dart';

class FormNama extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // manMasjidC.nama.text = manMasjidC.deMasjid.nama ?? "";
    manMasjidC.alamat.text = manMasjidC.deMasjid.alamat ?? "";

    manMasjidC.nama.addListener(() {});
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      child: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(16),
          decoration: new BoxDecoration(
            color: appStore.scaffoldBackground,
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 10.0,
                offset: const Offset(0.0, 10.0),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min, // To make the card compact
            children: <Widget>[
              GestureDetector(
                onTap: () {
                  finish(context);
                },
                child: Container(
                    padding: EdgeInsets.all(4),
                    alignment: Alignment.centerRight,
                    child: Icon(Icons.close, color: appStore.textPrimaryColor)),
              ),
              Text(mk_lbl_nama,
                  style: boldTextStyle(
                      color: appStore.textPrimaryColor, size: 20)),
              16.height,

              TextFormField(
                autocorrect: false,
                autofocus: true,
                initialValue: manMasjidC.deMasjid.nama,
                onChanged: (newValue) {
                  manMasjidC.nama.text = newValue;
                },
                // controller: manMasjidC.nama,
                textInputAction: TextInputAction.next,
                cursorColor: appStore.textPrimaryColor,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.fromLTRB(4, 8, 4, 8),
                  hintText: manMasjidC.keMasjid.nama ?? mk_null,
                  // hintStyle: secondaryTextStyle(
                  //     color: appStore.textSecondaryColor, size: 16),
                  enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                          color: appStore.textPrimaryColor!, width: 0.0)),
                  focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                          color: appStore.textPrimaryColor!, width: 0.0)),
                ),
                keyboardType: TextInputType.name,
                // inputFormatters: [
                //   FilteringTextInputFormatter.singleLineFormatter
                // ],
                style: primaryTextStyle(color: appStore.textPrimaryColor),
              ),
              30.height,
              Text(mk_lbl_alamat,
                  style: boldTextStyle(
                      color: appStore.textPrimaryColor, size: 20)),
              16.height,
              // TextField(),
              TextFormField(
                cursorColor: appStore.textPrimaryColor,
                controller: manMasjidC.alamat,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.fromLTRB(4, 8, 4, 8),
                  hintText: manMasjidC.keMasjid.alamat ?? mk_null,
                  hintStyle: secondaryTextStyle(
                      color: appStore.textSecondaryColor, size: 16),
                  enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                          color: appStore.textPrimaryColor!, width: 0.0)),
                  focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                          color: appStore.textPrimaryColor!, width: 0.0)),
                ),
                keyboardType: TextInputType.streetAddress,
                // inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                style: primaryTextStyle(color: appStore.textPrimaryColor),
              ),
              30.height,
              GestureDetector(
                onTap: () {
                  manMasjidC.updateDataMasjid(
                      // nama: manMasjidC.nama.text,
                      // alamat: manMasjidC.alamat.text,
                      );
                  manMasjidC.clearControllers();
                  finish(context);
                },
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  decoration:
                      boxDecoration(bgColor: mkColorPrimary, radius: 10),
                  padding: EdgeInsets.fromLTRB(16, 8, 16, 8),
                  child: Center(
                    child: Text(mk_submit, style: boldTextStyle(color: white)),
                  ),
                ),
              ),
              16.height,
            ],
          ),
        ),
      ),
    );
  }
}
