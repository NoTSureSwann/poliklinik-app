class Pasien {
  String? id;
  String nama;
  String alamat;
  String telepon;
  bool hasFoto;

  Pasien({
    this.id,
    required this.nama,
    required this.alamat,
    required this.telepon,
    this.hasFoto = false,
  });

  factory Pasien.fromJson(Map<String, dynamic> json) {
    return Pasien(
      id: json["id"],
      nama: json["nama"],
      alamat: json["alamat"],
      telepon: json["telepon"],
      hasFoto: json["hasFoto"] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "nama": nama,
      "alamat": alamat,
      "telepon": telepon,
      "hasFoto": hasFoto,
    };
  }
}
