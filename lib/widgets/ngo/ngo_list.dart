import 'package:flutter/material.dart';
import '../../models/ngo.dart';
import './ngo_tile.dart';

class NGOList extends StatelessWidget {
  final List<NGO> ngoList;

  const NGOList({Key? key, required this.ngoList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      physics: const AlwaysScrollableScrollPhysics(),
      children: ngoList
          .map((e) => NGOTile(
                key: ValueKey(e.id),
                ngo: e,
              ))
          .toList(),
    );
  }
}
