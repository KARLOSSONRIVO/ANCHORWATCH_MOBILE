/// Data quality model for analytics data validation
class DataQualityModel {
  final double overallScore;
  final double completenessScore;
  final double freshnessScore;
  final double consistencyScore;
  final double accuracyScore;
  final double dataAgeHours;
  final DateTime lastUpdated;
  final String qualityStatus;
  final bool hasIssues;
  final bool hasWarnings;
  final List<String> issues;
  final List<String> warnings;

  const DataQualityModel({
    required this.overallScore,
    required this.completenessScore,
    required this.freshnessScore,
    required this.consistencyScore,
    required this.accuracyScore,
    required this.dataAgeHours,
    required this.lastUpdated,
    required this.qualityStatus,
    required this.hasIssues,
    required this.hasWarnings,
    required this.issues,
    required this.warnings,
  });

  /// Create from JSON
  factory DataQualityModel.fromJson(Map<String, dynamic> json) {
    return DataQualityModel(
      overallScore: (json['overall_score'] as num?)?.toDouble() ?? 0.0,
      completenessScore: (json['completeness_score'] as num?)?.toDouble() ?? 0.0,
      freshnessScore: (json['freshness_score'] as num?)?.toDouble() ?? 0.0,
      consistencyScore: (json['consistency_score'] as num?)?.toDouble() ?? 0.0,
      accuracyScore: (json['accuracy_score'] as num?)?.toDouble() ?? 0.0,
      dataAgeHours: (json['data_age_hours'] as num?)?.toDouble() ?? 0.0,
      lastUpdated: DateTime.tryParse(json['last_updated'] as String? ?? '') ?? DateTime.now(),
      qualityStatus: json['quality_status'] as String? ?? 'unknown',
      hasIssues: json['has_issues'] as bool? ?? false,
      hasWarnings: json['has_warnings'] as bool? ?? false,
      issues: (json['issues'] as List<dynamic>?)?.cast<String>() ?? [],
      warnings: (json['warnings'] as List<dynamic>?)?.cast<String>() ?? [],
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'overall_score': overallScore,
      'completeness_score': completenessScore,
      'freshness_score': freshnessScore,
      'consistency_score': consistencyScore,
      'accuracy_score': accuracyScore,
      'data_age_hours': dataAgeHours,
      'last_updated': lastUpdated.toIso8601String(),
      'quality_status': qualityStatus,
      'has_issues': hasIssues,
      'has_warnings': hasWarnings,
      'issues': issues,
      'warnings': warnings,
    };
  }

  /// Get quality status color
  String get qualityStatusColor {
    switch (qualityStatus.toLowerCase()) {
      case 'excellent':
        return '#4CAF50'; // Green
      case 'good':
        return '#8BC34A'; // Light Green
      case 'fair':
        return '#FF9800'; // Orange
      case 'poor':
        return '#FF5722'; // Red
      case 'critical':
        return '#F44336'; // Dark Red
      default:
        return '#9E9E9E'; // Grey
    }
  }

  /// Get quality status icon
  String get qualityStatusIcon {
    switch (qualityStatus.toLowerCase()) {
      case 'excellent':
        return 'check_circle';
      case 'good':
        return 'check_circle_outline';
      case 'fair':
        return 'warning';
      case 'poor':
        return 'error_outline';
      case 'critical':
        return 'error';
      default:
        return 'help_outline';
    }
  }

  /// Check if data quality is acceptable for analysis
  bool get isAcceptableForAnalysis => overallScore >= 0.7;

  /// Check if data quality is excellent
  bool get isExcellent => overallScore >= 0.9;

  /// Get formatted data age
  String get formattedDataAge {
    if (dataAgeHours < 1) {
      return 'Just updated';
    } else if (dataAgeHours < 24) {
      return '${dataAgeHours.toStringAsFixed(1)} hours ago';
    } else {
      final days = (dataAgeHours / 24).floor();
      return '$days day${days == 1 ? '' : 's'} ago';
    }
  }

  /// Get quality recommendations
  List<String> get recommendations {
    final recommendations = <String>[];
    
    if (completenessScore < 0.9) {
      recommendations.add('Data completeness could be improved');
    }
    
    if (freshnessScore < 0.8) {
      recommendations.add('Data is getting stale - consider refreshing');
    }
    
    if (consistencyScore < 0.9) {
      recommendations.add('Data consistency issues detected');
    }
    
    if (accuracyScore < 0.9) {
      recommendations.add('Data accuracy concerns - verify sources');
    }
    
    if (overallScore < 0.8) {
      recommendations.add('Overall data quality needs improvement');
    }
    
    return recommendations;
  }

  /// Create a copy with updated fields
  DataQualityModel copyWith({
    double? overallScore,
    double? completenessScore,
    double? freshnessScore,
    double? consistencyScore,
    double? accuracyScore,
    double? dataAgeHours,
    DateTime? lastUpdated,
    String? qualityStatus,
    bool? hasIssues,
    bool? hasWarnings,
    List<String>? issues,
    List<String>? warnings,
  }) {
    return DataQualityModel(
      overallScore: overallScore ?? this.overallScore,
      completenessScore: completenessScore ?? this.completenessScore,
      freshnessScore: freshnessScore ?? this.freshnessScore,
      consistencyScore: consistencyScore ?? this.consistencyScore,
      accuracyScore: accuracyScore ?? this.accuracyScore,
      dataAgeHours: dataAgeHours ?? this.dataAgeHours,
      lastUpdated: lastUpdated ?? this.lastUpdated,
      qualityStatus: qualityStatus ?? this.qualityStatus,
      hasIssues: hasIssues ?? this.hasIssues,
      hasWarnings: hasWarnings ?? this.hasWarnings,
      issues: issues ?? this.issues,
      warnings: warnings ?? this.warnings,
    );
  }

  @override
  String toString() {
    return 'DataQualityModel(overallScore: $overallScore, qualityStatus: $qualityStatus, hasIssues: $hasIssues)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is DataQualityModel &&
        other.overallScore == overallScore &&
        other.qualityStatus == qualityStatus &&
        other.hasIssues == hasIssues;
  }

  @override
  int get hashCode {
    return overallScore.hashCode ^ qualityStatus.hashCode ^ hasIssues.hashCode;
  }
}
