import 'dart:convert';
import 'dart:io';
import 'package:chatapp/chat/models/message.dart';
import 'package:path_provider/path_provider.dart';

class MessageRepository {
  static const String _fileName = 'chat_messages.json';
  static const String _archivedFileName = 'archived_messages.json';
  final List<Message> _messages = [];
  List<Message> _archivedMessages = [];

  Future<void> loadMessages() async {
    try {
      final file = await _getLocalFile();
      if (await file.exists()) {
        final contents = await file.readAsString();
        final List<dynamic> jsonList = json.decode(contents);
        _messages.clear();
        _messages.addAll(jsonList.map((json) => Message.fromJson(json)));
      } else {
        // Add sample messages if no messages exist
        await _addSampleMessages();
      }
    } catch (e) {
      _messages.clear();
      // Add sample messages if loading fails
      await _addSampleMessages();
    }
  }

  Future<void> _addSampleMessages() async {
    final now = DateTime.now();
    final sampleMessages = [
      Message(
        id: '1',
        senderId: 'current_user',
        receiverId: '1', // John Doe
        content: 'Hey John, how are you doing?',
        timestamp: now.subtract(const Duration(hours: 2)),
        type: MessageType.text,
        status: MessageStatus.read,
        isStarred: false,
      ),
      Message(
        id: '2',
        senderId: '1', // John Doe
        receiverId: 'current_user',
        content: 'Hi! I\'m doing great, thanks for asking. How about you?',
        timestamp: now.subtract(const Duration(hours: 1, minutes: 55)),
        type: MessageType.text,
        status: MessageStatus.read,
        isStarred: false,
      ),
      Message(
        id: '3',
        senderId: 'current_user',
        receiverId: '1', // John Doe
        content: 'I\'m good too! Just working on some new features for our chat app.',
        timestamp: now.subtract(const Duration(hours: 1, minutes: 50)),
        type: MessageType.text,
        status: MessageStatus.read,
        isStarred: false,
      ),
      Message(
        id: '4',
        senderId: '1', // John Doe
        receiverId: 'current_user',
        content: 'That sounds interesting! What kind of features are you working on?',
        timestamp: now.subtract(const Duration(hours: 1, minutes: 45)),
        type: MessageType.text,
        status: MessageStatus.read,
        isStarred: false,
      ),
      Message(
        id: '5',
        senderId: 'current_user',
        receiverId: '1', // John Doe
        content: 'I\'m adding support for file sharing, voice messages, and location sharing. Want to try it out?',
        timestamp: now.subtract(const Duration(hours: 1, minutes: 40)),
        type: MessageType.text,
        status: MessageStatus.read,
        isStarred: false,
      ),
    ];

    _messages.addAll(sampleMessages);
    await saveMessages();
  }

  Future<void> loadArchivedMessages() async {
    try {
      final file = await _getArchivedFile();
      if (await file.exists()) {
        final contents = await file.readAsString();
        final List<dynamic> jsonList = json.decode(contents);
        _archivedMessages = jsonList.map((json) => Message.fromJson(json)).toList();
      }
    } catch (e) {
      _archivedMessages.clear();
    }
  }

  Future<void> saveMessages() async {
    try {
      final file = await _getLocalFile();
      final jsonList = _messages.map((message) => message.toJson()).toList();
      await file.writeAsString(json.encode(jsonList));
    } catch (e) {
      // Handle error
    }
  }

  Future<void> saveArchivedMessages() async {
    try {
      final file = await _getArchivedFile();
      final jsonList = _archivedMessages.map((message) => message.toJson()).toList();
      await file.writeAsString(json.encode(jsonList));
    } catch (e) {
      // Handle error
    }
  }

  Future<File> _getLocalFile() async {
    final directory = await getApplicationDocumentsDirectory();
    return File('${directory.path}/$_fileName');
  }

  Future<File> _getArchivedFile() async {
    final directory = await getApplicationDocumentsDirectory();
    return File('${directory.path}/$_archivedFileName');
  }

  List<Message> getMessages({String? userId}) {
    if (userId != null) {
      return _messages.where((message) => message.senderId == userId || message.receiverId == userId).toList();
    }
    return _messages;
  }

