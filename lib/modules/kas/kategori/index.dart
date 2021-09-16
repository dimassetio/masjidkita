import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mosq/integrations/controllers.dart';
import 'package:mosq/main.dart';
import 'package:mosq/main/utils/AppWidget.dart';
import 'package:mosq/modules/kas/kategori/kategori_model.dart';
import 'package:mosq/modules/masjid/models/masjid_model.dart';
import 'package:mosq/routes/route_name.dart';
import 'package:mosq/screens/fitur/Kelola_Masjid/Dialog/confirm_leave_dialog.dart';
import 'package:mosq/screens/utils/MKColors.dart';
import 'package:mosq/screens/utils/MKConstant.dart';
import 'package:mosq/screens/utils/MKStrings.dart';
import 'package:nb_utils/nb_utils.dart';

class KategoriIndex extends StatelessWidget {
  MasjidModel model = Get.arguments ?? MasjidModel();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: appStore.appBarColor,
        leading: BackButton(),
        title: appBarTitleWidget(context, 'Kategori Transaksi'),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            physics: ScrollPhysics(),
            child: Container(
              child: GestureDetector(
                onTap: () {
                  FocusScopeNode currentFocus = FocusScope.of(context);

                  if (!currentFocus.hasPrimaryFocus) {
                    currentFocus.unfocus();
                  }
                },
                child: Column(
                  children: [
                    Obx(
                      () => kategoriC.kategories.isEmpty
                          ? Center(
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 16),
                                child: text(
                                    'Masjid ini belum memiliki kategori transaksi',
                                    isLongText: true,
                                    isCentered: true),
                              ),
                            )
                          : ListView.builder(
                              padding: EdgeInsets.symmetric(),
                              scrollDirection: Axis.vertical,
                              itemCount: kategoriC.kategories.length,
                              shrinkWrap: true,
                              physics: ScrollPhysics(),
                              itemBuilder: (context, index) {
                                return ListTile(
                                  onTap: () {
                                    toast('value');
                                  },
                                  contentPadding: EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 12),
                                  leading: CircleAvatar(
                                    backgroundColor:
                                        kategoriC.kategories[index].jenis ==
                                                'pemasukan'
                                            ? Colors.green.withOpacity(0.5)
                                            : Colors.red.withOpacity(0.5),
                                    child: Icon(
                                      kategoriC.kategories[index].jenis ==
                                              'pemasukan'
                                          ? Icons.arrow_downward
                                          : Icons.arrow_upward,
                                      color:
                                          kategoriC.kategories[index].jenis ==
                                                  'pemasukan'
                                              ? Colors.green
                                              : Colors.red,
                                    ),
                                  ),
                                  title: text(
                                      kategoriC.kategories[index].nama ??
                                          "Nama Kategori"),
                                  subtitle: text(
                                      kategoriC.kategories[index].jenis ??
                                          "Nama Kategori"),
                                );
                              },
                            ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Container(
              alignment: Alignment.bottomRight,
              padding: EdgeInsets.only(right: 15, bottom: 15),
              child: Obx(() => masjidC.myMasjid.value
                  ? FloatingActionButton(
                      onPressed: () {
                        Get.toNamed(RouteName.new_kategori,
                            arguments: KategoriModel(dao: model.kategoriDao));
                      },
                      child: Icon(
                        Icons.edit,
                        color: mkWhite,
                      ),
                      backgroundColor: mkColorPrimary,
                    )
                  : SizedBox())),
        ],
      ),
    );
  }
}
