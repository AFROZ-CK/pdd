import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/theme_provider.dart';
import '../../theme/app_theme.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notificationsEnabled = true;
  bool _alertsEnabled = true;
  bool _weeklyReport = true;
  bool _autoRefresh = true;
  String _refreshInterval = '5 minutes';
  String _apiEndpoint = 'https://api.datamind.ai/v1';

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();
    final auth = context.watch<AuthProvider>();
    final user = auth.user;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
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
            // Profile section
            _buildSectionHeader('Account'),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppTheme.primaryColor.withOpacity(0.12),
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
                          fontSize: 22,
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
                        Text(user?.name ?? 'DataMind User',
                            style: Theme.of(context).textTheme.titleLarge),
                        Text(user?.email ?? '',
                            style: Theme.of(context).textTheme.bodyMedium),
                        const SizedBox(height: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: AppTheme.primaryColor.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(user?.role ?? 'Analyst',
                              style: const TextStyle(
                                  color: AppTheme.primaryColor,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600)),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.edit_rounded,
                        color: AppTheme.primaryColor),
                    onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Profile edit coming soon')),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 28),

            // Appearance
            _buildSectionHeader('Appearance'),
            _buildSettingsCard([
              _SettingsTile(
                icon: Icons.dark_mode_rounded,
                label: 'Dark Mode',
                subtitle: 'Use dark theme across the app',
                trailing: Switch(
                  value: themeProvider.isDark,
                  onChanged: (_) => themeProvider.toggleTheme(),
                  activeColor: AppTheme.primaryColor,
                ),
              ),
            ]),
            const SizedBox(height: 20),

            // Notifications
            _buildSectionHeader('Notifications'),
            _buildSettingsCard([
              _SettingsTile(
                icon: Icons.notifications_rounded,
                label: 'Push Notifications',
                subtitle: 'Receive model and data alerts',
                trailing: Switch(
                  value: _notificationsEnabled,
                  onChanged: (v) => setState(() => _notificationsEnabled = v),
                  activeColor: AppTheme.primaryColor,
                ),
              ),
              _SettingsTile(
                icon: Icons.warning_amber_rounded,
                label: 'Alert Notifications',
                subtitle: 'Get notified on threshold breaches',
                trailing: Switch(
                  value: _alertsEnabled,
                  onChanged: (v) => setState(() => _alertsEnabled = v),
                  activeColor: AppTheme.primaryColor,
                ),
              ),
              _SettingsTile(
                icon: Icons.bar_chart_rounded,
                label: 'Weekly Report',
                subtitle: 'Receive weekly analytics digest',
                trailing: Switch(
                  value: _weeklyReport,
                  onChanged: (v) => setState(() => _weeklyReport = v),
                  activeColor: AppTheme.primaryColor,
                ),
              ),
            ]),
            const SizedBox(height: 20),

            // Data & Sync
            _buildSectionHeader('Data & Sync'),
            _buildSettingsCard([
              _SettingsTile(
                icon: Icons.refresh_rounded,
                label: 'Auto-Refresh',
                subtitle: 'Automatically refresh data',
                trailing: Switch(
                  value: _autoRefresh,
                  onChanged: (v) => setState(() => _autoRefresh = v),
                  activeColor: AppTheme.primaryColor,
                ),
              ),
              _SettingsTile(
                icon: Icons.timer_outlined,
                label: 'Refresh Interval',
                subtitle: _refreshInterval,
                onTap: () => _showRefreshIntervalPicker(context),
              ),
              _SettingsTile(
                icon: Icons.api_rounded,
                label: 'API Endpoint',
                subtitle: _apiEndpoint,
                onTap: () => _showApiEndpointDialog(context),
              ),
            ]),
            const SizedBox(height: 20),

            // Analytics
            _buildSectionHeader('Analytics Platform'),
            _buildSettingsCard([
              _SettingsTile(
                icon: Icons.model_training_rounded,
                label: 'Default Model',
                subtitle: 'XGBoost',
                onTap: () {},
              ),
              _SettingsTile(
                icon: Icons.storage_rounded,
                label: 'Cache Size',
                subtitle: '256 MB',
                onTap: () {},
              ),
              _SettingsTile(
                icon: Icons.delete_outline_rounded,
                label: 'Clear Cache',
                subtitle: 'Free up 47.3 MB',
                iconColor: AppTheme.errorColor,
                onTap: () => ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Cache cleared!')),
                ),
              ),
            ]),
            const SizedBox(height: 20),

            // About
            _buildSectionHeader('About DataMind'),
            _buildSettingsCard([
              _SettingsTile(
                icon: Icons.info_outline_rounded,
                label: 'Version',
                subtitle: '1.0.0 (Build 2024.01)',
              ),
              _SettingsTile(
                icon: Icons.school_rounded,
                label: 'Project',
                subtitle: 'Intelligent Predictive Analytics Platform',
              ),
              _SettingsTile(
                icon: Icons.description_outlined,
                label: 'Licenses',
                onTap: () {},
              ),
              _SettingsTile(
                icon: Icons.privacy_tip_outlined,
                label: 'Privacy Policy',
                onTap: () {},
              ),
            ]),
            const SizedBox(height: 20),

            // Sign out
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () async {
                  await auth.logout();
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
            const SizedBox(height: 32),

            Center(
              child: Text(
                'DataMind AI • v1.0.0\n© 2024 DataMind Platform',
                textAlign: TextAlign.center,
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(fontSize: 11),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Text(title, style: Theme.of(context).textTheme.headlineMedium),
    );
  }

  Widget _buildSettingsCard(List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Theme.of(context).dividerColor),
      ),
      child: Column(
        children: children.asMap().entries.map((e) {
          final isLast = e.key == children.length - 1;
          return Column(
            children: [
              e.value,
              if (!isLast) Divider(height: 1, color: Theme.of(context).dividerColor),
            ],
          );
        }).toList(),
      ),
    );
  }

  void _showRefreshIntervalPicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).cardTheme.color,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (_) => Column(
        mainAxisSize: MainAxisSize.min,
        children: ['1 minute', '5 minutes', '15 minutes', '30 minutes', '1 hour']
            .map((interval) => ListTile(
                  title: Text(interval),
                  trailing: _refreshInterval == interval
                      ? const Icon(Icons.check_rounded,
                          color: AppTheme.primaryColor)
                      : null,
                  onTap: () {
                    setState(() => _refreshInterval = interval);
                    Navigator.pop(context);
                  },
                ))
            .toList(),
      ),
    );
  }

  void _showApiEndpointDialog(BuildContext context) {
    final controller = TextEditingController(text: _apiEndpoint);
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: Theme.of(context).cardTheme.color,
        title: const Text('API Endpoint'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            prefixIcon: Icon(Icons.api_rounded),
            hintText: 'https://api.example.com/v1',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() => _apiEndpoint = controller.text);
              Navigator.pop(context);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String? subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;
  final Color? iconColor;

  const _SettingsTile({
    required this.icon,
    required this.label,
    this.subtitle,
    this.trailing,
    this.onTap,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      leading: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: (iconColor ?? AppTheme.primaryColor).withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: iconColor ?? AppTheme.primaryColor, size: 18),
      ),
      title: Text(label, style: Theme.of(context).textTheme.titleMedium),
      subtitle: subtitle != null
          ? Text(subtitle!,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 12),
              maxLines: 1,
              overflow: TextOverflow.ellipsis)
          : null,
      trailing: trailing ??
          (onTap != null
              ? Icon(Icons.chevron_right,
                  color: Theme.of(context).dividerColor)
              : null),
      onTap: onTap,
    );
  }
}
