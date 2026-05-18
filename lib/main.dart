import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  final FlutterLocalization localization = FlutterLocalization.instance;
  await localization.ensureInitialized();

  localization.init(
    mapLocales: [
      MapLocale('en', const {
        'welcome': 'Welcome',
        'start': 'Get Started',
      }),
      MapLocale('ne', const {
        'welcome': 'स्वागत छ',
        'start': 'सुरु गर्नुहोस्',
      }),
    ],
    initLanguageCode: 'ne', // Default to Nepali
  );

  runApp(MyApp(localization: localization));
}

class MyApp extends StatelessWidget {
  final FlutterLocalization localization;

  const MyApp({super.key, required this.localization});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      supportedLocales: localization.supportedLocales,
      localizationsDelegates: localization.localizationsDelegates,
      locale: localization.currentLocale,
      home: const OnBoardingScreen(),
    );
  }
}


