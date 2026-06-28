import 'dart:convert';
import 'package:http/http.dart' as http;

void main() async {
  final url = Uri.parse('https://6a3bffdee4a07f202e164a7d.mockapi.io/api/v1/doctors');

  final List<String> poliklinik = [
    "Poli Umum", "Poli Gigi", "Poli Anak", "Poli Kandungan",
    "Poli Penyakit Dalam", "Poli Mata", "Poli THT", "Poli Saraf"
  ];

  List<Map<String, dynamic>> doctorsToSeed = [];
  
  int docId = 1;
  for (var poli in poliklinik) {
    for (int i = 1; i <= 2; i++) {
      doctorsToSeed.add({
        "nama": "Dr. Ahli $poli $i",
        "spesialis": poli,
        "str": "STR-${DateTime.now().year}-$docId",
        "jadwal": "Senin - Jumat, 08:00 - 15:00"
      });
      docId++;
    }
  }

  print('Memulai injeksi 16 dokter...');
  
  for (var doc in doctorsToSeed) {
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(doc),
    );
    print('Inserted ${doc["nama"]} | Spesialis: ${doc["spesialis"]} -> Status: ${response.statusCode}');
  }
  
  print('Selesai!');
}
