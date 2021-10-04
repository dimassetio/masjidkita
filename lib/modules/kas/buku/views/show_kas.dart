import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mosq/helpers/formatter.dart';
import 'package:mosq/integrations/controllers.dart';
import 'package:mosq/main.dart';
import 'package:mosq/main/utils/AppWidget.dart';
import 'package:mosq/modules/kas/buku/models/kas_model.dart';
import 'package:mosq/modules/kas/transaksi/models/filter_model.dart';
import 'package:mosq/modules/kas/transaksi/views/list_transaksi.dart';
import 'package:mosq/modules/kas/transaksi/models/transaksi_model.dart';
import 'package:mosq/modules/kas/buku/views/index_kas.dart';
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
  KasModel kas = Get.arguments;
  RxList<TransaksiModel> _transaksies = RxList<TransaksiModel>();
  List<TransaksiModel> get transaksies => _transaksies.value;
  var _model = KasModel().obs;
  KasModel get model => _model.value;

  @override
  void initState() {
    super.initState();
    FilterModel filterByKas = FilterModel(
        field: "kas", value: kas.id, operator: Operator.arrayContains);
    _model.bindStream(kas.dao!.streamDetailKas(kas));
    _transaksies.bindStream(
      masjidC.currMasjid.transaksiDao!
          .transaksiStream(masjidC.currMasjid, filter: filterByKas),
    );
  }

  @override
  Widget build(BuildContext context) {
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
          body: Stack(
            children: [
              Obx(
                () => Container(
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
                                      expire: currencyFormatter(model.saldo),
                                      name: currencyFormatter(model.saldoAwal),
                                      // name: masjidC.currMasjid.nama ?? "Nama Masjid",
                                      color: mkColorPrimary,
                                      namaMasjid: masjidC.currMasjid.nama ?? '',
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        Obx(
                          () => text(transaksies.toString()),
                        ),
                        Container(
                          margin:
                              EdgeInsets.only(left: 16, right: 16, bottom: 16),
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
                                  border: Border.all(
                                      color: Colors.grey.withAlpha(50)),
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
                ),
              ),
              Container(
                  alignment: Alignment.bottomRight,
                  padding: EdgeInsets.only(right: 15, bottom: 15),
                  child: Obx(() => masjidC.myMasjid.value
                      ? FloatingActionButton(
                          child: Icon(
                            Icons.edit,
                            color: mkWhite,
                          ),
                          backgroundColor: mkColorPrimary,
                          onPressed: () {
                            Get.toNamed(RouteName.new_transaksi,
                                arguments: TransaksiModel(
                                    dao: masjidC.currMasjid.transaksiDao,
                                    fromKas: model.id));
                          })
                      : SizedBox())),
            ],
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
