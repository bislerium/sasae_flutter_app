import 'package:flutter/material.dart';
import 'package:sasae_flutter_app/widgets/misc/custom_card.dart';
import 'package:sasae_flutter_app/widgets/misc/custom_widgets.dart';
import 'package:sasae_flutter_app/widgets/post/post_type/post_dependent_widgets/dismissable_tile.dart';

class FormCardPollPost extends StatefulWidget {
  final List<String> pollItems;

  const FormCardPollPost({Key? key, required this.pollItems}) : super(key: key);

  @override
  _FormCardPollPostState createState() => _FormCardPollPostState();
}

class _FormCardPollPostState extends State<FormCardPollPost> {
  _FormCardPollPostState() : itemTEC = TextEditingController();

  TextEditingController itemTEC;

  @override
  void dispose() {
    itemTEC.dispose();
    super.dispose();
  }

  void addItem(String item) => setState(() {
        widget.pollItems.add(item);
      });

  void removeItem(String index) => setState(() {
        widget.pollItems.remove(index);
      });

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () {
                showModalSheet(ctx: context, children: [
                  TextField(
                    controller: itemTEC,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      addItem(itemTEC.text);
                      itemTEC.clear();
                      Navigator.of(context).pop();
                    },
                    child: Text('Add'),
                  ),
                ]);
              },
              child: Text('Add poll'),
            ),
            SizedBox(
              height: 800,
              child: ListView.builder(
                itemCount: widget.pollItems.length,
                itemBuilder: (context, index) {
                  String pollItem = widget.pollItems[index];
                  return DissmissableTile(
                      item: pollItem,
                      removeHandler: (value) => removeItem(pollItem));
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
