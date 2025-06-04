import 'package:equatable/equatable.dart';

class Recipient extends Equatable {
  final String id;
  final String name;
  final String email;
  final String? avatarUrl;
  final bool isOnline;
  final DateTime? lastSeen;

  const Recipient({required this.id, required this.name, required this.email, this.avatarUrl, this.isOnline = false, this.lastSeen});

  static Recipient empty = Recipient(id: "", name: "", email: "");

  factory Recipient.fromJson(Map<String, dynamic> json) {
    return Recipient(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      avatarUrl: json['avatarUrl'] as String?,
      isOnline: json['isOnline'] as bool? ?? false,
      lastSeen: json['lastSeen'] != null ? DateTime.parse(json['lastSeen'] as String) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name, 'email': email, 'avatarUrl': avatarUrl, 'isOnline': isOnline, 'lastSeen': lastSeen?.toIso8601String()};
  }

  Recipient copyWith({String? id, String? name, String? email, String? avatarUrl, bool? isOnline, DateTime? lastSeen}) {
    return Recipient(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      isOnline: isOnline ?? this.isOnline,
      lastSeen: lastSeen ?? this.lastSeen,
    );
  }

  @override
  List<Object?> get props => [id, name, email, avatarUrl, isOnline, lastSeen];
}
