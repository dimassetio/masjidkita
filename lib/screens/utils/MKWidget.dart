import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:mosq/screens/utils/MKColors.dart';
import 'package:mosq/screens/utils/MKImages.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:mosq/main/utils/AppWidget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mosq/screens/widgets/ImageSourceBottomSheet.dart';
import 'package:mosq/screens/utils/MKConstant.dart';
import 'package:image_picker/image_picker.dart';

import '../../main.dart';
import 'MKConstant.dart';

// ignore: must_be_immutable
class EditText extends StatefulWidget {
  var isPassword;
  var isSecure;
  var isEnabled;
  var fontSize;
  var textColor;
  var fontFamily;
  var text;
  var hint;
  var label;
  var maxLine;
  var isBordered;
  var isReadOnly;
  String? Function(String?)? validator;
  TextEditingController? mController;
  AutovalidateMode? autovalidateMode;
  List<TextInputFormatter>? inputFormatters;
  TextInputAction? textInputAction;
  TextInputType? keyboardType;
  Icon? icon;
  FocusNode? focus;
  TextAlign textAlign;
  String? initValue;
  Icon? suffix;
  VoidCallback? onPressed;

  EditText({
    var this.fontSize = textSizeNormal,
    var this.textColor = mkTextColorSecondary,
    var this.fontFamily = fontRegular,
    var this.isPassword = false,
    var this.hint = "",
    var this.isSecure = false,
    var this.isEnabled = true,
    var this.text = "",
    var this.mController,
    var this.initValue,
    var this.maxLine = 1,
    var this.validator,
    var this.icon,
    var this.suffix,
    var this.focus,
    var this.textAlign = TextAlign.start,
    var this.label,
    var this.inputFormatters,
    var this.keyboardType,
    var this.autovalidateMode = AutovalidateMode.onUserInteraction,
    var this.isBordered = false,
    var this.textInputAction = TextInputAction.next,
    var this.isReadOnly = false,
  });

  @override
  State<StatefulWidget> createState() {
    return EditTextState();
  }
}

class EditTextState extends State<EditText> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      initialValue: widget.initValue,
      focusNode: widget.focus,
      textAlign: widget.textAlign,
      readOnly: widget.isReadOnly,
      enabled: widget.isEnabled,
      autovalidateMode: widget.autovalidateMode,
      validator: widget.validator,
      controller: widget.mController,
      obscureText: widget.isPassword,
      inputFormatters: widget.inputFormatters,
      textInputAction: widget.textInputAction,
      keyboardType: widget.keyboardType,
      maxLines: widget.maxLine,
      style: TextStyle(
          color: appStore.textPrimaryColor,
          fontSize: textSizeMedium,
          fontFamily: fontRegular),
      decoration: InputDecoration(
        icon: widget.icon,
        suffixIcon: widget.isSecure
            ? GestureDetector(
                onTap: () {
                  setState(() {
                    widget.isPassword = !widget.isPassword;
                  });
                },
                child: new Icon(
                  widget.isPassword ? Icons.visibility : Icons.visibility_off,
                  color: appStore.iconColor,
                ),
              )
            : widget.suffix,
        contentPadding: widget.isBordered ? EdgeInsets.all(12) : null,
        hintText: widget.hint,
        hintStyle: secondaryTextStyle(color: mkColorPrimaryDark),
        labelText: widget.label,
        labelStyle: secondaryTextStyle(color: mkColorPrimaryDark),
        enabledBorder: widget.isBordered
            ? OutlineInputBorder(
                borderRadius: BorderRadius.circular(4),
                borderSide: const BorderSide(color: mkViewColor, width: 0.0),
              )
            : null,
        errorBorder: widget.isBordered
            ? OutlineInputBorder(
                borderRadius: BorderRadius.circular(4),
                borderSide: const BorderSide(color: mkViewColor, width: 0.0),
              )
            : null,
        focusedBorder: widget.isBordered
            ? OutlineInputBorder(
                borderRadius: BorderRadius.circular(4),
                borderSide: const BorderSide(color: mkViewColor, width: 0.0),
              )
            : null,
      ),
    );
  }
}

TextFormField editTextStyle(var hintText, {isPassword = true}) {
  return TextFormField(
    obscureText: isPassword,
    inputFormatters: [FilteringTextInputFormatter.singleLineFormatter],
    style: primaryTextStyle(color: appStore.textPrimaryColor),
    decoration: InputDecoration(
      contentPadding: EdgeInsets.fromLTRB(16, 10, 16, 10),
      hintText: hintText,
      hintStyle: TextStyle(color: mkTextColorThird),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(4),
        borderSide: const BorderSide(color: mkViewColor, width: 0.0),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(4),
        borderSide: const BorderSide(color: mkViewColor, width: 0.0),
      ),
    ),
  );
}

class TopBar extends StatefulWidget {
  var titleName;

  TopBar({var this.titleName = ""});

  @override
  State<StatefulWidget> createState() {
    return TopBarState();
  }
}

class TopBarState extends State<TopBar> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: 60,
        color: appStore.appBarColor,
        child: Stack(
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.keyboard_arrow_left, size: 45),
              onPressed: () {
                finish(context);
              },
            ),
            Center(
                child: text(widget.titleName,
                    textColor: appStore.textPrimaryColor,
                    fontSize: textSizeNormal,
                    fontFamily: fontBold))
          ],
        ),
      ),
    );
  }
}

class TipeTransaksiIcon extends StatelessWidget {
  const TipeTransaksiIcon({
    Key? key,
    required this.tipeTransaksi,
  }) : super(key: key);

  final int tipeTransaksi;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 30,
      child: CircleAvatar(
        backgroundColor: tipeTransaksi == 10
            ? Colors.green.withOpacity(0.5)
            : Colors.red.withOpacity(0.5),
        child: Icon(
          tipeTransaksi == 10 ? Icons.call_received : Icons.call_made,
          color: tipeTransaksi == 10 ? Colors.green : Colors.red,
          size: 24,
        ),
      ),
    );
  }
}

Text profile(var label) {
  return Text(label,
      style:
          TextStyle(color: mkColorPrimary, fontSize: 18, fontFamily: 'Medium'),
      textAlign: TextAlign.center);
}

Divider view() {
  return Divider(color: mk_view_color, height: 0.5);
}

Row profileText(var label, {var maxline = 1}) {
  return Row(
    children: <Widget>[
      Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 10, 0),
          child: text(label,
              fontSize: textSizeLargeMedium,
              textColor: appStore.textPrimaryColor,
              maxLine: maxline)),
    ],
  );
}

Row rowHeading(var label) {
  return Row(
    children: <Widget>[
      Padding(
        padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
        child: Text(label,
            style: TextStyle(
                color: appStore.textPrimaryColor,
                fontSize: 18,
                fontFamily: 'Bold'),
            textAlign: TextAlign.left),
      ),
    ],
  );
}

Widget divider() {
  return Divider(color: mkColorPrimaryDark);
}
