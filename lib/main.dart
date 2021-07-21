// @dart=2.9
//region imports
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:masjidkita/integrations/binding.dart';
import 'package:masjidkita/screens/MosqDashboard.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:masjidkita/main/store/AppStore.dart';
import 'package:masjidkita/main/utils/AppTheme.dart';
import 'main/utils/AppConstant.dart';
import 'routes/route_page.dart';
//endregion

/// This variable is used to get dynamic colors when theme mode is changed
AppStore appStore = AppStore();
int currentIndex = 0;

void main() async {
  //region Entry Point
  WidgetsFlutterBinding.ensureInitialized();

  await initialize();

  appStore.toggleDarkMode(value: getBoolAsync(isDarkModeOnPref));

  await Firebase.initializeApp();

  await GetStorage.init();
  // if (isMobile) {
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
        title: '$mainAppName${!isMobile ? ' ${platformName()}' : ''}',
        home: MosqDashboard(),
        // home: Splash(),
        // home: GoogleSignInScreen(),
        getPages: AppPage.pages,
        theme: !appStore.isDarkModeOn
            ? AppThemeData.lightTheme
            : AppThemeData.darkTheme,
        builder: scrollBehaviour(),
        initialBinding: InitBinding(),
      ),
    );
  }
}

class Splash extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appStore.backgroundColor,
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
