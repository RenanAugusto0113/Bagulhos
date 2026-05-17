import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'views/home_view.dart';
import 'package:google_fonts/google_fonts.dart';

void main() async {
  /* Se não houver .env com chave API, então usa uma de fallback
a API KEY do fallback é a mesma para todos e portanto não é recomendada. */
  try {
    await dotenv.load(fileName: ".env");
  } catch (fallback) {
    await dotenv.load(fileName: ".env.example");
    print(
      '[!] .env não encontrado | Usando API KEY de fallback (não recomendado)',
    );
  }
  runApp(const BagulhosApp());
}

class BagulhosApp extends StatelessWidget {
  const BagulhosApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bagulhos',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.lightBlue,
        scaffoldBackgroundColor: Colors.black87,
        textTheme: GoogleFonts.wdxlLubrifontJpNTextTheme(
          ThemeData.dark().textTheme,
        ),
        cardTheme: CardThemeData(
          color: const Color(0x40DDDDDD),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 4,
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.lightBlue,
          foregroundColor: Colors.white,
          elevation: 4,
        ),
      ),
      home: const HomeView(), // Chama a tela que criamos!
    );
  }
}
