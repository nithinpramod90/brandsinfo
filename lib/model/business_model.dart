class Business {
  final int id;
  final String name;
  final String businessType;
  final String locality;
  final String? city;
  final String state;
  final int noOfViews;
  final int user;
  final String score;
  final String? image;

  Business({
    required this.id,
    required this.name,
    required this.businessType,
    required this.locality,
    this.city,
    required this.state,
    required this.noOfViews,
    required this.user,
    required this.score,
    this.image,
  });

  factory Business.fromJson(Map<String, dynamic> json) {
    return Business(
      id: json['id'],
      name: json['name'],
      businessType: json['buisness_type'],
      locality: json['locality'],
      city: json['city'],
      state: json['state'],
      noOfViews: json['no_of_views'],
      user: json['user'],
      score: json['score'],
      image: json['image'],
    );
  }
}

class UserProfile {
  final String mobileNumber;
  final String firstName;

  UserProfile({
    required this.mobileNumber,
    required this.firstName,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      mobileNumber: json['mobile_number'],
      firstName: json['first_name'],
    );
  }
}

class BusinessResponse {
  final UserProfile userProfile;
  final List<Business> businesses;

  BusinessResponse({
    required this.userProfile,
    required this.businesses,
  });

  factory BusinessResponse.fromJson(Map<String, dynamic> json) {
    return BusinessResponse(
      userProfile: UserProfile.fromJson(json['userprofile']),
      businesses: (json['buisnesses'] as List)
          .map((item) => Business.fromJson(item))
          .toList(),
    );
  }
}
