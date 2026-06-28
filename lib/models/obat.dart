class Obat {
  String? id;
  String nama;
  String kategori;
  int stok;
  int harga;
  String? genericName;
  String? company;

  Obat({
    this.id,
    required this.nama,
    required this.kategori,
    required this.stok,
    required this.harga,
    this.genericName,
    this.company,
  });

  factory Obat.fromJson(Map<String, dynamic> json) {
    return Obat(
      id: json['id'],
      nama: json['nama'],
      kategori: json['kategori'],
      stok: json['stok'] != null ? int.tryParse(json['stok'].toString()) ?? 0 : 0,
      harga: json['harga'] != null ? int.tryParse(json['harga'].toString()) ?? 0 : 0,
      genericName: json['genericName'],
      company: json['company'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nama': nama,
      'kategori': kategori,
      'stok': stok,
      'harga': harga,
      'genericName': genericName,
      'company': company,
    };
  }
}
