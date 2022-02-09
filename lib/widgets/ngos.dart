import 'package:flutter/material.dart';

class NGOs extends StatefulWidget {
  const NGOs({Key? key}) : super(key: key);

  @override
  _NGOsState createState() => _NGOsState();
}

class _NGOsState extends State<NGOs> {
  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: <Widget>[
        SliverAppBar(
          pinned: true,
          snap: false,
          floating: false,
          expandedHeight: 100.0,
          flexibleSpace: FlexibleSpaceBar(
            title: const Text('NGO'),
            background: Column(
              children: <Widget>[
                const SizedBox(height: 10.0),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              gapPadding: 0,
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            filled: true,
                            hintText: "Search by Name",
                            fillColor: Colors.white70,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: IconButton(
                          onPressed: () {},
                          icon: const Icon(Icons.filter),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
