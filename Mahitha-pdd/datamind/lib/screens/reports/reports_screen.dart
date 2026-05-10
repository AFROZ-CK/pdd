import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../theme/app_theme.dart';

class ReportsScreen extends StatefulWidget {
  const ReportsScreen({super.key});

  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _selectedPeriod = 'Monthly';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reports & Insights'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.share_rounded),
            onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Report shared!')),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.download_rounded),
            onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Downloading PDF report...')),
            ),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppTheme.primaryColor,
          unselectedLabelColor: Theme.of(context).textTheme.bodyMedium?.color,
          indicatorColor: AppTheme.primaryColor,
          indicatorSize: TabBarIndicatorSize.label,
          tabs: const [
            Tab(text: 'Insights'),
            Tab(text: 'Trends'),
            Tab(text: 'Comparison'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildInsightsTab(),
          _buildTrendsTab(),
          _buildComparisonTab(),
        ],
      ),
    );
  }

  Widget _buildInsightsTab() {
    final insights = [
      {
        'title': '📈 Revenue Growing 33.2%',
        'description':
            'Revenue has consistently increased month-over-month in 2024. Q4 shows the strongest performance with \$105K peak.',
        'impact': 'HIGH',
        'color': AppTheme.successColor,
        'action': 'Invest more in high-performing regions',
        'metric': '+\$26K vs last year',
      },
      {
        'title': '⚠️ Churn Risk Identified',
        'description':
            '23% of customer segment shows high churn probability. Proactive engagement campaigns recommended.',
        'impact': 'HIGH',
        'color': AppTheme.errorColor,
        'action': 'Launch retention campaign for at-risk segment',
        'metric': '2,300 customers at risk',
      },
      {
        'title': '🔮 Demand Surge Expected',
        'description':
            'XGBoost model predicts 18% demand increase in Q1 2025. Supply chain adjustment advised.',
        'impact': 'MEDIUM',
        'color': AppTheme.warningColor,
        'action': 'Increase inventory by 20% before Q1',
        'metric': '8,750 units forecasted',
      },
      {
        'title': '🎯 Model Accuracy Improving',
        'description':
            'Average model accuracy increased by 2.1% this month. XGBoost leading at 96.2%.',
        'impact': 'LOW',
        'color': AppTheme.primaryColor,
        'action': 'Deploy XGBoost for production predictions',
        'metric': '94.7% avg accuracy',
      },
      {
        'title': '🕳️ Data Gaps Reduced',
        'description':
            'Gap remediation efforts closed 342 data gaps. Quality score improved from 81% to 87%.',
        'impact': 'MEDIUM',
        'color': AppTheme.accentColor,
        'action': 'Continue KNN imputation for age column',
        'metric': '87.3% data quality',
      },
    ];

    return ListView.separated(
      padding: const EdgeInsets.all(20),
      itemCount: insights.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (_, i) {
        final ins = insights[i];
        final color = ins['color'] as Color;
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
                  Expanded(
                    child: Text(ins['title'] as String,
                        style: Theme.of(context).textTheme.titleMedium),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(ins['impact'] as String,
                        style: TextStyle(
                            color: color, fontSize: 11, fontWeight: FontWeight.w700)),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(ins['description'] as String,
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(fontSize: 13)),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.07),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    Icon(Icons.lightbulb_outline_rounded, color: color, size: 16),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(ins['action'] as String,
                          style: TextStyle(
                              color: color, fontSize: 12, fontWeight: FontWeight.w500)),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              Text(ins['metric'] as String,
                  style: TextStyle(
                      color: color, fontSize: 12, fontWeight: FontWeight.w600)),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTrendsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Period selector
          Row(
            children: ['Weekly', 'Monthly', 'Quarterly', 'Yearly']
                .map((p) => Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: GestureDetector(
                        onTap: () => setState(() => _selectedPeriod = p),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 8),
                          decoration: BoxDecoration(
                            gradient: _selectedPeriod == p
                                ? AppTheme.primaryGradient
                                : null,
                            color: _selectedPeriod == p
                                ? null
                                : Theme.of(context).cardTheme.color,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                                color: _selectedPeriod == p
                                    ? Colors.transparent
                                    : Theme.of(context).dividerColor),
                          ),
                          child: Text(p,
                              style: TextStyle(
                                  color: _selectedPeriod == p
                                      ? Colors.white
                                      : Theme.of(context)
                                          .textTheme
                                          .bodyMedium
                                          ?.color,
                                  fontSize: 13,
                                  fontWeight: _selectedPeriod == p
                                      ? FontWeight.w600
                                      : FontWeight.w400)),
                        ),
                      ),
                    ))
                .toList(),
          ),
          const SizedBox(height: 20),

          // Trend chart
          Text('Revenue Trend',
              style: Theme.of(context).textTheme.headlineMedium),
          const SizedBox(height: 12),
          _buildTrendLineChart(context),
          const SizedBox(height: 20),

          // Trend metrics
          Text('Trend Metrics',
              style: Theme.of(context).textTheme.headlineMedium),
          const SizedBox(height: 12),
          _buildTrendMetrics(context),
          const SizedBox(height: 80),
        ],
      ),
    );
  }

  Widget _buildTrendLineChart(BuildContext context) {
    final data1 = [40.0, 45, 52, 48, 58, 62, 68, 71, 76, 84, 88, 95];
    final data2 = [30.0, 35, 33, 40, 38, 45, 44, 50, 52, 60, 64, 72];

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Theme.of(context).dividerColor),
      ),
      child: Column(
        children: [
          Row(
            children: [
              _LegendDot(color: AppTheme.primaryColor, label: 'This Year'),
              const SizedBox(width: 16),
              _LegendDot(color: AppTheme.accentColor, label: 'Last Year'),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 180,
            child: LineChart(
              LineChartData(
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: 20,
                  getDrawingHorizontalLine: (_) =>
                      FlLine(color: Theme.of(context).dividerColor, strokeWidth: 1),
                ),
                titlesData: const FlTitlesData(
                  leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                ),
                borderData: FlBorderData(show: false),
                lineBarsData: [
                  LineChartBarData(
                    spots: data1.asMap().entries
                        .map((e) => FlSpot(e.key.toDouble(), e.value))
                        .toList(),
                    isCurved: true,
                    gradient: AppTheme.primaryGradient,
                    barWidth: 3,
                    dotData: const FlDotData(show: false),
                    belowBarData: BarAreaData(
                      show: true,
                      gradient: LinearGradient(
                        colors: [
                          AppTheme.primaryColor.withOpacity(0.2),
                          AppTheme.primaryColor.withOpacity(0),
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),
                  LineChartBarData(
                    spots: data2.asMap().entries
                        .map((e) => FlSpot(e.key.toDouble(), e.value))
                        .toList(),
                    isCurved: true,
                    color: AppTheme.accentColor.withOpacity(0.6),
                    barWidth: 2,
                    dashArray: [6, 4],
                    dotData: const FlDotData(show: false),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTrendMetrics(BuildContext context) {
    final metrics = [
      ('Growth Rate', '33.2%', AppTheme.successColor, Icons.trending_up_rounded),
      ('CAGR', '28.7%', AppTheme.primaryColor, Icons.show_chart_rounded),
      ('Forecast Accuracy', '94.7%', AppTheme.accentColor, Icons.gps_fixed_rounded),
      ('Variance', '±5.2%', AppTheme.warningColor, Icons.bar_chart_rounded),
    ];

    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 10,
      mainAxisSpacing: 10,
      childAspectRatio: 2.0,
      children: metrics.map((m) => Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: m.$3.withOpacity(0.07),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: m.$3.withOpacity(0.2)),
            ),
            child: Row(
              children: [
                Icon(m.$4, color: m.$3, size: 24),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(m.$2,
                        style: TextStyle(
                            color: m.$3,
                            fontWeight: FontWeight.w800,
                            fontSize: 18)),
                    Text(m.$1,
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium
                            ?.copyWith(fontSize: 11)),
                  ],
                ),
              ],
            ),
          )).toList(),
    );
  }

  Widget _buildComparisonTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Model Performance Comparison',
              style: Theme.of(context).textTheme.headlineMedium),
          const SizedBox(height: 16),

          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).cardTheme.color,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Theme.of(context).dividerColor),
            ),
            child: Table(
              columnWidths: const {
                0: FlexColumnWidth(2),
                1: FlexColumnWidth(1.5),
                2: FlexColumnWidth(1.5),
                3: FlexColumnWidth(1.5),
              },
              children: [
                TableRow(
                  decoration: BoxDecoration(
                    color: AppTheme.primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  children: ['Model', 'Accuracy', 'F1-Score', 'Speed']
                      .map((h) => Padding(
                            padding: const EdgeInsets.all(10),
                            child: Text(h,
                                style: const TextStyle(
                                    color: AppTheme.primaryColor,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 12)),
                          ))
                      .toList(),
                ),
                ...([
                  ['XGBoost', '96.2%', '0.94', '⚡ Fast'],
                  ['Random Forest', '94.7%', '0.92', '🟡 Medium'],
                  ['Neural Net', '93.8%', '0.91', '🔴 Slow'],
                  ['LSTM', '91.5%', '0.89', '🔴 Slow'],
                  ['Prophet', '90.1%', '0.87', '⚡ Fast'],
                  ['Linear Reg.', '87.4%', '0.83', '⚡ Fast'],
                ].map((row) => TableRow(
                      children: row
                          .map((cell) => Padding(
                                padding: const EdgeInsets.all(10),
                                child: Text(cell,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.copyWith(fontSize: 12)),
                              ))
                          .toList(),
                    ))),
              ],
            ),
          ),
          const SizedBox(height: 24),

          Text('Dataset Quality Comparison',
              style: Theme.of(context).textTheme.headlineMedium),
          const SizedBox(height: 16),
          _buildQualityRadarChart(context),
          const SizedBox(height: 80),
        ],
      ),
    );
  }

  Widget _buildQualityRadarChart(BuildContext context) {
    // Simplified radar-like display using a container
    final datasets = [
      ('Sales 2024', 87.3, AppTheme.primaryColor),
      ('Customer Behavior', 76.5, AppTheme.warningColor),
      ('IoT Sensors', 95.8, AppTheme.successColor),
      ('Financial Markets', 98.2, AppTheme.accentColor),
    ];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Theme.of(context).dividerColor),
      ),
      child: Column(
        children: datasets.map((d) => Padding(
              padding: const EdgeInsets.only(bottom: 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(d.$1,
                          style:
                              Theme.of(context).textTheme.titleMedium?.copyWith(fontSize: 13)),
                      Text('${d.$2.toStringAsFixed(1)}%',
                          style: TextStyle(
                              color: d.$3,
                              fontWeight: FontWeight.w700,
                              fontSize: 14)),
                    ],
                  ),
                  const SizedBox(height: 6),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: LinearProgressIndicator(
                      value: d.$2 / 100,
                      minHeight: 10,
                      backgroundColor: d.$3.withOpacity(0.1),
                      valueColor: AlwaysStoppedAnimation<Color>(d.$3),
                    ),
                  ),
                ],
              ),
            )).toList(),
      ),
    );
  }
}

class _LegendDot extends StatelessWidget {
  final Color color;
  final String label;
  const _LegendDot({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 4,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 6),
        Text(label,
            style:
                Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 12)),
      ],
    );
  }
}
