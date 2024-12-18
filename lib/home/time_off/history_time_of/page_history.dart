import 'package:flutter/material.dart';
import '/components/primary_container.dart';
import 'content_history.dart';

class PageHistory extends StatelessWidget {
  const PageHistory({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PrimaryContainer(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(0),
            topRight: Radius.circular(0),
            bottomLeft: Radius.circular(0),
            bottomRight: Radius.circular(0)),
        width: MediaQuery.of(context).size.width,
        child: const ContentHistory(),
      ),
    );
  }
}
