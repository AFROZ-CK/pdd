import 'package:flutter/material.dart';
import 'dart:math';
import '../models/prediction_model.dart';

class AnalyticsProvider extends ChangeNotifier {
  List<PredictionResult> _predictions = [];
  bool _isRunningModel = false;
  String _selectedModel = 'Linear Regression';
  double _modelAccuracy = 94.7;
  List<double> _realtimeData = [];
  int _alertCount = 3;

  List<PredictionResult> get predictions => _predictions;
  bool get isRunningModel => _isRunningModel;
  String get selectedModel => _selectedModel;
  double get modelAccuracy => _modelAccuracy;
  List<double> get realtimeData => _realtimeData;
  int get alertCount => _alertCount;

  final List<String> availableModels = [
    'Linear Regression',
    'Random Forest',
    'XGBoost',
    'Neural Network',
    'LSTM (Time Series)',
    'K-Means Clustering',
    'ARIMA',
    'Prophet',
  ];

  AnalyticsProvider() {
    _initRealtimeData();
    _initPredictions();
  }

  void _initRealtimeData() {
    final rng = Random(42);
    _realtimeData = List.generate(50, (i) {
      return 60 + rng.nextDouble() * 40 + sin(i * 0.3) * 15;
    });
  }

  void _initPredictions() {
    _predictions = [
      PredictionResult(
        id: 'p001',
        modelName: 'Random Forest',
        targetVariable: 'Revenue',
        predictedValue: 127450.0,
        confidence: 91.3,
        timestamp: DateTime.now().subtract(const Duration(hours: 2)),
        featureImportances: {
          'region': 0.32,
          'product': 0.28,
          'season': 0.22,
          'marketing_spend': 0.18,
        },
        status: 'Completed',
      ),
      PredictionResult(
        id: 'p002',
        modelName: 'LSTM',
        targetVariable: 'Churn Probability',
        predictedValue: 0.23,
        confidence: 88.7,
        timestamp: DateTime.now().subtract(const Duration(hours: 5)),
        featureImportances: {
          'session_duration': 0.41,
          'purchase_freq': 0.31,
          'support_tickets': 0.28,
        },
        status: 'Completed',
      ),
      PredictionResult(
        id: 'p003',
        modelName: 'XGBoost',
        targetVariable: 'Demand Forecast',
        predictedValue: 8750.0,
        confidence: 95.1,
        timestamp: DateTime.now().subtract(const Duration(days: 1)),
        featureImportances: {
          'historical_sales': 0.45,
          'pricing': 0.25,
          'competition': 0.18,
          'seasonality': 0.12,
        },
        status: 'Completed',
      ),
    ];
  }

  void selectModel(String model) {
    _selectedModel = model;
    _updateModelAccuracy();
    notifyListeners();
  }

  void _updateModelAccuracy() {
    final accuracies = {
      'Linear Regression': 87.4,
      'Random Forest': 94.7,
      'XGBoost': 96.2,
      'Neural Network': 93.8,
      'LSTM (Time Series)': 91.5,
      'K-Means Clustering': 89.3,
      'ARIMA': 85.6,
      'Prophet': 90.1,
    };
    _modelAccuracy = accuracies[_selectedModel] ?? 90.0;
  }

  Future<PredictionResult?> runPrediction({
    required Map<String, dynamic> inputs,
    required String targetVariable,
  }) async {
    _isRunningModel = true;
    notifyListeners();

    await Future.delayed(const Duration(seconds: 3)); // Simulate ML inference

    final rng = Random();
    final result = PredictionResult(
      id: 'p${DateTime.now().millisecondsSinceEpoch}',
      modelName: _selectedModel,
      targetVariable: targetVariable,
      predictedValue: rng.nextDouble() * 100000 + 10000,
      confidence: 85 + rng.nextDouble() * 12,
      timestamp: DateTime.now(),
      featureImportances: {
        'feature_1': 0.35,
        'feature_2': 0.28,
        'feature_3': 0.22,
        'feature_4': 0.15,
      },
      status: 'Completed',
    );

    _predictions.insert(0, result);
    _isRunningModel = false;
    notifyListeners();
    return result;
  }

  void addRealtimePoint() {
    final rng = Random();
    final last = _realtimeData.isNotEmpty ? _realtimeData.last : 75;
    final next = (last + (rng.nextDouble() - 0.45) * 10).clamp(30.0, 120.0);
    _realtimeData.add(next);
    if (_realtimeData.length > 50) _realtimeData.removeAt(0);
    notifyListeners();
  }

  // Dashboard KPI data
  Map<String, dynamic> getDashboardKPIs() {
    return {
      'totalPredictions': 1247,
      'predictionsChange': 12.4,
      'avgAccuracy': 94.7,
      'accuracyChange': 2.1,
      'dataGapsClosed': 342,
      'gapsChange': -8.3,
      'activeModels': 8,
      'modelsChange': 25.0,
      'datasetsProcessed': 24,
      'alertsTriggered': 7,
    };
  }

  List<Map<String, dynamic>> getRecentAlerts() {
    return [
      {
        'title': 'Data Quality Alert',
        'message': 'Customer dataset missing >15% in \'age\' column',
        'type': 'warning',
        'time': '10 min ago',
      },
      {
        'title': 'Prediction Drift Detected',
        'message': 'Revenue model accuracy dropped below 90%',
        'type': 'error',
        'time': '1 hr ago',
      },
      {
        'title': 'Model Training Complete',
        'message': 'XGBoost v2 trained with 96.2% accuracy',
        'type': 'success',
        'time': '3 hr ago',
      },
      {
        'title': 'New Data Ingested',
        'message': '500K IoT sensor records processed successfully',
        'type': 'info',
        'time': '5 hr ago',
      },
    ];
  }
}
