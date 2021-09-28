import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mosq/integrations/controllers.dart';
import 'package:mosq/main.dart';
import 'package:mosq/main/utils/AppWidget.dart';
import 'package:mosq/modules/kas/buku/kas_model.dart';
import 'package:mosq/modules/kas/transaksi/filter_model.dart';
import 'package:mosq/modules/kas/transaksi/list_transaksi.dart';
import 'package:mosq/modules/kas/transaksi/transaksi_model.dart';
import 'package:mosq/modules/kas/buku/index_kas.dart';
import 'package:mosq/modules/masjid/models/masjid_model.dart';
import 'package:mosq/routes/route_name.dart';
import 'package:mosq/screens/utils/MKColors.dart';
import 'package:mosq/screens/utils/MKConstant.dart';
import 'package:mosq/screens/utils/MKStrings.dart';
import 'package:mosq/screens/utils/Style.dart';
import 'package:nb_utils/nb_utils.dart';

class DashboardKas extends StatefulWidget {
  // TransaksiModel modelT = Get.arguments;
  @override
  _DashboardKasState createState() => _DashboardKasState();
}

class _DashboardKasState extends State<DashboardKas> {
  // int _currentIndex = 0;
  KasModel model = Get.arguments;
  RxList<TransaksiModel> _transaksies = RxList<TransaksiModel>();
  List<TransaksiModel> get transaksies => _transaksies.value;

  @override
  void initState() {
    super.initState();
    FilterModel filterByKas = FilterModel(field: "from_kas", value: model.id);
    _transaksies.bindStream(
      masjidC.currMasjid.transaksiDao!
          .transaksiStream(masjidC.currMasjid, filter: filterByKas),
    );
  }

  @override
  Widget build(BuildContext context) {
    // final tab = [
    //   OPDasboardScreen(context, model),
    //   OPDasboardScreen(context, model),
    //   OPDasboardScreen(context, model),
    //   OPDasboardScreen(context, model),
    //   OPDasboardScreen(context, model),
    // OPMyCards(),
    // OPDasboardScreen(context),
    // OPAtmLocationScreen(),
    // OPprofilePage(),
    // ];t

    return SafeArea(
      child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: appStore.appBarColor,
            leading: IconButton(
              onPressed: () {
                Get.back();
              },
              icon: Icon(Icons.arrow_back,
                  color: appStore.isDarkModeOn ? white : black),
            ),
            title: appBarTitleWidget(context, model.nama ?? 'Detail'),
          ),
          // : SizedBox(),
          body: Container(
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      Container(
                        height: 260,
                        width: double.infinity,
                        child: PageView(
                          pageSnapping: true,
                          children: <Widget>[
                            Container(
                              child: CardDetails(
                                visaTitle: model.nama ?? 'Buku kas',
                                expire: model.saldo.toString(),
                                name: model.id ?? "Nama Masjid",
                                // name: masjidC.currMasjid.nama ?? "Nama Masjid",
                                color: mkColorPrimary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 16, right: 16, bottom: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text('Transaction',
                            style: secondaryTextStyle(
                                size: 18, fontFamily: fontMedium)),
                        Container(
                          padding: EdgeInsets.only(left: 16, right: 5),
                          height: 34,
                          margin: EdgeInsets.only(left: 8),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(24),
                            border:
                                Border.all(color: Colors.grey.withAlpha(50)),
                          ),
                          child: DropdownButton(
                            value: 'Weekly',
                            underline: SizedBox(),
                            items: <String>[
                              'Daily',
                              'Weekly',
                              'Monthly',
                              'Yearly'
                            ].map((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value,
                                    style: primaryTextStyle(size: 14)),
                              );
                            }).toList(),
                            onChanged: (dynamic value) {},
                          ),
                        )
                      ],
                    ),
                  ),
                  Obx(
                    () => TransaksiKas(
                      transaksies: transaksies,
                      length: transaksies.length,
                    ),
                  )
                ],
              ),
            ),
          )),
    );
  }
}

// ignore: non_constant_identifier_names
// Widget OPDasboardScreen(BuildContext context, KasModel model) {
//   return 
//   Container(
//     child: SingleChildScrollView(
//       child: Column(
//         children: <Widget>[
//           Column(
//             children: <Widget>[
//               Container(
//                 height: 260,
//                 width: double.infinity,
//                 child: PageView(
//                   pageSnapping: true,
//                   children: <Widget>[
//                     Container(
//                       child: CardDetails(
//                         visaTitle: model.nama ?? 'Buku kas',
//                         expire: model.saldo.toString(),
//                         name: masjidC.currMasjid.nama ?? "Nama Masjid",
//                         color: mkColorPrimary,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//           Container(
//             margin: EdgeInsets.only(left: 16, right: 16, bottom: 16),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: <Widget>[
//                 Text('Transaction',
//                     style:
//                         secondaryTextStyle(size: 18, fontFamily: fontMedium)),
//                 Container(
//                   padding: EdgeInsets.only(left: 16, right: 5),
//                   height: 34,
//                   margin: EdgeInsets.only(left: 8),
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.circular(24),
//                     border: Border.all(color: Colors.grey.withAlpha(50)),
//                   ),
//                   child: DropdownButton(
//                     value: 'Weekly',
//                     underline: SizedBox(),
//                     items: <String>['Daily', 'Weekly', 'Monthly', 'Yearly']
//                         .map((String value) {
//                       return DropdownMenuItem<String>(
//                         value: value,
//                         child: Text(value, style: primaryTextStyle(size: 14)),
//                       );
//                     }).toList(),
//                     onChanged: (dynamic value) {},
//                   ),
//                 )
//               ],
//             ),
//           ),
//           Obx(
//             () => TransaksiKas(transaksies),
//           )
//         ],
//       ),
//     ),
//   );
// }
