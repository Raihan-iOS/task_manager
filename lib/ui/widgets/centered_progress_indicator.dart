import 'package:flutter/material.dart';

class centered_circular_progress_indicator extends StatelessWidget {
  const centered_circular_progress_indicator({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(child: CircularProgressIndicator());
  }
}
