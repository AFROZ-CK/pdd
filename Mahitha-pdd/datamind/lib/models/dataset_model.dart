class DatasetModel {
  final String id;
  final String name;
  final String description;
  final int rowCount;
  final int columnCount;
  final double missingPercentage;
  final double qualityScore;
  final DateTime uploadDate;
  final String fileSize;
  final String type;
  final List<String> columns;
  final List<String> tags;

  DatasetModel({
    required this.id,
    required this.name,
    required this.description,
    required this.rowCount,
    required this.columnCount,
    required this.missingPercentage,
    required this.qualityScore,
    required this.uploadDate,
    required this.fileSize,
    required this.type,
    required this.columns,
    required this.tags,
  });

  String get formattedRowCount {
    if (rowCount >= 1000000) return '${(rowCount / 1000000).toStringAsFixed(1)}M';
    if (rowCount >= 1000) return '${(rowCount / 1000).toStringAsFixed(1)}K';
    return rowCount.toString();
  }

  String get qualityLabel {
    if (qualityScore >= 90) return 'Excellent';
    if (qualityScore >= 75) return 'Good';
    if (qualityScore >= 60) return 'Fair';
    return 'Poor';
  }
}
