import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'services/game_service.dart';
import 'screens/player_setup_screen.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => GameService(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    const Color primaryColor = Color(0xFF8F3985);
    const Color backgroundColor = Color(0xFF25283D); 
    const Color surfaceColor = Color(0xFF2E324D); 
    const Color textColor = Color(0xFFEFD9CE); 

    final theme = ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryColor,
        brightness: Brightness.dark,
        background: backgroundColor,
        surface: surfaceColor,
        onBackground: textColor,
        onSurface: textColor,
      ),
      scaffoldBackgroundColor: backgroundColor,
      textTheme: GoogleFonts.latoTextTheme(ThemeData.dark().textTheme).copyWith(
        displayMedium: GoogleFonts.poppins(fontWeight: FontWeight.bold, color: textColor),
        headlineSmall: GoogleFonts.poppins(fontWeight: FontWeight.w600, color: textColor),
        titleMedium: GoogleFonts.lato(fontWeight: FontWeight.bold, color: textColor),
        bodyMedium: GoogleFonts.lato(color: textColor),
      ),
    );

    return MaterialApp(
      title: 'Undercover Game',
      theme: theme,
      debugShowCheckedModeBanner: false,
      home: const PlayerSetupScreen(),
    );
  }
}
