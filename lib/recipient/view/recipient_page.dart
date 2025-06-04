import 'package:chatapp/common/common.dart';
import 'package:chatapp/recipient/bloc/recipient_bloc.dart';
import 'package:chatapp/recipient/repository/recipient_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'recipient_mobile.dart';

class RecipientPage extends StatelessWidget {
  const RecipientPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RecipientBloc(repository: RecipientRepository(prefRepo: getIt<PreferencesRepository>()))..add(InitializeRecipient()),
      child: RecipientMobile(),
    );
  }
}
