import 'package:flutter/material.dart';

class BBIconButton extends StatefulWidget {
  BBIconButton({
    super.key,
    required this.onPressed,
    required this.icon,
    required this.label,
    this.width = 0.0,
  });

  VoidCallback onPressed;
  Icon icon;
  Widget label;
  double width;

  @override
  State<BBIconButton> createState() => _BBIconButtonState();
}

class _BBIconButtonState extends State<BBIconButton> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width == 0.0 ? null : widget.width,
      child: ElevatedButton.icon(
        onPressed: widget.onPressed,
        style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            backgroundColor: Theme.of(context).colorScheme.secondary,
            padding: const EdgeInsets.all(14)),
        icon: widget.icon,
        label: widget.label,
      ),
    );
  }
}
