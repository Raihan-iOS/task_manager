import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class photo_upload_field extends StatelessWidget {
  const photo_upload_field({
    super.key,
    required this.onTap,
    required this.selectedImage,
  });
  final VoidCallback onTap;
  final XFile? selectedImage;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 50,
        width: double.maxFinite,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Row(
          spacing: 16,
          children: [
            Container(
              height: 50,
              width: 80,
              decoration: BoxDecoration(
                color: Colors.grey.shade900,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(6),
                  bottomLeft: Radius.circular(6),
                ),
              ),
              alignment: Alignment.center,
              child: Text('Photo', style: TextStyle(color: Colors.white)),
            ),
            Expanded(
              child: Text(
                selectedImage?.name ?? 'No file chosen',
                maxLines: 1,
                style: TextStyle(
                  color: Colors.grey,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
