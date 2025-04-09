class Business {
  final int id;
  final String name;
  final String? description;
  final String buildingName;
  final String locality;
  final String? city;
  final String state;
  final String pincode;
  final String? opensAt;
  final String? closesAt;
  final String? since;
  final String instagramLink;
  final String facebookLink;
  final String webLink;
  final String xLink;
  final String youtubeLink;
  final String whatsappNumber;
  final String inchargeNumber;
  final String? email;
  final String managerName;
  final int noOfViews;
  final String? image;
  final Plan plan;
  final String score;

  Business({
    required this.id,
    required this.name,
    this.description,
    required this.buildingName,
    required this.locality,
    this.city,
    required this.state,
    required this.pincode,
    this.opensAt,
    this.closesAt,
    this.since,
    required this.instagramLink,
    required this.facebookLink,
    required this.webLink,
    required this.xLink,
    required this.youtubeLink,
    required this.whatsappNumber,
    required this.inchargeNumber,
    this.email,
    required this.managerName,
    required this.noOfViews,
    this.image,
    required this.plan,
    required this.score,
  });

  factory Business.fromJson(Map<String, dynamic> json) {
    return Business(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      buildingName: json['building_name'],
      locality: json['locality'],
      city: json['city'],
      state: json['state'],
      pincode: json['pincode'],
      opensAt: json['opens_at'],
      closesAt: json['closes_at'],
      since: json['since'],
      instagramLink: json['instagram_link'] ?? '',
      facebookLink: json['facebook_link'] ?? '',
      webLink: json['web_link'] ?? '',
      xLink: json['x_link'] ?? '',
      youtubeLink: json['youtube_link'] ?? '',
      whatsappNumber: json['whatsapp_number'],
      inchargeNumber: json['incharge_number'] ?? '',
      email: json['email'],
      managerName: json['manager_name'] ?? '',
      noOfViews: json['no_of_views'],
      image: json['image'],
      plan: Plan.fromJson(json['plan']),
      score: json['score'],
    );
  }
}

class Plan {
  final String planName;
  final bool profileVisit;
  final bool imageGallery;
  final bool googleMap;
  final bool whatsappChat;
  final bool profileViewCount;
  final bool videoGallery;
  final bool biVerification;
  final bool productsAndServiceVisibility;
  final bool biAssured;
  final bool biCertification;
  final bool keywords;
  final bool averageTimeSpend;
  final bool saRate;

  Plan({
    required this.planName,
    required this.profileVisit,
    required this.imageGallery,
    required this.googleMap,
    required this.whatsappChat,
    required this.profileViewCount,
    required this.videoGallery,
    required this.biVerification,
    required this.productsAndServiceVisibility,
    required this.biAssured,
    required this.biCertification,
    required this.keywords,
    required this.averageTimeSpend,
    required this.saRate,
  });

  factory Plan.fromJson(Map<String, dynamic> json) {
    return Plan(
      planName: json['plan_name'],
      profileVisit: json['profile_visit'],
      imageGallery: json['image_gallery'],
      googleMap: json['google_map'],
      whatsappChat: json['whatsapp_chat'],
      profileViewCount: json['profile_view_count'],
      videoGallery: json['video_gallery'],
      biVerification: json['bi_verification'],
      productsAndServiceVisibility: json['products_and_service_visibility'],
      biAssured: json['bi_assured'],
      biCertification: json['bi_certification'],
      keywords: json['keywords'],
      averageTimeSpend: json['average_time_spend'],
      saRate: json['sa_rate'],
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
      userProfile: UserProfile.fromJson(json['user']),
      businesses: (json['buisnesses'] as List)
          .map((item) => Business.fromJson(item))
          .toList(),
    );
  }
}
