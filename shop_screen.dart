import 'dart:math';
import 'package:flutter/material.dart';
import 'shop_controller.dart';
import 'shop_fake_data.dart';
import 'shop_models.dart';

class CharacterCustomizationScreen extends StatefulWidget {
  const CharacterCustomizationScreen({super.key});

  @override
  State<CharacterCustomizationScreen> createState() =>
      _CharacterCustomizationScreenState();
}

class _CharacterCustomizationScreenState
    extends State<CharacterCustomizationScreen> with TickerProviderStateMixin {
  late final ShopController controller;
  late ShopCategory selectedCategory;

  @override
  void initState() {
    super.initState();
    selectedCategory = ShopCategory.backgrounds;
    controller = ShopController(
      catalog: buildFakeCatalog(),
      initialState: const ShopState(
        varos: 900,
        hpMax: 4,
        hpCurrent: 1,
        ownedItemIds: {'bg_sky'}, // fondo default gratis
        equipped: EquippedCosmetics(backgroundId: 'bg_sky'),
      ),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  List<ShopItem> _itemsFor(ShopCategory cat) =>
      controller.catalog.where((e) => e.category == cat).toList();

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        final s = controller.state;

        return Scaffold(
          backgroundColor: const Color(0xFFF6F7FB),
          body: SafeArea(
            child: Column(
              children: [
                _TopPreview(
                  name: 'Colorín', // cámbialo a tu usuario
                  hpMax: s.hpMax,
                  hpCurrent: s.hpCurrent,
                  varos: s.varos,
                  backgroundColor: _resolveBackgroundColor(s.equipped.backgroundId),
                  onAddTestVaros: () => controller.addVaros(100),
                ),
                const SizedBox(height: 12),
                _BottomSheetArea(
                  selectedCategory: selectedCategory,
                  onCategorySelected: (c) => setState(() => selectedCategory = c),
                  items: _itemsFor(selectedCategory),
                  isOwned: controller.isOwned,
                  isEquipped: controller.isEquipped,
                  onTapItem: (item) async {
                    final owned = controller.isOwned(item.id);
                    final equipped = controller.isEquipped(item);

                    if (equipped) return;

                    if (!owned && controller.state.varos < item.priceVaros) {
                      await _showNoMoney(context);
                      return;
                    }

                    // Compra + equipa
                    controller.buyAndEquip(item);
                    await _showEquippedToast(context, item, ownedBefore: owned);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Color _resolveBackgroundColor(String? bgId) {
    final item = controller.catalog
        .where((e) => e.category == ShopCategory.backgrounds)
        .cast<ShopItem?>()
        .firstWhere((e) => e?.id == bgId, orElse: () => null);

    return item?.color ?? const Color(0xFF4FA3FF);
  }

  Future<void> _showNoMoney(BuildContext context) async {
    return showModalBottomSheet(
      context: context,
      showDragHandle: true,
      backgroundColor: Colors.white,
      builder: (_) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(16, 10, 16, 18),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.lock_outline, size: 34),
              const SizedBox(height: 10),
              const Text(
                'Te faltan Varos',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 6),
              const Text(
                'Completa hábitos para ganar más Varos y desbloquear este ítem.',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 14),
              FilledButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Entendido'),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _showEquippedToast(
    BuildContext context,
    ShopItem item, {
    required bool ownedBefore,
  }) async {
    final text = ownedBefore ? 'Equipado: ${item.name}' : 'Comprado y equipado: ${item.name}';
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(text),
        duration: const Duration(milliseconds: 900),
      ),
    );
  }
}

/// ===================== TOP PREVIEW =====================

class _TopPreview extends StatelessWidget {
  const _TopPreview({
    required this.name,
    required this.hpMax,
    required this.hpCurrent,
    required this.varos,
    required this.backgroundColor,
    required this.onAddTestVaros,
  });

  final String name;
  final int hpMax;
  final int hpCurrent;
  final int varos;
  final Color backgroundColor;
  final VoidCallback onAddTestVaros;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 330,
      width: double.infinity,
      backgroundColor: backgroundColor,
      child: Stack(
        children: [
          // nubecitas simples
          Positioned(
            top: 14,
            right: 20,
            child: _Cloud(),
          ),
          Positioned(
            top: 44,
            left: 22,
            child: _Cloud(scale: 0.85),
          ),

          // header: nombre + hp
          Positioned(
            top: 12,
            left: 16,
            right: 16,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 34,
                    fontWeight: FontWeight.w900,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(width: 12),
                _HeartsRow(current: hpCurrent, max: hpMax),
                const Spacer(),
                _VarosPill(varos: varos),
              ],
            ),
          ),

          // personaje (tu widget real va aquí)
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 18),
              child: _YourCharacterPlaceholder(),
            ),
          ),

          // botón test para sumar varos (lo quitas en prod)
          Positioned(
            bottom: 14,
            left: 14,
            child: GestureDetector(
              onTap: onAddTestVaros,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.16),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: Colors.white.withOpacity(0.25)),
                ),
                child: const Text(
                  '+100 varos (test)',
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _VarosPill extends StatelessWidget {
  const _VarosPill({required this.varos});
  final int varos;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.18),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: Colors.white.withOpacity(0.25)),
      ),
      child: Row(
        children: [
          const Icon(Icons.monetization_on, color: Colors.amber, size: 20),
          const SizedBox(width: 6),
          Text(
            '$varos',
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w900,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}

class _HeartsRow extends StatelessWidget {
  const _HeartsRow({required this.current, required this.max});
  final int current;
  final int max;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(max, (i) {
        final filled = i < current;
        return Padding(
          padding: const EdgeInsets.only(right: 6),
          child: Icon(
            filled ? Icons.favorite : Icons.favorite_border,
            color: filled ? Colors.redAccent : Colors.white,
            size: 22,
          ),
        );
      }),
    );
  }
}

class _Cloud extends StatelessWidget {
  const _Cloud({this.scale = 1});
  final double scale;

  @override
  Widget build(BuildContext context) {
    return Transform.scale(
      scale: scale,
      child: Container(
        width: 88,
        height: 34,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.35),
          borderRadius: BorderRadius.circular(40),
        ),
      ),
    );
  }
}

