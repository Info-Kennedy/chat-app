part of 'recipient_bloc.dart';

enum RecipientStatus { initial, loading, changing, changed, loaded, success, error }

class RecipientState extends Equatable {
  final String message;
  final RecipientStatus status;
  final List<Recipient> chatList;
  final List<Recipient> filteredChatList;

  const RecipientState({required this.status, required this.message, required this.chatList, required this.filteredChatList});

  static RecipientState initial = RecipientState(message: "", status: RecipientStatus.initial, chatList: [], filteredChatList: []);

  RecipientState copyWith({
    RecipientStatus Function()? status,
    String Function()? message,
    List<Recipient> Function()? chatList,
    List<Recipient> Function()? filteredChatList,
  }) {
    return RecipientState(
      status: status != null ? status() : this.status,
      message: message != null ? message() : this.message,
      chatList: chatList != null ? chatList() : this.chatList,
      filteredChatList: filteredChatList != null ? filteredChatList() : this.filteredChatList,
    );
  }

  @override
  List<Object?> get props => [status, message, chatList, filteredChatList];
}
