import 'package:flutter/material.dart';
import '../../config/theme.dart';

enum KamiliButtonVariant { primary, secondary, text, destructive }

class KamiliButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final IconData? icon;
  final bool fullWidth;
  final KamiliButtonVariant variant;

  const KamiliButton({
    super.key,
    required this.label,
    this.onPressed,
    this.isLoading = false,
    this.icon,
    this.fullWidth = true,
    this.variant = KamiliButtonVariant.primary,
  });

  @override
  Widget build(BuildContext context) {
    final bool isDisabled = onPressed == null || isLoading;

    switch (variant) {
      case KamiliButtonVariant.primary:
        return _buildElevated(
          backgroundColor: KamiliColors.primary,
          foregroundColor: Colors.white,
          isDisabled: isDisabled,
        );
      case KamiliButtonVariant.destructive:
        return _buildElevated(
          backgroundColor: KamiliColors.ctaRed,
          foregroundColor: Colors.white,
          isDisabled: isDisabled,
        );
      case KamiliButtonVariant.secondary:
        return _buildOutlined(isDisabled: isDisabled);
      case KamiliButtonVariant.text:
        return _buildText(isDisabled: isDisabled);
    }
  }

  Widget _buildElevated({
    required Color backgroundColor,
    required Color foregroundColor,
    required bool isDisabled,
  }) {
    final style = ElevatedButton.styleFrom(
      backgroundColor: backgroundColor,
      foregroundColor: foregroundColor,
      disabledBackgroundColor: backgroundColor.withValues(alpha: 0.6),
      disabledForegroundColor: foregroundColor.withValues(alpha: 0.6),
      minimumSize: Size(fullWidth ? double.infinity : 0, 48),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      textStyle: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
      ),
    );

    return SizedBox(
      width: fullWidth ? double.infinity : null,
      height: 48,
      child: ElevatedButton(
        onPressed: isDisabled ? null : onPressed,
        style: style,
        child: _buildChild(foregroundColor),
      ),
    );
  }

  Widget _buildOutlined({required bool isDisabled}) {
    final style = OutlinedButton.styleFrom(
      foregroundColor: KamiliColors.primary,
      disabledForegroundColor: KamiliColors.primary.withValues(alpha: 0.6),
      minimumSize: Size(fullWidth ? double.infinity : 0, 48),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      side: BorderSide(
        color: isDisabled
            ? KamiliColors.primary.withValues(alpha: 0.6)
            : KamiliColors.primary,
      ),
      textStyle: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
      ),
    );

    return SizedBox(
      width: fullWidth ? double.infinity : null,
      height: 48,
      child: OutlinedButton(
        onPressed: isDisabled ? null : onPressed,
        style: style,
        child: _buildChild(KamiliColors.primary),
      ),
    );
  }

  Widget _buildText({required bool isDisabled}) {
    final style = TextButton.styleFrom(
      foregroundColor: KamiliColors.primary,
      minimumSize: Size(fullWidth ? double.infinity : 0, 48),
      textStyle: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
      ),
    );

    return SizedBox(
      width: fullWidth ? double.infinity : null,
      height: 48,
      child: TextButton(
        onPressed: isDisabled ? null : onPressed,
        style: style,
        child: _buildChild(KamiliColors.primary),
      ),
    );
  }

  Widget _buildChild(Color color) {
    if (isLoading) {
      final indicatorColor =
          (variant == KamiliButtonVariant.primary ||
                  variant == KamiliButtonVariant.destructive)
              ? Colors.white
              : KamiliColors.primary;
      return SizedBox(
        width: 24,
        height: 24,
        child: CircularProgressIndicator(
          strokeWidth: 2.5,
          valueColor: AlwaysStoppedAnimation<Color>(indicatorColor),
        ),
      );
    }

    if (icon != null) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 20),
          const SizedBox(width: 8),
          Text(label),
        ],
      );
    }

    return Text(label);
  }
}
