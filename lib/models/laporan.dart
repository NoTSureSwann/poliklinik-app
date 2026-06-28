class Laporan {
  String? id;
  String judul;
  String isi;

  Laporan({
    this.id,
    required this.judul,
    required this.isi,
  });

  factory Laporan.fromJson(Map<String, dynamic> json) {
    return Laporan(
      id: json["id"],
      judul: json["judul"],
      isi: json["isi"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "judul": judul,
      "isi": isi,
    };
  }
}
