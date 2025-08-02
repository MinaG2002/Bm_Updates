class RequestModel {
  final String id;
  final String name;
  final String ciscoNumber;
  final String location;
  final String phone;
  final String requestType;
  final String date;
  final String notes;

  RequestModel({
    required this.id,
    required this.name,
    required this.ciscoNumber,
    required this.location,
    required this.phone,
    required this.requestType,
    required this.date,
    required this.notes,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'ciscoNumber': ciscoNumber,
      'location': location,
      'phone': phone,
      'requestType': requestType,
      'date': date,
      'notes': notes,
    };
  }

  factory RequestModel.fromMap(String id, Map<String, dynamic> map) {
    return RequestModel(
      id: id,
      name: map['name'] ?? "",
      ciscoNumber: map['ciscoNumber'] ?? "",
      location: map['location'] ?? "",
      phone: map['phone'],
      requestType: map['requestType'] ?? "",
      date: map['date'] ?? "",
      notes: map['notes'] ?? "",
    );
  }
}
