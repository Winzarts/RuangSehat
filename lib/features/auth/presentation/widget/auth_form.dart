import 'package:flutter/material.dart';
import 'package:Ruang_sehat/features/theme/app_color.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:Ruang_sehat/widgets/Bottom_navbar.dart';
import 'package:provider/provider.dart';
import 'package:Ruang_sehat/features/auth/provider/authProviders.dart';
import 'package:Ruang_sehat/utils/snackbar_helper.dart';

class AuthForm extends StatefulWidget {
  final bool isLogin;
  final VoidCallback onSwitchToLogin;
  const AuthForm({
    super.key,
    required this.isLogin,
    required this.onSwitchToLogin,
  });

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool _rememberMe = false;
  bool _isObscure = true;
  bool _isLoading = false;

  Future<void> handleSubmit(BuildContext context) async {
    setState(() {
      _isLoading = true;
    });

    final auth = context.read<Authproviders>();
    bool success;

    if (widget.isLogin) {
      success = await auth.login(
        usernameController.text.trim(),
        passwordController.text.trim(),
      );
    } else {
      success = await auth.register(
        nameController.text.trim(),
        usernameController.text.trim(),
        passwordController.text.trim(),
      );
    }

    if (!mounted) return;

    setState(() {
      _isLoading = false;
    });

    if (!context.mounted) return;

    if (success) {
      if (auth.successMessage != null) {
        SnackbarHelper.show(context, message: auth.successMessage!);
      }

      if (widget.isLogin) {
        Navigator.pushReplacementNamed(context, BottomNavbar.routename, arguments: 0);
      } else {
        widget.onSwitchToLogin();
      }
    } else {
      if (auth.errorMessage != null) {
        SnackbarHelper.show(context, message: auth.errorMessage!, isError: true);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.isLogin == false) ...[
          Text(
            'Name',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: nameController,
            decoration: InputDecoration(
              hintText: "Enter Your Name",
              hintStyle: TextStyle(color: AppColor.hintText),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: AppColor.border, width: 2),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: AppColor.border, width: 2),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 15,
                vertical: 14,
              ),
            ),
          ),
          const SizedBox(height: 12),
        ],
        const SizedBox(height: 12),
        Text(
          'Username',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: usernameController,
          decoration: InputDecoration(
            hintText: "Enter Your Username",
            hintStyle: TextStyle(color: AppColor.hintText),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppColor.border, width: 2),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppColor.border, width: 2),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 15,
              vertical: 14,
            ),
          ),
        ),
        const SizedBox(height: 12),
        Text(
          'Password',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: passwordController,
          obscureText: _isObscure,
          decoration: InputDecoration(
            hintText: "Enter Your Password",
            hintStyle: TextStyle(color: AppColor.hintText),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppColor.border, width: 2),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppColor.border, width: 2),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 15,
              vertical: 14,
            ),
            suffixIcon: IconButton(
              icon: Icon(
                _isObscure ? Icons.visibility : Icons.visibility_off,
                color: AppColor.hintText,
              ),
              onPressed: () {
                setState(() {
                  _isObscure = !_isObscure;
                });
              },
            ),
          ),
        ),
        SizedBox(height: 18),
        ElevatedButton(
          onPressed: _isLoading ? null : () => handleSubmit(context),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColor.primary,
            minimumSize: Size(double.infinity, 53),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: _isLoading
              ? const SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2.5,
                  ),
                )
              : Text(
                  widget.isLogin ? "Login" : "Register",
                  style: TextStyle(
                    color: AppColor.secondary,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
        ),
        SizedBox(height: 18),
        Row(
          children: [
            Checkbox(
              value: _rememberMe,
              onChanged: (value) {
                setState(() {
                  _rememberMe = value ?? false;
                });
              },
              activeColor: AppColor.primary,
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              visualDensity: VisualDensity.compact,
              side: const BorderSide(color: AppColor.border, width: 2),
            ),
            Flexible(
              child: Text(
                "Remember me",
                style: TextStyle(
                  color: AppColor.hintText,
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const Spacer(),
            TextButton(
              onPressed: () {},
              child: Text(
                "Forgot Password?",
                style: TextStyle(
                  color: AppColor.primary,
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        SizedBox(height: 18),
        Row(
          children: [
            Expanded(child: Divider(thickness: 1, color: AppColor.border)),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Text(
                "Or Login With",
                style: TextStyle(
                  color: AppColor.hintText,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            Expanded(child: Divider(thickness: 1, color: AppColor.border)),
          ],
        ),
        SizedBox(height: 18),
        Center(
          child: Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: AppColor.secondary.withOpacity(0.3),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColor.border, width: 2),
            ),
            child: Center(
              child: SvgPicture.asset(
                "assets/icons/google.svg",
                width: 24,
                height: 24,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
