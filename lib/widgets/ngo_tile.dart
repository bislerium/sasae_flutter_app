import 'package:flutter/material.dart';
import '../models/ngo.dart';

class NGOTile extends StatelessWidget {
  final NGO ngo;

  const NGOTile({Key? key, required this.ngo}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      shadowColor: Theme.of(context).primaryColorLight,
      margin: const EdgeInsets.symmetric(vertical: 10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
      ),
      child: InkWell(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: Image.network(
                  ngo.orgPhoto!,
                  fit: BoxFit.cover,
                  height: 100.0,
                  width: 100.0,
                ),
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
                                size: 18,
                                color: Theme.of(context).primaryColor,
                              ),
                              Text(
                                ngo.address!,
                                style: const TextStyle(color: Colors.black87),
                              )
                            ],
                          ),
                          Text(ngo.estDate!.year.toString()),
                        ],
                      ),
                      Text(
                        ngo.orgName!,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      SizedBox(
                        height: 40,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: ngo.fieldOfWork!.length,
                          itemBuilder: (context, _) {
                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 2),
                              child: Chip(
                                label: Text(
                                  ngo.fieldOfWork![_],
                                  style: TextStyle(
                                      color:
                                          Theme.of(context).primaryColorDark),
                                ),
                                backgroundColor:
                                    Theme.of(context).primaryColorLight,
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
        onTap: () => ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('You have clicked'),
          ),
        ),
      ),
    );
  }
}
