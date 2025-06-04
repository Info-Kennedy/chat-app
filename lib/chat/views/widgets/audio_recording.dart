import 'package:chatapp/chat/cubit/audio/audio_recorder_cubit.dart';
import 'package:chatapp/chat/services/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:async';

class AudioRecording extends StatefulWidget {
  final Function(String path) onRecordingComplete;

  const AudioRecording({super.key, required this.onRecordingComplete});

  @override
  State<AudioRecording> createState() => _AudioRecordingState();
}

class _AudioRecordingState extends State<AudioRecording> {
  final AudioService _audioRecorder = AudioService();
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    context.read<AudioRecorderCubit>().startRecording();
  }

  String _formatDuration(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    return '$minutes:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  @override
  void dispose() {
    _timer?.cancel();
    _audioRecorder.stopRecording();
    _audioRecorder.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AudioRecorderCubit, AudioRecorderState>(
      listener: (context, state) async {
        if (state.isRecording) {
          _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
            context.read<AudioRecorderCubit>().updateDuration();
          });
          await _audioRecorder.startRecording();
        } else if (state.isPaused) {
          await _audioRecorder.pauseRecording();
          _timer?.cancel();
        } else if (state.isResumed) {
          _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
            context.read<AudioRecorderCubit>().updateDuration();
          });
          await _audioRecorder.resumeRecording();
        } else if (state.isStopped) {
          _timer?.cancel();
          await _audioRecorder.stopRecording();
          await _audioRecorder.dispose();
        } else if (state.isSending) {
          widget.onRecordingComplete(state.filePath);
          await _audioRecorder.dispose();
          _timer?.cancel();
        }
      },
      builder: (context, state) {
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Row(
                  children: [
                    Text(_formatDuration(state.duration.inSeconds), style: Theme.of(context).textTheme.bodyMedium),
                    const SizedBox(width: 16),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: () {
                      context.read<AudioRecorderCubit>().dispose();
                    },
                    icon: Icon(Icons.delete, color: Theme.of(context).colorScheme.error, size: 28),
                  ),
                  IconButton(
                    onPressed: () {
                      if (state.isRecording) {
                        context.read<AudioRecorderCubit>().pauseRecording();
                      } else {
                        context.read<AudioRecorderCubit>().resumeRecording();
                      }
                    },
                    icon: Icon(state.isRecording ? Icons.pause_circle : Icons.play_circle, color: Theme.of(context).colorScheme.primary, size: 28),
                  ),
                  IconButton(
                    onPressed: () {
                      context.read<AudioRecorderCubit>().sendRecording();
                    },
                    icon: Icon(Icons.send, color: Theme.of(context).colorScheme.onPrimary, size: 20),
                    style: IconButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      fixedSize: const Size(30, 30),
                      shape: const CircleBorder(),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
