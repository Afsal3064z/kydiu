class Member {
  final String id;
  final String sender;
  final String receiver;
  final bool approved; // Change type to bool
  final String createdAt;
  final String username;
  final String status;
  final String reciverId;
  final String senterId;

  Member({
    required this.username,
    required this.status,
    required this.id,
    required this.sender,
    required this.receiver,
    required this.approved,
    required this.createdAt,
    required this.senterId,
    required this.reciverId,
  });

  factory Member.fromJson(Map<String, dynamic> json) {
    return Member(
      id: json['_id'] ?? '',
      sender: json['sender']['name'] ?? '',
      receiver: json['receiver']['name'] ?? '',
      approved: json['approved'] ?? false,
      createdAt: json['createdAt'] ?? '',
      username: '',
      status: '',
      senterId: json['sender'] ?? '',
      reciverId: json['receiver'] ?? '',
    );
  }
}
