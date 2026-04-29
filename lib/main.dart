import 'package:flutter/material.dart';
import 'package:Ruang_sehat/features/splash/splash_screen.dart';
import 'package:Ruang_sehat/features/auth/presentation/screen/authScreen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:Ruang_sehat/widgets/Bottom_navbar.dart';
import 'package:provider/provider.dart';
import 'package:Ruang_sehat/features/auth/provider/authProviders.dart';
import 'package:Ruang_sehat/features/home/screens/homeScreen.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:Ruang_sehat/features/articles/providers/articles_provider.dart';
import 'package:Ruang_sehat/features/articles/presentation/screen/detail_screen.dart';
import 'package:Ruang_sehat/features/articles/presentation/screen/form_article_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => Authproviders()),
        ChangeNotifierProvider(create: (_) => ArticlesProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        textTheme: GoogleFonts.manropeTextTheme(),
      ),
      initialRoute: SplashScreen.routename,
      routes: {
        SplashScreen.routename: (context) => SplashScreen(),
        AuthScreen.routename: (context) => AuthScreen(),
        HomeScreen.routename: (context) => HomeScreen(),
        BottomNavbar.routename: (context) => BottomNavbar(),
        DetailScreen.routename: (context) => DetailScreen(),
        FormArticleScreen.routename: (context) => FormArticleScreen(),
      },
    );
  }
}