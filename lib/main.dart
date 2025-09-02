import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart'; 
import 'services/game_service.dart';
import 'screens/player_setup_screen.dart';
import 'screens/tutorial_screen.dart'; 

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final prefs = await SharedPreferences.getInstance();
  final bool seenTutorial = prefs.getBool('seenTutorial') ?? false;

  runApp(
    ChangeNotifierProvider(
      create: (context) => GameService(),
      child: MyApp(seenTutorial: seenTutorial),
    ),
  );
}

class MyApp extends StatelessWidget {
  final bool seenTutorial;
  const MyApp({super.key, required this.seenTutorial});

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
      title: 'Undercover',
      theme: theme,
      debugShowCheckedModeBanner: false,
      home: seenTutorial ? const PlayerSetupScreen() : const TutorialScreen(),
    );
  }
}
