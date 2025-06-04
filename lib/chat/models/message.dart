import 'package:equatable/equatable.dart';

enum MessageType { text, image, voice, video, document, location, contact }

enum MessageStatus { sending, sent, delivered, read }

class Message extends Equatable {
  final String id;
  final String senderId;
  final String receiverId;
  final String content;
  final DateTime timestamp;
  final MessageType type;
  final MessageStatus status;
  final Map<String, dynamic>? metadata;
  final String? replyToId;
  final bool isStarred;

  const Message({
    required this.id,
    required this.senderId,
    required this.receiverId,
    required this.content,
    required this.timestamp,
    required this.type,
    required this.status,
    required this.isStarred,
    this.metadata,
    this.replyToId,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      id: json['id'] as String,
      senderId: json['senderId'] as String,
      receiverId: json['receiverId'] as String,
      content: json['content'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
      type: MessageType.values.firstWhere((e) => e.toString().split('.').last == json['type']),
      status: MessageStatus.values.firstWhere((e) => e.toString() == 'MessageStatus.${json['status']}'),
      metadata: json['metadata'] as Map<String, dynamic>?,
      replyToId: json['replyToId'] as String?,
      isStarred: json['isStarred'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'senderId': senderId,
      'receiverId': receiverId,
      'content': content,
      'timestamp': timestamp.toIso8601String(),
      'type': type.toString().split('.').last,
      'status': status.toString().split('.').last,
      'metadata': metadata,
      'replyToId': replyToId,
      'isStarred': isStarred,
    };
  }

  Message copyWith({
    String? id,
    String? senderId,
    String? receiverId,
    String? content,
    DateTime? timestamp,
    MessageType? type,
    MessageStatus? status,
    Map<String, dynamic>? metadata,
    String? replyToId,
    bool? isStarred,
  }) {
    return Message(
      id: id ?? this.id,
      senderId: senderId ?? this.senderId,
      receiverId: receiverId ?? this.receiverId,
      content: content ?? this.content,
      timestamp: timestamp ?? this.timestamp,
      type: type ?? this.type,
      status: status ?? this.status,
      metadata: metadata ?? this.metadata,
      replyToId: replyToId ?? this.replyToId,
      isStarred: isStarred ?? this.isStarred,
    );
  }

  @override
  List<Object?> get props => [id, senderId, receiverId, content, timestamp, type, status, replyToId, metadata];
}
