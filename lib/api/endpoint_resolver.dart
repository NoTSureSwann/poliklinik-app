import 'package:poliklinik/config/api_config.dart';

enum ApiModule {
  users,
  patients,
  doctors,
  appointments,
  medicalRecords,
  reports,
  obat,
  pembayaran,
  polis,
  notifications
}

class EndpointResolver {
  static String resolve(ApiModule module) {
    switch (module) {
      case ApiModule.users:
        return '${ApiConfig.baseUrl1}/users';
      case ApiModule.patients:
        return '${ApiConfig.baseUrl1}/patients';
      case ApiModule.doctors:
        return '${ApiConfig.baseUrl2}/doctors';
      case ApiModule.appointments:
        return '${ApiConfig.baseUrl2}/appointments';
      case ApiModule.medicalRecords:
        return '${ApiConfig.baseUrl3}/medical_records';
      case ApiModule.reports:
        return '${ApiConfig.baseUrl3}/reports';
      case ApiModule.obat:
        return '${ApiConfig.baseUrl4}/obat';
      case ApiModule.pembayaran:
        return '${ApiConfig.baseUrl4}/pembayaran';
      case ApiModule.polis:
        return '${ApiConfig.baseUrl1}/polis'; // Adjust if polis is elsewhere
      case ApiModule.notifications:
        return '${ApiConfig.baseUrl1}/notifications';
    }
  }
}
