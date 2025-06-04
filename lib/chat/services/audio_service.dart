import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:record/record.dart';
import 'package:just_audio/just_audio.dart';

class AudioService {
  final _audioRecorder = AudioRecorder();
  String? _currentRecordingPath;

  Future<bool> startRecording() async {
    final status = await Permission.microphone.request();
    if (status.isGranted) {
      final directory = await getApplicationDocumentsDirectory();
      _currentRecordingPath = '${directory.path}/voice_message_${DateTime.now().millisecondsSinceEpoch}.m4a';

      try {
        await _audioRecorder.start(RecordConfig(encoder: AudioEncoder.aacLc, bitRate: 128000, sampleRate: 44100), path: _currentRecordingPath!);
        return true;
      } catch (e) {
        _currentRecordingPath = null;
        return false;
      }
    }
    return false;
  }

  Future<bool> pauseRecording() async {
    try {
      await _audioRecorder.pause();
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> resumeRecording() async {
    try {
      await _audioRecorder.resume();
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<String?> stopRecording() async {
    try {
      await _audioRecorder.stop();
      return _currentRecordingPath;
    } catch (e) {
      return null;
    } finally {
      _currentRecordingPath = null;
    }
  }

  Future<void> dispose() async {
    await _audioRecorder.dispose();
  }

  Future<bool> isRecording() async {
    return await _audioRecorder.isRecording();
  }

  Future<Duration?> getDuration(String filePath) async {
    try {
      final file = File(filePath);
      if (await file.exists()) {
        final audioPlayer = AudioPlayer();
        await audioPlayer.setFilePath(filePath);
        final duration = audioPlayer.duration;
        await audioPlayer.dispose();
        return duration;
      }
    } catch (e) {
      return null;
    }
    return null;
  }
}
