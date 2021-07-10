// import 'package:masjidkita/constants/asset_path.dart';
import 'package:masjidkita/controllers/appController.dart';
// import 'package:masjidkita/screens/authentication/widgets/bottom_text.dart';
// import 'package:masjidkita/screens/authentication/widgets/login.dart';
// import 'package:masjidkita/screens/authentication/widgets/registration.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:masjidkita/screens/utils/MKImages.dart';

class AuthenticationScreen extends StatelessWidget {
  final AppController _appController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Obx(
          () => SingleChildScrollView(
            child: Stack(
              children: [
                Image.asset(
                  mk_contoh_image,
                  width: 800,
                  height: 600,
                  fit: BoxFit.cover,
                ),
                Container(
                  alignment: Alignment.bottomCenter,
                  height: MediaQuery.of(context).size.height / 1.1,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(height: MediaQuery.of(context).size.width / 0.9),
                      SizedBox(
                        height: MediaQuery.of(context).size.width / 70,
                      ),
                      // Visibility(
                      //     visible: _appController.isLoginWidgetDisplayed.value,
                      //     child: LoginWidget()),
                      // Visibility(
                      //     visible: !_appController.isLoginWidgetDisplayed.value,
                      //     child: RegistrationWidget()),
                      // SizedBox(
                      //   height: 20,
                      // ),
                      // Visibility(
                      //   visible: _appController.isLoginWidgetDisplayed.value,
                      //   child: BottomTextWidget(
                      //     onTap: () {
                      //       _appController.changeDIsplayedAuthWidget();
                      //     },
                      //     text1: "Belum punya akun?",
                      //     text2: "Buat akun baru",
                      //     // key: null,
                      //   ),
                      // ),
                      // Visibility(
                      //   visible: !_appController.isLoginWidgetDisplayed.value,
                      //   child: BottomTextWidget(
                      //     onTap: () {
                      //       _appController.changeDIsplayedAuthWidget();
                      //     },
                      //     text1: "Sudah punya akun?",
                      //     text2: "Masuk",
                      //     // key: null,
                      //   ),
                      // ),
                    ],
                  ),
                ),
                // Positioned(
                //   top: MediaQuery.of(context).size.height / 6,
                //   left: 20,
                //   child: Image.asset(
                //     logo2,
                //     width: 140,
                //   ),
                // )
              ],
            ),
          ),
        ));
  }
}
