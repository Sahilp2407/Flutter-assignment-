import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/product.dart';
import '../data/products.dart';
import '../theme/app_theme.dart';
import '../widgets/empty_state.dart';
import '../widgets/product_image.dart';

/// Cart screen — shows items with quantity controls and order total.
class CartScreen extends StatefulWidget {
  final Map<int, int> cartQuantities;
  final Function(int) onRemoveFromCart;
  final Function(int, int) onUpdateQuantity;

  const CartScreen({
    super.key,
    required this.cartQuantities,
    required this.onRemoveFromCart,
    required this.onUpdateQuantity,
  });

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  List<Product> get _cartProducts => sampleProducts
      .where((p) => widget.cartQuantities.containsKey(p.id))
      .toList();

  double get _subtotal => _cartProducts.fold(0.0, (sum, p) {
        final qty = widget.cartQuantities[p.id] ?? 1;
        return sum + (p.price * qty);
      });

  double get _discount => _subtotal * 0.10; // 10% discount
  double get _total => _subtotal - _discount;

  bool _checkingOut = false;

  void _checkout() async {
    HapticFeedback.heavyImpact();
    setState(() => _checkingOut = true);
    await Future.delayed(const Duration(milliseconds: 1500));
    if (mounted) {
      setState(() => _checkingOut = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Row(
            children: [
              Icon(Icons.check_circle_rounded, color: Colors.white),
              SizedBox(width: 10),
              Text('Order placed successfully! 🎉',
                  style: TextStyle(fontWeight: FontWeight.w600)),
            ],
          ),
          backgroundColor: AppColors.success,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          margin: const EdgeInsets.all(16),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final products = _cartProducts;
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: Row(
                children: [
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'My Cart',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w800,
                            color: AppColors.charcoal,
                          ),
                        ),
                        Text(
                          'Review your items',
                          style: TextStyle(
                            fontSize: 13,
                            color: AppColors.mediumGrey,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (products.isNotEmpty)
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppColors.gold.withAlpha(25),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        '${products.length} items',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: AppColors.gold,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            // Content
            Expanded(
              child: products.isEmpty
                  ? EmptyState(
                      icon: Icons.shopping_cart_outlined,
                      title: 'Your cart is empty',
                      message:
                          'Looks like you haven\'t added\nanything to your cart yet.',
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                      itemCount: products.length,
                      itemBuilder: (context, index) {
                        final product = products[index];
                        final qty = widget.cartQuantities[product.id] ?? 1;
                        return _CartItem(
                          product: product,
                          quantity: qty,
                          onRemove: () {
                            HapticFeedback.lightImpact();
                            widget.onRemoveFromCart(product.id);
                            setState(() {});
                          },
                          onIncrement: () {
                            widget.onUpdateQuantity(product.id, qty + 1);
                            setState(() {});
                          },
                          onDecrement: () {
                            if (qty > 1) {
                              widget.onUpdateQuantity(product.id, qty - 1);
                              setState(() {});
                            } else {
                              widget.onRemoveFromCart(product.id);
                              setState(() {});
                            }
                          },
                        );
                      },
                    ),
            ),
            // Order Summary
            if (products.isNotEmpty)
              Container(
                padding: EdgeInsets.fromLTRB(
                    20, 20, 20, MediaQuery.of(context).padding.bottom + 20),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(28),
                    topRight: Radius.circular(28),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withAlpha(15),
                      blurRadius: 20,
                      offset: const Offset(0, -4),
                    )
                  ],
                ),
                child: Column(
                  children: [
                    _SummaryRow('Subtotal', '₹${_subtotal.toStringAsFixed(0)}'),
                    const SizedBox(height: 8),
                    _SummaryRow('Discount (10%)',
                        '-₹${_discount.toStringAsFixed(0)}',
                        valueColor: AppColors.success),
                    const SizedBox(height: 8),
                    const Divider(height: 1),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Total',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            color: AppColors.charcoal,
                          ),
                        ),
                        Text(
                          '₹${_total.toStringAsFixed(0)}',
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w900,
                            color: AppColors.charcoal,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _checkingOut ? null : _checkout,
                        child: _checkingOut
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                            : const Text('Checkout Now'),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _CartItem extends StatelessWidget {
  final Product product;
  final int quantity;
  final VoidCallback onRemove;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;

  const _CartItem({
    required this.product,
    required this.quantity,
    required this.onRemove,
    required this.onIncrement,
    required this.onDecrement,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(12),
            blurRadius: 10,
            offset: const Offset(0, 3),
          )
        ],
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: ProductImage(
              imagePath: product.image,
              width: 76,
              height: 76,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.name,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: AppColors.charcoal,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  '₹${product.price.toStringAsFixed(0)} each',
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.mediumGrey,
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    _QtyBtn(icon: Icons.remove_rounded, onTap: onDecrement),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Text(
                        '$quantity',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          color: AppColors.charcoal,
                        ),
                      ),
                    ),
                    _QtyBtn(icon: Icons.add_rounded, onTap: onIncrement),
                    const Spacer(),
                    Text(
                      '₹${(product.price * quantity).toStringAsFixed(0)}',
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                        color: AppColors.charcoal,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: onRemove,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.red.withAlpha(20),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.delete_outline_rounded,
                  color: Colors.red, size: 18),
            ),
          ),
        ],
      ),
    );
  }
}

class _QtyBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _QtyBtn({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 30,
        height: 30,
        decoration: BoxDecoration(
          color: AppColors.lightGrey,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, size: 16, color: AppColors.charcoal),
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;
  const _SummaryRow(this.label, this.value, {this.valueColor});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label,
            style: const TextStyle(fontSize: 14, color: AppColors.mediumGrey)),
        Text(value,
            style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: valueColor ?? AppColors.charcoal)),
      ],
    );
  }
}
