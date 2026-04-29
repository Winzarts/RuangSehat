import "package:flutter/material.dart";
import "package:Ruang_sehat/features/auth/presentation/widget/headline_text.dart";
import "package:Ruang_sehat/features/theme/app_color.dart";
import "package:Ruang_sehat/features/auth/presentation/widget/auth_form.dart";

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  static const routename = "/auth-screen";

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool isLogin = true;

  @override
  Widget build(BuildContext context) {
    final bottomHeight = MediaQuery.of(context).size.height / 4.2 * 3;

    return Scaffold(
      backgroundColor: AppColor.primary,
      body: Stack(
        children: [
          HeadlineText(isLogin: isLogin, bottomHeight: bottomHeight),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              width: double.infinity,
              height: bottomHeight,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 32,
                ),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(4),
                        height: 50,
                        decoration: BoxDecoration(
                          color: Colors.grey,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    isLogin = true;
                                  });
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 10,
                                  ),
                                  decoration: BoxDecoration(
                                    color: isLogin 
                                    ? AppColor.secondary
                                    : Colors.transparent,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: const Center(
                                    child: Text(
                                      "Login",
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            ),
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    isLogin = false;
                                  });
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 10,
                                  ),
                                  decoration: BoxDecoration(
                                    color: isLogin 
                                    ? Colors.transparent
                                    : AppColor.secondary,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: const Center(
                                    child: Text(
                                      "Register",
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),
                      AuthForm(
                        isLogin: isLogin,
                        onSwitchToLogin: () {
                          setState(() {
                            isLogin = true;
                          });
                        },
                        
                      ),
                    ],
                  ),
                )
              ),
            ),
          ),
        ]
      ),
    );
  }
}