import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mosq/main.dart';
import 'package:mosq/main/utils/AppWidget.dart';
import 'package:mosq/routes/route_name.dart';
import 'package:mosq/screens/utils/MKColors.dart';
import 'package:mosq/screens/utils/MKConstant.dart';
import 'package:mosq/screens/utils/Style.dart';
import 'package:nb_utils/nb_utils.dart';

class DashboardKas extends StatefulWidget {
  @override
  _DashboardKasState createState() => _DashboardKasState();
}

class _DashboardKasState extends State<DashboardKas> {
  int _currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    final tab = [
      OPDasboardScreen(context),
      OPDasboardScreen(context),
      OPDasboardScreen(context),
      OPDasboardScreen(context),
      OPDasboardScreen(context),
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
                // KasC.checkControllers(
                //         Get.currentRoute == RouteName.edit_Kas
                //             ? dataKas!
                //             : KasModel(
                //                 nama: "", jabatan: "", photoUrl: "", id: ""))
                //     ? showDialog(
                //         context: Get.context!,
                //         builder: (BuildContext context) => ConfirmDialog(),
                //       )
                //     :
                Get.back();
              },
              icon: Icon(Icons.arrow_back,
                  color: appStore.isDarkModeOn ? white : black),
            ),
            // title: appBarTitleWidget(
            //   context,
            //   Get.currentRoute == RouteName.edit_kas ? mk_edit_kas : mk_add_kas,
            // ),
            // actions: actions,
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

Widget OPDasboardScreen(BuildContext context) {
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
                        visaTitle: 'Visa',
                        creditNumber: '3456',
                        expire: '12/20',
                        name: 'John Doe',
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
          Column(
            children: <Widget>[
              Container(
                padding: EdgeInsets.symmetric(vertical: 5.0),
                width: double.infinity,
                child: DashboardList(
                  name: 'John Doe',
                  status: 'Payment Received',
                  color: mkColorPrimary,
                  amount: '+ ₹250',
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
          ),
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
