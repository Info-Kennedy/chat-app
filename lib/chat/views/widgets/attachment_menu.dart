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
          padding: const EdgeInsets.only(top: 24, left: 0, right: 0, bottom: 16),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  const SizedBox(width: 10),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.black),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  Expanded(
                    child: Center(
                      child: Text('Share Content', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w500)),
                    ),
                  ),
                  SizedBox(width: 48), // To balance the close icon
                ],
              ),
              const SizedBox(height: 8),
              _buildListOption(
                context,
                icon: Icons.camera_alt,
                title: 'Camera',
                subtitle: 'Take a photo',
                onTap: context.read<AttachmentCubit>().captureCamera,
              ),
              _divider(),
              _buildListOption(
                context,
                icon: Icons.insert_drive_file,
                title: 'Documents',
                subtitle: 'Share your files',
                onTap: context.read<AttachmentCubit>().pickDocument,
              ),
              _divider(),
              _buildListOption(context, icon: Icons.poll, title: 'Create a poll', subtitle: 'Create a poll for any querry', onTap: () {}),
              _divider(),
              _buildListOption(
                context,
                icon: Icons.photo,
                title: 'Media',
                subtitle: 'Share photos and videos',
                onTap: context.read<AttachmentCubit>().pickImage,
              ),
              _divider(),
              _buildListOption(
                context,
                icon: Icons.contact_phone,
                title: 'Contact',
                subtitle: 'Share your contacts',
                onTap: context.read<AttachmentCubit>().pickContact,
              ),
              _divider(),
              _buildListOption(
                context,
                icon: Icons.location_on,
                title: 'Location',
                subtitle: 'Share your location',
                onTap: context.read<AttachmentCubit>().sendCurrentLocation,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _divider() => const Divider(height: 1, thickness: 0.5, indent: 16, endIndent: 16);

  Widget _buildListOption(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(color: Colors.grey.withValues(alpha: 0.12), shape: BoxShape.circle),
              child: Icon(icon, color: Colors.black54, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w500)),
                  const SizedBox(height: 2),
                  Text(subtitle, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.black54)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
