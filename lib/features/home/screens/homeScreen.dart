import 'package:Ruang_sehat/widgets/modal_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:Ruang_sehat/theme/app_colors.dart';
import 'package:Ruang_sehat/features/home/widgets/featuredCard.dart';
import 'package:Ruang_sehat/features/home/widgets/recommendCard.dart';
import 'package:Ruang_sehat/features/auth/provider/authProviders.dart';
import 'package:provider/provider.dart';
import 'package:Ruang_sehat/utils/snackbar_helper.dart';
import 'package:Ruang_sehat/features/auth/presentation/screen/authScreen.dart';
import 'package:Ruang_sehat/features/articles/providers/articles_provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  static const String routename = '/home';

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 16),
          child: Row(
            children: [
              CircleAvatar(
                child: Image.asset(
                  "assets/images/profile.png",
                  fit: BoxFit.cover,
                  width: size.width / 8,
                  height: size.height / 8,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Consumer<Authproviders>(
                      builder: (context, provider, _) {
                        return Text(
                          'Hi, ${provider.profile?.name ?? 'User'}',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                        );
                      },
                    ),
                    Text(
                      'Bagaimana keadaan mu saat ini?',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              PopupMenuButton<String>(
                icon: const Icon(Icons.more_horiz, size: 28),
                offset: const Offset(0, 50),
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(16)),
                ),
                color: AppColors.secondary,
                onSelected: (value) {
                  ModalBottomSheet.show(
                    context: context,
                    label: 'Apakah anda yakin ingin keluar ?',
                    isLogout: true,
                    onConfirm: () async {
                      final authproviders = context.read<Authproviders>();
                      await authproviders.logout();

                      if (authproviders.errorMessage == null) {
                        SnackbarHelper.show(
                          context,
                          message: authproviders.successMessage ?? 'success',
                          isError: false,
                        );

                        Navigator.pushNamedAndRemoveUntil(
                          context,
                          AuthScreen.routename,
                          (route) => false,
                        );
                      } else {
                        SnackbarHelper.show(
                          context,
                          message: authproviders.errorMessage ?? 'error',
                          isError: true,
                        );
                      }
                    },
                  );
                },
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    value: 'Logout',
                    child: Row(
                      children: [
                        Icon(Icons.logout, color: AppColors.error),
                        SizedBox(width: 8),
                        Text(
                          'Log out',
                          style: TextStyle(color: AppColors.error),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      body: NotificationListener<ScrollNotification>(
        onNotification: (ScrollNotification scrollInfo) {
          if (scrollInfo.metrics.pixels >= scrollInfo.metrics.maxScrollExtent - 200) {
            final provider = context.read<ArticlesProvider>();
            if (!provider.isFetchingMore && provider.hasNextPage) {
              provider.getArticles(isRefresh: false);
            }
          }
          return true;
        },
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 8, 24, 16),
                child: Row(
                  children: [
                    const Text(
                      'Featured',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                    ),
                    Spacer(),
                    Text(
                      'See More >',
                      style: TextStyle(
                        fontSize: 16,
                        color: AppColors.hintText,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 24, bottom: 16),
                child: FeaturedCard(),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 8, 24, 16),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Recommended for You',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          'See More >',
                          style: TextStyle(
                            fontSize: 16,
                            color: AppColors.hintText,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    RecommendCard(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
