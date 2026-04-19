import 'package:flutter/material.dart';

class QuantitySelector extends StatelessWidget {
  const QuantitySelector({
    super.key,
    required this.quantity,
    required this.onIncrease,
    required this.onDecrease,
    this.compact = false,
  });

  final int quantity;
  final VoidCallback onIncrease;
  final VoidCallback onDecrease;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final double height = compact ? 32 : 40;
    final double iconSize = compact ? 16 : 18;

    return Container(
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.green.shade50,
        border: Border.all(color: Colors.green.shade200),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _ActionButton(icon: Icons.remove, size: iconSize, onTap: onDecrease),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Text(
              '$quantity',
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
          ),
          _ActionButton(icon: Icons.add, size: iconSize, onTap: onIncrease),
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.icon,
    required this.size,
    required this.onTap,
  });

  final IconData icon;
  final double size;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(8),
      onTap: onTap,
      child: SizedBox(
        width: 34,
        height: double.infinity,
        child: Icon(icon, size: size, color: Colors.green.shade800),
      ),
    );
  }
}
