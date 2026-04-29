import "package:flutter/material.dart";
import "package:Ruang_sehat/features/theme/app_color.dart";
import "package:flutter_svg/flutter_svg.dart";
import "package:Ruang_sehat/features/auth/presentation/screen/authScreen.dart";

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  static const routename = '/splash-screen';

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _iconController;
  late AnimationController _textController;

  late Animation<Offset> _slideAnimation;
  late Animation<double> _textAnimation;

  @override
  void initState() {
    super.initState();
    _iconController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    _textController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );

    _slideAnimation =
        Tween<Offset>(
          begin: const Offset(0, 1),
          end: const Offset(0, 0),
        ).animate(
          CurvedAnimation(parent: _iconController, curve: Curves.bounceOut),
        );

    _textAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(parent: _textController, curve: Curves.easeOut));

    _iconController.forward();

    _iconController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _textController.forward();
      }
    });

    _textController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        Future.delayed(const Duration(seconds: 1), () {
          Navigator.pushReplacementNamed(context, AuthScreen.routename);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.primary,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SlideTransition(
                position: _slideAnimation,
                child: SvgPicture.asset("assets/icons/logo.svg", width: 60),
              ),
              AnimatedBuilder(
                animation: _textAnimation,
                builder: (context, child) {
                  return ClipRect(
                    child: Align(
                      alignment: Alignment.centerLeft,
                      widthFactor: _textAnimation.value,
                      child: child,
                    ),
                  );
                },
                child: Text(
                  "Ruang Sehat",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
