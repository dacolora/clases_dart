import 'package:flutter/material.dart';
import 'shop_models.dart';

class ShopController extends ChangeNotifier {
  ShopController({
    required List<ShopItem> catalog,
    ShopState? initialState,
  })  : _catalog = catalog,
        _state = initialState ??
            const ShopState(
              varos: 0,
              hpMax: 4,
              hpCurrent: 1,
              ownedItemIds: {},
              equipped: EquippedCosmetics(),
            );

  final List<ShopItem> _catalog;
  ShopState _state;

  ShopState get state => _state;
  List<ShopItem> get catalog => _catalog;

  bool isOwned(String itemId) => _state.ownedItemIds.contains(itemId);

  bool isEquipped(ShopItem item) {
    final e = _state.equipped;
    switch (item.category) {
      case ShopCategory.backgrounds:
        return e.backgroundId == item.id;
      case ShopCategory.hats:
        return e.hatId == item.id;
      case ShopCategory.glasses:
        return e.glassesId == item.id;
      case ShopCategory.outfits:
        return e.outfitId == item.id;
      case ShopCategory.accessories:
        return e.accessoryId == item.id;
      case ShopCategory.pets:
        return e.petId == item.id;
    }
  }

  void addVaros(int amount) {
    _state = _state.copyWith(varos: _state.varos + amount);
    notifyListeners();
  }

  /// Compra si no es owned y si alcanza la plata.
  bool buy(ShopItem item) {
    if (isOwned(item.id)) return true;
    if (_state.varos < item.priceVaros) return false;

    final newOwned = {..._state.ownedItemIds, item.id};
    _state = _state.copyWith(
      varos: _state.varos - item.priceVaros,
      ownedItemIds: newOwned,
    );
    notifyListeners();
    return true;
  }

  void equip(ShopItem item) {
    final e = _state.equipped;
    EquippedCosmetics next = e;

    switch (item.category) {
      case ShopCategory.backgrounds:
        next = e.copyWith(backgroundId: item.id);
        break;
      case ShopCategory.hats:
        next = e.copyWith(hatId: item.id);
        break;
      case ShopCategory.glasses:
        next = e.copyWith(glassesId: item.id);
        break;
      case ShopCategory.outfits:
        next = e.copyWith(outfitId: item.id);
        break;
      case ShopCategory.accessories:
        next = e.copyWith(accessoryId: item.id);
        break;
      case ShopCategory.pets:
        next = e.copyWith(petId: item.id);
        break;
    }

    _state = _state.copyWith(equipped: next);
    notifyListeners();
  }

  /// Compra + equipa (flow principal al tocar una tarjeta).
  bool buyAndEquip(ShopItem item) {
    final ok = buy(item);
    if (!ok) return false;
    equip(item);
    return true;
  }
}