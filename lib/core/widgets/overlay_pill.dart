import 'package:flutter/material.dart';

class OverlayPill extends StatelessWidget {
  final String message;

  const OverlayPill({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.black87,
            borderRadius: BorderRadius.circular(50),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.25),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}

void showOverlayPill(BuildContext context, String message) {
  final overlay = Overlay.of(context);

  final entry = OverlayEntry(
    builder: (context) => Positioned(
      bottom: 50,
      left: 0,
      right: 0,
      child: OverlayPill(message: message),
    ),
  );

  overlay.insert(entry);

  Future.delayed(const Duration(seconds: 2), () {
    if (entry.mounted) {
      entry.remove();
    }
  });
}
