class Period {
  final String id;
  final DateTime startDate;
  final DateTime? endDate;
  final int? durationDays;

  const Period({
    required this.id,
    required this.startDate,
    this.endDate,
    this.durationDays,
  });

  bool get isActive => endDate == null;

  int get dayCount {
    if (endDate == null) return 0;
    return endDate!.difference(startDate).inDays + 1;
  }
}
