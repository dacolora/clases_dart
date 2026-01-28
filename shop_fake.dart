import 'package:flutter/material.dart';
import 'shop_models.dart';

List<ShopItem> buildFakeCatalog() {
  return const [
    // BACKGROUNDS
    ShopItem(
      id: 'bg_sky',
      category: ShopCategory.backgrounds,
      name: 'Cielo',
      priceVaros: 0,
      color: Color(0xFF4FA3FF),
    ),
    ShopItem(
      id: 'bg_sunset',
      category: ShopCategory.backgrounds,
      name: 'Atardecer',
      priceVaros: 250,
      color: Color(0xFFFF7A59),
    ),
    ShopItem(
      id: 'bg_night',
      category: ShopCategory.backgrounds,
      name: 'Noche',
      priceVaros: 450,
      color: Color(0xFF0E1B3D),
    ),

    // HATS
    ShopItem(
      id: 'hat_blue',
      category: ShopCategory.hats,
      name: 'Gorra Azul',
      priceVaros: 250,
    ),
    ShopItem(
      id: 'hat_top',
      category: ShopCategory.hats,
      name: 'Sombrero',
      priceVaros: 300,
    ),

    // GLASSES
    ShopItem(
      id: 'gls_sun',
      category: ShopCategory.glasses,
      name: 'Gafas Cool',
      priceVaros: 300,
    ),

    // OUTFITS
    ShopItem(
      id: 'outfit_gym',
      category: ShopCategory.outfits,
      name: 'Gym Fit',
      priceVaros: 450,
    ),
    ShopItem(
      id: 'outfit_formal',
      category: ShopCategory.outfits,
      name: 'Formal',
      priceVaros: 600,
    ),

    // ACCESSORIES
    ShopItem(
      id: 'acc_watch',
      category: ShopCategory.accessories,
      name: 'Reloj',
      priceVaros: 300,
    ),
    ShopItem(
      id: 'acc_backpack',
      category: ShopCategory.accessories,
      name: 'Mochila',
      priceVaros: 350,
    ),

    // PETS
    ShopItem(
      id: 'pet_cat',
      category: ShopCategory.pets,
      name: 'Mini Gato',
      priceVaros: 700,
    ),
  ];
}