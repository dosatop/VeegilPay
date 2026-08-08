import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:veegil_pay/core/theme/app_colors.dart';

class CustomTextfield extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final IconData iconType;
  final String textFieldName;
  final bool obscureText;
  final bool showPasswordToggle;
  final TextInputType textInputType;
  final String? Function(String?)? validator;
  final bool forceObscure;
  final bool enabled;

  final List<TextInputFormatter>? inputFormatters;

  const CustomTextfield({
    super.key,
    required this.controller,
    required this.hintText,
    required this.iconType,
    required this.textFieldName,
    required this.textInputType,
    required this.obscureText,
    this.showPasswordToggle = false,
    this.validator,
    this.inputFormatters,
    this.forceObscure = false,
    this.enabled = true,
  });

  @override
  State<CustomTextfield> createState() => _CustomTextfieldState();
}

class _CustomTextfieldState extends State<CustomTextfield> {
  final FocusNode _focusNode = FocusNode();

  late bool _obscureText;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.obscureText;

    _focusNode.addListener(() {
      setState(() {});
    });
  }

  @override
  void didUpdateWidget(CustomTextfield oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.forceObscure && !oldWidget.forceObscure) {
      setState(() {
        _obscureText = true;
      });
    }
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,

      children: [
        Text(
          widget.textFieldName,
          style: const TextStyle(fontWeight: FontWeight.w500),
        ),

        const SizedBox(height: 5),

        TextFormField(
          enabled: widget.enabled,
          obscureText: _obscureText,

          focusNode: _focusNode,

          controller: widget.controller,

          validator: widget.validator,

          keyboardType: widget.textInputType,

          style: const TextStyle(fontSize: 14),

          inputFormatters: widget.inputFormatters,

          decoration: InputDecoration(
            hintText: widget.hintText,

            prefixIcon: Icon(
              widget.iconType,
              color: _focusNode.hasFocus ? AppColors.primary : Colors.grey,
            ),

            suffixIcon: widget.showPasswordToggle
                ? IconButton(
                    icon: Icon(
                      _obscureText
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      size: 18,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscureText = !_obscureText;
                      });
                    },
                  )
                : null,

            filled: true,

            fillColor: Colors.white,

            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 15,
            ),

            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),

            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade400),
            ),

            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.primary, width: 2),
            ),

            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.error),
            ),

            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.error, width: 2),
            ),

            errorStyle: const TextStyle(height: 0.8, fontSize: 12),
          ),
        ),
      ],
    );
  }
}
