import 'package:poliklinik/models/janji_temu.dart';
import 'package:poliklinik/repositories/appointment_repository.dart';
import 'package:poliklinik/api/api_result.dart';

class QueueManager {
  final AppointmentQueryHandler _queryHandler;
  
  QueueManager(this._queryHandler);

  Future<int> getNextQueueNumber() async {
    final result = await _queryHandler.handle(GetAppointmentsQuery());
    
    if (result is ApiSuccess<List<JanjiTemu>>) {
      final appointments = result.data;
      if (appointments.isEmpty) return 1;

      // Find the highest queue number in the database
      int maxQueue = 0;
      for (var appt in appointments) {
        if (appt.queueNumber != null && appt.queueNumber! > maxQueue) {
          maxQueue = appt.queueNumber!;
        }
      }
      return maxQueue + 1;
    } else {
      // If fetching fails, we default to 1 or we could throw an exception
      return 1;
    }
  }

  String generateAppointmentNumber(int queueNumber) {
    final now = DateTime.now();
    final dateStr = '${now.year}${now.month.toString().padLeft(2, '0')}${now.day.toString().padLeft(2, '0')}';
    final queueStr = queueNumber.toString().padLeft(3, '0');
    return 'APT-$dateStr-$queueStr';
  }
}
