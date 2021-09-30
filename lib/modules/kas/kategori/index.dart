import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mosq/helpers/formatter.dart';
import 'package:mosq/integrations/controllers.dart';
import 'package:mosq/main.dart';
import 'package:mosq/main/utils/AppWidget.dart';
import 'package:mosq/modules/kas/kategori/kategori_model.dart';
import 'package:mosq/modules/masjid/models/masjid_model.dart';
import 'package:mosq/routes/route_name.dart';
import 'package:mosq/screens/fitur/Kelola_Masjid/Dialog/DeleteDialog.dart';
import 'package:mosq/screens/fitur/Kelola_Masjid/Dialog/confirm_leave_dialog.dart';
import 'package:mosq/screens/utils/MKColors.dart';
import 'package:mosq/screens/utils/MKConstant.dart';
import 'package:mosq/screens/utils/MKStrings.dart';
import 'package:mosq/screens/utils/MKWidget.dart';
import 'package:mosq/screens/widgets/DismissibleBackground.dart';
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
                                return KategoriCard(
                                  model: kategoriC.kategories[index],
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

// ignore: must_be_immutable
class KategoriCard extends StatelessWidget {
  KategoriCard({required this.model});
  KategoriModel model;

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(model.id!),
      direction: masjidC.myMasjid.value
          ? DismissDirection.horizontal
          : DismissDirection.none,
      background: slideRightBackground(),
      secondaryBackground: slideLeftBackground(),
      confirmDismiss: (direction) async {
        if (direction == DismissDirection.startToEnd) {
          Get.toNamed(RouteName.edit_kategori, arguments: model);
          return false;
        } else if (direction == DismissDirection.endToStart) {
          // toast("Delete data");
          return await showDialog(
              context: context,
              builder: (BuildContext context) => CustomDelete(
                    titleName: 'Kategori',
                    subtitleName: model.nama ?? "",
                  ));
        }
      },
      onDismissed: (direction) async {
        try {
          kategoriC.deleteKategori(model);
        } catch (e) {
          toast('Error Delete Data');
          rethrow;
        }
      },
      child: Column(
        children: [
          ListTile(
            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            leading: TipeTransaksiIcon(tipeTransaksi: model.jenis!),
            title: text(model.nama ?? "Nama Kategori"),
            subtitle: text(tipeTransaksiToStr(model.jenis),
                fontSize: textSizeSMedium),
          ),
          Divider(
            color: mk_view_color,
            height: 1,
          )
        ],
      ),
    );
  }
}
