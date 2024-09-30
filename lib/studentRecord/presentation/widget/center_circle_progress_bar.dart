import 'package:flutter/material.dart';

class CenterCircleProgressBar extends StatelessWidget {
  const CenterCircleProgressBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Center(child: CircularProgressIndicator());
  }
}
