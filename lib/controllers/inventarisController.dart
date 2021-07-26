import 'package:masjidkita/models/inventaris.dart';
import 'package:masjidkita/services/database.dart';
import 'package:get/get.dart';
import 'package:masjidkita/routes/route_name.dart';

class InventarisController extends GetxController {
  Rx<InventarisModel> _inventarisModel = InventarisModel().obs;

  RxList<InventarisModel> inventarisList = RxList<InventarisModel>();
  List<InventarisModel> get inventariss => inventarisList.value;

  addInventaris(String? nama, String? kondisi, int? jumlah,
      String? inventarisID, String? foto, String? url, int? harga) {
    print('controller passed');

    Database()
        .addInventaris(nama, kondisi, jumlah, inventarisID, foto, harga, url);
    Get.toNamed(RouteName.kelolamasjid);
  }

  InventarisModel get inventaris => _inventarisModel.value;

  set inventaris(InventarisModel value) => this._inventarisModel.value = value;

  void getInventaris(inventarisID) async {
    inventaris = await Database().getInventaris(inventarisID);
    // inventarisList.bindStream(Database().inventarisStream());
  }

  updateInventaris(String? nama, String? kondisi, int? jumlah,
      String? inventarisID, String? foto, int? harga) {
    print('controller passed');

    Database()
        .updateInventaris(nama, kondisi, jumlah, inventarisID, foto, harga);
    Get.toNamed(RouteName.kelolamasjid);
  }

  void clear() {
    _inventarisModel.value = InventarisModel();
  }

  @override
  void onInit() {
    inventarisList.bindStream(Database().inventarisStream());
  }
}
