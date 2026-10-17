import 'package:flutter/material.dart';

String getTypeImage(String skillKind) {
  switch (skillKind) {
    case 'weapon':
      return 'assets/imgs/weapons/artian.webp';
    case 'armor':
      return 'assets/imgs/drawer/armor.webp';
    case 'group':
      return 'assets/imgs/armor/chest/group_armor.webp';
    case 'set':
      return 'assets/imgs/armor/chest/set_armor.webp';
    default:
      return 'assets/imgs/weapons/artian.webp';
  }
}

Widget getJewelSlotIcon(int slot) {
  if (slot == 1) {
    return Image.asset('assets/imgs/decorations/gem_level_1.png',
        excludeFromSemantics: true);
  }
  if (slot == 2) {
    return Image.asset('assets/imgs/decorations/gem_level_2.png',
        excludeFromSemantics: true);
  }
  if (slot == 3) {
    return Image.asset('assets/imgs/decorations/gem_level_3.png',
        excludeFromSemantics: true);
  }
  if (slot == 4) {
    return Image.asset('assets/imgs/decorations/gem_level_4.png',
        excludeFromSemantics: true);
  }
  return Image.asset('assets/imgs/decorations/gem_level_1.png',
      excludeFromSemantics: true);
}

String getKindImage(String skillKind) {
  switch (skillKind) {
    case 'head':
      return 'assets/imgs/armor/head/rarity8.webp';
    case 'chest':
      return 'assets/imgs/armor/chest/rarity8.webp';
    case 'arms':
      return 'assets/imgs/armor/arms/rarity8.webp';
    case 'waist':
      return 'assets/imgs/armor/waist/rarity8.webp';
    case 'legs':
      return 'assets/imgs/armor/legs/rarity8.webp';
    default:
      return 'assets/imgs/armor/chest/rarity8.webp';
  }
}
