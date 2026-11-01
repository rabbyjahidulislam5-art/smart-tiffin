import 'package:flutter/material.dart';

import '../theme/st_colors.dart';
import '../theme/st_role_theme.dart';

class StField extends StatelessWidget {
  const StField({
    super.key,
    required this.label,
    this.controller,
    this.error,
    this.hint,
    this.obscure = false,
    this.keyboardType,
    this.onChanged,
    this.placeholder,
    this.enabled = true,
    this.maxLines = 1,
  });

  final String label;
  final TextEditingController? controller;
  final String? error;
  final String? hint;
  final bool obscure;
  final TextInputType? keyboardType;
  final ValueChanged<String>? onChanged;
  final String? placeholder;
  final bool enabled;
  final int maxLines;

  @override
  Widget build(BuildContext context) {
    final role = context.roleColor;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(child: Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600))),
            if (hint != null) Text(hint!, style: TextStyle(fontSize: 12, color: Theme.of(context).hintColor)),
          ],
        ),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          obscureText: obscure,
          keyboardType: keyboardType,
          onChanged: onChanged,
          enabled: enabled,
          maxLines: maxLines,
          decoration: InputDecoration(
            hintText: placeholder,
            filled: true,
            fillColor: Theme.of(context).brightness == Brightness.dark
                ? StColors.darkMuted.withValues(alpha: 0.7)
                : StColors.muted.withValues(alpha: 0.7),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: error != null ? StColors.danger : Colors.transparent),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: error != null ? StColors.danger : Colors.transparent),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: role.withValues(alpha: 0.5), width: 2),
            ),
          ),
        ),
        if (error != null) ...[
          const SizedBox(height: 4),
          Text(error!, style: const TextStyle(fontSize: 12, color: StColors.danger, fontWeight: FontWeight.w500)),
        ],
      ],
    );
  }
}
