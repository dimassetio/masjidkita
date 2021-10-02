import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mosq/modules/kas/buku/models/kas_model.dart';
import 'package:mosq/modules/kas/periode/periode_database.dart';

class PeriodeModel {
  String? id;
  DateTime? tanggalAwal;
  DateTime? tanggalAkhir;
  int? saldoAwal;
  int? saldoAkhir;
  PeriodeDatabase? dao;

  PeriodeModel(
      {this.id,
      this.tanggalAwal,
      this.tanggalAkhir,
      this.saldoAwal,
      this.saldoAkhir,
      this.dao});

  save() async {
    if (this.id == null) {
      return await this.dao!.store(this);
    } else {
      return await this.dao!.update(this);
    }
  }

  delete() async {
    return await this.dao!.delete(this);
  }

  PeriodeModel fromKas(KasModel kas) {
    return PeriodeModel(
      tanggalAwal: kas.tanggalAwal,
      tanggalAkhir: kas.tanggalAkhir,
      saldoAwal: kas.saldo,
    );
  }

  PeriodeModel fromSnapshot(DocumentSnapshot snapshot, PeriodeDatabase? dao) {
    return PeriodeModel(
      id: snapshot.id,
      tanggalAwal: snapshot.data()?["tanggalAwal"],
      tanggalAkhir: snapshot.data()?["tanggalAkhir"],
      saldoAwal: snapshot.data()?["saldoAwal"],
      saldoAkhir: snapshot.data()?["saldoAkhir"],
      dao: dao,
    );
  }

  Map<String, dynamic> toSnapshot() {
    return {
      'id': this.id,
      'tanggalAwal': this.tanggalAwal,
      'tanggalAkhir': this.tanggalAkhir,
      'saldoAwal': this.saldoAwal,
      'saldoAkhir': this.saldoAkhir,
    };
  }
}
