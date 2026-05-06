import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:Ruang_sehat/features/auth/provider/authProviders.dart';
import 'package:Ruang_sehat/theme/app_colors.dart';
import 'package:Ruang_sehat/utils/snackbar_helper.dart';

class UpdateForm extends StatefulWidget {
  const UpdateForm({super.key});

  @override
  State<UpdateForm> createState() => _UpdateFormState();
}

class _UpdateFormState extends State<UpdateForm> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool _isLoading = false;

  Future<void> handleSubmit(BuildContext context) async {
    setState(() {
      _isLoading = true;
    });

    final upt = context.read<Authproviders>();
    bool success;

    success = await upt.updateProfile(
      nameController.text.trim(),
      usernameController.text.trim(),
      passwordController.text.trim(),
    );

    if (!mounted) return;

    setState(() {
      _isLoading = false;
    });

    if (!context.mounted) return;

    if (success) {
      if (upt.successMessage != null) {
        SnackbarHelper.show(context, message: upt.successMessage!);
      }
    } else {
      if (upt.errorMessage != null) {
        SnackbarHelper.show(context, message: upt.errorMessage!, isError: true);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'name',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppColors.text,
          ),
        ),
        const SizedBox(height: 8),
        Consumer<Authproviders>(
          builder: (context, provider, _) {
            return TextFormField(
              controller: nameController,
              decoration: InputDecoration(
                hintText: provider.profile?.name ?? 'user',
                hintStyle: TextStyle(color: AppColors.text),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: AppColors.background, width: 2),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: AppColors.background, width: 2),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 15,
                  vertical: 14,
                ),
                filled: true,
                fillColor: AppColors.background,
              ),
            );
          },
        ),
        Text(
          'username',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppColors.text,
          ),
        ),
        const SizedBox(height: 8),
        Consumer<Authproviders>(
          builder: (context, provider, _) {
            return TextFormField(
              controller: usernameController,
              decoration: InputDecoration(
                hintText: provider.profile?.username ?? 'user',
                hintStyle: TextStyle(color: AppColors.text),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: AppColors.background, width: 2),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: AppColors.background, width: 2),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 15,
                  vertical: 14,
                ),
                filled: true,
                fillColor: AppColors.background,
              ),
            );
          },
        ),
        Text(
          'password',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppColors.text,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: passwordController,
          decoration: InputDecoration(
            hintText: '****************',
            hintStyle: TextStyle(color: AppColors.text),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppColors.background, width: 2),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppColors.background, width: 2),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 15,
              vertical: 14,
            ),
            filled: true,
            fillColor: AppColors.background,
          ),
        ),
        SizedBox(height: 18),
        ElevatedButton(
          onPressed: _isLoading ? null : () => handleSubmit(context),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            minimumSize: Size(double.infinity, 53),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: _isLoading
              ? const SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(color: Colors.white),
                )
              : Text(
                  'Simpan Perubahan',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
        ),
      ],
    );
  }
}
