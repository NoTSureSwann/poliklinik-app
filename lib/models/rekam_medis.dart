class RekamMedis {
  String? id;

  String pasienId;
  String dokterId;
  String keluhan;
  String diagnosa;
  String tindakan;
  String obat;
  String catatanDokter;
  String tanggal;
  String statusFlow;

  RekamMedis({
    this.id,
    required this.pasienId,
    required this.dokterId,
    required this.keluhan,
    required this.diagnosa,
    required this.tindakan,
    required this.obat,
    required this.catatanDokter,
    required this.tanggal,
    this.statusFlow = 'Menunggu Dokter',
  });

  factory RekamMedis.fromJson(Map<String, dynamic> json) {
    return RekamMedis(
      id: json["id"],
      pasienId: json["pasienId"],
      dokterId: json["dokterId"],
      keluhan: json["keluhan"],
      diagnosa: json["diagnosa"],
      tindakan: json["tindakan"],
      obat: json["obat"] ?? '',
      catatanDokter: json["catatanDokter"] ?? '',
      tanggal: json["tanggal"] ?? '',
      statusFlow: json["statusFlow"] ?? 'Menunggu Dokter',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "pasienId": pasienId,
      "dokterId": dokterId,
      "keluhan": keluhan,
      "diagnosa": diagnosa,
      "tindakan": tindakan,
      "obat": obat,
      "catatanDokter": catatanDokter,
      "tanggal": tanggal,
      "statusFlow": statusFlow,
    };
  }
}
