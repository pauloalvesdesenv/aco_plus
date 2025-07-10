extension DurationExt on Duration {
  String text() {
    return '${inHours}h${inMinutes % 60}m';
  }
}
