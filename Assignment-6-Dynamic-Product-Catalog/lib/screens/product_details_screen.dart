import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/product.dart';
import '../theme/app_theme.dart';
import '../widgets/product_image.dart';

class ProductDetailsScreen extends StatefulWidget {
  final Product product;
  final bool isWishlisted;
  final VoidCallback onWishlistToggle;
  final VoidCallback onAddToCart;

  const ProductDetailsScreen({
    super.key,
    required this.product,
    required this.isWishlisted,
    required this.onWishlistToggle,
    required this.onAddToCart,
  });

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  late bool _isWishlisted;
  int _quantity = 1;
  int _selectedColorIndex = 0;
  bool _addedToCart = false;

  @override
  void initState() {
    super.initState();
    _isWishlisted = widget.isWishlisted;
  }

  void _toggleWishlist() {
    HapticFeedback.lightImpact();
    setState(() => _isWishlisted = !_isWishlisted);
    widget.onWishlistToggle();
  }

  void _handleAddToCart() {
    HapticFeedback.mediumImpact();
    widget.onAddToCart();
    setState(() => _addedToCart = true);
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) setState(() => _addedToCart = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    final product = widget.product;
    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          // ── Image / SliverAppBar ────────────────────────
          SliverAppBar(
            expandedHeight: 340,
            pinned: true,
            backgroundColor: AppColors.background,
            leading: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                margin: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withAlpha(20),
                      blurRadius: 8,
                    )
                  ],
                ),
                child: const Icon(Icons.arrow_back_ios_new_rounded,
                    color: AppColors.charcoal, size: 18),
              ),
            ),
            actions: [
              GestureDetector(
                onTap: _toggleWishlist,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  margin: const EdgeInsets.only(right: 12),
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: _isWishlisted
                        ? AppColors.wishlistRed.withAlpha(230)
                        : Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withAlpha(20),
                        blurRadius: 8,
                      )
                    ],
                  ),
                  child: Icon(
                    _isWishlisted
                        ? Icons.favorite_rounded
                        : Icons.favorite_border_rounded,
                    color:
                        _isWishlisted ? Colors.white : AppColors.mediumGrey,
                    size: 20,
                  ),
                ),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Hero(
                // ASSIGNMENT: Hero animation from product card to detail
                tag: 'product_image_${product.id}',
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    ProductImage(
                      imagePath: product.image,
                      fit: BoxFit.cover,
                    ),
                    // Gradient overlay at bottom for text legibility
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        height: 80,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                            colors: [
                              AppColors.background,
                              AppColors.background.withAlpha(0),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // ── Product Details ─────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 100),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Category chip
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 5),
                    decoration: BoxDecoration(
                      color: AppColors.gold.withAlpha(25),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      product.category,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppColors.gold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  // Product name
                  Text(
                    product.name,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w800,
                      color: AppColors.charcoal,
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Rating + reviews
                  Row(
                    children: [
                      ...List.generate(5, (i) {
                        final filled = i < product.rating.floor();
                        final half = !filled &&
                            (product.rating - product.rating.floor() >= 0.5) &&
                            i == product.rating.floor();
                        return Icon(
                          half
                              ? Icons.star_half_rounded
                              : filled
                                  ? Icons.star_rounded
                                  : Icons.star_border_rounded,
                          color: AppColors.gold,
                          size: 20,
                        );
                      }),
                      const SizedBox(width: 8),
                      Text(
                        '${product.rating} (${product.reviewCount} reviews)',
                        style: const TextStyle(
                          fontSize: 13,
                          color: AppColors.mediumGrey,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // Price
                  Text(
                    '₹${product.price.toStringAsFixed(0)}',
                    style: const TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w900,
                      color: AppColors.charcoal,
                    ),
                  ),
                  const SizedBox(height: 22),
                  // Description
                  const Text(
                    'Description',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: AppColors.charcoal,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    product.description,
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppColors.mediumGrey,
                      height: 1.6,
                    ),
                  ),
                  const SizedBox(height: 22),
                  // Color options
                  const Text(
                    'Available Options',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: AppColors.charcoal,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 10,
                    runSpacing: 8,
                    children: product.colors.asMap().entries.map((entry) {
                      final isSelected = entry.key == _selectedColorIndex;
                      return GestureDetector(
                        onTap: () =>
                            setState(() => _selectedColorIndex = entry.key),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 180),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 8),
                          decoration: BoxDecoration(
                            color: isSelected ? AppColors.gold : AppColors.surface,
                            border: Border.all(
                              color: isSelected
                                  ? AppColors.gold
                                  : AppColors.lightGrey,
                              width: 1.5,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            entry.value,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: isSelected
                                  ? Colors.white
                                  : AppColors.darkGrey,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 24),
                  // Quantity selector
                  Row(
                    children: [
                      const Text(
                        'Quantity',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: AppColors.charcoal,
                        ),
                      ),
                      const Spacer(),
                      _QuantityButton(
                        icon: Icons.remove_rounded,
                        onTap: () {
                          if (_quantity > 1) {
                            setState(() => _quantity--);
                          }
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          '$_quantity',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            color: AppColors.charcoal,
                          ),
                        ),
                      ),
                      _QuantityButton(
                        icon: Icons.add_rounded,
                        onTap: () => setState(() => _quantity++),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      // ── Bottom Action Bar ───────────────────────────────
      bottomNavigationBar: Container(
        padding: EdgeInsets.fromLTRB(
            20, 16, 20, MediaQuery.of(context).padding.bottom + 16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(15),
              blurRadius: 20,
              offset: const Offset(0, -4),
            )
          ],
        ),
        child: Row(
          children: [
            // Total price
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Total Price',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.mediumGrey,
                  ),
                ),
                Text(
                  '₹${(widget.product.price * _quantity).toStringAsFixed(0)}',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                    color: AppColors.charcoal,
                  ),
                ),
              ],
            ),
            const SizedBox(width: 20),
            // Add to cart
            Expanded(
              child: GestureDetector(
                onTap: _handleAddToCart,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  height: 52,
                  decoration: BoxDecoration(
                    color: _addedToCart ? AppColors.success : AppColors.gold,
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [
                      BoxShadow(
                        color: (_addedToCart ? AppColors.success : AppColors.gold)
                            .withAlpha(76),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      )
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        _addedToCart
                            ? Icons.check_circle_rounded
                            : Icons.shopping_bag_rounded,
                        color: Colors.white,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        _addedToCart ? 'Added to Cart!' : 'Add to Cart',
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _QuantityButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _QuantityButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: AppColors.lightGrey,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, size: 18, color: AppColors.charcoal),
      ),
    );
  }
}
