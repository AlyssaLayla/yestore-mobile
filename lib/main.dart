import 'package:flutter/material.dart';
import 'package:yestore_mobile/screens/menu.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:yestore_mobile/screens/login.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Provider(
      create: (_) {
        CookieRequest request = CookieRequest();
        return request;
      },
    child: MaterialApp(
      title: 'YESTORE',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: Colors.red,
        ).copyWith(secondary: const Color.fromARGB(255, 236, 125, 125)),
        useMaterial3: true,
      ),
      home: const LoginPage(),
    ),
    );
  }
}


