import 'package:flutter/material.dart';
import 'package:auto_wallet2/utils/app_theme.dart';

class AppButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color? backgroundColor;
  final Color? textColor;
  final double width;
  final double height;
  final bool isOutlined;
  final IconData? icon;
  
  const AppButton({
    Key? key,
    required this.text,
    required this.onPressed,
    this.backgroundColor,
    this.textColor,
    this.width = double.infinity,
    this.height = 50,
    this.isOutlined = false,
    this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (isOutlined) {
      return SizedBox(
        width: width,
        height: height,
        child: OutlinedButton(
          onPressed: onPressed,
          style: OutlinedButton.styleFrom(
            side: BorderSide(
              color: backgroundColor ?? Theme.of(context).colorScheme.primary,
              width: 1.5,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppTheme.borderRadiusMedium),
            ),
          ),
          child: _buildButtonContent(context),
        ),
      );
    } else {
      return SizedBox(
        width: width,
        height: height,
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: backgroundColor ?? Theme.of(context).colorScheme.primary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppTheme.borderRadiusMedium),
            ),
          ),
          child: _buildButtonContent(context),
        ),
      );
    }
  }
  
  Widget _buildButtonContent(BuildContext context) {
    final Color contentColor = isOutlined
        ? (textColor ?? Theme.of(context).colorScheme.primary)
        : (textColor ?? Colors.white);
    
    if (icon != null) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: contentColor, size: 20),
          const SizedBox(width: 8),
          Text(
            text,
            style: TextStyle(
              color: contentColor,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      );
    } else {
      return Text(
        text,
        style: TextStyle(
          color: contentColor,
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      );
    }
  }
} 