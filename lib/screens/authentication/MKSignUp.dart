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

class MKSignUp extends StatelessWidget {
  var isLoading = false.obs;
  final _formKey = GlobalKey<FormState>();
  TextEditingController name = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController confirmPassword = TextEditingController();
  @override
  Widget build(BuildContext context) {
    // changeStatusColor(mkWhite);
    var width = Get.width;

    return Scaffold(
      body: GestureDetector(
        onTap: () {
          FocusScopeNode currentFocus = FocusScope.of(context);

          if (!currentFocus.hasPrimaryFocus) {
            currentFocus.unfocus();
          }
        },
        child: Container(
          height: Get.height,
          alignment: Alignment.center,
          padding: EdgeInsets.symmetric(vertical: 20),
          child: SingleChildScrollView(
            physics: ScrollPhysics(),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Image.asset(mk_login,
                      width: width / 2.5, height: width / 2.5),
                  text(mk_register,
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
                          mController: name,
                          keyboardType: TextInputType.name,
                          validator: (value) => (Validator(
                                  attributeName: mk_lbl_nama, value: value)
                                ..required())
                              .getError(),
                          label: mk_lbl_nama,
                        ),
                        SizedBox(height: 24),
                        EditText(
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
                          textInputAction: TextInputAction.done,
                          validator: (value) => (Validator(
                                  attributeName: mk_lbl_password, value: value)
                                ..required()
                                ..minLength(8))
                              .getError(),
                          label: mk_hint_password,
                          isSecure: true,
                          isPassword: true,
                        ),
                        SizedBox(height: 24),
                        EditText(
                          mController: confirmPassword,
                          textInputAction: TextInputAction.done,
                          autovalidateMode: AutovalidateMode.disabled,
                          validator: (value) {
                            (Validator(
                                    attributeName: mk_lbl_password,
                                    value: value)
                                  ..required())
                                .getError();
                            if (value != password.text) {
                              return "Password doesn't match";
                            }
                          },
                          label: mk_confirm_password,
                          isSecure: true,
                          isPassword: true,
                        ),
                        SizedBox(height: 24),
                        Row(
                          children: <Widget>[
                            Expanded(
                              child: InkWell(
                                onTap: () async {
                                  if (isLoading.value == false) {
                                    if (_formKey.currentState!.validate()) {
                                      isLoading.value = true;
                                      await authController.signUpWithEmail(
                                          name.text, email.text, password.text);
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
                                        : text(mk_sign_up,
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
                        Get.toNamed(RouteName.sign_in);
                      },
                      child: text(mk_to_login,
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
