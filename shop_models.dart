import 'package:flutter/material.dart';

enum ShopCategory { backgrounds, hats, glasses, outfits, accessories, pets }

extension ShopCategoryX on ShopCategory {
  String get label {
    switch (this) {
      case ShopCategory.backgrounds:
        return 'Fondos';
      case ShopCategory.hats:
        return 'Gorras';
      case ShopCategory.glasses:
        return 'Gafas';
      case ShopCategory.outfits:
        return 'Ropa';
      case ShopCategory.accessories:
        return 'Accesorios';
      case ShopCategory.pets:
        return 'Mascotas';
    }
  }

  IconData get icon {
    switch (this) {
      case ShopCategory.backgrounds:
        return Icons.image_outlined;
      case ShopCategory.hats:
        return Icons.checkroom_outlined;
      case ShopCategory.glasses:
        return Icons.visibility_outlined;
      case ShopCategory.outfits:
        return Icons.style_outlined;
      case ShopCategory.accessories:
        return Icons.auto_awesome_outlined;
      case ShopCategory.pets:
        return Icons.pets_outlined;
    }
  }
}

class ShopItem {
  final String id;
  final ShopCategory category;
  final String name;
  final int priceVaros;

  /// Puede ser un asset, un color, o un "skinId" que tu personaje entiende.
  final String? asset;
  final Color? color;

  const ShopItem({
    required this.id,
    required this.category,
    required this.name,
    required this.priceVaros,
    this.asset,
    this.color,
  });
}

class EquippedCosmetics {
  final String? backgroundId;
  final String? hatId;
  final String? glassesId;
  final String? outfitId;
  final String? accessoryId;
  final String? petId;

  const EquippedCosmetics({
    this.backgroundId,
    this.hatId,
    this.glassesId,
    this.outfitId,
    this.accessoryId,
    this.petId,
  });

  EquippedCosmetics copyWith({
    String? backgroundId,
    String? hatId,
    String? glassesId,
    String? outfitId,
    String? accessoryId,
    String? petId,
  }) {
    return EquippedCosmetics(
      backgroundId: backgroundId ?? this.backgroundId,
      hatId: hatId ?? this.hatId,
      glassesId: glassesId ?? this.glassesId,
      outfitId: outfitId ?? this.outfitId,
      accessoryId: accessoryId ?? this.accessoryId,
      petId: petId ?? this.petId,
    );
  }
}

class ShopState {
  final int varos;
  final int hpMax;
  final int hpCurrent;

  final Set<String> ownedItemIds;
  final EquippedCosmetics equipped;

  const ShopState({
    required this.varos,
    required this.hpMax,
    required this.hpCurrent,
    required this.ownedItemIds,
    required this.equipped,
  });

  ShopState copyWith({
    int? varos,
    int? hpMax,
    int? hpCurrent,
    Set<String>? ownedItemIds,
    EquippedCosmetics? equipped,
  }) {
    return ShopState(
      varos: varos ?? this.varos,
      hpMax: hpMax ?? this.hpMax,
      hpCurrent: hpCurrent ?? this.hpCurrent,
      ownedItemIds: ownedItemIds ?? this.ownedItemIds,
      equipped: equipped ?? this.equipped,
    );
  }
}