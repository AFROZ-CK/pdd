import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import 'dart:async';
import '../../providers/analytics_provider.dart';
import '../../theme/app_theme.dart';

class RealtimeScreen extends StatefulWidget {
  const RealtimeScreen({super.key});

  @override
  State<RealtimeScreen> createState() => _RealtimeScreenState();
}

class _RealtimeScreenState extends State<RealtimeScreen> {
  Timer? _timer;
  bool _isStreaming = false;
  final List<Map<String, dynamic>> _events = [];
  double _threshold = 90.0;

  @override
  void initState() {
    super.initState();
    _loadInitialEvents();
  }

  void _loadInitialEvents() {
    _events.addAll([
      {'time': '17:48:01', 'source': 'Sensor-A1', 'value': 87.3, 'status': 'normal'},
      {'time': '17:47:58', 'source': 'Model-XGB', 'value': 96.2, 'status': 'high'},
      {'time': '17:47:55', 'source': 'Sensor-B2', 'value': 72.1, 'status': 'normal'},
      {'time': '17:47:52', 'source': 'API-Stream', 'value': 104.5, 'status': 'alert'},
      {'time': '17:47:49', 'source': 'Sensor-A1', 'value': 88.9, 'status': 'normal'},
    ]);
  }

  void _startStreaming() {
    setState(() => _isStreaming = true);
    _timer = Timer.periodic(const Duration(milliseconds: 1500), (_) {
      final analytics = context.read<AnalyticsProvider>();
      analytics.addRealtimePoint();
      final now = DateTime.now();
      final value = analytics.realtimeData.last;
      final status = value > _threshold ? 'alert' : value > 80 ? 'high' : 'normal';
      setState(() {
        _events.insert(0, {
          'time': '${now.hour.toString().padLeft(2, '0')}:'
              '${now.minute.toString().padLeft(2, '0')}:'
              '${now.second.toString().padLeft(2, '0')}',
          'source': ['Sensor-A1', 'Model-XGB', 'API-Stream', 'Sensor-B2'][now.second % 4],
          'value': double.parse(value.toStringAsFixed(1)),
          'status': status,
        });
        if (_events.length > 20) _events.removeLast();
      });
    });
  }

  void _stopStreaming() {
    _timer?.cancel();
    setState(() => _isStreaming = false);
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final analytics = context.watch<AnalyticsProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Real-Time Decision Engine'),
        automaticallyImplyLeading: false,
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            child: Row(
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: _isStreaming ? AppTheme.successColor : AppTheme.errorColor,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  _isStreaming ? 'LIVE' : 'OFFLINE',
                  style: TextStyle(
                    color: _isStreaming ? AppTheme.successColor : AppTheme.errorColor,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.2,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Stream control
            _buildStreamControl(),
            const SizedBox(height: 20),

            // Live chart
            Text('Live Data Stream',
                style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: 12),
            _buildLiveChart(analytics),
            const SizedBox(height: 20),

            // Threshold control
            _buildThresholdControl(),
            const SizedBox(height: 20),

            // Decision cards
            Text('Decision Recommendations',
                style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: 12),
            _buildDecisionCards(analytics),
            const SizedBox(height: 20),

            // Event log
            Text('Event Log',
                style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: 12),
            _buildEventLog(),
            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }

  Widget _buildStreamControl() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: _isStreaming
              ? [AppTheme.successColor.withOpacity(0.15), AppTheme.accentColor.withOpacity(0.05)]
              : [AppTheme.errorColor.withOpacity(0.1), AppTheme.errorColor.withOpacity(0.05)],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: _isStreaming
              ? AppTheme.successColor.withOpacity(0.3)
              : AppTheme.errorColor.withOpacity(0.2),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: (_isStreaming ? AppTheme.successColor : AppTheme.errorColor)
                  .withOpacity(0.15),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(
              _isStreaming ? Icons.stream_rounded : Icons.stream_rounded,
              color: _isStreaming ? AppTheme.successColor : AppTheme.errorColor,
              size: 24,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _isStreaming ? 'Stream Active' : 'Stream Inactive',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                Text(
                  _isStreaming
                      ? 'Receiving data at 1.5s intervals'
                      : 'Tap Start to begin real-time stream',
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(fontSize: 12),
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: _isStreaming ? _stopStreaming : _startStreaming,
            style: ElevatedButton.styleFrom(
              backgroundColor: _isStreaming ? AppTheme.errorColor : AppTheme.successColor,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            child: Text(_isStreaming ? 'Stop' : 'Start'),
          ),
        ],
      ),
    );
  }

