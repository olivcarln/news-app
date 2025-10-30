import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:news_app/utils/app_colors.dart';

class BottomNavBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;

  const BottomNavBar({
    Key? key,
    required this.selectedIndex,
    required this.onItemTapped,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      // posisi & margin bawah
      margin: const EdgeInsets.only(bottom: 20),
      alignment: Alignment.bottomCenter,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.85),
          borderRadius: BorderRadius.circular(50),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.12),
              blurRadius: 20,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min, 
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
   IconButton(
  onPressed: () => onItemTapped(0),
  icon: TweenAnimationBuilder<Color?>(
    tween: ColorTween(
      begin: Colors.black45,
      end: selectedIndex == 0 ? AppColors.secondary : Colors.black45,
    ),
    duration: const Duration(milliseconds: 250),
    builder: (context, color, _) => Icon(
      Icons.home_rounded,
      size: 30,
      color: color,
    ),
  ),
),
const SizedBox(width: 20),
IconButton(
  onPressed: () {
    onItemTapped(1);
    Get.toNamed('/bookmark');
  },
  icon: TweenAnimationBuilder<Color?>(
    tween: ColorTween(
      begin: Colors.black45,
      end: selectedIndex == 1 ? AppColors.secondary : Colors.black45,
    ),
    duration: const Duration(milliseconds: 250),
    builder: (context, color, _) => Icon(
      Icons.bookmark_rounded,
      size: 30,
      color: color,
    ),
  ),
),
          ],
        ),
      ),
    );
  }
}