class _YourCharacterPlaceholder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Aquí sustituyes por tu personaje real (SVG/PNG/Lottie/custom painter).
    return Container(
      width: 190,
      height: 190,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.18),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: Colors.white.withOpacity(0.22)),
      ),
      child: const Center(
        child: Text(
          'TU PERSONAJE\n(AQUÍ)',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w900,
          ),
        ),
      ),
    );
  }
}

/// ===================== BOTTOM CUSTOMIZATION =====================

class _BottomSheetArea extends StatelessWidget {
  const _BottomSheetArea({
    required this.selectedCategory,
    required this.onCategorySelected,
    required this.items,
    required this.isOwned,
    required this.isEquipped,
    required this.onTapItem,
  });

  final ShopCategory selectedCategory;
  final ValueChanged<ShopCategory> onCategorySelected;
  final List<ShopItem> items;
  final bool Function(String itemId) isOwned;
  final bool Function(ShopItem item) isEquipped;
  final ValueChanged<ShopItem> onTapItem;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          color: Color(0xFFF6F7FB),
          borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
        ),
        child: Column(
          children: [
            const SizedBox(height: 10),
            _CategoriesBar(
              selected: selectedCategory,
              onSelected: onCategorySelected,
            ),
            const SizedBox(height: 8),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                child: GridView.builder(
                  itemCount: items.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    childAspectRatio: 0.92,
                  ),
                  itemBuilder: (context, i) {
                    final item = items[i];
                    final owned = isOwned(item.id);
                    final equipped = isEquipped(item);

                    return _ShopTile(
                      item: item,
                      owned: owned,
                      equipped: equipped,
                      onTap: () => onTapItem(item),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CategoriesBar extends StatelessWidget {
  const _CategoriesBar({
    required this.selected,
    required this.onSelected,
  });

  final ShopCategory selected;
  final ValueChanged<ShopCategory> onSelected;

  @override
  Widget build(BuildContext context) {
    final cats = ShopCategory.values;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              blurRadius: 14,
              offset: const Offset(0, 6),
              color: Colors.black.withOpacity(0.06),
            ),
          ],
        ),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: cats.map((c) {
              final isSel = c == selected;
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6),
                child: InkWell(
                  borderRadius: BorderRadius.circular(14),
                  onTap: () => onSelected(c),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 220),
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    decoration: BoxDecoration(
                      color: isSel ? Colors.black : Colors.transparent,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          c.icon,
                          size: 18,
                          color: isSel ? Colors.white : Colors.black87,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          c.label,
                          style: TextStyle(
                            fontWeight: FontWeight.w800,
                            color: isSel ? Colors.white : Colors.black87,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}

class _ShopTile extends StatelessWidget {
  const _ShopTile({
    required this.item,
    required this.owned,
    required this.equipped,
    required this.onTap,
  });

  final ShopItem item;
  final bool owned;
  final bool equipped;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final border = equipped ? Border.all(width: 2.2, color: Colors.black) : null;

    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            border: border,
            boxShadow: [
              BoxShadow(
                blurRadius: 14,
                offset: const Offset(0, 8),
                color: Colors.black.withOpacity(0.05),
              ),
            ],
          ),
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              Expanded(
                child: _ItemPreview(item: item),
              ),
              const SizedBox(height: 8),
              if (equipped)
                _Tag(text: 'Equipado', icon: Icons.check_circle, tight: true)
              else if (owned)
                _Tag(text: 'Comprado', icon: Icons.verified, tight: true)
              else
                _PricePill(price: item.priceVaros),
            ],
          ),
        ),
      ),
    );
  }
}

