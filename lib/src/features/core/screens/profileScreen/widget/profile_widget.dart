import 'package:flutter/material.dart';
import 'package:flutter_app/src/utilities/constants/sizes.dart';

class ProfileWidget extends StatelessWidget {
  final String text;
  final String subText;
  final IconData iconData;

  const ProfileWidget({
    super.key,
    required this.text,
    required this.subText,
    required this.iconData,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: [
          Icon(iconData, size: AppSizes.iconLg),
          const SizedBox(width: 15),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                text,
                style: TextStyle(fontSize: AppSizes.fontSizeLg),
              ), // Tani waa magaca qaybta
              Text(
                subText, // Halkan waxaa lagu daabacayaa subText (sida taleefanka ama emailka)
                style: TextStyle(
                  fontSize: AppSizes.fontSizeMd,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
