import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:masjidkita/integrations/controllers.dart';
import 'package:masjidkita/main/utils/AppWidget.dart';
import 'package:masjidkita/screens/utils/MKColors.dart';
import 'package:masjidkita/screens/utils/MKImages.dart';
import 'package:masjidkita/screens/utils/widgets/DetailMasjid/TabKas.dart';
import 'package:masjidkita/screens/utils/widgets/DetailMasjid/TabProfile.dart';
import 'package:masjidkita/screens/utils/widgets/DetailMasjid/TabTakmir.dart';
import 'package:masjidkita/screens/fitur/Kelola_Masjid/ManMasjid.dart';
import 'package:nb_utils/nb_utils.dart';
// import 'package:masjidkita/screens/utils/widgets/T5Slider.dart';

import 'package:masjidkita/main.dart';

import 'TMTabKas.dart';
import 'TMTabProfile.dart';
import 'TMTabTakmir.dart';

class KeMasjid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DefaultTabController(
        length: 3,
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
                  pinned: true,
                  snap: false,
                  elevation: 50,
                  backgroundColor: white,
                  flexibleSpace: Obx(
                    () => FlexibleSpaceBar(
                        centerTitle: true,
                        title: Text(manMasjidC.keMasjid.nama ?? "Nama Masjid",
                            style: primaryTextStyle(
                                color: innerBoxIsScrolled
                                    ? appStore.textPrimaryColor
                                    : white)),
                        background: Image.asset(
                          mk_contoh_image,
                          fit: BoxFit.cover,
                        )),
                  ),
                ),
                SliverPersistentHeader(
                  delegate: _SliverAppBarDelegate(
                    TabBar(
                      labelColor: mkColorPrimary,
                      indicatorColor: mkColorPrimaryDark,
                      unselectedLabelColor: appStore.textPrimaryColor,
                      tabs: [
                        Tab(text: "Profil"),
                        Tab(text: "Takmir"),
                        Tab(text: "Kas"),
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
      decoration: boxDecoration(
          radius: 10,
          bgColor: appStore.isDarkModeOn
              ? appStore.scaffoldBackground
              : mkColorPrimaryLight,
          showShadow: true),
      child: _tabBar,
    );
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return false;
  }
}
