part of 'chat_bloc.dart';

sealed class ChatEvent extends Equatable {
  const ChatEvent();

  @override
  List<Object> get props => [];
}

class InitializeChat extends ChatEvent {
  const InitializeChat();
}

class ShowEmojiPicker extends ChatEvent {
  const ShowEmojiPicker();
}

class ShowAttachmentMenu extends ChatEvent {
  const ShowAttachmentMenu();
}

class ShowRecordAudio extends ChatEvent {
  const ShowRecordAudio();
}

class ChangeFormValue extends ChatEvent {
  final Map<String, dynamic> formData;
  const ChangeFormValue({required this.formData});

  @override
  List<Object> get props => [formData];
}

class SendText extends ChatEvent {
  final String text;
  final String recipientId;
  final String? replyToId;

  const SendText({required this.text, required this.recipientId, this.replyToId});
}

class SendContact extends ChatEvent {
  final Map<String, dynamic> contact;
  final String recipientId;
  final String? replyToId;

  const SendContact({required this.contact, required this.recipientId, this.replyToId});
}

class SendLocation extends ChatEvent {
  final Map<String, dynamic> location;
  final String recipientId;
  final String? replyToId;

  const SendLocation({required this.location, required this.recipientId, this.replyToId});
}

class SendCameraCapture extends ChatEvent {
  final File file;
  final String recipientId;
  final String? replyToId;

  const SendCameraCapture({required this.file, required this.recipientId, this.replyToId});
}

class SendImage extends ChatEvent {
  final File file;
  final String recipientId;
  final String? replyToId;

  const SendImage({required this.file, required this.recipientId, this.replyToId});
}

class SendFile extends ChatEvent {
  final File file;
  final String recipientId;
  final String? replyToId;

  const SendFile({required this.file, required this.recipientId, this.replyToId});
}

class SendAudio extends ChatEvent {
  final File file;
  final String recipientId;
  final String? replyToId;

  const SendAudio({required this.file, required this.recipientId, this.replyToId});
}

class ReplyMessage extends ChatEvent {
  final Message? message;

  const ReplyMessage({required this.message});
}

class ForwardMessage extends ChatEvent {
  final Message message;
  final String recipientId;

  const ForwardMessage({required this.message, required this.recipientId});
}

class DeleteMessage extends ChatEvent {
  final String messageId;

  const DeleteMessage({required this.messageId});
}

class StarMessage extends ChatEvent {
  final String messageId;

  const StarMessage({required this.messageId});
}
