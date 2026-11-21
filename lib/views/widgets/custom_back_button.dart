import 'package:flutter/material.dart';

class CustomBackButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final bool? isDarkMode;
  final Color? iconColor;
  final Color? backgroundColor;
  final double iconSize;
  final EdgeInsetsGeometry padding;

  const CustomBackButton({
    super.key,
    this.onPressed,
    this.isDarkMode,
    this.iconColor,
    this.backgroundColor,
    this.iconSize = 18,
    this.padding = const EdgeInsets.all(6),
  });

  @override
  Widget build(BuildContext context) {
    final effectiveDarkMode =
        isDarkMode ?? (Theme.of(context).brightness == Brightness.dark);

    return IconButton(
      tooltip: "Back",
      icon: Container(
        padding: padding,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: backgroundColor ??
              (effectiveDarkMode
                  ? Colors.white.withValues(alpha: 0.08)
                  : const Color(0xFFF1F5F9)),
        ),
        child: Icon(
          Icons.arrow_back,
          size: iconSize,
          color: iconColor ??
              (effectiveDarkMode ? Colors.white : const Color(0xFF334155)),
        ),
      ),
      onPressed: () {
        if (onPressed != null) {
          onPressed!();
        } else {
          Navigator.maybePop(context);
        }
      },
    );
  }
}
