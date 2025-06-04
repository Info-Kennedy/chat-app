import 'package:chatapp/common/common.dart';
import 'package:chatapp/recipient/models/recipient.dart';
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';

class RecipientRepository {
  final log = Logger();
  GetIt getIt = GetIt.instance;
  final PreferencesRepository prefRepo;

  RecipientRepository({required this.prefRepo});

  Future<List<Recipient>> getRecipientList() async {
    try {
      await Future.delayed(const Duration(milliseconds: 500));
      return [
        const Recipient(id: '1', name: 'John Doe', email: 'john@example.com', avatarUrl: 'https://via.placeholder.com/150', isOnline: true),
        const Recipient(
          id: '2',
          name: 'Jane Smith',
          email: 'jane@example.com',
          avatarUrl: 'https://via.placeholder.com/150',
          isOnline: false,
          lastSeen: null,
        ),
        const Recipient(id: '3', name: 'Bob Johnson', email: 'bob@example.com', isOnline: true),
        const Recipient(
          id: '4',
          name: 'Alice Brown',
          email: 'alice@example.com',
          avatarUrl: 'https://via.placeholder.com/150',
          isOnline: false,
          lastSeen: null,
        ),
        const Recipient(id: '5', name: 'Charlie Wilson', email: 'charlie@example.com', isOnline: true),
      ];
    } catch (error) {
      log.e("RecipientRepository:::getRecipientList::Error: $error");
      throw Exception('$error');
    }
  }

  Future<Recipient?> getRecipientById(String id) async {
    final recipients = await getRecipientList();
    return recipients.firstWhere((recipient) => recipient.id == id);
  }
}
