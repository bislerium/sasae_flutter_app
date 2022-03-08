import 'package:flutter/material.dart';
import '../../models/ngo_.dart';
import 'ngo_card.dart';

class NGOList extends StatefulWidget {
  final List<NGO_> ngoList;

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
    return ListView(
      controller: listScroll,
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      physics: const AlwaysScrollableScrollPhysics(),
      children: widget.ngoList
          .map((e) => NGOCard(
                key: ValueKey(e.id),
                ngo_: e,
              ))
          .toList(),
    );
  }
}
