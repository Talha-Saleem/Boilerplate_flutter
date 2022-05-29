import "package:flutter/material.dart";

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({final Key? key, this.message = "Loading..."})
      : super(key: key);
  final String message;

  @override
  Widget build(final BuildContext context) => Material(
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircularProgressIndicator(),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(message),
            ),
          ],
        ),
      ),
    );
}
