import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:esnaf_pos/firebase_options.dart';
import 'package:esnaf_pos/main_layout.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('tr_TR', null);
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    const Color primaryBlue = Color(0xFF0D47A1);
    const Color backgroundWhite = Colors.white;
    const Color panelGrey = Color(0xFFF5F5F5);
    const Color dividerGrey = Color(0xFFE0E0E0);
    const Color textBlack = Color(0xFF212121);

    return MaterialApp(
      title: 'Esnaf POS',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: primaryBlue,
        scaffoldBackgroundColor: backgroundWhite,
        canvasColor: panelGrey,
        dividerColor: dividerGrey,
        fontFamily: 'Helvetica',
        colorScheme: ColorScheme.fromSeed(
          seedColor: primaryBlue,
          primary: primaryBlue,
          background: backgroundWhite,
        ),
        useMaterial3: true,
        textTheme: Theme.of(context).textTheme.apply(
              fontFamily: 'Helvetica',
              bodyColor: textBlack,
              displayColor: textBlack,
            ),
        appBarTheme: const AppBarTheme(
          backgroundColor: primaryBlue,
          foregroundColor: Colors.white,
          elevation: 2,
          centerTitle: true,
          titleTextStyle: TextStyle(
            fontFamily: 'Helvetica',
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: primaryBlue,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            textStyle: const TextStyle(
              fontFamily: 'Helvetica',
              fontWeight: FontWeight.w700,
              fontSize: 16,
            ),
          ),
        ),
        cardTheme: CardThemeData(
          elevation: 1,
          color: panelGrey,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(0), // Genel kartlar keskin kalsın
          ),
        ),
      ),
      home: const MainLayout(),
    );
  }
}