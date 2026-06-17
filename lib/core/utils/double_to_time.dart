String doubleToTime(double value) {
  final parts = value.toString().split('.');
  final hours = parts.first;
  final minutes = parts.length > 1 ? parts.last : '00';
  return '${hours}h ${minutes}m';
}
