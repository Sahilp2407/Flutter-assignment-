import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/product.dart';
import '../theme/app_theme.dart';
import '../data/products.dart';
import '../widgets/product_card.dart';
import '../widgets/category_chip.dart';
import '../widgets/empty_state.dart';

/// ==============================================================
/// ASSIGNMENT CORE: Home Screen (StatefulWidget)
/// ==============================================================
/// This screen demonstrates:
///   1. `List<Product>` products           — source of truth
///   2. `List<Product>` filteredProducts   — derived filtered list
///   3. ListView.builder                 — dynamic rendering
///   4. setState()                       — reactive state updates
///   5. TextField + onChanged            — search/filter trigger
/// ==============================================================
class HomeScreen extends StatefulWidget {
  final Set<int> wishlistedIds;
  final Set<int> cartIds;
  final Map<int, int> cartQuantities;
  final Function(int) onWishlistToggle;
  final Function(int) onAddToCart;

  const HomeScreen({
    super.key,
    required this.wishlistedIds,
    required this.cartIds,
    required this.cartQuantities,
    required this.onWishlistToggle,
    required this.onAddToCart,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  // ──────────────────────────────────────────────────────────
  // ASSIGNMENT: The master product list (never mutated)
  // ──────────────────────────────────────────────────────────
  final List<Product> _allProducts = sampleProducts;

  // ──────────────────────────────────────────────────────────
  // ASSIGNMENT: filteredProducts is what ListView.builder uses
  // It is updated via setState() inside _applyFilters()
  // ──────────────────────────────────────────────────────────
  late List<Product> _filteredProducts;

  // Search state
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  // Category filter state
  String _selectedCategory = 'All';
  final List<String> _categories = [
    'All',
    'Electronics',
    'Fashion',
    'Shoes',
    'Accessories',
    'Beauty',
  ];

  // Entrance animation
  late AnimationController _listAnimController;

  @override
  void initState() {
    super.initState();
    // Initialize filtered list with all products
    _filteredProducts = List.from(_allProducts);

    _listAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    )..forward();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _listAnimController.dispose();
    super.dispose();
  }

  // ──────────────────────────────────────────────────────────
  // ASSIGNMENT: Core filter logic
  // Called by search onChanged AND category chip onTap.
  // Uses setState() to rebuild ListView.builder with new data.
  // ──────────────────────────────────────────────────────────
  void _applyFilters() {
    setState(() {
      _filteredProducts = _allProducts.where((product) {
        // Step 1: Match category ('All' means no category filter)
        final categoryMatch = _selectedCategory == 'All' ||
            product.category == _selectedCategory;

        // Step 2: Match search query (case-insensitive)
        final queryMatch = _searchQuery.isEmpty ||
            product.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
            product.category.toLowerCase().contains(_searchQuery.toLowerCase());

        // Both conditions must be true (AND logic)
        return categoryMatch && queryMatch;
      }).toList();
    });
  }

  void _onSearchChanged(String query) {
    _searchQuery = query;
    _applyFilters(); // setState() called inside _applyFilters
  }

  void _onCategorySelected(String category) {
    _selectedCategory = category;
    _applyFilters(); // setState() called inside _applyFilters
  }

  void _clearSearch() {
    _searchController.clear();
    _searchQuery = '';
    _applyFilters();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // ── Header ──────────────────────────────────────
            SliverToBoxAdapter(child: _buildHeader()),

            // ── Search Bar ──────────────────────────────────
            SliverToBoxAdapter(child: _buildSearchBar()),

            // ── Category Chips ───────────────────────────────
            SliverToBoxAdapter(child: _buildCategoryRow()),

            // ── Section Title ────────────────────────────────
            SliverToBoxAdapter(child: _buildSectionTitle()),

            // ── Product Grid / Empty State ───────────────────
            if (_filteredProducts.isEmpty)
              SliverFillRemaining(
                child: EmptyState(
                  icon: Icons.search_off_rounded,
                  title: 'No products found',
                  message:
                      'Try a different search or\nselect another category.',
                  actionLabel: 'Clear Filters',
                  onAction: () {
                    _clearSearch();
                    _onCategorySelected('All');
                  },
                ),
              )
            else
              // ──────────────────────────────────────────────
              // ASSIGNMENT: ListView.builder renders products
              // dynamically from _filteredProducts list.
              // itemBuilder is only called for visible items
              // (efficient for large lists).
              // ──────────────────────────────────────────────
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                sliver: SliverGrid.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    childAspectRatio: 0.65,
                  ),
                  itemCount: _filteredProducts.length,
                  itemBuilder: (context, index) {
                    // ASSIGNMENT: Each item is built from _filteredProducts[index]
                    final product = _filteredProducts[index];

                    // Entrance animation per card
                    final animation = Tween<double>(begin: 0.0, end: 1.0)
                        .animate(CurvedAnimation(
                      parent: _listAnimController,
                      curve: Interval(
                        (index / _filteredProducts.length) * 0.6,
                        1.0,
                        curve: Curves.easeOut,
                      ),
                    ));

                    return FadeTransition(
                      opacity: animation,
                      child: SlideTransition(
                        position: Tween<Offset>(
                          begin: const Offset(0, 0.15),
                          end: Offset.zero,
                        ).animate(animation),
                        child: ProductCard(
                          product: product,
                          isWishlisted:
                              widget.wishlistedIds.contains(product.id),
                          isInCart: widget.cartIds.contains(product.id),
                          onWishlistToggle: () =>
                              widget.onWishlistToggle(product.id),
                          onAddToCart: () => widget.onAddToCart(product.id),
                        ),
                      ),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 6),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Good ${_getGreeting()}, Sahil 👋',
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: AppColors.charcoal,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Discover something luxurious today',
                  style: TextStyle(
                    fontSize: 13,
                    color: AppColors.mediumGrey,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
          // Profile avatar
          GestureDetector(
            onTap: () {},
            child: Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppColors.gold, AppColors.goldDark],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.gold.withAlpha(76),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  )
                ],
              ),
              child: const Icon(Icons.person_rounded,
                  color: Colors.white, size: 22),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 14, 20, 0),
      child: Row(
        children: [
          Expanded(
            // ────────────────────────────────────────────────
            // ASSIGNMENT: TextField with onChanged drives search.
            // Every keystroke calls setState() through _onSearchChanged.
            // ────────────────────────────────────────────────
            child: TextField(
              controller: _searchController,
              onChanged: _onSearchChanged, // ASSIGNMENT: onChanged callback
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.charcoal,
                fontWeight: FontWeight.w500,
              ),
              decoration: InputDecoration(
                hintText: 'Search products...',
                hintStyle: const TextStyle(
                  color: AppColors.mediumGrey,
                  fontWeight: FontWeight.w400,
                ),
                prefixIcon: const Icon(Icons.search_rounded,
                    color: AppColors.gold, size: 22),
                suffixIcon: _searchQuery.isNotEmpty
                    ? GestureDetector(
                        onTap: () {
                          HapticFeedback.lightImpact();
                          _clearSearch();
                        },
                        child: const Icon(Icons.close_rounded,
                            color: AppColors.mediumGrey, size: 20),
                      )
                    : null,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryRow() {
    return SizedBox(
      height: 58,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 4),
        itemCount: _categories.length,
        separatorBuilder: (_, _) => const SizedBox(width: 8),
        itemBuilder: (_, index) {
          final cat = _categories[index];
          return CategoryChipWidget(
            label: cat,
            isSelected: _selectedCategory == cat,
            onTap: () {
              HapticFeedback.selectionClick();
              _onCategorySelected(cat);
            },
          );
        },
      ),
    );
  }

  Widget _buildSectionTitle() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 14),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Popular Products',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: AppColors.charcoal,
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
            decoration: BoxDecoration(
              color: AppColors.gold.withAlpha(25),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              '${_filteredProducts.length} items',
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppColors.gold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Morning';
    if (hour < 17) return 'Afternoon';
    return 'Evening';
  }
}
