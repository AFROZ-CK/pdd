import 'package:flutter/material.dart';
import 'dart:math';
import '../models/dataset_model.dart';

class DataProvider extends ChangeNotifier {
  List<DatasetModel> _datasets = [];
  DatasetModel? _selectedDataset;
  bool _isLoading = false;

  List<DatasetModel> get datasets => _datasets;
  DatasetModel? get selectedDataset => _selectedDataset;
  bool get isLoading => _isLoading;

  DataProvider() {
    _initSampleData();
  }

  void _initSampleData() {
    _datasets = [
      DatasetModel(
        id: 'ds001',
        name: 'Sales Performance 2024',
        description: 'Monthly sales data across all regions',
        rowCount: 12450,
        columnCount: 18,
        missingPercentage: 4.2,
        qualityScore: 87.3,
        uploadDate: DateTime.now().subtract(const Duration(days: 5)),
        fileSize: '2.4 MB',
        type: 'CSV',
        columns: ['date', 'region', 'product', 'sales', 'revenue', 'cost', 'profit'],
        tags: ['sales', 'finance', 'regional'],
      ),
      DatasetModel(
        id: 'ds002',
        name: 'Customer Behavior Analysis',
        description: 'User interaction and purchase patterns',
        rowCount: 85000,
        columnCount: 24,
        missingPercentage: 8.7,
        qualityScore: 76.5,
        uploadDate: DateTime.now().subtract(const Duration(days: 12)),
        fileSize: '15.2 MB',
        type: 'JSON',
        columns: ['user_id', 'session_duration', 'pages_visited', 'purchase', 'churn'],
        tags: ['customer', 'behavior', 'churn'],
      ),
      DatasetModel(
        id: 'ds003',
        name: 'IoT Sensor Streams',
        description: 'Real-time sensor readings from production floor',
        rowCount: 500000,
        columnCount: 12,
        missingPercentage: 1.3,
        qualityScore: 95.8,
        uploadDate: DateTime.now().subtract(const Duration(hours: 3)),
        fileSize: '45.8 MB',
        type: 'CSV',
        columns: ['timestamp', 'sensor_id', 'temperature', 'pressure', 'humidity', 'status'],
        tags: ['IoT', 'sensor', 'real-time'],
      ),
      DatasetModel(
        id: 'ds004',
        name: 'Financial Markets Data',
        description: 'Stock prices and trading volumes',
        rowCount: 250000,
        columnCount: 15,
        missingPercentage: 0.8,
        qualityScore: 98.2,
        uploadDate: DateTime.now().subtract(const Duration(days: 2)),
        fileSize: '28.1 MB',
        type: 'CSV',
        columns: ['date', 'ticker', 'open', 'high', 'low', 'close', 'volume'],
        tags: ['finance', 'stocks', 'trading'],
      ),
    ];
    notifyListeners();
  }

  void selectDataset(DatasetModel ds) {
    _selectedDataset = ds;
    notifyListeners();
  }

  List<Map<String, dynamic>> getTablePreview(String datasetId) {
    final rng = Random(42);
    final List<String> regions = ['North', 'South', 'East', 'West', 'Central'];
    final List<String> products = ['Analytics Pro', 'DataMind Basic', 'Enterprise Suite', 'IoT Bridge'];

    return List.generate(20, (i) => {
      'ID': 'ROW-${1000 + i}',
      'Date': '2024-${(i % 12 + 1).toString().padLeft(2, '0')}-15',
      'Region': regions[i % regions.length],
      'Product': products[i % products.length],
      'Revenue': '\$${(rng.nextInt(50000) + 5000).toStringAsFixed(2)}',
      'Profit': '${(rng.nextDouble() * 40 + 10).toStringAsFixed(1)}%',
      'Status': i % 5 == 0 ? 'MISSING' : 'OK',
    });
  }

  List<double> getColumnMissingRates(String datasetId) {
    final rng = Random(42);
    return List.generate(12, (_) => rng.nextDouble() * 20);
  }

  Future<void> refreshData() async {
    _isLoading = true;
    notifyListeners();
    await Future.delayed(const Duration(seconds: 1));
    _isLoading = false;
    notifyListeners();
  }
}
