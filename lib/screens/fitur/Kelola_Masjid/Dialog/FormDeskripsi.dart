import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:masjidkita/main.dart';
import 'package:masjidkita/main/utils/AppWidget.dart';
import 'package:masjidkita/screens/utils/MKColors.dart';
import 'package:masjidkita/screens/utils/m_k_icon_icons.dart';
import 'package:nb_utils/nb_utils.dart';

class FormDeskripsi extends StatelessWidget {
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
              Text('Deskripsi',
                  style: boldTextStyle(
                      color: appStore.textPrimaryColor, size: 20)),
              16.height,
              TextFormField(
                // controller: addressCont,
                focusNode: FocusNode(),
                style: primaryTextStyle(),
                decoration: InputDecoration(
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25.0),
                    borderSide: BorderSide(color: appStore.iconColor!),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25.0),
                    borderSide:
                        BorderSide(width: 1, color: appStore.iconColor!),
                  ),
                  labelText: 'Tentang Masjid Anda',
                  labelStyle: primaryTextStyle(),
                  alignLabelWithHint: true,
                ),
                maxLines: 3,
                cursorColor: appStore.isDarkModeOn ? white : blackColor,
                keyboardType: TextInputType.multiline,
                validator: (s) {
                  if (s!.trim().isEmpty) return 'Address is required';
                  return null;
                },
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
