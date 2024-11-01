import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
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
    'image': 'assets/images/logo.png',
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
      body: Column(
        children: [
          SizedBox(
            height: MediaQuery.sizeOf(context).height * 0.8,
            child: PageView(
              controller: controller,
              children: List.generate(
                  onBoardingList.length, (index) => OnboardingView(index)),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 35.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                SmoothPageIndicator(
                    controller: controller, // PageController
                    count: onBoardingList.length,
                    effect: ExpandingDotsEffect(
                      dotHeight: 10,
                      dotWidth: 22,
                      activeDotColor: AppColors.heading,
                      radius: 100,
                      dotColor: AppColors.lightText,
                    ), // your preferred effect
                    onDotClicked: (index) {}),
                const SizedBox(height: 20),
                Row(
                  children: [
                    GradientButton(
                      text: LocaleKeys.get_started.tr(),
                      gradientColors: const [
                        AppColors.bluePrimaryColor,
                        AppColors.blueSecondColor
                      ],
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  RegisterPage(showSignUpPage: () {})),
                        );
                      },
                      width: 150,
                    ),
                    const Spacer(),
                    GradientButton(
                      text: LocaleKeys.skip.tr(),
                      gradientColors: const [AppColors.white, AppColors.white],
                      textColor: AppColors.text,
                      width: 120,
                      onPressed: () {
                        controller.animateToPage(
                          1,
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
