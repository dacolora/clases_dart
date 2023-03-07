import 'package:flutter/material.dart';

import 'widgets/item_list_card.dart';
import '../../../infraestructure/list_mock.dart';

class ListPage extends StatefulWidget {
  static const routeName = '/listPage';
  const ListPage({super.key});

  @override
  State<ListPage> createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      child: ListView.builder(
        itemCount: listMock.length,
        itemBuilder: (_, index) {
          return ItemListCard(
            departamento: listMock[index],
          );
        },
      ),
    );
  }
}
