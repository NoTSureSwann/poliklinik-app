import 'dart:async';
import 'package:flutter/foundation.dart';
import '../cqrs/query/appointment_query.dart';
import '../cqrs/command/appointment_command.dart';
import '../cqrs/query/doctor_query.dart';
import '../cqrs/query/patient_query.dart';
import '../cqrs/query/dashboard_query.dart';
import '../models/janji_temu.dart';
import '../models/dokter.dart';
import '../models/pasien.dart';
import '../models/rekam_medis.dart';
import '../models/pembayaran.dart';
import '../models/obat.dart';
import '../models/poli.dart';
import '../api/api_result.dart';

class DataProvider extends ChangeNotifier {
  final AppointmentQueryHandler _appointmentQuery;
  final AppointmentCommandHandler _appointmentCommand;
  final DoctorQueryHandler _doctorQuery;
  final PatientQueryHandler _patientQuery;
  final DashboardQueryHandler _dashboardQuery;

  List<JanjiTemu> _appointments = [];
  List<Dokter> _doctors = [];
  List<Pasien> _patients = [];
  Map<String, dynamic> _dashboardStats = {};
  
  // Legacy / Missing models arrays to satisfy UI compilation
  List<dynamic> _rekamList = [];
  List<Pembayaran> _pembayaranList = [];
  List<Obat> _obatList = [];
  List<Poli> _poliList = [];

  bool _isLoading = false;
  String? _error;
  
  Timer? _pollingTimer;
  bool _isPolling = false;

  DataProvider(
    this._appointmentQuery,
    this._appointmentCommand,
    this._doctorQuery,
    this._patientQuery,
    this._dashboardQuery,
  );

  List<JanjiTemu> get appointments => _appointments;
  List<Dokter> get doctors => _doctors;
  List<Pasien> get patients => _patients;
  Map<String, dynamic> get dashboardStats => _dashboardStats;
  
  List<dynamic> get rekamList => _rekamList;
  List<Pembayaran> get pembayaranList => _pembayaranList;
  List<Obat> get obatList => _obatList;
  List<Poli> get poliList => _poliList;
  List<Poli> get polis => _poliList; // For poli_page compatibility

  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchAllData() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    await Future.wait([
      fetchDoctors(silent: true),
      fetchPatients(silent: true),
      fetchAppointments(silent: true),
      fetchDashboardStats(silent: true),
    ]);

    _isLoading = false;
    notifyListeners();
  }

  Future<void> fetchDoctors({bool silent = false}) async {
    final result = await _doctorQuery.getDoctors();
    if (result is ApiSuccess<List<Dokter>>) {
      if (_doctors.toString() != result.data.toString()) {
        _doctors = result.data;
        if (!silent) notifyListeners();
      }
    }
  }

  Future<void> fetchPatients({bool silent = false}) async {
    final result = await _patientQuery.getPatients();
    if (result is ApiSuccess<List<Pasien>>) {
      if (_patients.toString() != result.data.toString()) {
        _patients = result.data;
        if (!silent) notifyListeners();
      }
    }
  }

  Future<void> fetchDashboardStats({bool silent = false}) async {
    final result = await _dashboardQuery.getDashboardStatistics();
    if (result is ApiSuccess<Map<String, dynamic>>) {
      if (_dashboardStats.toString() != result.data.toString()) {
        _dashboardStats = result.data;
        if (!silent) notifyListeners();
      }
    }
  }

  Future<void> fetchAppointments({bool silent = false}) async {
    final result = await _appointmentQuery.getAppointments();
    if (result is ApiSuccess<List<JanjiTemu>>) {
      if (_hasAppointmentsChanged(result.data)) {
        _appointments = result.data;
        if (!silent) notifyListeners();
      }
    }
  }

  bool _hasAppointmentsChanged(List<JanjiTemu> newData) {
    if (_appointments.length != newData.length) return true;
    return _appointments.toString() != newData.toString();
  }

  // Polling logic untuk mock api / real-time fallback
  void startPolling() {
    if (_isPolling) return;
    _isPolling = true;
    // Polling setiap 3 detik untuk simulasi real-time dari mock api
    _pollingTimer = Timer.periodic(const Duration(seconds: 3), (timer) async {
      await fetchDoctors();
      await fetchPatients();
      await fetchAppointments();
      await fetchDashboardStats();
      await fetchRekam();
      await fetchObat();
    });
  }

  void stopPolling() {
    _pollingTimer?.cancel();
    _pollingTimer = null;
    _isPolling = false;
  }

  // CRUD
  Future<bool> createAppointment(Map<String, dynamic> data) async {
    final result = await _appointmentCommand.createAppointment(data);
    if (result is ApiSuccess<JanjiTemu>) {
      await fetchAppointments(); 
      return true;
    }
    return false;
  }

  Future<bool> updateAppointment(String id, Map<String, dynamic> data) async {
    final result = await _appointmentCommand.updateAppointment(id, data);
    if (result is ApiSuccess<JanjiTemu>) {
      await fetchAppointments();
      return true;
    }
    return false;
  }

  Future<bool> deleteAppointment(String id) async {
    final result = await _appointmentCommand.deleteAppointment(id);
    if (result is ApiSuccess) {
      await fetchAppointments();
      return true;
    }
    return false;
  }

  // Stubs to fix UI compilation
  Future<void> fetchRekam() async {}
  Future<void> deleteRekam(String id) async {}
  Future<void> updateRekam(dynamic rekam) async {}
  Future<void> addRekam(dynamic rekam) async {}
  
  Future<void> fetchPembayaran() async {}
  Future<void> updatePembayaran(dynamic pembayaran) async {}
  
  Future<void> fetchObat() async {}
  Future<void> addObat(dynamic obat) async {}
  Future<void> deleteObat(String id) async {}
  
  Future<void> fetchPolis() async {}
  Future<void> deletePoli(String id) async {}
  Future<void> addPoli(dynamic poli) async {}
  
  Future<void> deletePasien(String id) async {}
  Future<void> addPasien(dynamic pasien) async {}
  Future<void> updatePasien(dynamic pasien) async {}
  
  Future<void> updateJanji(dynamic janji) async {}
  Future<void> addJanji(dynamic janji) async {}
  Future<void> deleteJanji(String id) async {}
  
  Future<void> updateDokter(dynamic dokter) async {}
  Future<void> deleteDokter(String id) async {}
  Future<void> addDokter(dynamic dokter) async {}

  String? get errorMessage => _error;

  @override
  void dispose() {
    stopPolling();
    super.dispose();
  }
}
