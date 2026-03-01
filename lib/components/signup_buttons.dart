import 'package:sulabh_market_app/components/custom_icon_button.dart';
import 'package:sulabh_market_app/constants/colors.dart';
import 'package:sulabh_market_app/screens/auth/phone_auth_screen.dart';
import 'package:sulabh_market_app/services/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SignUpButtons extends StatefulWidget {
  const SignUpButtons({
    Key? key,
  }) : super(key: key);

  @override
  State<SignUpButtons> createState() => _SignUpButtonsState();
}

class _SignUpButtonsState extends State<SignUpButtons> {
  Auth authService = Auth();
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (builder) => const PhoneAuthScreen(
                          isFromLogin: false,
                        )));
          },
          child: CustomIconButton(
            text: 'Signup with Phone',
            imageIcon: 'assets/phone.png',
            bgColor: greyColor,
            imageOrIconColor: whiteColor,
            imageOrIconRadius: 20,
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        InkWell(
          onTap: () async {
            User? user = await Auth.signInWithGoogle(context: context);
            if (!mounted) return;
            if (user != null) {
              authService.getAdminCredentialPhoneNumber(context, user);
            }
          },
          child: CustomIconButton(
            text: 'Signup with Google',
            imageIcon: 'assets/google.png',
            bgColor: whiteColor,
          ),
        ),
        const SizedBox(
          height: 10,
        ),
      ],
    );
  }
}
