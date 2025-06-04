import 'package:chatapp/app/route_names.dart';
import 'package:chatapp/common/common.dart';
import 'package:chatapp/recipient/bloc/recipient_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:go_router/go_router.dart';

class RecipientMobile extends StatefulWidget {
  const RecipientMobile({super.key});

  @override
  State<RecipientMobile> createState() => _RecipientMobileState();
}

class _RecipientMobileState extends State<RecipientMobile> {
  final _formKey = GlobalKey<FormBuilderState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Chats')),
      floatingActionButton: FloatingActionButton(onPressed: () {}, child: const Icon(Icons.add)),
      body: BlocBuilder<RecipientBloc, RecipientState>(
        builder: (context, state) {
          return Container(
            color: Theme.of(context).colorScheme.primaryContainer.withValues(alpha: 0.2),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: FormBuilder(
                    key: _formKey,
                    onChanged: () {
                      _formKey.currentState?.save();
                      context.read<RecipientBloc>().add(ChangeFormValue(formData: _formKey.currentState!.value));
                    },
                    child: FormBuilderTextField(
                      name: "search",
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Theme.of(context).colorScheme.surfaceContainerLow,
                        hoverColor: Theme.of(context).colorScheme.surfaceContainer,
                        hint: Text("Search users...", style: Theme.of(context).textTheme.bodyMedium),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.3), width: 0.5),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
                        prefixIcon: Padding(padding: const EdgeInsets.all(8.0), child: const Icon(Icons.search)),
                      ),
                    ),
                  ),
                ),
                state.status == RecipientStatus.initial || state.status == RecipientStatus.loading
                    ? const Expanded(child: Center(child: LoaderWidget()))
                    : state.filteredChatList.isEmpty
                    ? Expanded(
                        child: Center(child: Text('No users found', style: Theme.of(context).textTheme.bodyMedium)),
                      )
                    : Expanded(
                        child: ListView.builder(
                          itemCount: state.filteredChatList.length,
                          itemBuilder: (context, index) {
                            final recipient = state.filteredChatList[index];
                            return ListTile(
                              leading: CircleAvatar(
                                backgroundImage: recipient.avatarUrl != null ? NetworkImage(recipient.avatarUrl!) : null,
                                child: recipient.avatarUrl == null ? Text(recipient.name[0]) : null,
                              ),
                              title: Text(recipient.name, style: Theme.of(context).textTheme.bodyMedium),
                              subtitle: Text(recipient.email, style: Theme.of(context).textTheme.bodySmall),
                              trailing: recipient.isOnline ? const Icon(Icons.circle, color: Colors.green, size: 12) : null,
                              onTap: () => context.goNamed(RouteNames.chat, extra: recipient),
                            );
                          },
                        ),
                      ),
              ],
            ),
          );
        },
      ),
    );
  }
}
