class ApiConfig {
  static const String baseUrl1 = "https://6a3bfde1e4a07f202e164805.mockapi.io/api/v1";
  static const String baseUrl2 = "https://6a3bffdee4a07f202e164a7d.mockapi.io/api/v1";
  static const String baseUrl3 = "https://6a3c0117e4a07f202e164c6b.mockapi.io/api/v1";
  static const String baseUrl4 = "https://6a3c14b0e4a07f202e1669ce.mockapi.io/api/v1";
  
  static const int connectionTimeout = 10000;
  static const int receiveTimeout = 10000;
  
  static String get pembayaran => "$baseUrl3/pembayaran";
  static String get medicalRecords => "$baseUrl2/rekam_medis";
  static String get patients => "$baseUrl1/pasien";
  static String get doctors => "$baseUrl1/dokter";
  static String get appointments => "$baseUrl1/janji";
  static String get schedules => "$baseUrl2/jadwal";
  static String get medicines => "$baseUrl2/obat";
  static String get obat => "$baseUrl2/obat";
  static String get users => "$baseUrl3/users";
  static String get polis => "$baseUrl3/poli";
  static String get reports => "$baseUrl4/laporan";
  static String get dashboards => "$baseUrl4/dashboard";
}
