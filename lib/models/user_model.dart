class UserModel {
  final String email;
  final int frequency;
  final String phone;
  final int point;
  final String username;
  final double weight;

  UserModel({
    required this.email,
    required this.frequency,
    required this.phone,
    required this.point,
    required this.username,
    required this.weight,
  });

  // Convert from Firebase Map
  factory UserModel.fromMap(Map<String, dynamic> data) {
    return UserModel(
      email: data['email'] ?? '',
      frequency: data['frequency'] ?? 0,
      phone: data['phone'] ?? '',
      point: data['point'] ?? 0,
      username: data['username'] ?? '',
      weight: (data['weight'] ?? 0).toDouble(),
    );
  }

  // Convert to Map (optional, for updates)
  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'frequency': frequency,
      'phone': phone,
      'point': point,
      'username': username,
      'weight': weight,
    };
  }
}