import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../theme/app_theme.dart';
import 'dashboard/dashboard_screen.dart';
import 'analytics/predictive_screen.dart';
import 'analytics/realtime_screen.dart';
import 'data/data_management_screen.dart';
import 'data/gap_analysis_screen.dart';
import 'reports/reports_screen.dart';
import 'settings/settings_screen.dart';

class MainNavScreen extends StatefulWidget {
  const MainNavScreen({super.key});

  @override
  State<MainNavScreen> createState() => _MainNavScreenState();
}

class _MainNavScreenState extends State<MainNavScreen> {
  int _selectedIndex = 0;

  final List<_NavItem> _navItems = [
    _NavItem(icon: Icons.dashboard_rounded, label: 'Dashboard'),
    _NavItem(icon: Icons.auto_graph_rounded, label: 'Predict'),
    _NavItem(icon: Icons.stream_rounded, label: 'Real-Time'),
    _NavItem(icon: Icons.storage_rounded, label: 'Data'),
    _NavItem(icon: Icons.more_horiz_rounded, label: 'More'),
  ];

  late final List<Widget> _screens = [
    const DashboardScreen(),
    const PredictiveScreen(),
    const RealtimeScreen(),
    const DataManagementScreen(),
    _MoreScreen(onSelect: (i) => _showMoreOption(i)),
  ];

  void _showMoreOption(int index) {
    final screens = [
      const GapAnalysisScreen(),
      const ReportsScreen(),
      const SettingsScreen(),
    ];
    if (index < screens.length) {
      Navigator.push(
          context, MaterialPageRoute(builder: (_) => screens[index]));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _screens,
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildBottomNav() {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: Theme.of(context).dividerColor,
            width: 1,
          ),
        ),
      ),
      child: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (i) => setState(() => _selectedIndex = i),
        items: _navItems
            .map((item) => BottomNavigationBarItem(
                  icon: Icon(item.icon),
                  label: item.label,
                ))
            .toList(),
      ),
    );
  }
}

class _NavItem {
  final IconData icon;
  final String label;
  _NavItem({required this.icon, required this.label});
}

class _MoreScreen extends StatelessWidget {
  final Function(int) onSelect;
  const _MoreScreen({required this.onSelect});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final user = auth.user;

    final items = [
      _MoreTile(
        icon: Icons.heatmap_sharp,
        label: 'Gap Analysis',
        subtitle: 'Identify & bridge data gaps',
        gradient: AppTheme.warningGradient,
        index: 0,
      ),
      _MoreTile(
        icon: Icons.bar_chart_rounded,
        label: 'Reports',
        subtitle: 'Insights & trend analysis',
        gradient: AppTheme.successGradient,
        index: 1,
      ),
      _MoreTile(
        icon: Icons.settings_rounded,
        label: 'Settings',
        subtitle: 'App preferences & config',
        gradient: AppTheme.purpleGradient,
        index: 2,
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('More'),
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // User profile card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppTheme.primaryColor.withOpacity(0.15),
                    AppTheme.accentColor.withOpacity(0.05),
                  ],
                ),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                    color: AppTheme.primaryColor.withOpacity(0.2)),
              ),
              child: Row(
                children: [
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      gradient: AppTheme.primaryGradient,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Center(
                      child: Text(
                        user?.initials ?? 'DM',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          user?.name ?? 'DataMind User',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          user?.role ?? 'Analyst',
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(color: AppTheme.primaryColor),
                        ),
                        Text(
                          user?.email ?? '',
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(fontSize: 11),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            Text('Features',
                style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: 16),

            ...items.map((item) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: GestureDetector(
                    onTap: () => onSelect(item.index),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardTheme.color,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                            color: Theme.of(context).dividerColor),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                              gradient: item.gradient,
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: Icon(item.icon,
                                color: Colors.white, size: 24),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(item.label,
                                    style:
                                        Theme.of(context).textTheme.titleMedium),
                                Text(item.subtitle,
                                    style:
                                        Theme.of(context).textTheme.bodyMedium),
                              ],
                            ),
                          ),
                          Icon(Icons.chevron_right,
                              color: Theme.of(context).dividerColor),
                        ],
                      ),
                    ),
                  ),
                )),

            const SizedBox(height: 24),

            // Sign out
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () async {
                  await context.read<AuthProvider>().logout();
                  if (context.mounted) {
                    Navigator.pushNamedAndRemoveUntil(
                        context, '/login', (_) => false);
                  }
                },
                icon: const Icon(Icons.logout_rounded,
                    color: AppTheme.errorColor),
                label: const Text('Sign Out',
                    style: TextStyle(color: AppTheme.errorColor)),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  side: BorderSide(
                      color: AppTheme.errorColor.withOpacity(0.3)),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MoreTile {
  final IconData icon;
  final String label;
  final String subtitle;
  final Gradient gradient;
  final int index;
  _MoreTile({
    required this.icon,
    required this.label,
    required this.subtitle,
    required this.gradient,
    required this.index,
  });
}
