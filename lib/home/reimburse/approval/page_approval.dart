import 'package:flutter/material.dart';

import '../../../components/primary_container.dart';
import 'content_approval.dart';

class PageApproval extends StatelessWidget {
  const PageApproval({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PrimaryContainer(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(0),
        width: MediaQuery.of(context).size.width,
        child: const ContentApproval(),
      ),
    );
  }
}
