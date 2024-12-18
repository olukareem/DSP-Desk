import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTextField extends StatefulWidget {
  final String label;
  final String hintText;
  final bool isRequired;
  final TextInputType keyboardType;
  final int? maxLines;
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final String? Function(String?)? validator;
  final bool obscureText;
  final bool showPasswordToggle;
  final Color? textColor;
  final Color? labelColor;
  final Color? hintTextColor;
  final double? labelSize;

  const AppTextField({
    super.key,
    required this.label,
    required this.hintText,
    this.isRequired = false,
    this.keyboardType = TextInputType.text,
    this.maxLines = 1,
    this.controller,
    this.onChanged,
    this.validator,
    this.obscureText = false,
    this.showPasswordToggle = false,
    this.textColor,
    this.labelColor,
    this.hintTextColor,
    this.labelSize,
  });

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  bool _passwordVisible = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              widget.label,
              style: GoogleFonts.montserrat(
                fontSize: widget.labelSize ?? 16,
                fontWeight: FontWeight.w500,
                color:
                    widget.labelColor ?? const Color.fromRGBO(102, 112, 133, 1),
              ),
            ),
            if (widget.isRequired)
              const Text(
                ' *',
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 16,
                ),
              ),
          ],
        ),
        const SizedBox(height: 6),
        TextFormField(
          controller: widget.controller,
          onChanged: widget.onChanged,
          keyboardType: widget.keyboardType,
          maxLines: widget.maxLines,
          obscureText: widget.obscureText && !_passwordVisible,
          validator: widget.validator,
          style: GoogleFonts.montserrat(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: widget.textColor ?? const Color.fromRGBO(102, 112, 133, 1),
          ),
          decoration: InputDecoration(
            hintText: widget.hintText,
            hintStyle: GoogleFonts.montserrat(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: widget.hintTextColor ??
                  const Color.fromRGBO(102, 112, 133, 0.5),
            ),
            suffixIcon: widget.showPasswordToggle
                ? IconButton(
                    icon: Icon(
                      _passwordVisible
                          ? Icons.visibility
                          : Icons.visibility_off,
                      color: Colors.grey,
                    ),
                    onPressed: () {
                      setState(() {
                        _passwordVisible = !_passwordVisible;
                      });
                    },
                  )
                : null,
          ),
        ),
      ],
    );
  }
}

class AppDropdownField<T> extends StatelessWidget {
  final String label;
  final bool isRequired;
  final List<T> items;
  final T? value;
  final ValueChanged<T?> onChanged;
  final String? Function(T?)? validator;
  final String hintText;

  const AppDropdownField({
    super.key,
    required this.label,
    required this.items,
    required this.onChanged,
    this.value,
    this.isRequired = false,
    this.validator,
    this.hintText = '',
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              label,
              style: GoogleFonts.montserrat(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: const Color.fromRGBO(102, 112, 133, 1),
              ),
            ),
            if (isRequired)
              const Text(
                ' *',
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 16,
                ),
              ),
          ],
        ),
        const SizedBox(height: 6),
        DropdownButtonFormField<T>(
          value: value,
          decoration: InputDecoration(
            isDense: true,
            hintText: hintText,
            hintStyle: GoogleFonts.montserrat(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: const Color.fromRGBO(102, 112, 133, 0.5),
            ),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6),
              borderSide: const BorderSide(
                color: Color.fromRGBO(208, 213, 221, 1),
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6),
              borderSide: const BorderSide(
                color: Color.fromRGBO(208, 213, 221, 1),
              ),
            ),
          ),
          icon: const Icon(
            Icons.keyboard_arrow_down,
            color: Color.fromRGBO(102, 112, 133, 1),
          ),
          isExpanded: true,
          items: items
              .map((item) => DropdownMenuItem<T>(
                    value: item,
                    child: Text(
                      item.toString(),
                      style: GoogleFonts.montserrat(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: const Color.fromRGBO(102, 112, 133, 1),
                      ),
                    ),
                  ))
              .toList(),
          onChanged: onChanged,
          validator: validator,
          style: GoogleFonts.montserrat(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: const Color.fromRGBO(102, 112, 133, 1),
          ),
        ),
      ],
    );
  }
}

class AppDateField extends AppTextField {
  final DateTime? initialDate;
  final DateTime? firstDate;
  final DateTime? lastDate;
  final Function(DateTime)? onDateSelected;

  const AppDateField({
    super.key,
    required super.label,
    required super.hintText,
    super.isRequired = false,
    super.controller,
    this.initialDate,
    this.firstDate,
    this.lastDate,
    this.onDateSelected,
  }) : super(
          keyboardType: TextInputType.none,
        );

  @override
  _AppDateFieldState createState() => _AppDateFieldState();
}

class _AppDateFieldState extends State<AppTextField> {
  String _formatDate(DateTime date) {
    return "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              widget.label,
              style: GoogleFonts.montserrat(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: const Color(0xFF344054),
              ),
            ),
            if (widget.isRequired)
              const Text(
                ' *',
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 16,
                ),
              ),
          ],
        ),
        const SizedBox(height: 6),
        TextFormField(
          controller: widget.controller,
          readOnly: true,
          decoration: InputDecoration(
            hintText: widget.hintText,
            suffixIcon: const Icon(Icons.calendar_today),
          ),
          onTap: () async {
            final DateTime? picked = await showDatePicker(
              context: context,
              initialDate:
                  (widget as AppDateField).initialDate ?? DateTime.now(),
              firstDate: (widget as AppDateField).firstDate ?? DateTime(2000),
              lastDate: (widget as AppDateField).lastDate ?? DateTime(2100),
            );

            if (picked != null) {
              widget.controller?.text = _formatDate(picked);
              (widget as AppDateField).onDateSelected?.call(picked);
            }
          },
        ),
      ],
    );
  }
}
