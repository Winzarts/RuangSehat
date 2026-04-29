import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:Ruang_sehat/features/articles/presentation/screen/detail_screen.dart';
import 'package:Ruang_sehat/theme/app_colors.dart';
import 'package:provider/provider.dart';
import 'package:Ruang_sehat/features/articles/providers/articles_provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class MyArticleCard extends StatelessWidget {
  const MyArticleCard({super.key});

  static final String baseUrl = dotenv.env['BASE_URL']!;

  @override
  Widget build(BuildContext context) {
    return Consumer<ArticlesProvider>(
      builder: (context, provider, _) {
        if (provider.isLoading) {
          return Center(child: CircularProgressIndicator());
        }

        if (provider.myArticles.isEmpty) {
          return Center(child: Text('Tidak ada artikel'));
        }
        return ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: provider.myArticles.length,
          separatorBuilder: (_, __) => const SizedBox(height: 10),
          itemBuilder: (context, index) {
            final article = provider.myArticles[index];
            return GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, DetailScreen.routename, arguments: {'id': article.id, 'isMe': true});
              },
              child: Card(
                color: AppColors.secondary,
                clipBehavior: Clip.antiAlias,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(4),
                  child: Column(
                    children: [
                      Stack(
                        children: [
                          Container(
                            width: double.infinity,
                            height: 196,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              image: DecorationImage(
                                image: CachedNetworkImageProvider('${baseUrl}/${article.image}'),
                                fit: BoxFit.cover,
                                alignment: Alignment.center,
                              ),
                            ),
                          ),
                          Positioned(
                            top: 10,
                            left: 10,
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.primary,
                                borderRadius: BorderRadius.circular(99),
                              ),
                              child: Text(
                                article.category,
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.secondary,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Artikel ke ${index + 1}',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: AppColors.hintText,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Text(
                                  'article.date',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: AppColors.hintText,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                            Text(
                              article.title,
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
