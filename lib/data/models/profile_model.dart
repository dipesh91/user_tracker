class ProfileModel {
  String fullName,
      email,
      phone,
      employeeId,
      designation,
      department,
      workLocation,
      avatarUrl,
      joiningDate;

  ProfileModel({
    required this.fullName,
    required this.email,
    required this.phone,
    required this.employeeId,
    required this.designation,
    required this.department,
    required this.workLocation,
    required this.avatarUrl,
    required this.joiningDate,
  });

  factory ProfileModel.fromJson({required Map<String, dynamic> json}) {
    return ProfileModel(
      fullName: json['full_name'] ?? 'Unknown',
      email: json['email'] ?? 'Unknown',
      phone: json['phone'] ?? 'Unknown',
      employeeId: json['employee_id'] ?? 'Unknown',
      designation: json['designation'] ?? 'Unknown',
      department: json['department'] ?? 'Unknown',
      workLocation: json['work_location'] ?? 'Unknown',
      avatarUrl: json['avatar_url'] ?? 'Unknown',
      joiningDate: json['joining_date'] ?? 'Unknown',
    );
  }

  Map<String, String> toMap() {
    return {
      'full_name': fullName,
      'email': email,
      'phone': phone,
      'employee_id': employeeId,
      'designation': designation,
      'department': department,
      'work_location': workLocation,
      'avatar_url': avatarUrl,
      'joining_date': joiningDate,
    };
  }
}
