import 'package:flutter/material.dart';
import '../../utils/Colors_Utils.dart';
import '../../utils/custom_text.dart';
import 'onboarding_screen.dart';

class OnboardingView extends StatelessWidget {
  const OnboardingView(this.index, {Key? key}) : super(key: key);
  final int index;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 10),
          Container(
            alignment: Alignment.center,
            height: MediaQuery.sizeOf(context).height * 0.35,
            padding: const EdgeInsets.all(10),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.asset(
                '${onBoardingList[index]['image']}',
                width: 150,
                fit: BoxFit.cover,
              ),
            ),
          ),
          CustomText(
            text: '${onBoardingList[index]['title']}',
            textAlign: TextAlign.start,
            color: AppColors.activeBlack,
            height: 1.1,
            fontSize: 33,
            fontWeight: FontWeight.bold,
          ),
          const SizedBox(height: 20),
          CustomText(
            text: '${onBoardingList[index]['description']}',
            textAlign: TextAlign.start,
            fontFamily: 'outfit',
            color: AppColors.activeBlack,
            height: 1,
            maxLines: 6,
            fontSize: 15,
          ),
        ],
      ),
    );
  }
}
