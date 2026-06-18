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
}
