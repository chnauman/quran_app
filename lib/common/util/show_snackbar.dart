import 'package:flutter/material.dart';

void showSnackBar(BuildContext context, String message,
        [VoidCallback? onPressed]) =>
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        action: onPressed == null
            ? null
            : SnackBarAction(label: "retry", onPressed: onPressed),
      ),
    );
