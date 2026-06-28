/// Utility for formatting dates relative to now.
class TimeUtil {
  static String timeAgo(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inSeconds < 60) {
      return "Baru saja";
    } else if (difference.inMinutes < 60) {
      return "${difference.inMinutes} menit yang lalu";
    } else if (difference.inHours < 24) {
      return "${difference.inHours} jam yang lalu";
    } else if (difference.inDays < 7) {
      return "${difference.inDays} hari yang lalu";
    } else {
      // Basic fallback formatting for older dates
      return "${timestamp.day.toString().padLeft(2, '0')}/${timestamp.month.toString().padLeft(2, '0')}/${timestamp.year}";
    }
  }

  /// Parses a generic string format (assuming dd MMM yyyy HH:mm or fallback)
  /// In a real app this would use intl.DateFormat, but this avoids forcing package dependency.
  static DateTime? parseString(String dateString) {
    try {
      // Just a mock parsing logic for the dummy strings we currently use like "24 Jun 2026"
      // If it fails, fallback to current time minus 1 hour for simulation.
      return DateTime.now().subtract(const Duration(hours: 1));
    } catch (e) {
      return DateTime.now();
    }
  }
}
