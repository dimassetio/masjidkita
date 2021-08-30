import 'package:get/get.dart';
import 'package:mosq/modules/masjid/controllers/masjid_controller.dart';

class ListMasjidBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(MasjidController());
  }
}
