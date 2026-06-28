import 'package:poliklinik/config/api_config.dart';
import 'package:poliklinik/models/obat.dart';
import 'api_service.dart';

class ObatService {
  final ApiService _api = ApiService();

  Future<List<Obat>> getObat() async {
    final data = await _api.getAll(ApiConfig.obat);
    return data.map<Obat>((e) => Obat.fromJson(e)).toList();
  }

  Future<void> addObat(Obat obat) async {
    await _api.post(ApiConfig.obat, obat.toJson());
  }

  Future<void> updateObat(Obat obat) async {
    await _api.put("${ApiConfig.obat}/${obat.id}", obat.toJson());
  }

  Future<void> deleteObat(String id) async {
    await _api.delete("${ApiConfig.obat}/$id");
  }
}
