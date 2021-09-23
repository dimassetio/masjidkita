import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mosq/integrations/controllers.dart';
import 'package:mosq/main.dart';
import 'package:mosq/main/utils/AppWidget.dart';
import 'package:mosq/modules/kas/models/kas_model.dart';
import 'package:mosq/modules/kas/models/transaksi_model.dart';
import 'package:mosq/modules/masjid/models/masjid_model.dart';
import 'package:mosq/routes/route_name.dart';
import 'package:mosq/screens/utils/MKColors.dart';
import 'package:mosq/screens/utils/MKConstant.dart';
import 'package:mosq/screens/utils/MKStrings.dart';
import 'package:mosq/screens/utils/Style.dart';
import 'package:nb_utils/nb_utils.dart';

class DashboardKas extends StatefulWidget {
  KasModel model = Get.arguments;
  // TransaksiModel modelT = Get.arguments;
  @override
  _DashboardKasState createState() => _DashboardKasState();
}

class _DashboardKasState extends State<DashboardKas> {
  int _currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    final tab = [
      OPDasboardScreen(context, widget.model),
      OPDasboardScreen(context, widget.model),
      OPDasboardScreen(context, widget.model),
      OPDasboardScreen(context, widget.model),
      OPDasboardScreen(context, widget.model),
      // OPMyCards(),
      // OPDasboardScreen(context),
      // OPAtmLocationScreen(),
      // OPprofilePage(),
    ];
    var title = '';

    if (_currentIndex == 0) {
      title = 'Dashboard';
    } else if (_currentIndex == 1) {
      title = 'My card';
    } else if (_currentIndex == 2) {
      title = 'Dashboard';
    } else if (_currentIndex == 3) {
      title = 'ATM Location';
    } else if (_currentIndex == 4) {
      title = 'Profile';
    }

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
            title: appBarTitleWidget(context, widget.model.nama ?? 'Detail'),
          ),
          // : SizedBox(),
          body: tab[_currentIndex],
          bottomNavigationBar: Stack(
            alignment: Alignment.center,
            children: [
              BottomNavigationBar(
                backgroundColor: Colors.white,
                type: BottomNavigationBarType.fixed,
                showUnselectedLabels: false,
                selectedItemColor: mkColorPrimary,
                unselectedItemColor: mkColorAccent.withOpacity(0.6),
                currentIndex: _currentIndex,
                elevation: 8.0,
                items: [
                  BottomNavigationBarItem(
                      icon: Icon(
                        Icons.home,
                        size: 24,
                      ),
                      label: ''),
                  BottomNavigationBarItem(
                      icon: Icon(
                        Icons.credit_card,
                        size: 24,
                      ),
                      label: ''),
                  BottomNavigationBarItem(
                      icon: Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: Image(
                          width: 36,
                          height: 36,
                          image: AssetImage('images/widgets/opsplash.png'),
                        ),
                      ),
                      label: ''),
                  BottomNavigationBarItem(
                      icon: Icon(
                        Icons.location_on,
                        size: 24,
                      ),
                      label: ''),
                  BottomNavigationBarItem(
                      icon: Icon(
                        Icons.person,
                        size: 24,
                      ),
                      label: ''),
                ],
                onTap: (index) {
                  setState(() {
                    _currentIndex = index;
                  });
                },
              ),
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TransaksiKas(),
                    ),
                  );
                },
                child: Image(
                  width: 36,
                  height: 36,
                  image: AssetImage('images/widgets/opsplash.png'),
                ),
              )
            ],
          )),
    );
  }
}

// ignore: non_constant_identifier_names
Widget OPDasboardScreen(BuildContext context, KasModel model) {
  return Container(
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
                        creditNumber: model.id ?? 'Ini kode',
                        expire: model.saldo.toString(),
                        name: 'Masjid',
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
                    style:
                        secondaryTextStyle(size: 18, fontFamily: fontMedium)),
                Container(
                  padding: EdgeInsets.only(left: 16, right: 5),
                  height: 34,
                  margin: EdgeInsets.only(left: 8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: Colors.grey.withAlpha(50)),
                  ),
                  child: DropdownButton(
                    value: 'Weekly',
                    underline: SizedBox(),
                    items: <String>['Daily', 'Weekly', 'Monthly', 'Yearly']
                        .map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value, style: primaryTextStyle(size: 14)),
                      );
                    }).toList(),
                    onChanged: (dynamic value) {},
                  ),
                )
              ],
            ),
          ),
          Obx(() => ListView.builder(
              padding: EdgeInsets.symmetric(),
              scrollDirection: Axis.vertical,
              itemCount: transaksiC.transaksies.length,
              shrinkWrap: true,
              physics: ScrollPhysics(),
              itemBuilder: (context, index) {
                return Transaksies(
                    dataTransaksi: transaksiC.transaksies[index]);
              })),
          text(transaksiC.transaksies.toString())
        ],
      ),
    ),
  );
}

class TransaksiKas extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        appBar: getAppBar('Transfer', pressed: () {
          finish(context);
        }),
        body: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Column(
                children: <Widget>[
                  Container(
                    width: size.width,
                    padding: EdgeInsets.only(
                        left: 16, right: 16, top: 16, bottom: 30),
                    margin: EdgeInsets.all(16),
                    decoration: boxDecoration(radius: 16),
                    child: textField2(
                      title: 'Receiver',
                      image: Icons.person_outline,
                      textInputType: TextInputType.number,
                    ),
                  ),
                ],
              ),
              Center(
                child: Container(
                  width: double.infinity,
                  height: 50,
                  margin: EdgeInsets.all(16),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: mkColorPrimary,
                      elevation: 1,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    onPressed: () {
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(
                      //     builder: (context) => OPTransferReviewScreen(),
                      //   ),
                      // );
                    },
                    child: Text(
                      "Next",
                      textAlign: TextAlign.center,
                      style: boldTextStyle(color: Colors.white),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class Transaksies extends StatelessWidget {
  const Transaksies({required this.dataTransaksi});
  final TransaksiModel dataTransaksi;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          padding: EdgeInsets.symmetric(vertical: 5.0),
          width: double.infinity,
          child: DashboardList(
            name: '${dataTransaksi.jumlah}',
            status: '${dataTransaksi.jumlah}',
            color: mkColorPrimary,
            amount: '${dataTransaksi.jumlah}',
            onPressed: () {
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(
              //     builder: (context) => OPTransactionDetailsScreen(),
              //   ),
              // );
            },
          ),
        ),
      ],
    );
  }
}
