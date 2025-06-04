import 'package:chatapp/common/common.dart';
import 'package:flutter/material.dart';
import 'routes.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    final UiHelper uiHelper = UiHelper();
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: Routes().router,
      theme: uiHelper.themeData(Constants.themeConfig.LIGHT),
    );
  }
}
