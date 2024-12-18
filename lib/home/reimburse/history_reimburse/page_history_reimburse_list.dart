import 'package:flutter/material.dart';
import '/components/primary_container.dart';
import '/components/text_style.dart';

import 'history_reimburse_list.dart';

class PageHistoryReimburseList extends StatelessWidget {
  const PageHistoryReimburseList({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Image.asset('assets/appBar_bg_full.png', fit: BoxFit.cover),
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 15.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(Icons.arrow_back),
                      color: Colors.white,
                    ),
                    Text(
                      'Reimburse History',
                      style: AppTextStyles.heading1_2,
                    ),
                    const SizedBox(width: 40)
                  ],
                ),
              ),
              const SizedBox(height: 30),
              Expanded(
                child: PrimaryContainer(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(15),
                      topRight: Radius.circular(15),
                      bottomLeft: Radius.circular(0),
                      bottomRight: Radius.circular(0)),
                  width: MediaQuery.of(context).size.width,
                  height: 200,
                  child: const HistoryReimburseList(),
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
