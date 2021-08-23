import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mosq/integrations/controllers.dart';

import 'package:mosq/main/utils/AppWidget.dart';
import 'package:mosq/routes/route_name.dart';
import 'package:mosq/screens/fitur/Kelola_Masjid/Tab_Kegiatan/DetailKegiatan.dart';
import 'package:mosq/screens/utils/MKColors.dart';
import 'package:mosq/screens/widgets/KegiatanCard.dart';
// import 'package:mosq/screens/widgets/KegiatanSlider.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../../main.dart';

const double _fabDimension = 56;

class TMTabKegiatan extends StatefulWidget {
  static String tag = '/TMTabKegiatan';

  @override
  _TMTabKegiatanState createState() => _TMTabKegiatanState();
}

class _TMTabKegiatanState extends State<TMTabKegiatan> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  ContainerTransitionType _transitionType = ContainerTransitionType.fade;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Stack(
        // key: _scaffoldKey,
        // appBar: appBar(context, 'Open Container Transform Demo'),
        children: [
          ListView(
            // padding: const EdgeInsets.all(8),
            children: [
              Row(
                children: [
                  Expanded(
                    child: _OpenContainerWrapper(
                      transitionType: _transitionType,
                      closedBuilder: (context, openContainer) {
                        return Obx(
                          () => ListView.builder(
                              padding: EdgeInsets.symmetric(),
                              scrollDirection: Axis.vertical,
                              itemCount: kegiatanC.kegiatans.length,
                              // itemCount: mListings.length,
                              shrinkWrap: true,
                              physics: ScrollPhysics(),
                              itemBuilder: (context, index) {
                                return KegiatanCard(
                                  openContainer: openContainer,
                                  width: Get.width,
                                  dataKegiatan: kegiatanC.kegiatans[index],
                                );
                              }),
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: 8),
                ],
              ),
              // const SizedBox(height: 16),
              // ...List.generate(4, (index) {
              //   return OpenContainer<bool>(
              //     transitionType: _transitionType,
              //     openBuilder: (context, openContainer) => const _DetailsPage(),
              //     tappable: false,
              //     closedShape: const RoundedRectangleBorder(),
              //     closedElevation: 0,
              //     closedBuilder: (context, openContainer) {
              //       return Container(
              //         color: appStore.appBarColor,
              //         child: ListTile(
              //           leading: Image.network(SampleImageUrl,
              //               width: 40, fit: BoxFit.cover),
              //           onTap: openContainer,
              //           title: Text(
              //             'List Menu Item' + ' ${index + 1}',
              //             style: primaryTextStyle(size: 16),
              //           ),
              //           subtitle: Text(
              //             'Placeholder text',
              //             style: secondaryTextStyle(size: 12),
              //           ),
              //         ),
              //       );
              //     },
              //   );
              // }),
            ],
          ),
          Container(
              alignment: Alignment.bottomRight,
              padding: EdgeInsets.only(right: 15, bottom: 15),
              child: Obx(() => manMasjidC.myMasjid.value
                  ? FloatingActionButton(
                      // heroTag: '1',
                      // heroTag: '5',
                      // label: Text(
                      //   "Add",
                      //   style: primaryTextStyle(color: Colors.white),
                      // ),
                      child: Icon(
                        Icons.edit,
                        color: mkWhite,
                      ),
                      backgroundColor: mkColorPrimary,
                      onPressed: () {
                        // CustomDelete();
                        Get.toNamed(RouteName.new_kegiatan);
                      })
                  : SizedBox())),
        ]);
  }
}

// class TMTabKegiatan extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Stack(children: [
//       Container(
//         height: Get.height,
//         child: SingleChildScrollView(
//           child: Obx(
//             () => ListView.builder(
//                 padding: EdgeInsets.symmetric(),
//                 scrollDirection: Axis.vertical,
//                 itemCount: kegiatanC.kegiatans.length,
//                 // itemCount: mListings.length,
//                 shrinkWrap: true,
//                 physics: ScrollPhysics(),
//                 itemBuilder: (context, index) {
//                   return KegiatanCard(
//                     width: Get.width,
//                     dataKegiatan: kegiatanC.kegiatans[index],
//                   );
//                 }),
//           ),
//         ),
//       ),
//     ]);
//   }
// }

class _OpenContainerWrapper extends StatelessWidget {
  const _OpenContainerWrapper({
    this.closedBuilder,
    this.transitionType,
  });

  final CloseContainerBuilder? closedBuilder;
  final ContainerTransitionType? transitionType;

  @override
  Widget build(BuildContext context) {
    return OpenContainer<bool>(
      transitionType: transitionType!,
      openBuilder: (context, openContainer) => const DetailsPage(),
      tappable: false,
      closedBuilder: closedBuilder!,
    );
  }
}
