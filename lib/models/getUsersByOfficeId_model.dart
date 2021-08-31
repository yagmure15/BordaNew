class UsersByOfficeId {
  final String fullName;
  final int departmentId;
  UsersByOfficeId({required this.fullName, required this.departmentId});

  factory UsersByOfficeId.fromJson(Map<String, dynamic> json) {
    return UsersByOfficeId(
      fullName: json['fullName'],
      departmentId: json['departmentId'],
    );
  }
}
