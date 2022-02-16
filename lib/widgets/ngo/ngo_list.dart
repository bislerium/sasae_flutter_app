import 'package:flutter/material.dart';
import '../../models/ngo.dart';
import 'ngo_card.dart';

class NGOList extends StatefulWidget {
  final List<NGO> ngoList;

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

  void _scrollDown() {
    listScroll.animateTo(
      listScroll.position.minScrollExtent,
      duration: const Duration(milliseconds: 500),
      curve: Curves.linear,
    );
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
                ngo: e,
              ))
          .toList(),
    );
  }
}
