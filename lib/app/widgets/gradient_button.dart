import 'package:flutter/material.dart';

class GradientButton extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  final IconData? icon;
  final double height;
  final double radius;
  final double fontSize;
  final List<Color>? colors;
  final bool isLoading;

  const GradientButton({
    super.key,
    required this.text,
    required this.onTap,
    this.icon,
    this.height = 58,
    this.radius = 18,
    this.fontSize = 17,
    this.colors,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    final gradientColors = colors ??
        const [
          Color(0xFF2563EB),
          Color(0xFF7C3AED),
        ];

    return SizedBox(
      width: double.infinity,
      height: height,
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: gradientColors,
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          borderRadius: BorderRadius.circular(radius),
          boxShadow: [
            BoxShadow(
              color: gradientColors.first.withOpacity(0.35),
              blurRadius: 22,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: ElevatedButton(
          onPressed: isLoading ? null : onTap,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            disabledBackgroundColor: Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(radius),
            ),
          ),
          child: isLoading
              ? const SizedBox(
                  height: 24,
                  width: 24,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2.5,
                  ),
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (icon != null) ...[
                      Icon(
                        icon,
                        color: Colors.white,
                        size: 24,
                      ),
                      const SizedBox(width: 10),
                    ],
                    Text(
                      text,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: fontSize,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.4,
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
