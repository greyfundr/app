import 'dart:io';

import 'participants.dart';
import 'dart:convert';

class Campaign {
   String title = '';
   String description = '';
   File? imageUrl;
   String startDate = '';
   String endDate = '';
   String amount = '';
   String category = '';
   List<Participant> participants = [];
   List<File> images = [];
   List<Map<String, String>> savedAutoOffers = [];
   List<Map<String, String>> savedManualOffers = [];

   Campaign(String name, String desc, String aCategory, List<Map<String, String>> mOffers, List<Map<String, String>> aOffers) {
     title = name;
     description = desc;
     category = aCategory;
     savedAutoOffers = aOffers;
     savedManualOffers = mOffers;
   }

   void setName(String newName) {
     title = newName;
     // You can add logic here, like validation or updating the UI state in Flutter

   }

   void setCampaignDetails(String startDate, String endDate, File mainImage, String amount,List<Participant> participant,List<File> image) {
     this.startDate = startDate;
     this.endDate= endDate;
     imageUrl = mainImage;
     this.amount = amount;
     participants = participant;
     images = image;
     // You can add logic here, like validation or updating the UI state in Flutter

   }

   void setImages(List<File> image) {
     images = image;
     // You can add logic here, like validation or updating the UI state in Flutter

   }

   void setParticipants(List<Participant> participant) {
     participants = participant;
     // You can add logic here, like validation or updating the UI state in Flutter

   }

   void setStartDate(List<File> image) {
     images = image;
     // You can add logic here, like validation or updating the UI state in Flutter

   }
}