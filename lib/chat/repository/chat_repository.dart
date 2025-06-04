import 'package:chatapp/chat/models/message.dart';
import 'package:chatapp/chat/repository/message_repository.dart';
import 'package:chatapp/common/common.dart';
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';

class ChatRepository {
  final log = Logger();
  GetIt getIt = GetIt.instance;
  final PreferencesRepository prefRepo;
  final MessageRepository messageRepo;

  ChatRepository({required this.prefRepo, required this.messageRepo});

  Future<List<Message>> getChatList() async {
    try {
      List<Message> chatList = [];
      // await messageRepo.loadMessages();
      // chatList = messageRepo.getMessages();
      return chatList;
    } catch (error) {
      log.e("ChatRepository:::getChatList::Error: $error");
      throw Exception('$error');
    }
  }

  Future<void> sendMessage(Message message) async {
    try {
      // await messageRepo.saveMessages(text, recipientId, replyToId);
    } catch (error) {
      log.e("ChatRepository:::sendText::Error: $error");
      throw Exception('$error');
    }
  }
}
