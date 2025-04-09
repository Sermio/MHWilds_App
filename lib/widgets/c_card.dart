import 'package:flutter/material.dart';
import 'package:mhwilds_app/models/decoration.dart';
import 'package:mhwilds_app/models/monster.dart';
import 'package:mhwilds_app/screens/decoration_details.dart';
import 'package:mhwilds_app/screens/monster_details.dart';
// import 'package:mh_app/data/decoration.dart';
// import 'package:mh_app/data/monster.dart';
// import 'package:mh_app/screens/monster_details_screen.dart';
// import 'package:mh_app/screens/decoration_details_screen.dart';

// ignore: must_be_immutable
class Ccard extends StatelessWidget {
  final dynamic cardData;
  final String cardTitle;
  final Widget? cardBody;
  String? cardSubtitle1 = "Subtitle1";
  String? cardSubtitle2 = "Subtitle2";
  String? cardSubtitle1Label = "cardSubtitle1Label";
  String? cardSubtitle2Label = "cardSubtitle2Label";
  final Widget? leading;
  final Widget? trailing;
  final Color? cardTitleColor;
  bool bodyOnTop;

  Ccard({
    super.key,
    required this.cardData,
    required this.cardTitle,
    this.cardBody,
    this.cardSubtitle1,
    this.cardSubtitle2,
    this.cardSubtitle1Label,
    this.cardSubtitle2Label,
    this.leading,
    this.trailing,
    this.cardTitleColor,
    this.bodyOnTop = true,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (cardData is Monster) {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => MonsterDetails(monster: cardData)),
          );
        } else if (cardData is DecorationItem) {
          // Navigator.push(
          //   context,
          //   MaterialPageRoute(
          //       builder: (context) => DecorationDetails(decoration: cardData)),
          // );
        }
        // else {
        //   // Redirigir a una pantalla por defecto
        //   Navigator.push(
        //     context,
        //     MaterialPageRoute(builder: (context) => DefaultScreen()), // Cambia esto por tu pantalla por defecto
        //   );
        // }
      },
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
        child: Card(
          // color: const Color.fromARGB(98, 124, 132, 116),
          elevation: 3,
          color: Colors.white,

          child: ListTile(
            leading: leading,
            trailing: trailing,
            title: Text(
              cardTitle,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: cardTitleColor,
              ),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (cardBody != null && bodyOnTop) ...[
                  cardBody!,
                  const SizedBox(height: 5),
                ],
                if (cardSubtitle1 != null && cardSubtitle1Label != null)
                  Row(
                    children: [
                      Text(
                        cardSubtitle1Label ?? "cardSubtitle1Label",
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        cardSubtitle1 ?? "subtitle1",
                      ),
                    ],
                  ),
                if (cardSubtitle2 != null && cardSubtitle2Label != null)
                  Row(
                    children: [
                      if (cardSubtitle2Label != null)
                        Text(
                          cardSubtitle2Label ?? "cardSubtitle2Label",
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      if (cardSubtitle2 != null)
                        Expanded(
                          child: Text(
                            cardSubtitle2 ?? "Unknown",
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style:
                                const TextStyle(fontWeight: FontWeight.normal),
                          ),
                        ),
                    ],
                  ),
                if (cardBody != null && !bodyOnTop) ...[
                  cardBody!,
                  const SizedBox(height: 5),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
