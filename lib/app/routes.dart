import 'package:chatapp/chat/views/chat_page.dart';
import 'package:chatapp/common/common.dart';
import 'package:chatapp/recipient/models/recipient.dart';
import 'package:chatapp/recipient/view/recipient_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'route_names.dart';

class Routes {
  /// The route configuration.
  GoRouter router = GoRouter(
    initialLocation: '/recipient',
    routes: [
      GoRoute(
        name: RouteNames.recipient,
        path: '/recipient',
        builder: (BuildContext context, GoRouterState state) {
          RouteHistory.push({'/recipient': state.extra});
          return const RecipientPage();
        },
      ),
      GoRoute(
        name: RouteNames.chat,
        path: '/chat',
        builder: (BuildContext context, GoRouterState state) {
          RouteHistory.push({'/chat': state.extra});
          return ChatPage(recipient: state.extra as Recipient);
        },
      ),
    ],
    redirect: (BuildContext context, GoRouterState state) {
      return state.matchedLocation;
    },
    debugLogDiagnostics: true,
    // changes on the listenable will cause the router to refresh it's route
    // refreshListenable: GoRouterRefreshStream(_loginBloc.stream),
  );
}
