import 'package:Ruang_sehat/features/auth/presentation/widget/update_form.dart';
import 'package:flutter/material.dart';
import 'package:Ruang_sehat/theme/app_colors.dart';

class UpdateProfile extends StatefulWidget {

  static const routename = '/update-profile';

  const UpdateProfile({super.key});

  @override
  State<UpdateProfile> createState() => _UpdateProfileState();
}

class _UpdateProfileState extends State<UpdateProfile> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.topCenter,
        children: [
          Container(
            height: 180,
            width: double.infinity,
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(36),
                bottomRight: Radius.circular(36),
              ),
            ),
            child: Padding(
              padding: EdgeInsets.only(top: 14),
              child: Text(
                'Edit Profile',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Positioned(
            top: 80,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(99),
                border: Border.all(color: Colors.white, width: 3),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(99),
                child: Image.asset(
                  'assets/images/profile.png',
                  fit: BoxFit.cover,
                  width: size.width / 2.5,
                  height: size.width / 2.5,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            child: SingleChildScrollView(
              child: Column(children: [SizedBox(height: 210), UpdateForm()]),
            ),
          ),
        ],
      ),
    );
  }
}

