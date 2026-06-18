class UserProfile {
  final String id;
  final String name;
  final String email;
  final String? avatarUrl;
  final DateTime? lastPeriodDate;
  final int periodDuration;
  final int cycleLength;
  final String? goal;

  const UserProfile({
    required this.id,
    required this.name,
    required this.email,
    this.avatarUrl,
    this.lastPeriodDate,
    this.periodDuration = 5,
    this.cycleLength = 28,
    this.goal,
  });

  UserProfile copyWith({
    String? name,
    String? email,
    String? avatarUrl,
    DateTime? lastPeriodDate,
    int? periodDuration,
    int? cycleLength,
    String? goal,
  }) {
    return UserProfile(
      id: id,
      name: name ?? this.name,
      email: email ?? this.email,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      lastPeriodDate: lastPeriodDate ?? this.lastPeriodDate,
      periodDuration: periodDuration ?? this.periodDuration,
      cycleLength: cycleLength ?? this.cycleLength,
      goal: goal ?? this.goal,
    );
  }
}
