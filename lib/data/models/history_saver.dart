import '../repositories/db_saver.dart';

abstract class HistorySaver {
  factory HistorySaver() => DbSaver();

  Future<bool> addToHistory(Map<String, Object> historyItem);
  Future<List<Map<String, Object?>>?> getHistory();
  Future<bool> removeFromHistory(String id);
}
