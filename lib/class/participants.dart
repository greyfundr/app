class Participant {
  final int id;
  final String name;
  final String username;
  final String imageUrl;

  Participant({required this.id, required this.name, required this.username, required this.imageUrl});

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'username': username,
      'imageUrl': imageUrl,
    };
  }
}