import 'package:flutter/material.dart';
import 'package:user_tracker/core/consts/app_colors.dart';

Container profilePicture({required double size, required String imageLink}) {
  return Container(
    height: size,
    width: size,
    clipBehavior: Clip.hardEdge,
    decoration: BoxDecoration(
      color: AppColors.profileBackground,
      shape: BoxShape.circle,
      border: Border.all(
        color: Colors.white,
        strokeAlign: BorderSide.strokeAlignOutside,
        width: size * 0.02,
      ),
    ),
    child: imageLink.isEmpty
        ? Icon(Icons.person, size: size * 0.35)
        : Image.network(imageLink, fit: BoxFit.cover),
  );
}
