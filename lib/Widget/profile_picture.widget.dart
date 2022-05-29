import "package:flutter/material.dart";

class ProfilePictureWidget extends StatelessWidget {
  const ProfilePictureWidget({
    required this.path,
    required this.size,
    final Key? key,
  }) : super(key: key);
  final String path;
  final double size;

  @override
  Widget build(final BuildContext context) => SizedBox.square(
        dimension: size,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(1000),
          child: Image.asset(path),
        ),
      );
}
