import 'package:flutter/material.dart';
import 'package:Ruang_sehat/theme/app_colors.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:Ruang_sehat/features/articles/presentation/widgets/my_article_card.dart';
import 'package:provider/provider.dart';
import 'package:Ruang_sehat/features/articles/providers/articles_provider.dart';
import 'package:Ruang_sehat/features/articles/presentation/screen/form_article_screen.dart';

class MyArticlesScreen extends StatelessWidget {
  const MyArticlesScreen({super.key});

  static const String routename = '/my_articles';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 16, horizontal: 14),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Artikel Saya',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Consumer<ArticlesProvider>(
                      builder: (context, provider, _) {
                        if(provider.isLoading){
                          return const Center(child: CircularProgressIndicator());
                        }
                        return Text(
                          '${provider.myArticles.length} items',
                          style: TextStyle(
                            fontSize: 16,
                            color: AppColors.hintText,
                            fontWeight: FontWeight.w500,
                          ),
                        );
                      },
                    ),
                  ],
                ),
                SizedBox(height: 16),
                MyArticleCard(),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(
            context,
            FormArticleScreen.routename,
            arguments: {'isEdit': false}
          );
        },
        backgroundColor: AppColors.primary,
        child: Icon(LucideIcons.plus, color: Colors.white, size:30),
      ),
    );
  }
}