import 'package:flutter/material.dart';

import '../utils/text_styles.dart';

class CustomButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String label;
  final TextStyle? labelStyle;
  final EdgeInsets? padding;
  final double? width;
  final BorderRadius? borderRadius;

  final Color? buttonColor;

  final bool isLoading;

  final BorderSide borderSide;

  const CustomButton({
    super.key,
    required this.onPressed,
    required this.label,
    this.labelStyle,
    this.padding,
    this.width,
    this.borderRadius,
    this.buttonColor,
    this.isLoading = false,
    this.borderSide = BorderSide.none,
  });

  @override
  Widget build(BuildContext context) {
    final disabled = onPressed == null || isLoading;
    final bgColor = buttonColor ?? (borderSide != BorderSide.none ? Theme.of(context).colorScheme.surface : Theme.of(context).colorScheme.primary);
    return MaterialButton(
      onPressed: disabled ? null : onPressed,
      minWidth: width,
      elevation: 0,
      clipBehavior: Clip.hardEdge,
      color: disabled ? bgColor.withOpacity(0.5) : bgColor,
      padding: padding,
      shape: RoundedRectangleBorder(borderRadius: borderRadius ?? BorderRadius.circular(22), side: borderSide),
      splashColor: Colors.transparent,
      child: isLoading
          ? SizedBox(
              height: 18,
              width: 18,
              child: CircularProgressIndicator(strokeWidth: 2, valueColor: AlwaysStoppedAnimation(Theme.of(context).colorScheme.surface)),
            )
          : Text(
              label,
              style: TextHelper.size18.copyWith(fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.surface).merge(labelStyle),
            ),
    );
  }
}
