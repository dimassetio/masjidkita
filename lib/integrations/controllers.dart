import 'package:mosq/controllers/appController.dart';
import 'package:mosq/controllers/authController.dart';
import 'package:mosq/modules/inventaris/controllers/inventarisController.dart';
import 'package:mosq/modules/kegiatan/controllers/kegiatan_controller.dart';
import 'package:mosq/modules/masjid/controllers/masjid_controller.dart';
import 'package:mosq/modules/profile/controllers/profile_controller.dart';
import 'package:mosq/modules/takmir/controllers/takmir_controller.dart';

AppController appController = AppController.instance;
AuthController authController = AuthController.instance;
// ManMasjidController masjidC = ManMasjidController.instance;
MasjidController masjidC = MasjidController.instance;
InventarisController inventarisC = InventarisController.instance;
KegiatanController kegiatanC = KegiatanController.instance;
TakmirController takmirC = TakmirController.instance;
ProfilController profilC = ProfilController.instance;
