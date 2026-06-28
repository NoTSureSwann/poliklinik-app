class Poli {
  String id;
  String nama;
  String deskripsi;

  Poli({
    required this.id,
    required this.nama,
    required this.deskripsi,
  });

  factory Poli.fromJson(Map<String, dynamic> json) {
    return Poli(
      id: json['id'],
      nama: json['nama'],
      deskripsi: json['deskripsi'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nama': nama,
      'deskripsi': deskripsi,
    };
  }
}