  List<Message> getArchivedMessages() {
    return List.unmodifiable(_archivedMessages);
  }

  Future<void> addMessage(Message message) async {
    _messages.add(message);
    await saveMessages();
  }

  Future<void> updateMessage(Message message) async {
    final index = _messages.indexWhere((m) => m.id == message.id);
    if (index != -1) {
      _messages[index] = message;
      await saveMessages();
    }
  }

  Future<void> deleteMessage(String messageId) async {
    _messages.removeWhere((message) => message.id == messageId);
    await saveMessages();
  }

  Future<void> clearMessages() async {
    _messages.clear();
    await saveMessages();
  }

  List<Message> searchMessages(String query) {
    query = query.toLowerCase();
    return _messages.where((message) {
      if (message.type == MessageType.text) {
        return message.content.toLowerCase().contains(query);
      } else if (message.metadata != null) {
        final fileName = message.metadata!['fileName'] as String?;
        if (fileName != null) {
          return fileName.toLowerCase().contains(query);
        }
      }
      return false;
    }).toList();
  }

  Future<void> archiveMessage(String messageId) async {
    final message = _messages.firstWhere((m) => m.id == messageId);
    _messages.removeWhere((m) => m.id == messageId);
    _archivedMessages.add(message);
    await saveMessages();
    await saveArchivedMessages();
  }

  Future<void> unarchiveMessage(String messageId) async {
    final message = _archivedMessages.firstWhere((m) => m.id == messageId);
    _archivedMessages.removeWhere((m) => m.id == messageId);
    _messages.add(message);
    await saveMessages();
    await saveArchivedMessages();
  }

  Future<String> exportMessages() async {
    final jsonList = _messages.map((message) => message.toJson()).toList();
    return json.encode(jsonList);
  }

  Future<void> importMessages(String jsonString) async {
    try {
      final List<dynamic> jsonList = json.decode(jsonString);
      final importedMessages = jsonList.map((json) => Message.fromJson(json)).toList();
      _messages.addAll(importedMessages);
      await saveMessages();
    } catch (e) {
      // Handle error
    }
  }

  Future<void> createBackup() async {
    final directory = await getApplicationDocumentsDirectory();
    final backupDir = Directory('${directory.path}/backups');
    if (!await backupDir.exists()) {
      await backupDir.create();
    }

    final timestamp = DateTime.now().toIso8601String().replaceAll(':', '-');
    final backupFile = File('${backupDir.path}/backup_$timestamp.json');

    final backupData = {
      'messages': _messages.map((m) => m.toJson()).toList(),
      'archivedMessages': _archivedMessages.map((m) => m.toJson()).toList(),
      'timestamp': timestamp,
    };

    await backupFile.writeAsString(json.encode(backupData));
  }

  Future<void> restoreFromBackup(String backupPath) async {
    try {
      final file = File(backupPath);
      if (await file.exists()) {
        final contents = await file.readAsString();
        final backupData = json.decode(contents) as Map<String, dynamic>;

        _messages.clear();
        _archivedMessages.clear();

        _messages.addAll((backupData['messages'] as List).map((json) => Message.fromJson(json)));
        _archivedMessages.addAll((backupData['archivedMessages'] as List).map((json) => Message.fromJson(json)));

        await saveMessages();
        await saveArchivedMessages();
      }
    } catch (e) {
      // Handle error
    }
  }

  Future<List<String>> getAvailableBackups() async {
    final directory = await getApplicationDocumentsDirectory();
    final backupDir = Directory('${directory.path}/backups');
    if (!await backupDir.exists()) {
      return [];
    }

    final files = await backupDir.list().toList();
    return files.whereType<File>().map((file) => file.path).where((path) => path.endsWith('.json')).toList();
  }

  Future<void> updateMessageStatus(String messageId, MessageStatus status) async {
    final index = _messages.indexWhere((message) => message.id == messageId);
    if (index != -1) {
      final message = _messages[index];
      _messages[index] = message.copyWith(status: status);
      await saveMessages();
    }
  }
}
