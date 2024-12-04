import 'package:flutter/material.dart';

class AppButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final ButtonSize size;
  final ButtonVariant variant;
  final bool isFullWidth;
  final bool isLoading;
  final IconData? leftIcon;
  final IconData? rightIcon;

  const AppButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.size = ButtonSize.large,
    this.variant = ButtonVariant.primary,
    this.isFullWidth = false,
    this.isLoading = false,
    this.leftIcon,
    this.rightIcon,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: isFullWidth ? double.infinity : null,
      height: size.height,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.resolveWith<Color>(
            (Set<WidgetState> states) {
              if (states.contains(WidgetState.disabled)) {
                return variant.backgroundColor.withOpacity(0.5);
              }
              if (states.contains(WidgetState.hovered)) {
                return variant.hoverBackgroundColor;
              }
              return variant.backgroundColor;
            },
          ),
          foregroundColor: WidgetStateProperty.resolveWith<Color>(
            (Set<WidgetState> states) {
              if (states.contains(WidgetState.hovered)) {
                return variant.hoverTextColor;
              }
              return variant.textColor;
            },
          ),
          padding: WidgetStateProperty.all<EdgeInsets>(
            size.padding,
          ),
          shape: WidgetStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4),
              side: variant.border,
            ),
          ),
          elevation: WidgetStateProperty.all(0),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: isFullWidth ? MainAxisSize.max : MainAxisSize.min,
          children: [
            if (leftIcon != null) ...[
              Icon(leftIcon, size: size.iconSize),
              SizedBox(width: 8),
            ],
            if (isLoading)
              SizedBox(
                width: size.loadingSize,
                height: size.loadingSize,
                child: CircularProgressIndicator(
                  color: variant.textColor,
                  strokeWidth: 2,
                ),
              )
            else
              Text(
                text,
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize: size.fontSize,
                  fontWeight: FontWeight.w400,
                  height: size.lineHeight,
                ),
              ),
            if (rightIcon != null) ...[
              SizedBox(width: 8),
              Icon(rightIcon, size: size.iconSize),
            ],
          ],
        ),
      ),
    );
  }
}

enum ButtonSize {
  large,
  medium,
  small;

  double get height {
    switch (this) {
      case ButtonSize.large:
        return 44;
      case ButtonSize.medium:
        return 36;
      case ButtonSize.small:
        return 32;
    }
  }

  double get fontSize {
    switch (this) {
      case ButtonSize.large:
        return 16;
      case ButtonSize.medium:
        return 14;
      case ButtonSize.small:
        return 12;
    }
  }

  double get lineHeight {
    switch (this) {
      case ButtonSize.large:
        return 1.5;
      case ButtonSize.medium:
        return 1.4;
      case ButtonSize.small:
        return 1.33;
    }
  }

  EdgeInsets get padding {
    switch (this) {
      case ButtonSize.large:
        return const EdgeInsets.symmetric(horizontal: 16, vertical: 10);
      case ButtonSize.medium:
        return const EdgeInsets.symmetric(horizontal: 12, vertical: 8);
      case ButtonSize.small:
        return const EdgeInsets.symmetric(horizontal: 8, vertical: 6);
    }
  }

  double get iconSize {
    switch (this) {
      case ButtonSize.large:
        return 20;
      case ButtonSize.medium:
        return 18;
      case ButtonSize.small:
        return 16;
    }
  }

  double get loadingSize {
    switch (this) {
      case ButtonSize.large:
        return 20;
      case ButtonSize.medium:
        return 18;
      case ButtonSize.small:
        return 16;
    }
  }
}

enum ButtonVariant {
  primary,
  secondary,
  tertiary,
  outline,
  wide,
  roleActive,
  roleInactive;

  const ButtonVariant();

  Color get backgroundColor {
    switch (this) {
      case ButtonVariant.primary:
        return const Color(0xFF1C4A97);
      case ButtonVariant.secondary:
        return Colors.white;
      case ButtonVariant.tertiary:
        return Colors.transparent;
      case ButtonVariant.outline:
        return Colors.transparent;
      case ButtonVariant.wide:
        return const Color.fromRGBO(1, 107, 228, 1);
      case ButtonVariant.roleActive:
        return const Color(0xFF1C4A97);
      case ButtonVariant.roleInactive:
        return const Color.fromRGBO(231, 231, 231, 1);
    }
  }

  Color get textColor {
    switch (this) {
      case ButtonVariant.primary:
      case ButtonVariant.wide:
      case ButtonVariant.roleActive:
        return Colors.white;
      case ButtonVariant.secondary:
      case ButtonVariant.tertiary:
      case ButtonVariant.outline:
        return const Color(0xFF1C4A97);
      case ButtonVariant.roleInactive:
        return const Color.fromRGBO(111, 108, 144, 1);
    }
  }

  Color get hoverBackgroundColor {
    switch (this) {
      case ButtonVariant.primary:
        return const Color(0xFF1C4A97).withOpacity(0.9);
      case ButtonVariant.secondary:
        return Colors.grey[100]!;
      case ButtonVariant.tertiary:
        return Colors.transparent;
      case ButtonVariant.outline:
        return const Color(0xFF1C4A97);
      case ButtonVariant.wide:
        return const Color.fromRGBO(1, 107, 228, 1).withOpacity(0.9);
      case ButtonVariant.roleActive:
        return const Color(0xFF1C4A97).withOpacity(0.9);
      case ButtonVariant.roleInactive:
        return const Color.fromRGBO(231, 231, 231, 0.9);
    }
  }

  Color get hoverTextColor {
    switch (this) {
      case ButtonVariant.primary:
      case ButtonVariant.wide:
      case ButtonVariant.roleActive:
        return Colors.white;
      case ButtonVariant.secondary:
      case ButtonVariant.tertiary:
        return const Color(0xFF1C4A97);
      case ButtonVariant.outline:
        return Colors.white;
      case ButtonVariant.roleInactive:
        return const Color.fromRGBO(111, 108, 144, 1);
    }
  }

  BorderSide get border {
    switch (this) {
      case ButtonVariant.outline:
        return const BorderSide(
          color: Color(0xFF1C4A97),
          width: 1,
        );
      case ButtonVariant.primary:
      case ButtonVariant.secondary:
      case ButtonVariant.tertiary:
      case ButtonVariant.wide:
      case ButtonVariant.roleActive:
      case ButtonVariant.roleInactive:
        return BorderSide.none;
    }
  }
}
