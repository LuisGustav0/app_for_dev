import 'package:flutter/material.dart';

import 'package:app_for_dev/ui/pages/pages.dart';

class App extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Dev',
      debugShowCheckedModeBanner: false,
      home: LoginPage(),
    );
  }
}