class Dokter {
  String? id;
  String nama;
  String spesialis;
  String str;
  String jadwal;
  int? biaya;
  String? hospitalName;
  String? clinicName;
  double? rating;
  int? reviewsCount;
  String? biography;
  String? education;

  Dokter({
    this.id,
    required this.nama,
    required this.spesialis,
    required this.str,
    required this.jadwal,
    this.biaya,
    this.hospitalName,
    this.clinicName,
    this.rating,
    this.reviewsCount,
    this.biography,
    this.education,
  });

  factory Dokter.fromJson(Map<String, dynamic> json) {
    return Dokter(
      id: json["id"],
      nama: json["nama"],
      spesialis: json["spesialis"],
      str: json["str"],
      jadwal: json["jadwal"],
      biaya: json["biaya"],
      hospitalName: json["hospitalName"],
      clinicName: json["clinicName"],
      rating: json["rating"]?.toDouble(),
      reviewsCount: json["reviewsCount"],
      biography: json["biography"],
      education: json["education"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "nama": nama,
      "spesialis": spesialis,
      "str": str,
      "jadwal": jadwal,
      "biaya": biaya,
      "hospitalName": hospitalName,
      "clinicName": clinicName,
      "rating": rating,
      "reviewsCount": reviewsCount,
      "biography": biography,
      "education": education,
    };
  }
}
