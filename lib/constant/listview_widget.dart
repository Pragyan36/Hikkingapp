import 'package:flutter/material.dart';

class ListItemWidget extends StatelessWidget {
  final Widget leading;
  final String title;
  final Widget? trailing;
  final bool selected;
  final void Function(bool?)? onCheckboxChanged;
  final VoidCallback? onTap;

  const ListItemWidget({
    super.key,
    required this.leading,
    required this.title,
    this.trailing,
    this.selected = false,
    this.onCheckboxChanged,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.grey[850],
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              if (onCheckboxChanged != null)
                Checkbox(
                  value: selected,
                  activeColor: Colors.red,
                  onChanged: onCheckboxChanged,
                ),
              leading,
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
              if (trailing != null) trailing!,
            ],
          ),
        ),
      ),
    );
  }
}
