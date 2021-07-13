import 'package:get/get.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:masjidkita/controllers/authController.dart';
import 'package:masjidkita/controllers/fiturController.dart';

class InitBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(AuthController(), permanent: true);
    Get.lazyPut(() => FiturController());
  }
}
