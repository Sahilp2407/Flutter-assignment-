import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/app_theme.dart';
import '../data/products.dart';
import 'home_screen.dart';
import 'wishlist_screen.dart';
import 'cart_screen.dart';
import 'profile_screen.dart';

/// MainShell holds the bottom navigation and all shared state:
/// - wishlistedIds  (`Set<int>`)
/// - cartQuantities (`Map<int, int>`)
///
/// State is lifted here so all tabs stay in sync (e.g. cart badge count).
class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell>
    with SingleTickerProviderStateMixin {
  int _currentIndex = 0;

  // ── Shared State ────────────────────────────────────────────
  // Wishlist: set of product IDs
  final Set<int> _wishlistedIds = {};

  // Cart: product ID → quantity map
  final Map<int, int> _cartQuantities = {};

  Set<int> get _cartIds => _cartQuantities.keys.toSet();
  int get _cartCount => _cartQuantities.values.fold(0, (a, b) => a + b);

  // ── Wishlist logic ───────────────────────────────────────────
  void _toggleWishlist(int productId) {
    setState(() {
      if (_wishlistedIds.contains(productId)) {
        _wishlistedIds.remove(productId);
      } else {
        _wishlistedIds.add(productId);
      }
    });
  }

  // ── Cart logic ───────────────────────────────────────────────
  void _addToCart(int productId) {
    setState(() {
      _cartQuantities[productId] = (_cartQuantities[productId] ?? 0) + 1;
    });
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '${sampleProducts.firstWhere((p) => p.id == productId).name} added to cart!',
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        backgroundColor: AppColors.charcoal,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 2),
        action: SnackBarAction(
          label: 'View Cart',
          textColor: AppColors.gold,
          onPressed: () => setState(() => _currentIndex = 2),
        ),
      ),
    );
  }

  void _removeFromCart(int productId) {
    setState(() => _cartQuantities.remove(productId));
  }

  void _updateCartQuantity(int productId, int newQty) {
    setState(() {
      if (newQty <= 0) {
        _cartQuantities.remove(productId);
      } else {
        _cartQuantities[productId] = newQty;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // Tabs are kept alive to preserve scroll position
    final tabs = <Widget>[
      HomeScreen(
        wishlistedIds: _wishlistedIds,
        cartIds: _cartIds,
        cartQuantities: _cartQuantities,
        onWishlistToggle: _toggleWishlist,
        onAddToCart: _addToCart,
      ),
      WishlistScreen(
        wishlistedIds: _wishlistedIds,
        cartQuantities: _cartQuantities,
        onWishlistToggle: _toggleWishlist,
        onAddToCart: _addToCart,
      ),
      CartScreen(
        cartQuantities: _cartQuantities,
        onRemoveFromCart: _removeFromCart,
        onUpdateQuantity: _updateCartQuantity,
      ),
      const ProfileScreen(),
    ];

    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: tabs,
      ),
      bottomNavigationBar: _PremiumNavBar(
        currentIndex: _currentIndex,
        cartCount: _cartCount,
        wishlistCount: _wishlistedIds.length,
        onTap: (i) {
          HapticFeedback.selectionClick();
          setState(() => _currentIndex = i);
        },
      ),
    );
  }
}

// ── Premium Bottom Navigation Bar ─────────────────────────────
class _PremiumNavBar extends StatelessWidget {
  final int currentIndex;
  final int cartCount;
  final int wishlistCount;
  final Function(int) onTap;

  const _PremiumNavBar({
    required this.currentIndex,
    required this.cartCount,
    required this.wishlistCount,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final items = [
      _NavItem(icon: Icons.home_rounded, label: 'Home', badge: 0),
      _NavItem(
          icon: Icons.favorite_rounded,
          label: 'Wishlist',
          badge: wishlistCount),
      _NavItem(
          icon: Icons.shopping_bag_rounded,
          label: 'Cart',
          badge: cartCount),
      _NavItem(icon: Icons.person_rounded, label: 'Profile', badge: 0),
    ];

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(20),
            blurRadius: 20,
            offset: const Offset(0, -4),
          )
        ],
      ),
      child: SafeArea(
        child: SizedBox(
          height: 68,
          child: Row(
            children: items.asMap().entries.map((entry) {
              final i = entry.key;
              final item = entry.value;
              final selected = currentIndex == i;
              return Expanded(
                child: GestureDetector(
                  onTap: () => onTap(i),
                  behavior: HitTestBehavior.opaque,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Stack(
                        clipBehavior: Clip.none,
                        children: [
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            curve: Curves.easeInOut,
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: selected
                                  ? AppColors.gold.withAlpha(25)
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(
                              item.icon,
                              size: 24,
                              color: selected
                                  ? AppColors.gold
                                  : AppColors.mediumGrey,
                            ),
                          ),
                          if (item.badge > 0)
                            Positioned(
                              top: -4,
                              right: -4,
                              child: Container(
                                padding: const EdgeInsets.all(4),
                                decoration: const BoxDecoration(
                                  color: AppColors.wishlistRed,
                                  shape: BoxShape.circle,
                                ),
                                constraints: const BoxConstraints(
                                  minWidth: 18,
                                  minHeight: 18,
                                ),
                                child: Text(
                                  '${item.badge > 99 ? "99+" : item.badge}',
                                  style: const TextStyle(
                                    fontSize: 9,
                                    fontWeight: FontWeight.w900,
                                    color: Colors.white,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 2),
                      AnimatedDefaultTextStyle(
                        duration: const Duration(milliseconds: 200),
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                          color: selected ? AppColors.gold : AppColors.mediumGrey,
                          fontFamily: 'Poppins',
                        ),
                        child: Text(item.label),
                      ),
                    ],
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

class _NavItem {
  final IconData icon;
  final String label;
  final int badge;
  const _NavItem({required this.icon, required this.label, required this.badge});
}
