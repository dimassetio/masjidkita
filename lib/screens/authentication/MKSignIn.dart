import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:mosq/controllers/authController.dart';
import 'package:mosq/helpers/Validator.dart';
import 'package:mosq/integrations/controllers.dart';
import 'package:mosq/routes/route_name.dart';
import 'package:mosq/screens/utils/MKConstant.dart';
import 'package:nb_utils/nb_utils.dart';

import 'package:mosq/main/utils/AppWidget.dart';
import 'package:mosq/screens/utils/MKColors.dart';
import 'package:mosq/screens/utils/MKImages.dart';
import 'package:mosq/screens/utils/MKStrings.dart';
import 'package:mosq/screens/utils/MKWidget.dart';

import '../../main.dart';
// import 'T5Dialog.dart';

class MKSignIn extends StatelessWidget {
  var isLoading = false.obs;
  final _formKey = GlobalKey<FormState>();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    changeStatusColor(mkWhite);
    var width = Get.width;
    var height = Get.height;

    return Scaffold(
      body: GestureDetector(
        onTap: () {
          FocusScopeNode currentFocus = FocusScope.of(context);

          if (!currentFocus.hasPrimaryFocus) {
            currentFocus.unfocus();
          }
        },
        child: Container(
          height: height,
          alignment: Alignment.center,
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Image.asset(mk_login,
                      width: width / 2.5, height: width / 2.5),
                  text(mkapp_name,
                      textColor: appStore.textPrimaryColor,
                      fontFamily: fontBold,
                      fontSize: 22.0),
                  Container(
                    margin: EdgeInsets.all(24),
                    decoration: boxDecoration(
                        bgColor: appStore.scaffoldBackground,
                        showShadow: true,
                        radius: 4),
                    padding: EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        SizedBox(height: 10),
                        EditText(
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          mController: email,
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) => (Validator(
                                  attributeName: mk_lbl_email, value: value)
                                ..required()
                                ..email())
                              .getError(),
                          label: mk_lbl_email,
                        ),
                        SizedBox(height: 24),
                        EditText(
                          mController: password,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          textInputAction: TextInputAction.done,
                          validator: (value) => (Validator(
                                  attributeName: mk_lbl_password, value: value)
                                ..required())
                              .getError(),
                          label: mk_hint_password,
                          isSecure: true,
                          isPassword: true,
                        ),
                        SizedBox(height: 10),
                        GestureDetector(
                          onTap: () {
                            toast(mk_forgot_pswd);
                          },
                          child: Padding(
                            padding:
                                EdgeInsets.only(top: 10, bottom: 10, right: 10),
                            child: text(mk_forgot_pswd,
                                textColor: mkColorPrimary,
                                fontSize: textSizeMedium,
                                fontFamily: fontSemibold),
                          ),
                        ),
                        SizedBox(
                          height: 16,
                        ),
                        Row(
                          children: <Widget>[
                            Expanded(
                              child: InkWell(
                                onTap: () async {
                                  if (isLoading.value == false) {
                                    if (_formKey.currentState!.validate()) {
                                      isLoading.value = true;
                                      await authController.signIn(
                                          email.text.trim(),
                                          password.text.trim());
                                      isLoading.value = false;
                                    } else {
                                      _formKey.currentState!.validate();
                                    }
                                  }
                                },
                                child: Obx(
                                  () => Container(
                                    alignment: Alignment.center,
                                    height: width / 8,
                                    child: isLoading.value
                                        ? CircularProgressIndicator(
                                            color: mkWhite,
                                          )
                                        : text(mk_sign_in,
                                            textColor: mkWhite,
                                            isCentered: true),
                                    decoration: boxDecoration(
                                        bgColor: mkColorPrimary, radius: 8),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                  InkWell(
                      onTap: () {
                        Get.toNamed(RouteName.sign_up);
                      },
                      child: text(mk_to_register,
                          textColor: mkColorPrimary, fontSize: textSizeMedium))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
