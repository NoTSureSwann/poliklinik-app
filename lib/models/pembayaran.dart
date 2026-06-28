class Pembayaran {
  String? id;
  String rekamId;
  String pasienNama;
  int biayaDokter;
  int biayaObat;
  int totalBiaya;
  String statusValidasi;

  Pembayaran({
    this.id,
    required this.rekamId,
    required this.pasienNama,
    required this.biayaDokter,
    required this.biayaObat,
    required this.totalBiaya,
    this.statusValidasi = 'Belum Lunas',
  });

  factory Pembayaran.fromJson(Map<String, dynamic> json) {
    return Pembayaran(
      id: json['id'],
      rekamId: json['rekamId'],
      pasienNama: json['pasienNama'],
      biayaDokter: json['biayaDokter'] != null ? int.tryParse(json['biayaDokter'].toString()) ?? 0 : 0,
      biayaObat: json['biayaObat'] != null ? int.tryParse(json['biayaObat'].toString()) ?? 0 : 0,
      totalBiaya: json['totalBiaya'] != null ? int.tryParse(json['totalBiaya'].toString()) ?? 0 : 0,
      statusValidasi: json['statusValidasi'] ?? 'Belum Lunas',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'rekamId': rekamId,
      'pasienNama': pasienNama,
      'biayaDokter': biayaDokter,
      'biayaObat': biayaObat,
      'totalBiaya': totalBiaya,
      'statusValidasi': statusValidasi,
    };
  }
}
