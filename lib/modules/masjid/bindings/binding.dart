import 'package:get/get.dart';
import 'package:mosq/modules/masjid/controlllers/masjid_controller.dart';

class ListMasjidBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(MasjidController());
  }
}
