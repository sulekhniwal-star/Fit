enum MedicationTimeOfDay {
  morning,
  afternoon,
  evening,
  night,
}

enum MedicationStatus {
  scheduled,
  taken,
  skipped,
}

class MedicationEntry {
  final String id;
  final String userId;
  final String name;
  final String dosage;
  final MedicationTimeOfDay timeOfDay;
  final MedicationStatus status;
  final DateTime scheduledDate;

  const MedicationEntry({
    required this.id,
    required this.userId,
    required this.name,
    required this.dosage,
    required this.timeOfDay,
    this.status = MedicationStatus.scheduled,
    required this.scheduledDate,
  });

  MedicationEntry copyWith({
    String? id,
    String? userId,
    String? name,
    String? dosage,
    MedicationTimeOfDay? timeOfDay,
    MedicationStatus? status,
    DateTime? scheduledDate,
  }) {
    return MedicationEntry(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      name: name ?? this.name,
      dosage: dosage ?? this.dosage,
      timeOfDay: timeOfDay ?? this.timeOfDay,
      status: status ?? this.status,
      scheduledDate: scheduledDate ?? this.scheduledDate,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'user_id': userId,
        'name': name,
        'dosage': dosage,
        'time_of_day': timeOfDay.name,
        'status': status.name,
        'scheduled_date': scheduledDate.toIso8601String(),
      };

  factory MedicationEntry.fromJson(Map<String, dynamic> json) {
    return MedicationEntry(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      name: json['name'] as String? ?? '',
      dosage: json['dosage'] as String? ?? '',
      timeOfDay: MedicationTimeOfDay.values.firstWhere(
        (t) => t.name == json['time_of_day'],
        orElse: () => MedicationTimeOfDay.morning,
      ),
      status: MedicationStatus.values.firstWhere(
        (s) => s.name == json['status'],
        orElse: () => MedicationStatus.scheduled,
      ),
      scheduledDate: DateTime.tryParse(json['scheduled_date'] as String? ?? '') ?? DateTime.now(),
    );
  }
}

