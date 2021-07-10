import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:masjidkita/screens/controller/pageController.dart';

import 'package:masjidkita/screens/utils/MKColors.dart';
import 'package:masjidkita/screens/utils/MKImages.dart';
import 'package:masjidkita/screens/utils/m_k_icon_icons.dart';

import 'package:nb_utils/nb_utils.dart';

import '../../main.dart';
import 'PageSiMasjid.dart';

class MKDashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final pageC = Get.put(PagexController(), permanent: true);
    // var _currentPage = 0;
    return Scaffold(
        // body: PageHome(),
        // bottomNavigationBar: Obx(() {
        //   return BottomNavigationBar(
        //     backgroundColor: Colors.white,
        //     type: BottomNavigationBarType.fixed,
        //     showUnselectedLabels: false,
        //     selectedItemColor: mkColorPrimary,
        //     unselectedItemColor: grey,
        //     currentIndex: pageC.page.value,
        //     elevation: 8.0,
        //     items: [
        //       BottomNavigationBarItem(
        //           icon: Icon(
        //             Icons.home,
        //             size: 24,
        //           ),
        //           label: 'Home'),
        //       BottomNavigationBarItem(
        //           icon: Icon(
        //             MKIcon.mosque,
        //             size: 24,
        //           ),
        //           label: 'Masjid'),
        //       // BottomNavigationBarItem(
        //       //     icon: Padding(
        //       //       padding: const EdgeInsets.only(bottom: 8.0),
        //       //       child: SvgPicture.asset(
        //       //         mk_ic_mosque,
        //       //         width: 36,
        //       //         height: 36,
        //       //         color: Colors.white,
        //       //       ),
        //       //     ),
        //       //     label: ''),
        //       // BottomNavigationBarItem(
        //       //     icon: Icon(
        //       //       Icons.location_on,
        //       //       size: 24,
        //       //     ),
        //       //     label: ''),
        //       BottomNavigationBarItem(
        //           icon: Icon(
        //             Icons.person,
        //             size: 24,
        //           ),
        //           label: 'Profil'),
        //     ],
        //     onTap: (index) {
        //       print(index);
        //       pageC.page.value = index;
        //     },
        //   );
        // })
        );
  }
}
