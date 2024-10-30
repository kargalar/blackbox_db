extension DurationFormatting on Duration {
  String formatTime() {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    final minutes = twoDigits(inMinutes.remainder(60));
    final seconds = twoDigits(inSeconds.remainder(60));

    return [minutes, seconds].join(':');
  }
}

extension IntFormatting on int {
  String secondToTime() {
    final int hours = this ~/ 3600;
    final int minutes = this % 3600 ~/ 60;
    final int remainingSeconds = this % 60;

    return "${hours}h ${minutes}m ${remainingSeconds}s";
  }
}
