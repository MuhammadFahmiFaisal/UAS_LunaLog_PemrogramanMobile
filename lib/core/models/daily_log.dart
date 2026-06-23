enum FlowLevel { none, light, medium, heavy }

enum Mood { happy, calm, sad, anxious, angry, tired }

class DailyLog {
  final String id;
  final DateTime date;
  final FlowLevel flow;
  final List<String> symptoms;
  final Mood? mood;
  final bool? sexualActivity;
  final String? notes;

  const DailyLog({
    required this.id,
    required this.date,
    this.flow = FlowLevel.none,
    this.symptoms = const [],
    this.mood,
    this.sexualActivity,
    this.notes,
  });

  DailyLog copyWith({
    FlowLevel? flow,
    List<String>? symptoms,
    Mood? mood,
    bool? sexualActivity,
    String? notes,
  }) {
    return DailyLog(
      id: id,
      date: date,
      flow: flow ?? this.flow,
      symptoms: symptoms ?? this.symptoms,
      mood: mood ?? this.mood,
      sexualActivity: sexualActivity ?? this.sexualActivity,
      notes: notes ?? this.notes,
    );
  }

  factory DailyLog.fromJson(Map<String, dynamic> json) {
    return DailyLog(
      id: json['id'] as String,
      date: DateTime.parse(json['log_date'] as String),
      flow: FlowLevel.values.firstWhere(
        (e) => e.name == json['flow'],
        orElse: () => FlowLevel.none,
      ),
      symptoms: (json['symptoms'] as List<dynamic>?)?.map((e) => e as String).toList() ?? [],
      mood: json['mood'] != null
          ? Mood.values.firstWhere(
              (e) => e.name == json['mood'],
              orElse: () => Mood.happy,
            )
          : null,
      sexualActivity: json['sexual_activity'] as bool?,
      notes: json['notes'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'log_date': date.toIso8601String().split('T')[0],
      'flow': flow.name,
      'symptoms': symptoms,
      'mood': mood?.name,
      'sexual_activity': sexualActivity,
      'notes': notes,
    };
  }
}
