import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:Ruang_sehat/features/articles/presentation/screen/form_article_screen.dart';
import 'package:Ruang_sehat/widgets/modal_bottom_sheet.dart';
import 'package:Ruang_sehat/features/articles/providers/articles_provider.dart';
import 'package:provider/provider.dart';
import 'package:Ruang_sehat/utils/snackbar_helper.dart';
import 'package:Ruang_sehat/widgets/Bottom_navbar.dart';

class PopUpMenu extends StatelessWidget {
  final String articleId;
  const PopUpMenu({super.key, required this.articleId});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
        child: Container(
          width: 180,
          padding: const EdgeInsets.symmetric(vertical: 5),
          decoration: BoxDecoration(color: Colors.black.withOpacity(0.3)),
          child: Column(
            children: [
              ListTile(
                leading: Icon(Icons.edit, color: Colors.white),
                title: Text('Edit article', style: TextStyle(color: Colors.white)),
                onTap: () {
                  Navigator.pushNamed(context, FormArticleScreen.routename, arguments: {'isEdit': true, 'articleId': articleId});
                },
              ),
              ListTile(
                leading: Icon(Icons.delete, color: Colors.red),
                title: Text('Delete article', style: TextStyle(color: Colors.red)),
                onTap: () {
                  ModalBottomSheet.show(
                    context: context,
                    label: 'Apakah kamu yakin ingin menghapus artikel ini?',
                    isLogout: false,
                    onConfirm: () async {
                      final articleProvider = Provider.of<ArticlesProvider>(context, listen: false);
                      final navigator = Navigator.of(context);
                      navigator.pop();
                      await articleProvider.deleteArticle(articleId);
                      if (articleProvider.errorMessage == null) {
                        SnackbarHelper.show(
                          navigator.context,
                          message: articleProvider.successMessage ?? 'success',
                          isError: false,
                        );
                        navigator.pushNamedAndRemoveUntil(
                          BottomNavbar.routename,
                          (route) => false,
                          arguments: 1,
                        );
                      } else {
                        SnackbarHelper.show(
                          navigator.context,
                          message: articleProvider.errorMessage ?? 'error',
                          isError: true,
                        );
                      }
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}