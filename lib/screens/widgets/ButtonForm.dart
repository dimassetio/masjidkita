import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mosq/main/utils/AppWidget.dart';
import 'package:mosq/screens/utils/MKColors.dart';
import 'package:mosq/screens/utils/MKStrings.dart';
import 'package:nb_utils/nb_utils.dart';

class ButtonForm extends StatelessWidget {
  const ButtonForm({
    Key? key,
    required this.tapFunction,
    required this.isSaving,
  }) : super(key: key);
  final void Function() tapFunction;
  final RxBool isSaving;

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Container(
        width: MediaQuery.of(context).size.width,
        height: 50,
        margin: EdgeInsets.all(10),
        decoration: boxDecoration(
            bgColor: isSaving.value ? mkColorPrimaryLight : mkColorPrimary,
            radius: 10),
        padding: EdgeInsets.fromLTRB(16, 8, 16, 8),
        child: InkWell(
          onTap: tapFunction,
          child: Center(
            child: isSaving.value
                ? Container(
                    // color: mkColorAccent,
                    height: 30,
                    width: 30,
                    child: CircularProgressIndicator(),
                  )
                : Text(mk_submit, style: boldTextStyle(color: white, size: 18)),
          ),
        ),
      ),
    );
  }
}
