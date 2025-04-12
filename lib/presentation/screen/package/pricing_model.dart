class Plan {
  final int id;
  final String planName;
  final List<PlanVariant> variants;
  final bool profileVisit;
  final bool averageTimeSpend;
  final bool chat;
  final bool searchPriority1;
  final bool imageGallery;
  final bool googleMap;
  final bool whatsappChat;
  final bool profileViewCount;
  final bool saRate;
  final bool keywords;
  final bool searchPriority2;
  final bool videoGallery;
  final bool biVerification;
  final bool productsAndServiceVisibility;
  final bool socialMediaPaidPromotion;
  final bool mostSearchedPS;
  final bool searchPriority3;
  final bool todaysOffer;
  final bool biAssured;
  final bool biCertification;

  Plan({
    required this.id,
    required this.planName,
    required this.variants,
    required this.profileVisit,
    required this.averageTimeSpend,
    required this.chat,
    required this.searchPriority1,
    required this.imageGallery,
    required this.googleMap,
    required this.whatsappChat,
    required this.profileViewCount,
    required this.saRate,
    required this.keywords,
    required this.searchPriority2,
    required this.videoGallery,
    required this.biVerification,
    required this.productsAndServiceVisibility,
    required this.socialMediaPaidPromotion,
    required this.mostSearchedPS,
    required this.searchPriority3,
    required this.todaysOffer,
    required this.biAssured,
    required this.biCertification,
  });

  factory Plan.fromJson(Map<String, dynamic> json) {
    return Plan(
      id: json['id'],
      planName: json['plan_name'],
      variants: (json['varients'] as List)
          .map((variant) => PlanVariant.fromJson(variant))
          .toList(),
      profileVisit: json['profile_visit'] ?? false,
      averageTimeSpend: json['average_time_spend'] ?? false,
      chat: json['chat'] ?? false,
      searchPriority1: json['search_priority_1'] ?? false,
      imageGallery: json['image_gallery'] ?? false,
      googleMap: json['google_map'] ?? false,
      whatsappChat: json['whatsapp_chat'] ?? false,
      profileViewCount: json['profile_view_count'] ?? false,
      saRate: json['sa_rate'] ?? false,
      keywords: json['keywords'] ?? false,
      searchPriority2: json['search_priority_2'] ?? false,
      videoGallery: json['video_gallery'] ?? false,
      biVerification: json['bi_verification'] ?? false,
      productsAndServiceVisibility:
          json['products_and_service_visibility'] ?? false,
      socialMediaPaidPromotion:
          json['social_media_paid_promotion_in_bi_youtube'] ?? false,
      mostSearchedPS: json['most_searhed_p_s'] ?? false,
      searchPriority3: json['search_priority_3'] ?? false,
      todaysOffer: json['todays_offer'] ?? false,
      biAssured: json['bi_assured'] ?? false,
      biCertification: json['bi_certification'] ?? false,
    );
  }
}

class PlanVariant {
  final int id;
  final String duration;
  final String price;
  final int planId;

  PlanVariant({
    required this.id,
    required this.duration,
    required this.price,
    required this.planId,
  });

  factory PlanVariant.fromJson(Map<String, dynamic> json) {
    return PlanVariant(
      id: json['id'],
      duration: json['duration'],
      price: json['price'],
      planId: json['plan'],
    );
  }
}
