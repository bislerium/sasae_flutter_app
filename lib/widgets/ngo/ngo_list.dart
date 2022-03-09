import 'package:flutter/material.dart';
import 'package:sasae_flutter_app/models/ngo_.dart';
import 'package:sasae_flutter_app/widgets/ngo/ngo_card.dart';

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
    return ListView.builder(
      controller: listScroll,
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      physics: const AlwaysScrollableScrollPhysics(),
      itemCount: widget.ngoList.length,
      itemBuilder: (context, index) => NGOCard(
        key: ValueKey('ngoCard-${widget.ngoList[index].id}'),
        ngo_: widget.ngoList[index],
      ),
    );
  }
}
