import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:mosq/controllers/inventarisController.dart';
import 'package:mosq/integrations/controllers.dart';
import 'package:mosq/main/utils/AppWidget.dart';
import 'package:mosq/models/inventaris.dart';
import 'package:mosq/screens/fitur/Kelola_Masjid/Tab_Kegiatan/TMTabKegiatan.dart';
import 'package:mosq/screens/utils/MKColors.dart';
import 'package:mosq/screens/utils/MKImages.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:get/get.dart';
// import 'package:mosq/screens/widgets/T5Slider.dart';

import 'package:mosq/main.dart';

import 'Tab_Kas/TMTabKas.dart';
import 'Tab_Profile/TMTabProfile.dart';
import 'Tab_Takmir/TMTabTakmir.dart';
import 'Tab_Inventaris/TMTabInventaris.dart';

class KeMasjid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Get.put(InventarisController().onInit());
    return Scaffold(
      body: DefaultTabController(
        length: 5,
        child: NestedScrollView(
            headerSliverBuilder:
                (BuildContext context, bool innerBoxIsScrolled) {
              return <Widget>[
                SliverAppBar(
                  leading: IconButton(
                    icon: Icon(Icons.arrow_back),
                    color: appStore.isDarkModeOn
                        ? appStore.iconColor
                        : innerBoxIsScrolled
                            ? blackColor
                            : lightGrey,
                    onPressed: () {
                      Get.back();
                    },
                  ),
                  expandedHeight: 220.0,
                  floating: true,
                  centerTitle: true,
                  title: Obx(() => Text(
                      manMasjidC.deMasjid.nama ?? "Nama Masjid",
                      style:
                          primaryTextStyle(color: appStore.textPrimaryColor))),
                  pinned: true,
                  snap: false,
                  elevation: 50,
                  backgroundColor: white,
                  flexibleSpace: Obx(
                    () => FlexibleSpaceBar(
                      centerTitle: true,
                      background: manMasjidC.deMasjid.photoUrl != ""
                          ? CachedNetworkImage(
                              placeholder: placeholderWidgetFn() as Widget
                                  Function(BuildContext, String)?,
                              imageUrl: manMasjidC.deMasjid.photoUrl ?? "",
                              fit: BoxFit.cover,
                            )
                          : Image.asset(mk_contoh_image, fit: BoxFit.cover),
                      // Image.network(
                      //   manMasjidC.deMasjid.photoUrl ?? "",
                      //   fit: BoxFit.cover,
                      //   loadingBuilder: (BuildContext context, Widget child,
                      //       ImageChunkEvent? loadingProgress) {
                      //     if (loadingProgress == null) {
                      //       return child;
                      //     }
                      //     return Center(
                      //       child: CircularProgressIndicator(
                      //         value: loadingProgress.expectedTotalBytes !=
                      //                 null
                      //             ? loadingProgress.cumulativeBytesLoaded /
                      //                 loadingProgress.expectedTotalBytes!
                      //             : null,
                      //       ),
                      //     );
                      //   },
                      //   errorBuilder: (BuildContext context, Object exception,
                      //       StackTrace? stackTrace) {
                      //     return Image.asset(mk_contoh_image,
                      //         fit: BoxFit.cover);
                      //   },
                      // ),
                    ),
                  ),
                ),
                SliverPersistentHeader(
                  delegate: _SliverAppBarDelegate(
                    TabBar(
                      physics: ScrollPhysics(),
                      isScrollable: true,
                      labelColor: mkColorPrimaryDark,
                      indicatorColor: mkColorPrimaryDark,
                      unselectedLabelColor: appStore.textPrimaryColor,
                      tabs: [
                        Tab(text: "Profil"),
                        Tab(text: "Takmir"),
                        Tab(text: "Kas"),
                        Tab(text: "Inventaris"),
                        Tab(text: "Kegiatan"),
                        // Tab(text: "Kegiatan"),
                      ],
                    ),
                  ),
                  pinned: true,
                ),
              ];
            },
            body: TabBarView(
              children: [
                TMTabProfile(),
                TMTabTakmir(),
                TMTabKas(),
                TMTabInventaris(InventarisModel()),
                TMTabKegiatan(),
                // TMTabKegiatan(),
              ],
            )),
      ),
    );
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate(this._tabBar);

  final TabBar _tabBar;

  @override
  double get minExtent => _tabBar.preferredSize.height + 32;

  @override
  double get maxExtent => _tabBar.preferredSize.height + 32;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      margin: EdgeInsets.all(16),
      padding: EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(10)),
        // radius: 10,
        color: appStore.isDarkModeOn
            ? appStore.scaffoldBackground
            : mkColorPrimaryLight,
        // bgColor: appStore.isDarkModeOn
        //     ? appStore.scaffoldBackground
        //     : mkColorPrimaryLight,
        boxShadow: [BoxShadow()],
        // showShadow: true
      ),
      child: _tabBar,
    );
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return false;
  }
}
