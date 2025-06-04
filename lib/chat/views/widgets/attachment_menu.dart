import 'dart:io';
import 'package:chatapp/chat/cubit/attachment/attachment_cubit.dart';
import 'package:chatapp/common/common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AttachmentMenu extends StatelessWidget {
  final Function(File) onFileSelected;
  final Function(File) onImageSelected;
  final Function(File) onCameraCapture;
  final Function(Map<String, dynamic>) onLocationSelected;
  final Function(Map<String, dynamic>) onContactSelected;

  const AttachmentMenu({
    super.key,
    required this.onFileSelected,
    required this.onImageSelected,
    required this.onCameraCapture,
    required this.onLocationSelected,
    required this.onContactSelected,
  });

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AttachmentCubit, AttachmentState>(
      listener: (context, state) {
        if (state.error) {
          ToastUtil.showErrorToast(context, state.errorMessage);
        }
        if (state.location.isNotEmpty) {
          onLocationSelected({'latitude': state.location['latitude'], 'longitude': state.location['longitude']});
        }
        if (state.file != null) {
          onFileSelected(state.file!);
        }
        if (state.image != null) {
          onImageSelected(state.image!);
        }
        if (state.camera != null) {
          onCameraCapture(state.camera!);
        }
        if (state.contact.isNotEmpty) {
          onContactSelected(state.contact);
        }
      },

      builder: (context, state) {
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(color: Colors.grey.withValues(alpha: 0.3), borderRadius: BorderRadius.circular(2)),
              ),
              GridView.count(
                shrinkWrap: true,
                crossAxisCount: 4,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: [
                  _buildAttachmentOption(
                    context,
                    icon: Icons.insert_drive_file,
                    label: 'Document',
                    onTap: context.read<AttachmentCubit>().pickDocument,
                  ),
                  _buildAttachmentOption(context, icon: Icons.photo, label: 'Gallery', onTap: context.read<AttachmentCubit>().pickImage),
                  _buildAttachmentOption(context, icon: Icons.camera_alt, label: 'Camera', onTap: context.read<AttachmentCubit>().captureCamera),
                  _buildAttachmentOption(
                    context,
                    icon: Icons.location_on,
                    label: 'Location',
                    onTap: context.read<AttachmentCubit>().sendCurrentLocation,
                  ),
                  _buildAttachmentOption(context, icon: Icons.contact_phone, label: 'Contact', onTap: context.read<AttachmentCubit>().pickContact),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildAttachmentOption(BuildContext context, {required IconData icon, required String label, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(color: Theme.of(context).colorScheme.primaryContainer, borderRadius: BorderRadius.circular(16)),
            child: Icon(icon, color: Theme.of(context).colorScheme.onPrimaryContainer, size: 28),
          ),
          const SizedBox(height: 8),
          Text(label, style: Theme.of(context).textTheme.bodySmall, textAlign: TextAlign.center),
        ],
      ),
    );
  }
}
