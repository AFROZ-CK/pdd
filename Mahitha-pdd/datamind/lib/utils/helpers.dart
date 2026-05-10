import 'package:intl/intl.dart';

class AppHelpers {
  // ── Date / Time ────────────────────────────────────────────────────
  static String formatDate(DateTime dt) =>
      DateFormat('MMM d, yyyy').format(dt);

  static String formatDateTime(DateTime dt) =>
      DateFormat('MMM d, yyyy • HH:mm').format(dt);

  static String timeAgo(DateTime dt) {
    final diff = DateTime.now().difference(dt);
    if (diff.inSeconds < 60) return '${diff.inSeconds}s ago';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    if (diff.inDays < 7) return '${diff.inDays}d ago';
    return formatDate(dt);
  }

  // ── Number formatting ──────────────────────────────────────────────
  static String formatNumber(num value) {
    if (value >= 1000000) return '${(value / 1000000).toStringAsFixed(1)}M';
    if (value >= 1000) return '${(value / 1000).toStringAsFixed(1)}K';
    return value.toStringAsFixed(0);
  }

  static String formatCurrency(double value) {
    final formatter = NumberFormat.currency(symbol: '\$', decimalDigits: 2);
    return formatter.format(value);
  }

  static String formatPercent(double value, {int decimals = 1}) =>
      '${value.toStringAsFixed(decimals)}%';

  static String formatFileSize(int bytes) {
    if (bytes >= 1073741824) return '${(bytes / 1073741824).toStringAsFixed(1)} GB';
    if (bytes >= 1048576) return '${(bytes / 1048576).toStringAsFixed(1)} MB';
    if (bytes >= 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    return '$bytes B';
  }

  // ── String helpers ─────────────────────────────────────────────────
  static String capitalize(String s) =>
      s.isEmpty ? s : s[0].toUpperCase() + s.substring(1).toLowerCase();

  static String titleCase(String s) =>
      s.split(' ').map(capitalize).join(' ');

  static String truncate(String s, int maxLength) =>
      s.length > maxLength ? '${s.substring(0, maxLength)}...' : s;

  static String getInitials(String name) {
    final parts = name.trim().split(' ');
    if (parts.length >= 2) {
      return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
    }
    return name.isNotEmpty ? name[0].toUpperCase() : '?';
  }

  // ── Validation ─────────────────────────────────────────────────────
  static bool isValidEmail(String email) =>
      RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);

  static bool isValidPassword(String password) => password.length >= 6;

  static bool isValidUrl(String url) =>
      Uri.tryParse(url)?.hasAbsolutePath ?? false;

  // ── Quality helpers ────────────────────────────────────────────────
  static String qualityLabel(double score) {
    if (score >= 90) return 'Excellent';
    if (score >= 75) return 'Good';
    if (score >= 60) return 'Fair';
    return 'Poor';
  }

  static String confidenceLabel(double confidence) {
    if (confidence >= 90) return 'High';
    if (confidence >= 75) return 'Medium';
    return 'Low';
  }

  // ── Alert type helpers ─────────────────────────────────────────────
  static String alertIcon(String type) {
    switch (type) {
      case 'warning': return '⚠️';
      case 'error': return '❌';
      case 'success': return '✅';
      default: return 'ℹ️';
    }
  }
}
