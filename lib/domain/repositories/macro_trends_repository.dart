import '../entities/macro_trends.dart';

abstract class MacroTrendsRepository {
  Future<MacroTrendsData> getMacroTrendsData({
    required String aggregationPeriod,
  });
}