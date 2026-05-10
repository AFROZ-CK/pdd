class PredictionResult {
  final String id;
  final String modelName;
  final String targetVariable;
  final double predictedValue;
  final double confidence;
  final DateTime timestamp;
  final Map<String, double> featureImportances;
  final String status;

  PredictionResult({
    required this.id,
    required this.modelName,
    required this.targetVariable,
    required this.predictedValue,
    required this.confidence,
    required this.timestamp,
    required this.featureImportances,
    required this.status,
  });

  String get formattedValue {
    if (predictedValue < 1) return '${(predictedValue * 100).toStringAsFixed(1)}%';
    if (predictedValue >= 1000) return '\$${(predictedValue / 1000).toStringAsFixed(1)}K';
    return predictedValue.toStringAsFixed(0);
  }

  String get confidenceLabel {
    if (confidence >= 90) return 'High';
    if (confidence >= 75) return 'Medium';
    return 'Low';
  }
}
