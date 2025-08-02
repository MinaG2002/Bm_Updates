class UserLogin {
  final String id;
  final String username;
  final String ciscoNumber;
  final String phone;
  final String password;
  final String leader;
  final String location;
  final String manger;
  final String suber;

  UserLogin({
    required this.password,
    required this.id,
    required this.username,
    required this.ciscoNumber,
    required this.phone,
    required this.leader,
    required this.location,
    required this.manger,
    required this.suber,
  });

  factory UserLogin.fromMap(String id, Map<String, dynamic> data) {
    return UserLogin(
      id: id,
      username: data['username'],
      ciscoNumber: data['cisco'],
      phone: data['phone'],
      password: data['password'],
      leader: data["Leader"],
      location: data["Location"],
      manger: data["Manger"],
      suber: data["Suber"],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "password": password,
      'username': username,
      'cisco': ciscoNumber,
      'phone': phone,
    };
  }
}
