import 'package:flutter/material.dart';
import 'package:sasae_flutter_app/models/ngo_.dart';
import 'package:sasae_flutter_app/services/utilities.dart';
import 'package:sasae_flutter_app/widgets/misc/custom_card.dart';
import 'package:sasae_flutter_app/widgets/misc/custom_image.dart';
import 'package:sasae_flutter_app/ui/ngo/ngo_profile_screen.dart';

class NGOList extends StatefulWidget {
  final List<NGO_Model> ngoList;

  const NGOList({Key? key, required this.ngoList}) : super(key: key);

  @override
  State<NGOList> createState() => _NGOListState();
}

class _NGOListState extends State<NGOList> {
  final ScrollController listScroll;

  _NGOListState() : listScroll = ScrollController();

  @override
  void dispose() {
    listScroll.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: listScroll,
      padding: const EdgeInsets.fromLTRB(12, 0, 12, 6),
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      physics: const AlwaysScrollableScrollPhysics(),
      itemCount: widget.ngoList.length,
      itemBuilder: (context, index) => NGOCard(
        key: ValueKey('ngoCard${widget.ngoList[index].ngoID}'),
        ngo_: widget.ngoList[index],
      ),
    );
  }
}

class NGOCard extends StatelessWidget {
  final NGO_Model ngo_;

  const NGOCard({Key? key, required this.ngo_}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          if (!isInternetConnected(context)) return;
          Navigator.pushNamed(context, NGOProfileScreen.routeName,
              arguments: {'ngoID': ngo_.ngoID});
        },
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            children: [
              CustomImage(
                imageURL: ngo_.orgPhoto,
                width: 100.0,
                radius: 12,
                onTapViewImage: false,
                includeHero: false,
              ),
              Expanded(
                child: Container(
                  height: 100,
                  padding: const EdgeInsets.fromLTRB(8, 0, 0, 0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.location_pin,
                                size: 15,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                              const SizedBox(
                                width: 4,
                              ),
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.4,
                                child: Text(
                                  ngo_.address,
                                  style: Theme.of(context)
                                      .textTheme
                                      .caption
                                      ?.copyWith(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSurface,
                                      ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                          Text(
                            ngo_.estDate.year.toString(),
                            style: Theme.of(context)
                                .textTheme
                                .caption
                                ?.copyWith(
                                  color:
                                      Theme.of(context).colorScheme.onSurface,
                                ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 20,
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Text(
                            ngo_.orgName,
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 40,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: ngo_.fieldOfWork.length,
                          itemBuilder: (context, _) {
                            return Padding(
                              padding: const EdgeInsets.fromLTRB(0, 0, 6, 0),
                              child: Chip(
                                label: Text(
                                  ngo_.fieldOfWork[_],
                                  style: Theme.of(context)
                                      .textTheme
                                      .subtitle2
                                      ?.copyWith(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSecondaryContainer,
                                      ),
                                ),
                                backgroundColor: Theme.of(context)
                                    .colorScheme
                                    .secondaryContainer,
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
