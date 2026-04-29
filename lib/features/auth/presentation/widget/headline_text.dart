import 'package:flutter/material.dart';
import 'package:Ruang_sehat/features/theme/app_color.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HeadlineText extends StatelessWidget {
  final bool isLogin;
  final double bottomHeight;

  const HeadlineText({
    super.key,
    required this.isLogin,
    required this.bottomHeight,
  });

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return SafeArea(
      child: SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: screenHeight),
          child: Padding(
            padding: EdgeInsets.fromLTRB(24, 10, 24, bottomHeight + 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: AppColor.secondary.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: SvgPicture.asset("assets/icons/logo.svg", width: 24, height: 24),
                  )
                ),
                Text(
                  isLogin
                      ? "Go ahead and complete your \naccount and setup"
                      : "Register now to access \nyour personal account",
                  style: TextStyle(
                    color: AppColor.secondary,
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                    height: 1.2
                  ),
                ),
                Text(
                  isLogin
                      ? "Create your account and simplify your workflow instanly"
                      : "Register now to access your personal account",
                  style: TextStyle(
                    color: AppColor.secondary,
                    fontSize: 15,
                    fontWeight: FontWeight.w400,
                    height: 1.2
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}