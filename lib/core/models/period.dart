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

  factory Period.fromJson(Map<String, dynamic> json) {
    return Period(
      id: json['id'] as String,
      startDate: DateTime.parse(json['start_date'] as String),
      endDate: json['end_date'] != null 
          ? DateTime.parse(json['end_date'] as String) 
          : null,
      durationDays: json['duration_days'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'start_date': startDate.toIso8601String().split('T')[0],
      'end_date': endDate?.toIso8601String().split('T')[0],
      'duration_days': durationDays,
    };
  }
}
