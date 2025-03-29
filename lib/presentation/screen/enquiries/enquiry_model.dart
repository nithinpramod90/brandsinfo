class EnquiryModel {
  final int id;
  final String name;
  final String mobileNumber;
  final String? message;
  final int business;
  final String date;
  final String time;
  final bool isRead;
  final int user;

  EnquiryModel({
    required this.id,
    required this.name,
    required this.mobileNumber,
    this.message,
    required this.business,
    required this.date,
    required this.time,
    required this.isRead,
    required this.user,
  });

  factory EnquiryModel.fromJson(Map<String, dynamic> json) {
    return EnquiryModel(
      id: json['id'],
      name: json['name'],
      mobileNumber: json['mobile_number'],
      message: json['message'],
      business: json['buisness'],
      date: json['date'],
      time: json['time'],
      isRead: json['is_read'],
      user: json['user'],
    );
  }

  EnquiryModel copyWith({
    int? id,
    String? name,
    String? mobileNumber,
    String? message,
    int? business,
    String? date,
    String? time,
    bool? isRead,
    int? user,
  }) {
    return EnquiryModel(
      id: id ?? this.id,
      name: name ?? this.name,
      mobileNumber: mobileNumber ?? this.mobileNumber,
      message: message ?? this.message,
      business: business ?? this.business,
      date: date ?? this.date,
      time: time ?? this.time,
      isRead: isRead ?? this.isRead,
      user: user ?? this.user,
    );
  }
}
