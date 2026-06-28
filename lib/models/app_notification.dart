class AppNotification {
  String? id;
  String title;
  String message;
  bool isRead;
  String type; // Appointment Created, Payment Success, etc.
  DateTime createdAt;

  AppNotification({
    this.id,
    required this.title,
    required this.message,
    this.isRead = false,
    required this.type,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  factory AppNotification.fromJson(Map<String, dynamic> json) {
    return AppNotification(
      id: json['id'],
      title: json['title'],
      message: json['message'],
      isRead: json['isRead'] ?? false,
      type: json['type'],
      createdAt: json['createdAt'] != null ? DateTime.tryParse(json['createdAt']) ?? DateTime.now() : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'message': message,
      'isRead': isRead,
      'type': type,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
