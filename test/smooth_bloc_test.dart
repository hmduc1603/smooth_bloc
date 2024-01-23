import 'package:flutter/material.dart';
import 'package:smooth_bloc/smooth_bloc.dart';

import 'login_view/login_view.dart';

void main() {
  // Setup SmoothBloc
  SmoothBloc().setUp();

  // Run App
  runApp(const TestApp());
}

class TestApp extends StatefulWidget {
  const TestApp({super.key});

  @override
  State<TestApp> createState() => _TestAppState();
}

class _TestAppState extends State<TestApp> {
  @override
  Widget build(BuildContext context) {
    return const LoginView();
  }
}
