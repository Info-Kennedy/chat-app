part of 'chat_bloc.dart';

enum ChatStatus { initial, loading, changing, changed, loaded, sending, sent, forwarding, forwarded, error, deleting, deleted, success, starred }

class ChatState extends Equatable {
  final String message;
  final ChatStatus status;
  final List<Message> messageList;
  final bool isRecording;
  final Recipient recipient;
  final bool showEmojiPicker;
  final bool showAttachmentMenu;
  final File? selectedFile;
  final Message? replyingTo;
  final String messageText;

  const ChatState({
    required this.status,
    required this.message,
    required this.messageList,
    required this.recipient,
    required this.isRecording,
    required this.showEmojiPicker,
    required this.showAttachmentMenu,
    required this.selectedFile,
    required this.replyingTo,
    required this.messageText,
  });

  static ChatState initial = ChatState(
    message: "",
    status: ChatStatus.initial,
    messageList: [],
    recipient: Recipient.empty,
    isRecording: false,
    showEmojiPicker: false,
    showAttachmentMenu: false,
    selectedFile: null,
    replyingTo: null,
    messageText: "",
  );

  ChatState copyWith({
    ChatStatus Function()? status,
    String Function()? message,
    List<Message> Function()? messageList,
    Recipient Function()? recipient,
    bool Function()? isRecording,
    bool Function()? showEmojiPicker,
    bool Function()? showAttachmentMenu,
    File? Function()? selectedFile,
    Message? Function()? replyingTo,
    String Function()? messageText,
  }) {
    return ChatState(
      status: status != null ? status() : this.status,
      message: message != null ? message() : this.message,
      messageList: messageList != null ? messageList() : this.messageList,
      recipient: recipient != null ? recipient() : this.recipient,
      isRecording: isRecording != null ? isRecording() : this.isRecording,
      showEmojiPicker: showEmojiPicker != null ? showEmojiPicker() : this.showEmojiPicker,
      showAttachmentMenu: showAttachmentMenu != null ? showAttachmentMenu() : this.showAttachmentMenu,
      selectedFile: selectedFile != null ? selectedFile() : this.selectedFile,
      replyingTo: replyingTo != null ? replyingTo() : this.replyingTo,
      messageText: messageText != null ? messageText() : this.messageText,
    );
  }

  @override
  List<Object?> get props => [
    status,
    message,
    messageList,
    recipient,
    isRecording,
    showEmojiPicker,
    showAttachmentMenu,
    selectedFile,
    replyingTo,
    messageText,
  ];
}
