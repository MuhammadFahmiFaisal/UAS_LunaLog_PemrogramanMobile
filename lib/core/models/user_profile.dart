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

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      avatarUrl: json['avatar_url'] as String?,
      lastPeriodDate: json['last_period_date'] != null 
          ? DateTime.parse(json['last_period_date'] as String) 
          : null,
      periodDuration: json['period_duration'] as int? ?? 5,
      cycleLength: json['cycle_length'] as int? ?? 28,
      goal: json['goal'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'avatar_url': avatarUrl,
      'last_period_date': lastPeriodDate?.toIso8601String().split('T')[0],
      'period_duration': periodDuration,
      'cycle_length': cycleLength,
      'goal': goal,
    };
  }
}
