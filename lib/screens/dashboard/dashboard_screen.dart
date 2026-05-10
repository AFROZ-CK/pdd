import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../providers/auth_provider.dart';
import '../../providers/analytics_provider.dart';
import '../../theme/app_theme.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _fadeAnim;
  int _touchedPieIndex = -1;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1000));
    _fadeAnim = CurvedAnimation(parent: _animController, curve: Curves.easeOut);
    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final analytics = context.watch<AnalyticsProvider>();
    final kpis = analytics.getDashboardKPIs();
    final alerts = analytics.getRecentAlerts();

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Hello, ${auth.user?.name.split(' ').first ?? 'Analyst'} 👋',
                style: const TextStyle(fontSize: 16)),
            Text('Predictive Analytics Dashboard',
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(fontSize: 11)),
          ],
        ),
        actions: [
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.notifications_outlined),
                onPressed: () => _showNotifications(context, alerts),
              ),
              Positioned(
                right: 8,
                top: 8,
                child: Container(
                  width: 16,
                  height: 16,
                  decoration: const BoxDecoration(
                    color: AppTheme.errorColor,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      '${alerts.length}',
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: FadeTransition(
        opacity: _fadeAnim,
        child: RefreshIndicator(
          onRefresh: () => Future.delayed(const Duration(seconds: 1)),
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // KPI Cards
                _buildSectionTitle(context, 'Key Performance Indicators'),
                const SizedBox(height: 12),
                GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 1.4,
                  children: [
                    _KPICard(
                      title: 'Predictions Run',
                      value: '${kpis['totalPredictions']}',
                      change: kpis['predictionsChange'],
                      icon: Icons.model_training_rounded,
                      gradient: AppTheme.primaryGradient,
                    ),
                    _KPICard(
                      title: 'Avg Accuracy',
                      value: '${kpis['avgAccuracy']}%',
                      change: kpis['accuracyChange'],
                      icon: Icons.gps_fixed_rounded,
                      gradient: AppTheme.successGradient,
                    ),
                    _KPICard(
                      title: 'Data Gaps Closed',
                      value: '${kpis['dataGapsClosed']}',
                      change: kpis['gapsChange'],
                      icon: Icons.healing_rounded,
                      gradient: AppTheme.warningGradient,
                      isNegativeBetter: true,
                    ),
                    _KPICard(
                      title: 'Active Models',
                      value: '${kpis['activeModels']}',
                      change: kpis['modelsChange'],
                      icon: Icons.account_tree_rounded,
                      gradient: AppTheme.purpleGradient,
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Revenue Trend Chart
                _buildSectionTitle(context, 'Revenue Trend (2024)'),
                const SizedBox(height: 12),
                _buildLineChart(context),
                const SizedBox(height: 24),

                // Model Performance Row
                _buildSectionTitle(context, 'Model Performance'),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(child: _buildPieChart(context)),
                    const SizedBox(width: 12),
                    Expanded(child: _buildModelList(context)),
                  ],
                ),
                const SizedBox(height: 24),

                // Recent Alerts
                _buildSectionTitle(context, 'Recent Alerts'),
                const SizedBox(height: 12),
                ...alerts.map((a) => _AlertTile(alert: a)),
                const SizedBox(height: 24),

                // Bar Chart
                _buildSectionTitle(context, 'Predictions by Category'),
                const SizedBox(height: 12),
                _buildBarChart(context),
                const SizedBox(height: 80),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Text(title, style: Theme.of(context).textTheme.headlineMedium);
  }

  Widget _buildLineChart(BuildContext context) {
    final spots = <FlSpot>[
      const FlSpot(0, 45),
      const FlSpot(1, 52),
      const FlSpot(2, 48),
      const FlSpot(3, 61),
      const FlSpot(4, 58),
      const FlSpot(5, 72),
      const FlSpot(6, 68),
      const FlSpot(7, 85),
      const FlSpot(8, 79),
      const FlSpot(9, 94),
      const FlSpot(10, 88),
      const FlSpot(11, 105),
    ];
    final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
        'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];

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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('\$105K', style: Theme.of(context).textTheme.headlineLarge),
                  Row(
                    children: [
                      const Icon(Icons.trending_up_rounded,
                          color: AppTheme.successColor, size: 16),
                      const SizedBox(width: 4),
                      Text('+33.2% vs last year',
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(color: AppTheme.successColor, fontSize: 12)),
                    ],
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text('2024',
                    style: TextStyle(
                        color: AppTheme.primaryColor,
                        fontSize: 12,
                        fontWeight: FontWeight.w600)),
              ),
            ],
          ),
          const SizedBox(height: 24),
          SizedBox(
            height: 160,
            child: LineChart(
              LineChartData(
                gridData: FlGridData(
                  show: true,
                  horizontalInterval: 20,
                  getDrawingHorizontalLine: (_) => FlLine(
                    color: Theme.of(context).dividerColor,
                    strokeWidth: 1,
                  ),
                  drawVerticalLine: false,
                ),
                titlesData: FlTitlesData(
                  leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      interval: 2,
                      getTitlesWidget: (value, meta) {
                        final i = value.toInt();
                        if (i < months.length && i % 2 == 0) {
                          return Text(months[i],
                              style: TextStyle(
                                  fontSize: 10,
                                  color: Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.color));
                        }
                        return const SizedBox();
                      },
                    ),
                  ),
                ),
                borderData: FlBorderData(show: false),
                lineBarsData: [
                  LineChartBarData(
                    spots: spots,
                    isCurved: true,
                    gradient: AppTheme.primaryGradient,
                    barWidth: 3,
                    isStrokeCapRound: true,
                    dotData: const FlDotData(show: false),
                    belowBarData: BarAreaData(
                      show: true,
                      gradient: LinearGradient(
                        colors: [
                          AppTheme.primaryColor.withOpacity(0.3),
                          AppTheme.primaryColor.withOpacity(0.0),
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPieChart(BuildContext context) {
    final sections = [
      PieChartSectionData(
        value: 35,
        color: AppTheme.primaryColor,
        title: '35%',
        radius: _touchedPieIndex == 0 ? 55 : 45,
        titleStyle: const TextStyle(
            color: Colors.white, fontSize: 11, fontWeight: FontWeight.w700),
      ),
      PieChartSectionData(
        value: 28,
        color: AppTheme.successColor,
        title: '28%',
        radius: _touchedPieIndex == 1 ? 55 : 45,
        titleStyle: const TextStyle(
            color: Colors.white, fontSize: 11, fontWeight: FontWeight.w700),
      ),
      PieChartSectionData(
        value: 22,
        color: AppTheme.warningColor,
        title: '22%',
        radius: _touchedPieIndex == 2 ? 55 : 45,
        titleStyle: const TextStyle(
            color: Colors.white, fontSize: 11, fontWeight: FontWeight.w700),
      ),
      PieChartSectionData(
        value: 15,
        color: AppTheme.accentColor,
        title: '15%',
        radius: _touchedPieIndex == 3 ? 55 : 45,
        titleStyle: const TextStyle(
            color: Colors.black, fontSize: 11, fontWeight: FontWeight.w700),
      ),
    ];

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
          Text('Model Types', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 12),
          SizedBox(
            height: 130,
            child: PieChart(
              PieChartData(
                pieTouchData: PieTouchData(
                  touchCallback: (_, pieTouchResponse) {
                    setState(() {
                      if (pieTouchResponse?.touchedSection == null) {
                        _touchedPieIndex = -1;
                        return;
                      }
                      _touchedPieIndex = pieTouchResponse!
                          .touchedSection!.touchedSectionIndex;
                    });
                  },
                ),
                sections: sections,
                sectionsSpace: 3,
                centerSpaceRadius: 28,
              ),
            ),
          ),
          const SizedBox(height: 8),
          _legendItem('Regression', AppTheme.primaryColor),
          _legendItem('Classification', AppTheme.successColor),
          _legendItem('Clustering', AppTheme.warningColor),
          _legendItem('Time Series', AppTheme.accentColor),
        ],
      ),
    );
  }

  Widget _legendItem(String label, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Container(
              width: 8,
              height: 8,
              decoration:
                  BoxDecoration(color: color, shape: BoxShape.circle)),
          const SizedBox(width: 6),
          Text(label,
              style:
                  Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 11)),
        ],
      ),
    );
  }

  Widget _buildModelList(BuildContext context) {
    final models = [
      ('XGBoost', 96.2, AppTheme.primaryColor),
      ('Random Forest', 94.7, AppTheme.successColor),
      ('Neural Net', 93.8, AppTheme.accentColor),
      ('Prophet', 90.1, AppTheme.warningColor),
    ];
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
          Text('Top Models', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 12),
          ...models.map((m) => Padding(
                padding: const EdgeInsets.only(bottom: 14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(m.$1,
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(fontSize: 11)),
                        Text('${m.$2}%',
                            style: TextStyle(
                                color: m.$3,
                                fontSize: 11,
                                fontWeight: FontWeight.w600)),
                      ],
                    ),
                    const SizedBox(height: 4),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: m.$2 / 100,
                        minHeight: 5,
                        backgroundColor: m.$3.withOpacity(0.15),
                        valueColor: AlwaysStoppedAnimation<Color>(m.$3),
                      ),
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }

  Widget _buildBarChart(BuildContext context) {
    final barGroups = [
      BarChartGroupData(x: 0, barRods: [
        BarChartRodData(toY: 8, gradient: AppTheme.primaryGradient, width: 22,
            borderRadius: BorderRadius.circular(6))
      ]),
      BarChartGroupData(x: 1, barRods: [
        BarChartRodData(toY: 12, gradient: AppTheme.successGradient, width: 22,
            borderRadius: BorderRadius.circular(6))
      ]),
      BarChartGroupData(x: 2, barRods: [
        BarChartRodData(toY: 5, gradient: AppTheme.warningGradient, width: 22,
            borderRadius: BorderRadius.circular(6))
      ]),
      BarChartGroupData(x: 3, barRods: [
        BarChartRodData(toY: 16, gradient: AppTheme.purpleGradient, width: 22,
            borderRadius: BorderRadius.circular(6))
      ]),
      BarChartGroupData(x: 4, barRods: [
        BarChartRodData(toY: 9, gradient: AppTheme.primaryGradient, width: 22,
            borderRadius: BorderRadius.circular(6))
      ]),
    ];

    final labels = ['Revenue', 'Churn', 'Demand', 'Fraud', 'Pricing'];

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Theme.of(context).dividerColor),
      ),
      child: SizedBox(
        height: 180,
        child: BarChart(
          BarChartData(
            barGroups: barGroups,
            gridData: FlGridData(
              show: true,
              drawVerticalLine: false,
              horizontalInterval: 4,
              getDrawingHorizontalLine: (_) =>
                  FlLine(color: Theme.of(context).dividerColor, strokeWidth: 1),
            ),
            titlesData: FlTitlesData(
              leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
              rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
              topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  getTitlesWidget: (value, meta) => Text(
                    labels[value.toInt()],
                    style: TextStyle(
                        fontSize: 10,
                        color: Theme.of(context).textTheme.bodyMedium?.color),
                  ),
                ),
              ),
            ),
            borderData: FlBorderData(show: false),
          ),
        ),
      ),
    );
  }

  void _showNotifications(BuildContext context, List<Map<String, dynamic>> alerts) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).cardTheme.color,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (_) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 8),
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Theme.of(context).dividerColor,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Alerts & Notifications',
                    style: Theme.of(context).textTheme.headlineMedium),
                const SizedBox(height: 16),
                ...alerts.map((a) => _AlertTile(alert: a)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _KPICard extends StatelessWidget {
  final String title;
  final String value;
  final double change;
  final IconData icon;
  final Gradient gradient;
  final bool isNegativeBetter;

  const _KPICard({
    required this.title,
    required this.value,
    required this.change,
    required this.icon,
    required this.gradient,
    this.isNegativeBetter = false,
  });

  @override
  Widget build(BuildContext context) {
    final isPositive = change >= 0;
    final isGood = isNegativeBetter ? !isPositive : isPositive;
    final changeColor = isGood ? AppTheme.successColor : AppTheme.errorColor;
    final changeIcon = isPositive
        ? Icons.arrow_upward_rounded
        : Icons.arrow_downward_rounded;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Theme.of(context).dividerColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  gradient: gradient,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: Colors.white, size: 18),
              ),
              Row(
                children: [
                  Icon(changeIcon, color: changeColor, size: 14),
                  Text(
                    '${change.abs().toStringAsFixed(1)}%',
                    style: TextStyle(
                        color: changeColor,
                        fontSize: 12,
                        fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(value,
              style: Theme.of(context)
                  .textTheme
                  .headlineLarge
                  ?.copyWith(fontSize: 22)),
          Text(title,
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(fontSize: 11),
              maxLines: 1,
              overflow: TextOverflow.ellipsis),
        ],
      ),
    );
  }
}

class _AlertTile extends StatelessWidget {
  final Map<String, dynamic> alert;
  const _AlertTile({required this.alert});

  @override
  Widget build(BuildContext context) {
    final typeData = {
      'warning': (AppTheme.warningColor, Icons.warning_amber_rounded),
      'error': (AppTheme.errorColor, Icons.error_outline_rounded),
      'success': (AppTheme.successColor, Icons.check_circle_outline_rounded),
      'info': (AppTheme.infoColor, Icons.info_outline_rounded),
    };
    final td = typeData[alert['type']] ??
        (AppTheme.infoColor, Icons.info_outline_rounded);

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: td.$1.withOpacity(0.08),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: td.$1.withOpacity(0.2)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(td.$2, color: td.$1, size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(alert['title'],
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium
                        ?.copyWith(fontSize: 13)),
                const SizedBox(height: 2),
                Text(alert['message'],
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.copyWith(fontSize: 12)),
              ],
            ),
          ),
          Text(alert['time'],
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(fontSize: 10)),
        ],
      ),
    );
  }
}
