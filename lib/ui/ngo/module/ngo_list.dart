import 'package:flutter/material.dart';
import 'package:sasae_flutter_app/models/ngo_.dart';
import 'package:sasae_flutter_app/ui/ngo/module/ngo_card.dart';

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
      padding: const EdgeInsets.fromLTRB(15, 0, 15, 10),
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
