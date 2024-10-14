class Patient {
  final String name;
  final String id;
  String status;
  final String admissionDate;
  final int age;
  final String drugOfChoice;
  final String gender;
  final String hivStatus;
  final String injectionFrequency;
  final String needleSharingHistory;

  Patient({
    required this.name,
    required this.id,
    required this.status,
    required this.admissionDate,
    required this.age,
    required this.drugOfChoice,
    required this.gender,
    required this.hivStatus,
    required this.injectionFrequency,
    required this.needleSharingHistory,
  }) {
    if (name.isEmpty) {
      throw ArgumentError('Patient name cannot be empty');
    }
  }

  factory Patient.fromMap(Map<String, dynamic> map) {
    return Patient(
      name: map['fullName'] as String? ?? 'Unknown',
      id: map['id'] as String? ?? '',
      status: map['status'] as String? ?? 'Active',
      admissionDate: map['admissionDate'] as String? ?? '',
      age: map['age'] is int
          ? map['age']
          : int.tryParse(map['age']?.toString() ?? '') ?? 22,
      drugOfChoice: map['drugOfChoice'] as String? ?? '',
      gender: map['gender'] as String? ?? '',
      hivStatus: map['hivStatus'] as String? ?? '',
      injectionFrequency: map['injectionFrequency'] as String? ?? '',
      needleSharingHistory: map['needleSharingHistory'] as String? ?? '',
    );
  }
}
