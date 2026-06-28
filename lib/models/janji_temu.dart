class JanjiTemu {
  String? id;

  String pasienId;
  String dokterId;
  String tanggal;
  String jam;
  String status;
  String? gejala;
  String? poliId;
  int? biayaJasa;
  bool isPaid;
  int? queueNumber;
  String? appointmentNumber;

  JanjiTemu({
    this.id,
    required this.pasienId,
    required this.dokterId,
    required this.tanggal,
    required this.jam,
    this.status = 'Pending',
    this.gejala,
    this.poliId,
    this.biayaJasa,
    this.isPaid = false,
    this.queueNumber,
    this.appointmentNumber,
  });

  factory JanjiTemu.fromJson(Map<String, dynamic> json) {
    return JanjiTemu(
      id: json["id"],
      pasienId: json["pasienId"],
      dokterId: json["dokterId"],
      tanggal: json["tanggal"],
      jam: json["jam"],
      status: json["status"] ?? 'Pending',
      gejala: json["gejala"],
      poliId: json["poliId"],
      biayaJasa: json["biayaJasa"],
      isPaid: json["isPaid"] ?? false,
      queueNumber: json["queueNumber"],
      appointmentNumber: json["appointmentNumber"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "pasienId": pasienId,
      "dokterId": dokterId,
      "tanggal": tanggal,
      "jam": jam,
      "status": status,
      "gejala": gejala,
      "poliId": poliId,
      "biayaJasa": biayaJasa,
      "isPaid": isPaid,
      "queueNumber": queueNumber,
      "appointmentNumber": appointmentNumber,
    };
  }
}
