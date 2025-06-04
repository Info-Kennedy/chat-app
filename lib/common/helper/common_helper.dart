import 'package:chatapp/chat/models/message.dart';
import 'package:chatapp/common/common.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';

class CommonHelper {
  final log = Logger();

  CommonHelper();

  String convertDateToAppDate(String date) {
    DateTime parsedDate = DateTime.parse(date);
    return DateFormat('dd.MM.yy | hh:mm a').format(parsedDate);
  }

  String convertDateTimeToTime(String date) {
    DateTime parsedDate = DateTime.parse(date);
    return DateFormat('hh:mm a').format(parsedDate);
  }

  MessageType getFileType(String filePath) {
    final extension = filePath.split('.').last.toLowerCase();
    if (['jpg', 'jpeg', 'png', 'gif', 'webp'].contains(extension)) {
      return MessageType.image;
    } else if (['mp4', 'mov', 'avi', 'wmv'].contains(extension)) {
      return MessageType.video;
    } else if (['mp3', 'wav', 'm4a', 'aac'].contains(extension)) {
      return MessageType.voice;
    } else {
      return MessageType.document;
    }
  }

  Future<void> alertDialog(
    BuildContext context,
    String? title,
    String message,
    String? negativeText,
    Function? negative,
    String postiveText,
    Function postive,
  ) async {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
          title: Text(
            title ?? Constants.APP_NAME,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Theme.of(context).colorScheme.primary),
          ),
          content: Text(message, style: Theme.of(context).textTheme.bodyMedium),
          actions: [
            negativeText?.isNotEmpty == true ? OutlinedButton(onPressed: () => negative!(), child: Text(negativeText!)) : const SizedBox.shrink(),
            postiveText.isNotEmpty ? FilledButton(onPressed: () => postive(), child: Text(postiveText)) : const SizedBox.shrink(),
          ],
        );
      },
    );
  }
}
