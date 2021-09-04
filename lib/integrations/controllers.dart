import 'package:mosq/controllers/appController.dart';
import 'package:mosq/controllers/authController.dart';
import 'package:mosq/modules/inventaris/controllers/inventaris_controller.dart';
import 'package:mosq/controllers/kegiatanController.dart';
import 'package:mosq/modules/kas/controllers/kas_controller.dart';
import 'package:mosq/modules/masjid/controllers/masjid_controller.dart';
import 'package:mosq/modules/takmir/controllers/takmir_controller.dart';

AppController appController = AppController.instance;
AuthController authController = AuthController.instance;
// ManMasjidController masjidC = ManMasjidController.instance;
MasjidController masjidC = MasjidController.instance;
InventarisController inventarisC = InventarisController.instance;
KegiatanController kegiatanC = KegiatanController.instance;
TakmirController takmirC = TakmirController.instance;
KasController kasC = KasController.instance;
