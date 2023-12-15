import 'package:flutter/material.dart';

class Folder extends StatefulWidget {
  Folder({
    super.key,
    required this.text,
    required this.icon,
    required this.onPressed,
  });

  Text text;
  Icon icon;
  VoidCallback onPressed;

  @override
  State<Folder> createState() => _FolderState();
}

class _FolderState extends State<Folder> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onPressed,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.background,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.5),
              spreadRadius: 1,
              blurRadius: 3,
              offset: const Offset(0, 0),
            ),
          ],
        ),
        child: Row(
          children: [
            widget.icon,
            const Padding(padding: EdgeInsets.only(right: 10)),
            widget.text,
          ],
        ),
      ),
    );
  }
}
