import 'package:flutter/material.dart';
import 'package:Ruang_sehat/features/articles/presentation/screen/my_articles_screen.dart';
import 'package:Ruang_sehat/features/home/screens/homeScreen.dart';
import 'package:Ruang_sehat/theme/app_colors.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:Ruang_sehat/features/articles/providers/articles_provider.dart';
import 'package:Ruang_sehat/features/auth/provider/authProviders.dart';
import 'package:provider/provider.dart';

class BottomNavbar extends StatefulWidget {
  const BottomNavbar({super.key});

  static const String routename = '/bottom_navbar';

  @override
  State<BottomNavbar> createState() => _BottomNavbarState();
}

class _BottomNavbarState extends State<BottomNavbar> {
  bool _firstLoad = true;
  int _selectedIndex = 0;
  List<Widget> get _pages => [HomeScreen(), MyArticlesScreen()];

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      final articlesProvider = context.read<ArticlesProvider>();
      final authprovider = context.read<Authproviders>();
      articlesProvider.getArticles();
      articlesProvider.getMyArticles();
      authprovider.getProfile();
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (_firstLoad) {
      final args = ModalRoute.of(context)?.settings.arguments;
      if (args != null && args is int) {
        setState(() {
          _selectedIndex = args;
        });
      }
      _firstLoad = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: AppColors.secondary,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.hintText,
        currentIndex: _selectedIndex,
        iconSize: 20,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(icon: Icon(LucideIcons.house), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(LucideIcons.newspaper), label: 'My Articles')
        ],
      ),
    );
  }
}