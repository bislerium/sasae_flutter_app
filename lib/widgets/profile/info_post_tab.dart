import 'package:flutter/material.dart';

class InfoPostTab extends StatelessWidget {
  final Widget infoTab;
  final Widget postTab;
  const InfoPostTab({Key? key, required this.infoTab, required this.postTab})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: ListView(
        children: [
          Row(
            children: [
              const Spacer(),
              Container(
                padding: const EdgeInsets.all(5),
                margin: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: Theme.of(context).colorScheme.secondaryContainer,
                ),
                child: TabBar(
                  isScrollable: true,
                  labelColor: Theme.of(context).colorScheme.onSecondary,
                  unselectedLabelColor:
                      Theme.of(context).colorScheme.onSecondaryContainer,
                  indicator: BoxDecoration(
                    color: Theme.of(context).colorScheme.secondary,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  enableFeedback: true,
                  tabs: const [
                    Tab(
                      icon: Icon(
                        Icons.info_outline_rounded,
                      ),
                    ),
                    Tab(
                      icon: Icon(
                        Icons.post_add_outlined,
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
            ],
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.745,
            child: TabBarView(
              children: [
                infoTab,
                // Center(child: Icon(Icons.auto_awesome)),
                Center(child: Icon(Icons.directions_bike)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