class _ItemPreview extends StatelessWidget {
  const _ItemPreview({required this.item});
  final ShopItem item;

  @override
  Widget build(BuildContext context) {
    // Preview rápido sin assets: depende de category.
    // Tú luego lo conectas a tus imágenes/Lottie.
    Widget content;

    if (item.category == ShopCategory.backgrounds && item.color != null) {
      content = Container(
        decoration: BoxDecoration(
          color: item.color,
          borderRadius: BorderRadius.circular(14),
        ),
        child: const Center(
          child: Icon(Icons.landscape_outlined, color: Colors.white, size: 30),
        ),
      );
    } else {
      final icon = _iconFor(item.category);
      content = Container(
        decoration: BoxDecoration(
          color: const Color(0xFFF2F4F8),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Center(
          child: Icon(icon, size: 34, color: Colors.black87),
        ),
      );
    }

    return Stack(
      children: [
        Positioned.fill(child: content),
        Positioned(
          left: 8,
          right: 8,
          bottom: 8,
          child: Text(
            item.name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 11),
          ),
        ),
      ],
    );
  }

  IconData _iconFor(ShopCategory cat) {
    switch (cat) {
      case ShopCategory.hats:
        return Icons.sports_baseball;
      case ShopCategory.glasses:
        return Icons.sunglasses;
      case ShopCategory.outfits:
        return Icons.checkroom;
      case ShopCategory.accessories:
        return Icons.auto_awesome;
      case ShopCategory.pets:
        return Icons.pets;
      case ShopCategory.backgrounds:
        return Icons.image;
    }
  }
}

class _PricePill extends StatelessWidget {
  const _PricePill({required this.price});
  final int price;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        color: const Color(0xFFF2F4F8),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.monetization_on, color: Colors.amber, size: 18),
          const SizedBox(width: 6),
          Text(
            '$price',
            style: const TextStyle(fontWeight: FontWeight.w900),
          ),
        ],
      ),
    );
  }
}

class _Tag extends StatelessWidget {
  const _Tag({
    required this.text,
    required this.icon,
    this.tight = false,
  });

  final String text;
  final IconData icon;
  final bool tight;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: tight ? 10 : 12, vertical: 7),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: Colors.white),
          const SizedBox(width: 6),
          Text(
            text,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w900,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}