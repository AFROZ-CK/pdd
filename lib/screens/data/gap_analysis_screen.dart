import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../providers/data_provider.dart';
import '../../theme/app_theme.dart';

class GapAnalysisScreen extends StatefulWidget {
  const GapAnalysisScreen({super.key});

  @override
  State<GapAnalysisScreen> createState() => _GapAnalysisScreenState();
}

class _GapAnalysisScreenState extends State<GapAnalysisScreen> {
  String _selectedDataset = 'Sales Performance 2024';
  bool _isAnalyzing = false;
  bool _analyzed = false;

  final List<String> _datasets = [
    'Sales Performance 2024',
    'Customer Behavior Analysis',
    'IoT Sensor Streams',
    'Financial Markets Data',
  ];

  Future<void> _runAnalysis() async {
    setState(() {
      _isAnalyzing = true;
      _analyzed = false;
    });
    await Future.delayed(const Duration(seconds: 2));
    setState(() {
      _isAnalyzing = false;
      _analyzed = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final dataProvider = context.watch<DataProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Data Gap Analysis'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Overview banner
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppTheme.warningColor.withOpacity(0.15),
                    AppTheme.warningColor.withOpacity(0.05),
                  ],
                ),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                    color: AppTheme.warningColor.withOpacity(0.3)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.healing_rounded,
                      color: AppTheme.warningColor, size: 28),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Data Gap Analysis Engine',
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge
                                ?.copyWith(color: AppTheme.warningColor)),
                        Text(
                            'Detect missing values, identify patterns, and get imputation recommendations',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(fontSize: 12)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Dataset selector
            Text('Select Dataset',
                style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              value: _selectedDataset,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.storage_rounded),
              ),
              items: _datasets
                  .map((d) => DropdownMenuItem(value: d, child: Text(d)))
                  .toList(),
              onChanged: (v) => setState(() {
                _selectedDataset = v!;
                _analyzed = false;
              }),
            ),
            const SizedBox(height: 16),

            // Run analysis button
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton.icon(
                onPressed: _isAnalyzing ? null : _runAnalysis,
                icon: _isAnalyzing
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                            color: Colors.white, strokeWidth: 2))
                    : const Icon(Icons.search_rounded),
                label: Text(
                    _isAnalyzing ? 'Analyzing...' : 'Run Gap Analysis'),
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14)),
                ),
              ),
            ),
            const SizedBox(height: 24),

            if (_analyzed) ...[
              // Summary cards
              Text('Analysis Summary',
                  style: Theme.of(context).textTheme.headlineMedium),
              const SizedBox(height: 12),
              _buildSummaryCards(context),
              const SizedBox(height: 24),

              // Missing rate chart
              Text('Missing Value Rate by Column',
                  style: Theme.of(context).textTheme.headlineMedium),
              const SizedBox(height: 12),
              _buildMissingRateChart(context, dataProvider),
              const SizedBox(height: 24),

              // Gap patterns heatmap (simplified)
              Text('Gap Pattern Analysis',
                  style: Theme.of(context).textTheme.headlineMedium),
              const SizedBox(height: 12),
              _buildGapPatterns(context),
              const SizedBox(height: 24),

              // Imputation recommendations
              Text('Imputation Recommendations',
                  style: Theme.of(context).textTheme.headlineMedium),
              const SizedBox(height: 12),
              _buildImputationRecommendations(context),
              const SizedBox(height: 80),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryCards(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _GapSummaryCard(
            title: 'Total Missing',
            value: '4.2%',
            subtitle: '523 cells',
            color: AppTheme.warningColor,
            icon: Icons.warning_amber_rounded,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _GapSummaryCard(
            title: 'Critical Cols',
            value: '3',
            subtitle: '>10% missing',
            color: AppTheme.errorColor,
            icon: Icons.error_outline_rounded,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _GapSummaryCard(
            title: 'Quality Score',
            value: '87.3',
            subtitle: 'out of 100',
            color: AppTheme.successColor,
            icon: Icons.verified_rounded,
          ),
        ),
      ],
    );
  }

  Widget _buildMissingRateChart(BuildContext context, DataProvider dataProvider) {
    final rates = [4.2, 0.8, 12.3, 1.5, 8.7, 0.2, 15.1, 3.4, 0.9, 6.2];
    final cols = ['revenue', 'date', 'age', 'region', 'churn', 'id', 'email', 'score', 'type', 'status'];

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Theme.of(context).dividerColor),
      ),
      child: SizedBox(
        height: 200,
        child: BarChart(
          BarChartData(
            barGroups: rates.asMap().entries.map((e) {
              final color = e.value > 10
                  ? AppTheme.errorColor
                  : e.value > 5
                      ? AppTheme.warningColor
                      : AppTheme.successColor;
              return BarChartGroupData(x: e.key, barRods: [
                BarChartRodData(
                  toY: e.value,
                  color: color,
                  width: 18,
                  borderRadius: BorderRadius.circular(4),
                )
              ]);
            }).toList(),
            gridData: FlGridData(
              show: true,
              drawVerticalLine: false,
              getDrawingHorizontalLine: (_) =>
                  FlLine(color: Theme.of(context).dividerColor, strokeWidth: 1),
            ),
            titlesData: FlTitlesData(
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 28,
                  getTitlesWidget: (v, _) => Text('${v.toInt()}%',
                      style: TextStyle(
                          fontSize: 10,
                          color: Theme.of(context).textTheme.bodyMedium?.color)),
                ),
              ),
              rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
              topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  getTitlesWidget: (v, _) {
                    final i = v.toInt();
                    if (i < cols.length) {
                      return Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: RotatedBox(
                          quarterTurns: 1,
                          child: Text(cols[i],
                              style: TextStyle(
                                  fontSize: 9,
                                  color: Theme.of(context).textTheme.bodyMedium?.color)),
                        ),
                      );
                    }
                    return const SizedBox();
                  },
                ),
              ),
            ),
            borderData: FlBorderData(show: false),
            maxY: 20,
          ),
        ),
      ),
    );
  }

  Widget _buildGapPatterns(BuildContext context) {
    final patterns = [
      ('MCAR', 'Missing Completely At Random', 0.45, AppTheme.successColor,
          'Values missing independently of data — safe to use mean/median imputation'),
      ('MAR', 'Missing At Random', 0.35, AppTheme.warningColor,
          'Missing depends on other observed variables — use model-based imputation'),
      ('MNAR', 'Missing Not At Random', 0.20, AppTheme.errorColor,
          'Missing depends on unobserved data — requires domain-specific handling'),
    ];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Theme.of(context).dividerColor),
      ),
      child: Column(
        children: patterns.map((p) => Padding(
              padding: const EdgeInsets.only(bottom: 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 6,
                            height: 6,
                            decoration: BoxDecoration(
                              color: p.$4,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(p.$1,
                              style: TextStyle(
                                  color: p.$4,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 13)),
                          const SizedBox(width: 6),
                          Text(p.$2,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(fontSize: 12)),
                        ],
                      ),
                      Text('${(p.$3 * 100).toInt()}%',
                          style: TextStyle(
                              color: p.$4,
                              fontWeight: FontWeight.w600,
                              fontSize: 13)),
                    ],
                  ),
                  const SizedBox(height: 6),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: p.$3,
                      minHeight: 6,
                      backgroundColor: p.$4.withOpacity(0.1),
                      valueColor: AlwaysStoppedAnimation<Color>(p.$4),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(p.$5,
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.copyWith(fontSize: 11),
                      maxLines: 2),
                ],
              ),
            )).toList(),
      ),
    );
  }

  Widget _buildImputationRecommendations(BuildContext context) {
    final recs = [
      {
        'column': 'age',
        'missing': '12.3%',
        'method': 'KNN Imputation',
        'reason': 'Correlated with income and region',
        'confidence': 87,
        'icon': Icons.people_rounded,
        'color': AppTheme.primaryColor,
      },
      {
        'column': 'email',
        'missing': '15.1%',
        'method': 'Flag as Unknown',
        'reason': 'No reliable predictor available',
        'confidence': 92,
        'icon': Icons.email_outlined,
        'color': AppTheme.warningColor,
      },
      {
        'column': 'churn',
        'missing': '8.7%',
        'method': 'Logistic Regression',
        'reason': 'Can predict from session and purchase data',
        'confidence': 81,
        'icon': Icons.exit_to_app_rounded,
        'color': AppTheme.errorColor,
      },
      {
        'column': 'revenue',
        'missing': '4.2%',
        'method': 'Median Imputation',
        'reason': 'MCAR pattern — safe statistical imputation',
        'confidence': 94,
        'icon': Icons.attach_money_rounded,
        'color': AppTheme.successColor,
      },
    ];

    return Column(
      children: recs.map((r) {
        final color = r['color'] as Color;
        return Container(
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Theme.of(context).cardTheme.color,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Theme.of(context).dividerColor),
          ),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(r['icon'] as IconData, color: color, size: 22),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(r['column'] as String,
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontFamily: 'monospace', fontSize: 13)),
                        const SizedBox(width: 6),
                        Text('(${r['missing']} missing)',
                            style: const TextStyle(
                                color: AppTheme.warningColor, fontSize: 11)),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(r['method'] as String,
                        style: TextStyle(
                            color: color,
                            fontWeight: FontWeight.w600,
                            fontSize: 12)),
                    Text(r['reason'] as String,
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium
                            ?.copyWith(fontSize: 11)),
                  ],
                ),
              ),
              Column(
                children: [
                  Text('${r['confidence']}%',
                      style: TextStyle(
                          color: color,
                          fontWeight: FontWeight.w700,
                          fontSize: 14)),
                  Text('conf.',
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.copyWith(fontSize: 10)),
                ],
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}

class _GapSummaryCard extends StatelessWidget {
  final String title;
  final String value;
  final String subtitle;
  final Color color;
  final IconData icon;

  const _GapSummaryCard({
    required this.title,
    required this.value,
    required this.subtitle,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: color.withOpacity(0.07),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(height: 8),
          Text(value,
              style: TextStyle(
                  color: color, fontWeight: FontWeight.w800, fontSize: 22)),
          Text(title,
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(fontSize: 11, fontWeight: FontWeight.w500)),
          Text(subtitle,
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(fontSize: 10)),
        ],
      ),
    );
  }
}
