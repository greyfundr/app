// participants.dart
class Participant {
  final int id;
  final String name;
  final String username;
  final String imageUrl;

  Participant({
    required this.id,
    required this.name,
    required this.username,
    required this.imageUrl,
  });

  // ADD THIS COPY CONSTRUCTOR
  Participant.from(Participant other)
      : id = other.id,
        name = other.name,
        username = other.username,
        imageUrl = other.imageUrl;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'username': username,
      'imageUrl': imageUrl,
    };
  }
}