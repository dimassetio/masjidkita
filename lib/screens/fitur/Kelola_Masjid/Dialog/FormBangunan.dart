import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:masjidkita/integrations/controllers.dart';
import 'package:masjidkita/main.dart';
import 'package:masjidkita/main/utils/AppWidget.dart';
import 'package:masjidkita/screens/utils/MKColors.dart';
import 'package:masjidkita/screens/utils/MKStrings.dart';
import 'package:nb_utils/nb_utils.dart';

class FormBangunan extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
              Text(mk_tahun,
                  style: boldTextStyle(
                      color: appStore.textPrimaryColor, size: 20)),
              16.height,
              TextFormField(
                controller: keMasjidC.tahun,
                cursorColor: appStore.textPrimaryColor,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.fromLTRB(4, 8, 4, 8),
                  hintText: keMasjidC.keMasjid.tahun ?? mk_null,
                  hintStyle: secondaryTextStyle(
                      color: appStore.textSecondaryColor, size: 16),
                  enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                          color: appStore.textPrimaryColor!, width: 0.0)),
                  focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                          color: appStore.textPrimaryColor!, width: 0.0)),
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                ],
                style: primaryTextStyle(color: appStore.textPrimaryColor),
              ),
              30.height,
              Text(mk_LT,
                  style: boldTextStyle(
                      color: appStore.textPrimaryColor, size: 20)),
              16.height,
              TextFormField(
                controller: keMasjidC.luasTanah,
                cursorColor: appStore.textPrimaryColor,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.fromLTRB(4, 8, 4, 8),
                  hintText: "${keMasjidC.keMasjid.luasTanah ?? mk_null} m2",
                  hintStyle: secondaryTextStyle(
                      color: appStore.textSecondaryColor, size: 16),
                  enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                          color: appStore.textPrimaryColor!, width: 0.0)),
                  focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                          color: appStore.textPrimaryColor!, width: 0.0)),
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                style: primaryTextStyle(color: appStore.textPrimaryColor),
              ),
              30.height,
              Text(mk_LB,
                  style: boldTextStyle(
                      color: appStore.textPrimaryColor, size: 20)),
              16.height,
              TextFormField(
                controller: keMasjidC.luasBangunan,
                cursorColor: appStore.textPrimaryColor,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.fromLTRB(4, 8, 4, 8),
                  hintText: "${keMasjidC.keMasjid.luasBangunan ?? mk_null} m2",
                  hintStyle: secondaryTextStyle(
                      color: appStore.textSecondaryColor, size: 16),
                  enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                          color: appStore.textPrimaryColor!, width: 0.0)),
                  focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                          color: appStore.textPrimaryColor!, width: 0.0)),
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                style: primaryTextStyle(color: appStore.textPrimaryColor),
              ),
              30.height,
              Text(mk_status_tanah,
                  style: boldTextStyle(
                      color: appStore.textPrimaryColor, size: 20)),
              16.height,
              TextFormField(
                controller: keMasjidC.statusTanah,
                cursorColor: appStore.textPrimaryColor,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.fromLTRB(4, 8, 4, 8),
                  hintText: keMasjidC.keMasjid.statusTanah ?? mk_null,
                  hintStyle: secondaryTextStyle(
                      color: appStore.textSecondaryColor, size: 16),
                  enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                          color: appStore.textPrimaryColor!, width: 0.0)),
                  focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                          color: appStore.textPrimaryColor!, width: 0.0)),
                ),
                keyboardType: TextInputType.text,
                inputFormatters: [
                  FilteringTextInputFormatter.singleLineFormatter
                ],
                style: primaryTextStyle(color: appStore.textPrimaryColor),
              ),
              30.height,
              Text(mk_legalitas,
                  style: boldTextStyle(
                      color: appStore.textPrimaryColor, size: 20)),
              16.height,
              TextFormField(
                controller: keMasjidC.legalitas,
                cursorColor: appStore.textPrimaryColor,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.fromLTRB(4, 8, 4, 8),
                  hintText: keMasjidC.keMasjid.legalitas ?? mk_null,
                  hintStyle: secondaryTextStyle(
                      color: appStore.textSecondaryColor, size: 16),
                  enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                          color: appStore.textPrimaryColor!, width: 0.0)),
                  focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                          color: appStore.textPrimaryColor!, width: 0.0)),
                ),
                keyboardType: TextInputType.text,
                inputFormatters: [
                  FilteringTextInputFormatter.singleLineFormatter
                ],
                style: primaryTextStyle(color: appStore.textPrimaryColor),
              ),
              30.height,
              GestureDetector(
                onTap: () {
                  keMasjidC.updateDataMasjid(
                      // tahun: keMasjidC.tahun.text,
                      // luasTanah: keMasjidC.luasTanah.text,
                      // luasBangunan: keMasjidC.luasBangunan.text,
                      // statusTanah: keMasjidC.statusTanah.text,
                      // legalitas: keMasjidC.legalitas.text,
                      );
                  keMasjidC.clearControllers();
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
