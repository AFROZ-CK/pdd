import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../providers/analytics_provider.dart';
import '../../theme/app_theme.dart';
import '../../models/prediction_model.dart';

class PredictiveScreen extends StatefulWidget {
  const PredictiveScreen({super.key});

  @override
  State<PredictiveScreen> createState() => _PredictiveScreenState();
}

class _PredictiveScreenState extends State<PredictiveScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _formKey = GlobalKey<FormState>();
  String _targetVariable = 'Revenue';
  final Map<String, TextEditingController> _inputControllers = {
    'Region': TextEditingController(text: 'North'),
    'Product Category': TextEditingController(text: 'Analytics Pro'),
    'Historical Average': TextEditingController(text: '75000'),
    'Season Factor': TextEditingController(text: '1.2'),
  };

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    for (var c in _inputControllers.values) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final analytics = context.watch<AnalyticsProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Predictive Analytics'),
        automaticallyImplyLeading: false,
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppTheme.primaryColor,
          unselectedLabelColor: Theme.of(context).textTheme.bodyMedium?.color,
          indicatorColor: AppTheme.primaryColor,
          indicatorSize: TabBarIndicatorSize.label,
          tabs: const [
            Tab(text: 'Run Model'),
            Tab(text: 'Results'),
            Tab(text: 'Models'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildRunTab(analytics),
          _buildResultsTab(analytics),
          _buildModelsTab(analytics),
        ],
      ),
    );
  }

  Widget _buildRunTab(AnalyticsProvider analytics) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Model selector
            Text('Select Model', style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: 12),
            _buildModelSelector(analytics),
            const SizedBox(height: 24),

            // Accuracy badge
            _buildAccuracyBadge(analytics),
            const SizedBox(height: 24),

            // Target variable
            Text('Target Variable', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              value: _targetVariable,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.track_changes_rounded),
              ),
              items: ['Revenue', 'Churn Probability', 'Demand Forecast',
                  'Fraud Score', 'Customer LTV']
                  .map((v) => DropdownMenuItem(value: v, child: Text(v)))
                  .toList(),
              onChanged: (v) => setState(() => _targetVariable = v!),
            ),
            const SizedBox(height: 24),

            // Feature inputs
            Text('Feature Inputs', style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: 12),
            ..._inputControllers.entries.map((e) => Padding(
                  padding: const EdgeInsets.only(bottom: 14),
                  child: TextFormField(
                    controller: e.value,
                    decoration: InputDecoration(
                      labelText: e.key,
                      prefixIcon: const Icon(Icons.data_object_rounded),
                    ),
                    validator: (v) => v!.isEmpty ? '${e.key} required' : null,
                  ),
                )),
            const SizedBox(height: 24),

            // Run button
            SizedBox(
              width: double.infinity,
              height: 54,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: AppTheme.primaryGradient,
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.primaryColor.withOpacity(0.4),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: ElevatedButton.icon(
                  onPressed: analytics.isRunningModel
                      ? null
                      : () async {
                          if (!_formKey.currentState!.validate()) return;
                          await analytics.runPrediction(
                            inputs: {
                              for (var e in _inputControllers.entries)
                                e.key: e.value.text
                            },
                            targetVariable: _targetVariable,
                          );
                          if (mounted) _tabController.animateTo(1);
                        },
                  icon: analytics.isRunningModel
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                              color: Colors.white, strokeWidth: 2))
                      : const Icon(Icons.play_arrow_rounded, color: Colors.white),
                  label: Text(
                    analytics.isRunningModel ? 'Running Model...' : 'Run Prediction',
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14)),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildModelSelector(AnalyticsProvider analytics) {
    return SizedBox(
      height: 40,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: analytics.availableModels.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (_, i) {
          final model = analytics.availableModels[i];
          final selected = model == analytics.selectedModel;
          return GestureDetector(
            onTap: () => analytics.selectModel(model),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                gradient: selected ? AppTheme.primaryGradient : null,
                color: selected ? null : Theme.of(context).cardTheme.color,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: selected
                      ? Colors.transparent
                      : Theme.of(context).dividerColor,
                ),
              ),
              child: Text(
                model,
                style: TextStyle(
                  color: selected ? Colors.white : Theme.of(context).textTheme.bodyMedium?.color,
                  fontSize: 13,
                  fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildAccuracyBadge(AnalyticsProvider analytics) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppTheme.successColor.withOpacity(0.1),
            AppTheme.successColor.withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border:
            Border.all(color: AppTheme.successColor.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppTheme.successColor.withOpacity(0.15),
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(Icons.gps_fixed_rounded,
                color: AppTheme.successColor, size: 24),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(analytics.selectedModel,
                    style: Theme.of(context).textTheme.titleMedium),
                Row(
                  children: [
                    Text(
                      'Accuracy: ',
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.copyWith(fontSize: 12),
                    ),
                    Text(
                      '${analytics.modelAccuracy.toStringAsFixed(1)}%',
                      style: const TextStyle(
                          color: AppTheme.successColor,
                          fontWeight: FontWeight.w700,
                          fontSize: 14),
                    ),
                  ],
                ),
              ],
            ),
          ),
          _AccuracyRing(value: analytics.modelAccuracy / 100),
        ],
      ),
    );
  }

  Widget _buildResultsTab(AnalyticsProvider analytics) {
    if (analytics.predictions.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.auto_graph_rounded,
                size: 64, color: Theme.of(context).dividerColor),
            const SizedBox(height: 16),
            Text('No predictions yet',
                style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: 8),
            Text('Run your first model to see results here',
                style: Theme.of(context).textTheme.bodyMedium),
          ],
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(20),
      itemCount: analytics.predictions.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (_, i) => _PredictionCard(prediction: analytics.predictions[i]),
    );
  }

  Widget _buildModelsTab(AnalyticsProvider analytics) {
    final modelInfo = [
      {
        'name': 'Linear Regression',
        'type': 'Regression',
        'desc': 'Predicts continuous values using linear relationships',
        'accuracy': 87.4,
        'useCase': 'Revenue, pricing, forecasting',
        'color': AppTheme.primaryColor,
      },
      {
        'name': 'Random Forest',
        'type': 'Ensemble',
        'desc': 'Multiple decision trees for robust predictions',
        'accuracy': 94.7,
        'useCase': 'Classification, ranking, feature selection',
        'color': AppTheme.successColor,
      },
      {
        'name': 'XGBoost',
        'type': 'Gradient Boost',
        'desc': 'High-performance gradient boosting algorithm',
        'accuracy': 96.2,
        'useCase': 'Competition-grade predictions, tabular data',
        'color': AppTheme.accentColor,
      },
      {
        'name': 'Neural Network',
        'type': 'Deep Learning',
        'desc': 'Multi-layer perceptrons for complex patterns',
        'accuracy': 93.8,
        'useCase': 'Image, text, complex feature interactions',
        'color': AppTheme.warningColor,
      },
      {
        'name': 'LSTM (Time Series)',
        'type': 'Recurrent DL',
        'desc': 'Long Short-Term Memory for sequential data',
        'accuracy': 91.5,
        'useCase': 'Time series, sensor data, stock prices',
        'color': Color(0xFF9C27B0),
      },
      {
        'name': 'Prophet',
        'type': 'Forecasting',
        'desc': 'Facebook\'s forecasting model with seasonality',
        'accuracy': 90.1,
        'useCase': 'Business forecasting with trends & seasons',
        'color': AppTheme.infoColor,
      },
    ];

    return ListView.separated(
      padding: const EdgeInsets.all(20),
      itemCount: modelInfo.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (_, i) {
        final m = modelInfo[i];
        final color = m['color'] as Color;
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Theme.of(context).cardTheme.color,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Theme.of(context).dividerColor),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(Icons.model_training_rounded, color: color, size: 24),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(m['name'] as String,
                              style: Theme.of(context).textTheme.titleMedium),
                        ),
                        Text('${(m['accuracy'] as double).toStringAsFixed(1)}%',
                            style: TextStyle(
                                color: color,
                                fontWeight: FontWeight.w700,
                                fontSize: 14)),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: color.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(m['type'] as String,
                          style: TextStyle(
                              color: color, fontSize: 11, fontWeight: FontWeight.w600)),
                    ),
                    const SizedBox(height: 6),
                    Text(m['desc'] as String,
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium
                            ?.copyWith(fontSize: 12)),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.bolt, size: 12, color: AppTheme.warningColor),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(m['useCase'] as String,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(fontSize: 11),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _PredictionCard extends StatelessWidget {
  final PredictionResult prediction;
  const _PredictionCard({required this.prediction});

  @override
  Widget build(BuildContext context) {
    final confColor = prediction.confidence >= 90
        ? AppTheme.successColor
        : prediction.confidence >= 75
            ? AppTheme.warningColor
            : AppTheme.errorColor;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Theme.of(context).dividerColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(prediction.targetVariable,
                      style: Theme.of(context).textTheme.titleLarge),
                  Text(prediction.modelName,
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.copyWith(color: AppTheme.primaryColor)),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: confColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: confColor.withOpacity(0.3)),
                ),
                child: Text(
                  '${prediction.confidence.toStringAsFixed(1)}% conf.',
                  style: TextStyle(
                      color: confColor, fontSize: 12, fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ShaderMask(
            shaderCallback: (b) => AppTheme.primaryGradient.createShader(b),
            child: Text(
              prediction.formattedValue,
              style: const TextStyle(
                  fontSize: 32, fontWeight: FontWeight.w800, color: Colors.white),
            ),
          ),
          const SizedBox(height: 16),
          Text('Feature Importances',
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(fontSize: 12)),
          const SizedBox(height: 8),
          ...prediction.featureImportances.entries.map((e) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  children: [
                    SizedBox(
                      width: 120,
                      child: Text(e.key,
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(fontSize: 12),
                          overflow: TextOverflow.ellipsis),
                    ),
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: LinearProgressIndicator(
                          value: e.value,
                          minHeight: 6,
                          backgroundColor:
                              AppTheme.primaryColor.withOpacity(0.1),
                          valueColor: const AlwaysStoppedAnimation<Color>(
                              AppTheme.primaryColor),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text('${(e.value * 100).toInt()}%',
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium
                            ?.copyWith(
                                fontSize: 11,
                                color: AppTheme.primaryColor,
                                fontWeight: FontWeight.w600)),
                  ],
                ),
              )),
        ],
      ),
    );
  }
}

class _AccuracyRing extends StatelessWidget {
  final double value;
  const _AccuracyRing({required this.value});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 48,
      height: 48,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CircularProgressIndicator(
            value: value,
            backgroundColor: AppTheme.successColor.withOpacity(0.15),
            valueColor: const AlwaysStoppedAnimation<Color>(AppTheme.successColor),
            strokeWidth: 4,
          ),
          Text(
            '${(value * 100).toInt()}',
            style: const TextStyle(
                fontSize: 12, fontWeight: FontWeight.w700, color: AppTheme.successColor),
          ),
        ],
      ),
    );
  }
}
