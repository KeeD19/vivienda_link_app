import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:vivienda_link_app/screens/login/Login.dart';
import '../register/Register.dart';
import './generated/locale_keys.g.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../../utils/custom_button.dart';
import '../../utils/Colors_Utils.dart';
import 'onboarding_view.dart';

List onBoardingList = [
  {
    'title': LocaleKeys.boarding1_title.tr(),
    'description': LocaleKeys.boarding1_description.tr(),
    'image': 'assets/images/logoVivienda.jpeg',
  },
  {
    'title': LocaleKeys.boarding2_title.tr(),
    'description': LocaleKeys.boarding2_description.tr(),
    'image': 'assets/images/trabajos.png',
  }
];

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({Key? key}) : super(key: key);

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  final PageController controller = PageController(initialPage: 0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundSecondColor,
      body: Column(
        children: [
          SizedBox(
            height: MediaQuery.sizeOf(context).height * 0.7,
            child: PageView(
              controller: controller,
              children: List.generate(onBoardingList.length, (index) => OnboardingView(index)),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 10),
                SmoothPageIndicator(
                    controller: controller, // PageController
                    count: onBoardingList.length,
                    effect: ExpandingDotsEffect(
                      dotHeight: 10,
                      dotWidth: 10,
                      activeDotColor: AppColors.heading,
                      radius: 50,
                      dotColor: AppColors.lightText,
                    ), // your preferred effect
                    onDotClicked: (index) {}),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () async {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => RegisterPage(showSignUpPage: () {})),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.orangeColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                    ),
                    child: Text(
                      LocaleKeys.get_started.tr(),
                      style: const TextStyle(
                        color: AppColors.white,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  child: TextButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => LoginPage(
                              showLoginPage: () {},
                            ),
                          ));
                    },
                    style: TextButton.styleFrom(
                      backgroundColor: AppColors.backgroundSecondColor,
                      shadowColor: AppColors.backgroundSecondColor,
                      side: BorderSide.none,
                      padding: EdgeInsets.zero,
                    ),
                    child: Text(
                      LocaleKeys.skip.tr(),
                      style: const TextStyle(
                        color: AppColors.bluePrimaryColor,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                // Row(
                //   children: [
                //     GradientButton(
                //       text: LocaleKeys.get_started.tr(),
                //       gradientColors: const [AppColors.bluePrimaryColor, AppColors.blueSecondColor],
                //       onPressed: () {
                //         Navigator.push(
                //           context,
                //           MaterialPageRoute(builder: (context) => RegisterPage(showSignUpPage: () {})),
                //         );
                //       },
                //       width: 150,
                //     ),
                //     const Spacer(),
                //     GradientButton(
                //       text: LocaleKeys.skip.tr(),
                //       gradientColors: const [AppColors.white, AppColors.white],
                //       textColor: AppColors.text,
                //       width: 120,
                //       onPressed: () {
                //         controller.animateToPage(
                //           1,
                //           duration: const Duration(milliseconds: 300),
                //           curve: Curves.easeInOut,
                //         );
                //       },
                //     ),
                //   ],
                // ),
                // const SizedBox(height: 10),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
