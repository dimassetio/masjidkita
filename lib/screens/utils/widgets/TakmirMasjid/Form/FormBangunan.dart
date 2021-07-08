import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:masjidkita/main.dart';
import 'package:masjidkita/main/utils/AppWidget.dart';
import 'package:masjidkita/screens/utils/MKColors.dart';
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
              Text('Tahun Berdiri',
                  style: boldTextStyle(
                      color: appStore.textPrimaryColor, size: 20)),
              16.height,
              TextFormField(
                cursorColor: appStore.textPrimaryColor,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.fromLTRB(4, 8, 4, 8),
                  hintText: 'Tahun',
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
              Text('Luas Tanah',
                  style: boldTextStyle(
                      color: appStore.textPrimaryColor, size: 20)),
              16.height,
              TextFormField(
                cursorColor: appStore.textPrimaryColor,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.fromLTRB(4, 8, 4, 8),
                  hintText: ' ... m2',
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
              Text('Luas Bangunan',
                  style: boldTextStyle(
                      color: appStore.textPrimaryColor, size: 20)),
              16.height,
              TextFormField(
                cursorColor: appStore.textPrimaryColor,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.fromLTRB(4, 8, 4, 8),
                  hintText: ' ... m2',
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
              Text('Status Tanah',
                  style: boldTextStyle(
                      color: appStore.textPrimaryColor, size: 20)),
              16.height,
              TextFormField(
                cursorColor: appStore.textPrimaryColor,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.fromLTRB(4, 8, 4, 8),
                  hintText: 'Status Tanah',
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
              Text('Legalitas',
                  style: boldTextStyle(
                      color: appStore.textPrimaryColor, size: 20)),
              16.height,
              TextFormField(
                cursorColor: appStore.textPrimaryColor,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.fromLTRB(4, 8, 4, 8),
                  hintText: 'Legalitas',
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
                  finish(context);
                },
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  decoration:
                      boxDecoration(bgColor: mkColorPrimary, radius: 10),
                  padding: EdgeInsets.fromLTRB(16, 8, 16, 8),
                  child: Center(
                    child: Text("Apply", style: boldTextStyle(color: white)),
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
