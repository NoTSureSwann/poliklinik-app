class Laporan {
  String? id;

  String pasien;
  String dokter;
  String diagnosa;
  String tanggal;

  Laporan({
    this.id,
    required this.pasien,
    required this.dokter,
    required this.diagnosa,
    required this.tanggal,
  });

  factory Laporan.fromJson(Map<String, dynamic> json) {
    return Laporan(
      id: json["id"],
      pasien: json["pasien"],
      dokter: json["dokter"],
      diagnosa: json["diagnosa"],
      tanggal: json["tanggal"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "pasien": pasien,
      "dokter": dokter,
      "diagnosa": diagnosa,
      "tanggal": tanggal,
    };
  }
}
