import 'package:flutter/material.dart';

class StChipRow extends StatelessWidget {
  const StChipRow({super.key, required this.options, required this.value, required this.onChanged});
  final List<({String v, String l})> options;
  final String value;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          for (final o in options) ...[
            GestureDetector(
              onTap: () => onChanged(o.v),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: value == o.v
                      ? Theme.of(context).colorScheme.onSurface
                      : Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(99),
                  border: Border.all(
                    color: value == o.v
                        ? Theme.of(context).colorScheme.onSurface
                        : Theme.of(context).dividerColor,
                  ),
                ),
                child: Text(
                  o.l,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: value == o.v
                        ? Theme.of(context).colorScheme.surface
                        : Theme.of(context).colorScheme.onSurface,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
          ],
        ],
      ),
    );
  }
}
