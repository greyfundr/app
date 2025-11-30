import 'dart:io';
import 'participants.dart';
// import 'dart:convert';

class Campaign {
  int id = 0;
  String title = '';
  String description = '';
  File? imageUrl;                    // main/cover image
  String startDate = '';
  String endDate = '';
  double amount = 0.0;
  String category = '';
  List<Participant> participants = [];
  List<File> images = [];            // all campaign images (carousel)
  List<Map<String, String>> savedAutoOffers = [];
  List<Map<String, String>> savedManualOffers = [];
  DateTime? created_at;
  double currentAmount = 0.0;

  // Old constructor (you were using this)
  Campaign(String name, String desc, String aCategory, List<Map<String, String>> mOffers, List<Map<String, String>> aOffers) {
    title = name;
    description = desc;
    category = aCategory;
    savedAutoOffers = aOffers;
    savedManualOffers = mOffers;
  }

  // NEW: Copy constructor — THIS FIXES YOUR ERROR
  Campaign.from(Campaign other)
      : id = other.id,
        title = other.title,
        description = other.description,
        imageUrl = other.imageUrl,
        startDate = other.startDate,
        endDate = other.endDate,
        amount = other.amount,
        category = other.category,
        participants = other.participants.map((p) => Participant.from(p)).toList(),
        images = List<File>.from(other.images),
        savedAutoOffers = List<Map<String, String>>.from(other.savedAutoOffers),
        savedManualOffers = List<Map<String, String>>.from(other.savedManualOffers),
        created_at = other.created_at,
        currentAmount = other.currentAmount;

  // Your existing setter methods (kept all of them)
  void setName(String newName) => title = newName;

  void setId(int id) => this.id = id;

  void setCurrentAmount(double currentAmount) => this.currentAmount = currentAmount;

  void setCampaignDetails(String startDate, String endDate, File mainImage, double amount, List<Participant> participant, List<File> image) {
    this.startDate = startDate;
    this.endDate = endDate;
    imageUrl = mainImage;
    this.amount = amount;
    participants = participant;
    images = image;
  }

  void setCreationTime(DateTime created_at) => this.created_at = created_at;

  void setImages(List<File> image) => images = image;

  void setParticipants(List<Participant> participant) => participants = participant;

  // Fixed: You had a wrong method named setStartDate that was setting images!
  // Removed it — use setCampaignDetails instead

  Map<String, dynamic> toJson() {
    return {
      'name': title,
      'value': description,
      // Add more fields when sending to backend
    };
  }
}