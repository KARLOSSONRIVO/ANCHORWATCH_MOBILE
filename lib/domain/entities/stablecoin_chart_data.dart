class StablecoinChartData {
  final List<SupplyDataPoint> totalSupplyOverTime;
  final List<MintBurnActivity> mintBurnActivity;
  final List<NetChangeData> netChangeInSupply;
  final List<LargestMintBurnEvent> largestMintBurnEvents;
  final List<RollingAverageSupplyChange> rollingAverageSupplyChanges;

  StablecoinChartData({
    required this.totalSupplyOverTime,
    required this.mintBurnActivity,
    required this.netChangeInSupply,
    required this.largestMintBurnEvents,
    required this.rollingAverageSupplyChanges,
  });
}

class SupplyDataPoint {
  final DateTime date;
  final double supplyClosing;
  final double? price; // Price data from API

  SupplyDataPoint({
    required this.date,
    required this.supplyClosing,
    this.price,
  });
}

class MintBurnActivity {
  final DateTime date;
  final double mintUsd;
  final double burnUsd;

  MintBurnActivity({
    required this.date,
    required this.mintUsd,
    required this.burnUsd,
  });

  double get netChange => mintUsd - burnUsd;
}

class NetChangeData {
  final DateTime date;
  final double netChangeUsd;

  NetChangeData({
    required this.date,
    required this.netChangeUsd,
  });
}

class LargestMintBurnEvent {
  final DateTime date;
  final double largestMintUsd;
  final double largestBurnUsd;
  final double marketCap;

  LargestMintBurnEvent({
    required this.date,
    required this.largestMintUsd,
    required this.largestBurnUsd,
    required this.marketCap,
  });
}

class RollingAverageSupplyChange {
  final DateTime date;
  final double? shortTermAvg;
  final double? longTermAvg;

  RollingAverageSupplyChange({
    required this.date,
    this.shortTermAvg,
    this.longTermAvg,
  });
}