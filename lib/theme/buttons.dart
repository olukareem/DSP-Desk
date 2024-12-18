import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AppButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final ButtonSize size;
  final ButtonVariant variant;
  final bool isFullWidth;
  final double? customWidth;
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
    this.customWidth,
    this.isLoading = false,
    this.leftIcon,
    this.rightIcon,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: customWidth ?? (isFullWidth ? double.infinity : null),
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

class FilterButton extends StatelessWidget {
  final VoidCallback onPressed;

  const FilterButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 36,
      width: 73,
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          side: const BorderSide(color: Color(0xFF1C4A97)),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        onPressed: onPressed,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Filter',
              style: TextStyle(
                fontFamily: 'Montserrat',
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Color(0xFF1C4A97),
              ),
            ),
            const SizedBox(width: 4),
            const Icon(Icons.filter_list, color: Color(0xFF1C4A97), size: 16),
          ],
        ),
      ),
    );
  }
}

class SortByButton extends StatelessWidget {
  final VoidCallback onPressed;

  const SortByButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 36,
      width: 88,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color.fromRGBO(227, 232, 242, 1),
          padding: const EdgeInsets.symmetric(horizontal: 8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        onPressed: onPressed,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Sort By',
              style: TextStyle(
                fontFamily: 'Montserrat',
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Color.fromRGBO(28, 74, 151, 1),
              ),
            ),
            const SizedBox(width: 4),
            const Icon(
              Icons.keyboard_arrow_down,
              size: 16,
              color: Color.fromRGBO(28, 74, 151, 1),
            ),
          ],
        ),
      ),
    );
  }
}

class SearchButton extends StatelessWidget {
  final VoidCallback onPressed;

  const SearchButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: const Color(0xFFFFFFFF),
          border: Border.all(
            color: const Color(0xFFE4E2E6),
            width: 1,
          ),
          borderRadius: BorderRadius.circular(8),
          boxShadow: const [
            BoxShadow(
              color: Color.fromRGBO(16, 24, 40, 0.05),
              blurRadius: 2,
              offset: Offset(0, 1),
            ),
          ],
        ),
        child: Center(
          child: SvgPicture.asset(
            'assets/icons/search.svg',
            width: 12,
            height: 12,
            colorFilter: const ColorFilter.mode(
              Color(0xFF8D8D8D),
              BlendMode.srcIn,
            ),
          ),
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
