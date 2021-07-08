//region imports
// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get/get.dart';
import 'package:masjidkita/screens/DetailMasjid.dart';
import 'package:masjidkita/screens/MKDashboard.dart';
import 'package:masjidkita/screens/MKSignIn.dart';
import 'package:masjidkita/screens/MKSignUp.dart';
// import 'package:masjidkita/screens/T5Dashboard.dart';
// import 'package:google_mobile_ads/google_mobile_ads.dart';
// import 'package:masjidkita/screens/T5SignIn.dart';
import 'package:nb_utils/nb_utils.dart';
// import 'package:masjidkita/cloudStorage/model/CSDataModel.dart';
// import 'package:masjidkita/main/screens/AppSplashScreen.dart';
import 'package:masjidkita/main/store/AppStore.dart';
import 'package:masjidkita/main/utils/AppTheme.dart';
// import 'package:masjidkita/routes.dart';

import 'main/utils/AppConstant.dart';
import 'routes/route_page.dart';
// import 'muvi/utils/flix_app_localizations.dart';
//endregion

/// This variable is used to get dynamic colors when theme mode is changed
AppStore appStore = AppStore();
int currentIndex = 0;

void main() async {
  //region Entry Point
  WidgetsFlutterBinding.ensureInitialized();

  await initialize();

  appStore.toggleDarkMode(value: getBoolAsync(isDarkModeOnPref));

  // if (isMobile) {
  //   await Firebase.initializeApp();
  //   MobileAds.instance.initialize();

  //   FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
  // }

  runApp(MyApp());
  //endregion
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (_) => GetMaterialApp(
        debugShowCheckedModeBanner: false,
        // localizationsDelegates: [
        //   MuviAppLocalizations.delegate,
        //   GlobalMaterialLocalizations.delegate,
        //   GlobalWidgetsLocalizations.delegate
        // ],
        localeResolutionCallback: (locale, supportedLocales) =>
            Locale(appStore.selectedLanguage),
        locale: Locale(appStore.selectedLanguage),
        supportedLocales: [Locale('en', '')],
        // routes: routes(),
        title: '$mainAppName${!isMobile ? ' ${platformName()}' : ''}',
        // home: DetailMasjid(),
        // home: MKDashboard(),
        home: T5SignIn(),
        getPages: AppPage.pages,
        theme: !appStore.isDarkModeOn
            ? AppThemeData.lightTheme
            : AppThemeData.darkTheme,
        builder: scrollBehaviour(),
      ),
    );
  }
}