  Widget _buildLiveChart(AnalyticsProvider analytics) {
    final data = analytics.realtimeData;
    if (data.isEmpty) return const SizedBox();

    final spots = data.asMap().entries
        .map((e) => FlSpot(e.key.toDouble(), e.value))
        .toList();

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
              Text(
                '${data.last.toStringAsFixed(1)} units',
                style: Theme.of(context)
                    .textTheme
                    .headlineLarge
                    ?.copyWith(color: AppTheme.accentColor),
              ),
              if (_isStreaming)
                Row(
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: AppTheme.successColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 4),
                    const Text('LIVE',
                        style: TextStyle(
                            color: AppTheme.successColor,
                            fontSize: 11,
                            fontWeight: FontWeight.w700)),
                  ],
                ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 180,
            child: LineChart(
              LineChartData(
                minY: 20,
                maxY: 130,
                gridData: FlGridData(
                  show: true,
                  horizontalInterval: 20,
                  getDrawingHorizontalLine: (_) => FlLine(
                    color: Theme.of(context).dividerColor,
                    strokeWidth: 1,
                  ),
                  drawVerticalLine: false,
                ),
                titlesData: const FlTitlesData(
                  leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                ),
                borderData: FlBorderData(show: false),
                extraLinesData: ExtraLinesData(
                  horizontalLines: [
                    HorizontalLine(
                      y: _threshold,
                      color: AppTheme.errorColor.withOpacity(0.6),
                      strokeWidth: 1.5,
                      dashArray: [6, 4],
                      label: HorizontalLineLabel(
                        show: true,
                        style: const TextStyle(
                            color: AppTheme.errorColor, fontSize: 10),
                        labelResolver: (_) => 'Threshold: ${_threshold.toInt()}',
                      ),
                    ),
                  ],
                ),
                lineBarsData: [
                  LineChartBarData(
                    spots: spots,
                    isCurved: true,
                    gradient: const LinearGradient(
                      colors: [AppTheme.accentColor, AppTheme.primaryColor],
                    ),
                    barWidth: 2.5,
                    isStrokeCapRound: true,
                    dotData: const FlDotData(show: false),
                    belowBarData: BarAreaData(
                      show: true,
                      gradient: LinearGradient(
                        colors: [
                          AppTheme.accentColor.withOpacity(0.2),
                          AppTheme.accentColor.withOpacity(0.0),
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

  Widget _buildThresholdControl() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Theme.of(context).dividerColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Alert Threshold',
                  style: Theme.of(context).textTheme.titleMedium),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppTheme.errorColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '${_threshold.toInt()} units',
                  style: const TextStyle(
                      color: AppTheme.errorColor, fontWeight: FontWeight.w700),
                ),
              ),
            ],
          ),
          Slider(
            value: _threshold,
            min: 50,
            max: 120,
            divisions: 70,
            activeColor: AppTheme.errorColor,
            inactiveColor: AppTheme.errorColor.withOpacity(0.2),
            onChanged: (v) => setState(() => _threshold = v),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('50', style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 11)),
              Text('120', style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 11)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDecisionCards(AnalyticsProvider analytics) {
    final value = analytics.realtimeData.isNotEmpty
        ? analytics.realtimeData.last
        : 75.0;

    final decisions = [
      {
        'action': value > _threshold ? 'SCALE UP' : 'MAINTAIN',
        'reason': value > _threshold
            ? 'Current load exceeds threshold — scale resources'
            : 'System operating within normal parameters',
        'confidence': value > _threshold ? 89.3 : 94.7,
        'priority': value > _threshold ? 'HIGH' : 'LOW',
        'color': value > _threshold ? AppTheme.errorColor : AppTheme.successColor,
        'icon': value > _threshold ? Icons.trending_up_rounded : Icons.check_circle_outline_rounded,
      },
      {
        'action': 'ANALYZE DRIFT',
        'reason': 'Periodic model drift analysis recommended',
        'confidence': 78.5,
        'priority': 'MEDIUM',
        'color': AppTheme.warningColor,
        'icon': Icons.compare_arrows_rounded,
      },
      {
        'action': 'CACHE RESULTS',
        'reason': 'High prediction frequency — enable caching',
        'confidence': 91.2,
        'priority': 'LOW',
        'color': AppTheme.infoColor,
        'icon': Icons.cached_rounded,
      },
    ];

    return Column(
      children: decisions.map((d) {
        final color = d['color'] as Color;
        return Container(
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: color.withOpacity(0.07),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: color.withOpacity(0.2)),
          ),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(d['icon'] as IconData, color: color, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(d['action'] as String,
                            style: TextStyle(
                                color: color,
                                fontWeight: FontWeight.w700,
                                fontSize: 13)),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: color.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(d['priority'] as String,
                              style: TextStyle(
                                  color: color, fontSize: 10, fontWeight: FontWeight.w600)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(d['reason'] as String,
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium
                            ?.copyWith(fontSize: 12)),
                  ],
                ),
              ),
              Text('${(d['confidence'] as double).toStringAsFixed(1)}%',
                  style: TextStyle(
                      color: color, fontWeight: FontWeight.w600, fontSize: 13)),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildEventLog() {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Theme.of(context).dividerColor),
      ),
      child: Column(
        children: _events.take(8).map((e) {
          final statusColor = e['status'] == 'alert'
              ? AppTheme.errorColor
              : e['status'] == 'high'
                  ? AppTheme.warningColor
                  : AppTheme.successColor;
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: Theme.of(context).dividerColor,
                  width: 0.5,
                ),
              ),
            ),
            child: Row(
              children: [
                Text(e['time'],
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.copyWith(fontSize: 11, fontFamily: 'monospace')),
                const SizedBox(width: 12),
                Container(
                  width: 6,
                  height: 6,
                  decoration: BoxDecoration(
                    color: statusColor,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(e['source'],
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.copyWith(fontSize: 12)),
                ),
                Text('${e['value']} u',
                    style: TextStyle(
                        color: statusColor,
                        fontWeight: FontWeight.w600,
                        fontSize: 12)),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}
