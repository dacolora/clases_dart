import 'package:flutter/material.dart';

import '../departamento.dart';

class ItemListCard extends StatefulWidget {
  final Departamento departamento;
  const ItemListCard({
    required this.departamento,
    super.key,
  });

  @override
  State<ItemListCard> createState() => _ItemListCardState();
}

class _ItemListCardState extends State<ItemListCard> {
  bool isClosedCard = true;
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: GestureDetector(
          onTap: () {
            setState(() {
              isClosedCard = !isClosedCard;
            });
          },
          child: isClosedCard ? closedCard() : openCard(),
        ));
  }

  Card openCard() {
    return Card(
      color: const Color(0xFF353537),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(22.0),
      ),
      child: ClipRRect(
          borderRadius: BorderRadius.circular(22.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.asset(
                fit: BoxFit.fill,
                widget.departamento.image,
                height: 170.0,
                width: 170.0,
              ),
              const SizedBox(
                width: 8,
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.departamento.name,
                        style: const TextStyle(color: Colors.white),
                      ),
                      Text(
                        'Capital: ${widget.departamento.capital}',
                        style: const TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(top: 10.0),
                child: Icon(
                  Icons.arrow_upward_sharp,
                  color: Colors.white,
                ),
              ),
              const SizedBox(
                width: 16,
              ),
            ],
          )),
    );
  }

  Card closedCard() {
    return Card(
      color: const Color(0xFF353537),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(22.0),
      ),
      child: ClipRRect(
          borderRadius: BorderRadius.circular(22.0),
          child: Row(
            children: [
              Image.asset(
                fit: BoxFit.fill,
                widget.departamento.image,
                height: 50.0,
                width: 100.0,
              ),
              const SizedBox(
                width: 16,
              ),
              Text(
                '${widget.departamento.id}. ${widget.departamento.name}',
                style: const TextStyle(color: Colors.white),
              ),
              const Spacer(),
              const Icon(
                Icons.arrow_downward_sharp,
                color: Colors.white,
              ),
              const SizedBox(
                width: 16,
              ),
            ],
          )),
    );
  }
}
