class TimeFormatter {
  static String formatTime(int minutes) {
    if (minutes < 1) return 'Llegando';
    if (minutes == 1) return '1 min';
    return '$minutes min';
  }

  static String formatTimeDisplay(String time, {bool format12h = false}) {
    if (!format12h) return time;

    final parts = time.split(':');
    final hour = int.parse(parts[0]);
    final minute = parts[1];

    final ampm = hour >= 12 ? 'PM' : 'AM';
    final displayHour = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);

    return '$displayHour:$minute $ampm';
  }

  static String getCurrentTime() {
    final now = DateTime.now();
    final hours = now.hour.toString().padLeft(2, '0');
    final minutes = now.minute.toString().padLeft(2, '0');
    return '$hours:$minutes';
  }
}
