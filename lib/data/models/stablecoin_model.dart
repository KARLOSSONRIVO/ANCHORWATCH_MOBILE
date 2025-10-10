class StablecoinChartDataModel {
  final List<SupplyDataPointModel> totalSupplyOverTime;
  final List<MintBurnActivityModel> mintBurnActivity;
  final List<NetChangeDataModel> netChangeInSupply;
  final List<LargestMintBurnEventModel> largestMintBurnEvents;
  final List<RollingAverageSupplyChangeModel> rollingAverageSupplyChanges;

  StablecoinChartDataModel({
    required this.totalSupplyOverTime,
    required this.mintBurnActivity,
    required this.netChangeInSupply,
    required this.largestMintBurnEvents,
    required this.rollingAverageSupplyChanges,
  });

  factory StablecoinChartDataModel.fromJson(Map<String, dynamic> json) {
    return StablecoinChartDataModel(
      totalSupplyOverTime: (json['total_supply_over_time'] as List<dynamic>?)
              ?.map((e) => SupplyDataPointModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      mintBurnActivity: (json['mint_burn_activity'] as List<dynamic>?)
              ?.map((e) => MintBurnActivityModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      netChangeInSupply: (json['net_change_in_supply'] as List<dynamic>?)
              ?.map((e) => NetChangeDataModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      largestMintBurnEvents: (json['largest_mint_burn_events'] as List<dynamic>?)
              ?.map((e) => LargestMintBurnEventModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      rollingAverageSupplyChanges: (json['rolling_average_supply_changes'] as List<dynamic>?)
              ?.map((e) => RollingAverageSupplyChangeModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
}

class SupplyDataPointModel {
  final String date;
  final double supplyClosing;

  SupplyDataPointModel({
    required this.date,
    required this.supplyClosing,
  });

  factory SupplyDataPointModel.fromJson(Map<String, dynamic> json) {
    return SupplyDataPointModel(
      date: json['date'] as String,
      supplyClosing: (json['supply_closing'] as num).toDouble(),
    );
  }

  DateTime get dateTime => DateTime.parse(date);
}

class MintBurnActivityModel {
  final String date;
  final double mintUsd;
  final double burnUsd;

  MintBurnActivityModel({
    required this.date,
    required this.mintUsd,
    required this.burnUsd,
  });

  factory MintBurnActivityModel.fromJson(Map<String, dynamic> json) {
    return MintBurnActivityModel(
      date: json['date'] as String,
      mintUsd: (json['mint_usd'] as num).toDouble(),
      burnUsd: (json['burn_usd'] as num).toDouble(),
    );
  }

  DateTime get dateTime => DateTime.parse(date);
  double get netChange => mintUsd - burnUsd;
}

class NetChangeDataModel {
  final String date;
  final double netChangeUsd;

  NetChangeDataModel({
    required this.date,
    required this.netChangeUsd,
  });

  factory NetChangeDataModel.fromJson(Map<String, dynamic> json) {
    return NetChangeDataModel(
      date: json['date'] as String,
      netChangeUsd: (json['net_change_usd'] as num).toDouble(),
    );
  }

  DateTime get dateTime => DateTime.parse(date);
}

class LargestMintBurnEventModel {
  final String date;
  final double largestMintUsd;
  final double largestBurnUsd;
  final double marketCap;

  LargestMintBurnEventModel({
    required this.date,
    required this.largestMintUsd,
    required this.largestBurnUsd,
    required this.marketCap,
  });

  factory LargestMintBurnEventModel.fromJson(Map<String, dynamic> json) {
    return LargestMintBurnEventModel(
      date: json['date'] as String,
      largestMintUsd: (json['Largest Mint (USD)'] as num).toDouble(),
      largestBurnUsd: (json['Largest Burn (USD)'] as num).toDouble(),
      marketCap: (json['market_cap'] as num).toDouble(),
    );
  }

  DateTime get dateTime => DateTime.parse(date);
}

class RollingAverageSupplyChangeModel {
  final String date;
  final double? shortTermAvg;
  final double? longTermAvg;

  RollingAverageSupplyChangeModel({
    required this.date,
    this.shortTermAvg,
    this.longTermAvg,
  });

  factory RollingAverageSupplyChangeModel.fromJson(Map<String, dynamic> json) {
    return RollingAverageSupplyChangeModel(
      date: json['date'] as String,
      shortTermAvg: json['short_term_avg'] != null 
          ? (json['short_term_avg'] as num).toDouble() 
          : null,
      longTermAvg: json['long_term_avg'] != null 
          ? (json['long_term_avg'] as num).toDouble() 
          : null,
    );
  }

  DateTime get dateTime => DateTime.parse(date);
}