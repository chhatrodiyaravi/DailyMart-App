import 'package:flutter/material.dart';

class CustomSearchBar extends StatelessWidget {
  const CustomSearchBar({
    super.key,
    this.hintText = "Search 'milk', 'bread'...",
    this.controller,
    this.onTap,
    this.onChanged,
    this.onSubmitted,
    this.readOnly = false,
  });

  final String hintText;
  final TextEditingController? controller;
  final VoidCallback? onTap;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final bool readOnly;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 10),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        elevation: 1,
        child: SizedBox(
          height: 48,
          child: TextField(
            controller: controller,
            readOnly: readOnly,
            onTap: onTap,
            onChanged: onChanged,
            onSubmitted: onSubmitted,
            textInputAction: TextInputAction.search,
            textAlignVertical: TextAlignVertical.center,
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: TextStyle(
                color: Colors.grey.shade600,
                fontWeight: FontWeight.w500,
              ),
              prefixIcon: Icon(Icons.search, color: Colors.grey.shade600),
              suffixIcon: Icon(Icons.mic_none, color: Colors.grey.shade600),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 0,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
