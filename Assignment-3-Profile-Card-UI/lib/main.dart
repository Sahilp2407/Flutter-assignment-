import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const ModernProfileApp());
}

class ModernProfileApp extends StatefulWidget {
  const ModernProfileApp({super.key});

  @override
  State<ModernProfileApp> createState() => _ModernProfileAppState();
}

class _ModernProfileAppState extends State<ModernProfileApp> {
  bool _isDarkMode = false; // Light theme by default

  void _toggleTheme() {
    setState(() {
      _isDarkMode = !_isDarkMode;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Custom Gold / Wheat / Ghost White Palette
    const goldColor = Color(0xFFFFD700);
    const wheatColor = Color(0xFFF5DEB3);
    const ghostWhiteColor = Color(0xFFF8F8FF);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Sahil Pandey | Junior Flutter Developer',
      themeMode: _isDarkMode ? ThemeMode.dark : ThemeMode.light,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        scaffoldBackgroundColor: ghostWhiteColor,
        colorScheme: const ColorScheme.light(
          primary: Color(0xFFB45309), // Rich golden bronze for sharp contrast
          secondary: goldColor,
          tertiary: wheatColor,
          surface: Colors.white,
          onSurface: Color(0xFF1F2937),
        ),
        fontFamily: 'Roboto',
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF121214),
        colorScheme: const ColorScheme.dark(
          primary: goldColor,
          secondary: wheatColor,
          surface: Color(0xFF1C1B1E),
          onSurface: ghostWhiteColor,
        ),
        fontFamily: 'Roboto',
      ),
      home: ProfileHomeScreen(
        isDarkMode: _isDarkMode,
        onToggleTheme: _toggleTheme,
      ),
    );
  }
}

class ProfileHomeScreen extends StatefulWidget {
  final bool isDarkMode;
  final VoidCallback onToggleTheme;

  const ProfileHomeScreen({
    super.key,
    required this.isDarkMode,
    required this.onToggleTheme,
  });

  @override
  State<ProfileHomeScreen> createState() => _ProfileHomeScreenState();
}

class _ProfileHomeScreenState extends State<ProfileHomeScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _isConnected = false;
  int _followersCount = 850;

  static const String userEmail = 'sahilpandey.dev@gmail.com';

  // Palette Constants
  static const Color gold = Color(0xFFFFD700);
  static const Color deepGold = Color(0xFFD97706);
  static const Color wheat = Color(0xFFF5DEB3);
  static const Color ghostWhite = Color(0xFFF8F8FF);

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _handleConnectToggle() {
    setState(() {
      _isConnected = !_isConnected;
      _followersCount += _isConnected ? 1 : -1;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: _isConnected ? deepGold : const Color(0xFF64748B),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        content: Row(
          children: [
            Icon(
              _isConnected ? Icons.check_circle_rounded : Icons.person_remove_rounded,
              color: Colors.white,
              size: 20,
            ),
            const SizedBox(width: 10),
            Text(
              _isConnected
                  ? 'Connected with Sahil Pandey!'
                  : 'Removed from connections.',
              style: const TextStyle(fontWeight: FontWeight.w600, color: Colors.white),
            ),
          ],
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _showMessageDialog() {
    final messageController = TextEditingController();
    final isDark = widget.isDarkMode;

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: isDark ? const Color(0xFF1E1E24) : Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
          side: const BorderSide(color: wheat, width: 1.5),
        ),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: gold.withValues(alpha: 0.25),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.send_rounded,
                color: deepGold,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Text(
              'Send a Message',
              style: TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.bold,
                color: isDark ? ghostWhite : const Color(0xFF1F2937),
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Leave a note or job opportunity for Sahil:',
              style: TextStyle(
                fontSize: 13,
                color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF6B7280),
              ),
            ),
            const SizedBox(height: 14),
            TextField(
              controller: messageController,
              maxLines: 4,
              style: TextStyle(color: isDark ? ghostWhite : Colors.black87),
              decoration: InputDecoration(
                hintText: 'Hey Sahil, let\'s collaborate on...',
                hintStyle: const TextStyle(
                  color: Color(0xFF9CA3AF),
                  fontSize: 14,
                ),
                filled: true,
                fillColor: isDark ? const Color(0xFF121214) : ghostWhite,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: const BorderSide(color: wheat),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(color: wheat.withValues(alpha: 0.7)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: const BorderSide(color: deepGold, width: 1.5),
                ),
                contentPadding: const EdgeInsets.all(14),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(
              'Cancel',
              style: TextStyle(
                color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF6B7280),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  behavior: SnackBarBehavior.floating,
                  backgroundColor: deepGold,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  content: const Row(
                    children: [
                      Icon(Icons.mark_email_read_rounded, color: Colors.white, size: 20),
                      SizedBox(width: 10),
                      Text(
                        'Message sent successfully!',
                        style: TextStyle(fontWeight: FontWeight.w600, color: Colors.white),
                      ),
                    ],
                  ),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: deepGold,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            ),
            child: const Text('Send Note', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  void _copyEmail() {
    Clipboard.setData(const ClipboardData(text: userEmail));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: deepGold,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        content: const Row(
          children: [
            Icon(Icons.copy_rounded, color: Colors.white, size: 20),
            SizedBox(width: 10),
            Text(
              'Email copied to clipboard!',
              style: TextStyle(fontWeight: FontWeight.w600, color: Colors.white),
            ),
          ],
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = widget.isDarkMode;
    final bgSurface = isDark ? const Color(0xFF1E1E24) : Colors.white;
    final borderColor = isDark
        ? wheat.withValues(alpha: 0.2)
        : wheat.withValues(alpha: 0.7);

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF121214) : ghostWhite,
      body: CustomScrollView(
        slivers: [
          // Sleek Floating AppBar with Gold/Wheat glow
          SliverAppBar(
            pinned: true,
            elevation: 0,
            backgroundColor: isDark
                ? const Color(0xFF121214).withValues(alpha: 0.90)
                : ghostWhite.withValues(alpha: 0.90),
            surfaceTintColor: Colors.transparent,
            title: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(7),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [gold, deepGold],
                    ),
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: gold.withValues(alpha: 0.35),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.flutter_dash_rounded,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  'SP.',
                  style: TextStyle(
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1.2,
                    fontSize: 20,
                    color: isDark ? ghostWhite : const Color(0xFF1F2937),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: gold.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: deepGold.withValues(alpha: 0.4),
                    ),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircleAvatar(
                        radius: 3.5,
                        backgroundColor: deepGold,
                      ),
                      SizedBox(width: 5),
                      Text(
                        'OPEN TO WORK',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: deepGold,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            actions: [
              IconButton(
                tooltip: 'Toggle Theme',
                onPressed: widget.onToggleTheme,
                icon: Icon(
                  isDark ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
                  color: isDark ? gold : const Color(0xFF4B5563),
                ),
              ),
              IconButton(
                tooltip: 'Copy Email',
                onPressed: _copyEmail,
                icon: const Icon(
                  Icons.mail_outline_rounded,
                  color: deepGold,
                ),
              ),
              const SizedBox(width: 8),
            ],
          ),

          // Main Profile Body
          SliverToBoxAdapter(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1100),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  child: Column(
                    children: [
                      // HERO BANNER & AVATAR CARD
                      _buildHeroCard(isDark, bgSurface, borderColor),
                      const SizedBox(height: 24),

                      // TAB NAVIGATION BAR
                      _buildTabSelector(isDark),
                      const SizedBox(height: 24),

                      // TAB CONTENT PANELS
                      LayoutBuilder(
                        builder: (context, constraints) {
                          final isWide = constraints.maxWidth >= 768;
                          return AnimatedBuilder(
                            animation: _tabController,
                            builder: (context, child) {
                              switch (_tabController.index) {
                                case 0:
                                  return _buildOverviewTab(isDark, bgSurface, borderColor, isWide);
                                case 1:
                                  return _buildProjectsTab(isDark, bgSurface, borderColor, isWide);
                                case 2:
                                  return _buildSkillsTab(isDark, bgSurface, borderColor, isWide);
                                case 3:
                                  return _buildExperienceTab(isDark, bgSurface, borderColor, isWide);
                                default:
                                  return const SizedBox.shrink();
                              }
                            },
                          );
                        },
                      ),
                      const SizedBox(height: 48),

                      // FOOTER
                      _buildFooter(isDark),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- HERO CARD WITH GOLD & WHEAT GRADIENT COVER ---
  Widget _buildHeroCard(bool isDark, Color bgSurface, Color borderColor) {
    return Container(
      decoration: BoxDecoration(
        color: bgSurface,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: borderColor, width: 1.2),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withValues(alpha: 0.3)
                : const Color(0xFFD97706).withValues(alpha: 0.08),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          // Banner Background with Warm Gold/Wheat/Amber
          Stack(
            children: [
              Container(
                height: 140,
                width: double.infinity,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color(0xFFFFD700), // Gold
                      Color(0xFFF5DEB3), // Wheat
                      Color(0xFFFBBF24), // Warm Amber
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
              ),
              Positioned(
                right: -20,
                top: -30,
                child: CircleAvatar(
                  radius: 80,
                  backgroundColor: Colors.white.withValues(alpha: 0.25),
                ),
              ),
              Positioned(
                left: 120,
                bottom: -40,
                child: CircleAvatar(
                  radius: 60,
                  backgroundColor: Colors.white.withValues(alpha: 0.18),
                ),
              ),
            ],
          ),

          // Profile Info Section below Banner
          Padding(
            padding: const EdgeInsets.fromLTRB(28, 0, 28, 28),
            child: LayoutBuilder(
              builder: (context, box) {
                final isDesktop = box.maxWidth >= 650;
                return Column(
                  children: [
                    // Avatar & Actions Row
                    Transform.translate(
                      offset: const Offset(0, -45),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          // Glowing Avatar with Verified Badge
                          Stack(
                            clipBehavior: Clip.none,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  gradient: const LinearGradient(
                                    colors: [gold, deepGold, wheat],
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: gold.withValues(alpha: 0.45),
                                      blurRadius: 16,
                                      offset: const Offset(0, 6),
                                    ),
                                  ],
                                ),
                                child: Container(
                                  padding: const EdgeInsets.all(3),
                                  decoration: BoxDecoration(
                                    color: bgSurface,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const CircleAvatar(
                                    radius: 46,
                                    backgroundImage: AssetImage('assets/sahil_profile.jpg'),
                                  ),
                                ),
                              ),
                              Positioned(
                                right: 4,
                                bottom: 4,
                                child: Container(
                                  padding: const EdgeInsets.all(3),
                                  decoration: BoxDecoration(
                                    color: bgSurface,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.verified_rounded,
                                    color: deepGold,
                                    size: 24,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const Spacer(),
                          // Action Buttons
                          if (isDesktop)
                            Row(
                              children: [
                                _buildOutlinedButton(
                                  icon: Icons.chat_bubble_outline_rounded,
                                  label: 'Message',
                                  onTap: _showMessageDialog,
                                  isDark: isDark,
                                ),
                                const SizedBox(width: 12),
                                _buildPrimaryButton(
                                  icon: _isConnected
                                      ? Icons.check_rounded
                                      : Icons.person_add_alt_1_rounded,
                                  label: _isConnected ? 'Connected' : 'Connect',
                                  onTap: _handleConnectToggle,
                                  isActive: _isConnected,
                                ),
                              ],
                            ),
                        ],
                      ),
                    ),

                    // If Mobile, buttons go here
                    if (!isDesktop) ...[
                      Transform.translate(
                        offset: const Offset(0, -25),
                        child: Row(
                          children: [
                            Expanded(
                              child: _buildOutlinedButton(
                                icon: Icons.chat_bubble_outline_rounded,
                                label: 'Message',
                                onTap: _showMessageDialog,
                                isDark: isDark,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: _buildPrimaryButton(
                                icon: _isConnected
                                    ? Icons.check_rounded
                                    : Icons.person_add_alt_1_rounded,
                                label: _isConnected ? 'Connected' : 'Connect',
                                onTap: _handleConnectToggle,
                                isActive: _isConnected,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],

                    Transform.translate(
                      offset: Offset(0, isDesktop ? -25 : -10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                'Sahil Pandey',
                                style: TextStyle(
                                  fontSize: 26,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: -0.5,
                                  color: isDark ? ghostWhite : const Color(0xFF1F2937),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                decoration: BoxDecoration(
                                  color: gold.withValues(alpha: 0.25),
                                  borderRadius: BorderRadius.circular(6),
                                  border: Border.all(color: deepGold.withValues(alpha: 0.4)),
                                ),
                                child: const Text(
                                  'DEV',
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                    color: deepGold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            'Junior Flutter Developer | Mobile App Enthusiast',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: deepGold,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Wrap(
                            spacing: 16,
                            runSpacing: 8,
                            children: [
                              _buildMetaItem(
                                Icons.location_on_rounded,
                                'India',
                                isDark,
                              ),
                              _buildMetaItem(
                                Icons.school_rounded,
                                'Computer Science & Engineering',
                                isDark,
                              ),
                              _buildMetaItem(
                                Icons.bolt_rounded,
                                'Fast Learner & Builder',
                                isDark,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetaItem(IconData icon, String text, bool isDark) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          size: 15,
          color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF6B7280),
        ),
        const SizedBox(width: 5),
        Text(
          text,
          style: TextStyle(
            fontSize: 13,
            color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF6B7280),
          ),
        ),
      ],
    );
  }

  Widget _buildPrimaryButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    bool isActive = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        gradient: LinearGradient(
          colors: isActive
              ? [const Color(0xFF059669), const Color(0xFF10B981)]
              : [deepGold, const Color(0xFFB45309)],
        ),
        boxShadow: [
          BoxShadow(
            color: (isActive ? const Color(0xFF10B981) : deepGold).withValues(alpha: 0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ElevatedButton.icon(
        onPressed: onTap,
        icon: Icon(icon, size: 17, color: Colors.white),
        label: Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 13,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 13),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        ),
      ),
    );
  }

  Widget _buildOutlinedButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    required bool isDark,
  }) {
    return OutlinedButton.icon(
      onPressed: onTap,
      icon: Icon(
        icon,
        size: 17,
        color: deepGold,
      ),
      label: Text(
        label,
        style: TextStyle(
          color: isDark ? ghostWhite : const Color(0xFF1F2937),
          fontWeight: FontWeight.w600,
          fontSize: 13,
        ),
      ),
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 13),
        side: const BorderSide(color: wheat, width: 1.5),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
    );
  }

  // --- MODERN TAB SELECTOR ---
  Widget _buildTabSelector(bool isDark) {
    return Container(
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E24) : wheat.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: wheat.withValues(alpha: 0.8)),
      ),
      child: TabBar(
        controller: _tabController,
        dividerColor: Colors.transparent,
        indicatorSize: TabBarIndicatorSize.tab,
        indicator: BoxDecoration(
          gradient: const LinearGradient(colors: [deepGold, Color(0xFFB45309)]),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: deepGold.withValues(alpha: 0.35),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        labelColor: Colors.white,
        unselectedLabelColor: isDark ? const Color(0xFF94A3B8) : const Color(0xFF4B5563),
        labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
        unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
        tabs: const [
          Tab(
            icon: Icon(Icons.dashboard_outlined, size: 18),
            text: 'Overview',
          ),
          Tab(
            icon: Icon(Icons.rocket_launch_outlined, size: 18),
            text: 'Projects',
          ),
          Tab(
            icon: Icon(Icons.code_rounded, size: 18),
            text: 'Skills',
          ),
          Tab(
            icon: Icon(Icons.timeline_rounded, size: 18),
            text: 'Journey',
          ),
        ],
      ),
    );
  }

  // --- TAB 1: OVERVIEW (BENTO GRID STYLE) ---
  Widget _buildOverviewTab(
      bool isDark, Color bgSurface, Color borderColor, bool isWide) {
    return Column(
      children: [
        // 4 KPI STAT CARDS with Gold & Wheat Accent
        Row(
          children: [
            Expanded(
              child: _buildMetricCard(
                icon: Icons.layers_rounded,
                value: '12+',
                label: 'Projects Built',
                gradient: const [gold, deepGold],
                isDark: isDark,
                bgSurface: bgSurface,
                borderColor: borderColor,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: _buildMetricCard(
                icon: Icons.people_alt_rounded,
                value: '$_followersCount',
                label: 'Connections',
                gradient: const [Color(0xFFF59E0B), Color(0xFFD97706)],
                isDark: isDark,
                bgSurface: bgSurface,
                borderColor: borderColor,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: _buildMetricCard(
                icon: Icons.star_rounded,
                value: '4.8',
                label: 'Code Rating',
                gradient: const [Color(0xFFFBBF24), Color(0xFFB45309)],
                isDark: isDark,
                bgSurface: bgSurface,
                borderColor: borderColor,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: _buildMetricCard(
                icon: Icons.local_fire_department_rounded,
                value: '100%',
                label: 'Dedication',
                gradient: const [Color(0xFFEA580C), Color(0xFFD97706)],
                isDark: isDark,
                bgSurface: bgSurface,
                borderColor: borderColor,
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),

        // Bento 2-column or single column
        if (isWide)
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 6,
                child: Column(
                  children: [
                    _buildAboutBento(isDark, bgSurface, borderColor),
                    const SizedBox(height: 20),
                    _buildHighlightedTech(isDark, bgSurface, borderColor),
                  ],
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                flex: 4,
                child: Column(
                  children: [
                    _buildContactDock(isDark, bgSurface, borderColor),
                    const SizedBox(height: 20),
                    _buildServicesCard(isDark, bgSurface, borderColor),
                  ],
                ),
              ),
            ],
          )
        else
          Column(
            children: [
              _buildAboutBento(isDark, bgSurface, borderColor),
              const SizedBox(height: 18),
              _buildContactDock(isDark, bgSurface, borderColor),
              const SizedBox(height: 18),
              _buildHighlightedTech(isDark, bgSurface, borderColor),
              const SizedBox(height: 18),
              _buildServicesCard(isDark, bgSurface, borderColor),
            ],
          ),
      ],
    );
  }

  Widget _buildMetricCard({
    required IconData icon,
    required String value,
    required String label,
    required List<Color> gradient,
    required bool isDark,
    required Color bgSurface,
    required Color borderColor,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 14),
      decoration: BoxDecoration(
        color: bgSurface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: borderColor, width: 1.2),
        boxShadow: [
          BoxShadow(
            color: deepGold.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: gradient),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: Colors.white, size: 20),
          ),
          const SizedBox(height: 10),
          Text(
            value,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: isDark ? ghostWhite : const Color(0xFF1F2937),
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF6B7280),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAboutBento(bool isDark, Color bgSurface, Color borderColor) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: bgSurface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: borderColor, width: 1.2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: gold.withValues(alpha: 0.25),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.person_pin_rounded, color: deepGold, size: 20),
              ),
              const SizedBox(width: 12),
              Text(
                'About Sahil Pandey',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  color: isDark ? ghostWhite : const Color(0xFF1F2937),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            'Hi, I\'m Sahil! I am an enthusiastic Junior Flutter Developer driven by curiosity and a deep love for building intuitive, sleek cross-platform applications. I focus on writing maintainable Dart code, creating silky-smooth UI animations, and integrating modern backend services.',
            style: TextStyle(
              fontSize: 14,
              height: 1.65,
              color: isDark ? const Color(0xFFCBD5E1) : const Color(0xFF4B5563),
            ),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _buildTag('🚀 Flutter Enthusiast', isDark),
              _buildTag('📱 Responsive UI/UX', isDark),
              _buildTag('💡 Dart & OOP', isDark),
              _buildTag('🔥 Firebase Integrations', isDark),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTag(String label, bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF121214) : wheat.withValues(alpha: 0.35),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: wheat,
        ),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: isDark ? ghostWhite : const Color(0xFF78350F),
        ),
      ),
    );
  }

  Widget _buildContactDock(bool isDark, Color bgSurface, Color borderColor) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: bgSurface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: borderColor, width: 1.2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: gold.withValues(alpha: 0.25),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.alternate_email_rounded, color: deepGold, size: 20),
              ),
              const SizedBox(width: 12),
              Text(
                'Contact Details',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  color: isDark ? ghostWhite : const Color(0xFF1F2937),
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          _buildContactRow(
            icon: Icons.email_rounded,
            title: 'Email Address',
            value: userEmail,
            color: deepGold,
            onTap: _copyEmail,
            isDark: isDark,
          ),
          const SizedBox(height: 12),
          _buildContactRow(
            icon: Icons.language_rounded,
            title: 'Portfolio Website',
            value: 'sahilpandey.dev',
            color: const Color(0xFF059669),
            onTap: () {},
            isDark: isDark,
          ),
          const SizedBox(height: 12),
          _buildContactRow(
            icon: Icons.work_rounded,
            title: 'LinkedIn',
            value: 'linkedin.com/in/sahilpandey',
            color: const Color(0xFF0284C7),
            onTap: () {},
            isDark: isDark,
          ),
        ],
      ),
    );
  }

  Widget _buildContactRow({
    required IconData icon,
    required String title,
    required String value,
    required Color color,
    required VoidCallback onTap,
    required bool isDark,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF121214) : ghostWhite,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: wheat.withValues(alpha: 0.8),
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: color, size: 18),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF6B7280),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    value,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: isDark ? ghostWhite : const Color(0xFF1F2937),
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right_rounded,
              size: 18,
              color: isDark ? const Color(0xFF64748B) : const Color(0xFF9CA3AF),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHighlightedTech(bool isDark, Color bgSurface, Color borderColor) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: bgSurface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: borderColor, width: 1.2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: gold.withValues(alpha: 0.25),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.auto_awesome_rounded, color: deepGold, size: 20),
              ),
              const SizedBox(width: 12),
              Text(
                'Key Development Focus',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  color: isDark ? ghostWhite : const Color(0xFF1F2937),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildFocusItem('State Management', 'Provider & Riverpod for clean structured state', Icons.account_tree_rounded, deepGold, isDark),
          const SizedBox(height: 12),
          _buildFocusItem('API & Cloud Integration', 'REST APIs, JSON parsing & Firebase Firestore/Auth', Icons.cloud_sync_rounded, const Color(0xFFD97706), isDark),
          const SizedBox(height: 12),
          _buildFocusItem('Pixel-Perfect UI', 'Translating Figma designs into responsive Flutter widgets', Icons.animation_rounded, const Color(0xFFB45309), isDark),
        ],
      ),
    );
  }

  Widget _buildFocusItem(String title, String desc, IconData icon, Color color, bool isDark) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: color, size: 18),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: isDark ? ghostWhite : const Color(0xFF1F2937),
                ),
              ),
              Text(
                desc,
                style: TextStyle(
                  fontSize: 12,
                  color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF6B7280),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildServicesCard(bool isDark, Color bgSurface, Color borderColor) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isDark
              ? [const Color(0xFF2E2413), const Color(0xFF1C1917)]
              : [wheat.withValues(alpha: 0.6), const Color(0xFFFFFBEB)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: gold.withValues(alpha: 0.6),
          width: 1.2,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.local_fire_department_rounded, color: deepGold, size: 22),
              const SizedBox(width: 8),
              Text(
                'Looking for Opportunities',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: isDark ? ghostWhite : const Color(0xFF78350F),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            'Ready to contribute to innovative Flutter projects, full-time roles, or exciting internships.',
            style: TextStyle(
              fontSize: 13,
              color: isDark ? const Color(0xFFCBD5E1) : const Color(0xFF4B5563),
              height: 1.4,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: const LinearGradient(colors: [deepGold, Color(0xFFB45309)]),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: deepGold.withValues(alpha: 0.35),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: ElevatedButton(
              onPressed: _showMessageDialog,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
              child: const Text('Hire Sahil', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }

  // --- TAB 2: PROJECTS SHOWCASE ---
  Widget _buildProjectsTab(
      bool isDark, Color bgSurface, Color borderColor, bool isWide) {
    final projects = [
      {
        'title': 'QuickShop E-Commerce',
        'category': 'E-Commerce & Retail',
        'desc': 'Modern shopping application with product catalog, category filters, interactive cart animations, and payment checkout flow.',
        'tech': ['Flutter', 'Provider', 'REST API', 'SharedPrefs'],
        'stars': '120',
        'gradient': [gold, deepGold],
        'icon': Icons.shopping_bag_rounded,
      },
      {
        'title': 'SkyCast Weather App',
        'category': 'Utilities & APIs',
        'desc': 'Beautiful weather forecast app with live geolocation, dynamic weather backgrounds, hourly temperature charts, and 7-day outlook.',
        'tech': ['Flutter', 'OpenWeather API', 'Geolocator', 'Charts'],
        'stars': '98',
        'gradient': [const Color(0xFFF59E0B), const Color(0xFFD97706)],
        'icon': Icons.cloud_rounded,
      },
      {
        'title': 'TaskFlow Productivity',
        'category': 'Productivity & Tools',
        'desc': 'Minimalist task and habit tracking tool with custom categories, swipe actions, dark mode, and local persistent SQLite database.',
        'tech': ['Flutter', 'SQLite', 'Local Notifications', 'Dart'],
        'stars': '145',
        'gradient': [const Color(0xFFD97706), const Color(0xFFB45309)],
        'icon': Icons.check_circle_outline_rounded,
      },
      {
        'title': 'ChatSphere Messenger',
        'category': 'Real-time Social',
        'desc': 'Clean messaging app UI with Firebase authentication, Firestore live chat stream, media sharing, and online status indicators.',
        'tech': ['Flutter', 'Firebase Auth', 'Firestore', 'Storage'],
        'stars': '164',
        'gradient': [const Color(0xFFEAB308), const Color(0xFFCA8A04)],
        'icon': Icons.chat_rounded,
      },
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: projects.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: isWide ? 2 : 1,
        mainAxisSpacing: 18,
        crossAxisSpacing: 18,
        mainAxisExtent: 260,
      ),
      itemBuilder: (context, index) {
        final p = projects[index];
        final gradient = p['gradient'] as List<Color>;
        final techList = p['tech'] as List<String>;

        return Container(
          padding: const EdgeInsets.all(22),
          decoration: BoxDecoration(
            color: bgSurface,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: borderColor, width: 1.2),
            boxShadow: [
              BoxShadow(
                color: isDark
                    ? Colors.black.withValues(alpha: 0.2)
                    : deepGold.withValues(alpha: 0.05),
                blurRadius: 16,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(colors: gradient),
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: [
                        BoxShadow(
                          color: gradient.first.withValues(alpha: 0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Icon(p['icon'] as IconData, color: Colors.white, size: 22),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          p['title'] as String,
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: isDark ? ghostWhite : const Color(0xFF1F2937),
                          ),
                        ),
                        Text(
                          p['category'] as String,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: deepGold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      const Icon(Icons.star_rounded, color: Color(0xFFD97706), size: 18),
                      const SizedBox(width: 3),
                      Text(
                        p['stars'] as String,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF6B7280),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 14),
              Expanded(
                child: Text(
                  p['desc'] as String,
                  style: TextStyle(
                    fontSize: 13,
                    height: 1.45,
                    color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF4B5563),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 6,
                runSpacing: 6,
                children: techList.map((t) => _buildProjectTechChip(t, isDark)).toList(),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildProjectTechChip(String tech, bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF121214) : wheat.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: wheat),
      ),
      child: Text(
        tech,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: isDark ? ghostWhite : const Color(0xFF78350F),
        ),
      ),
    );
  }

  // --- TAB 3: SKILLS & PROFICIENCY ---
  Widget _buildSkillsTab(
      bool isDark, Color bgSurface, Color borderColor, bool isWide) {
    final skillCategories = [
      {
        'title': 'Core Mobile & Languages',
        'icon': Icons.phone_iphone_rounded,
        'color': deepGold,
        'skills': [
          {'name': 'Flutter & Custom UI Widgets', 'pct': 0.88, 'level': 'Advanced'},
          {'name': 'Dart Language & OOP Concepts', 'pct': 0.85, 'level': 'Advanced'},
          {'name': 'State Management (Provider / Riverpod)', 'pct': 0.82, 'level': 'Proficient'},
          {'name': 'Responsive Mobile & Web UI', 'pct': 0.86, 'level': 'Advanced'},
        ],
      },
      {
        'title': 'Backend, Cloud & Storage',
        'icon': Icons.cloud_done_rounded,
        'color': const Color(0xFFB45309),
        'skills': [
          {'name': 'Firebase (Authentication & Firestore)', 'pct': 0.80, 'level': 'Proficient'},
          {'name': 'REST APIs & JSON Handling', 'pct': 0.84, 'level': 'Proficient'},
          {'name': 'Local Storage (SQLite / SharedPrefs)', 'pct': 0.78, 'level': 'Intermediate'},
          {'name': 'Git Version Control & Workflows', 'pct': 0.85, 'level': 'Proficient'},
        ],
      },
      {
        'title': 'Design & Best Practices',
        'icon': Icons.design_services_rounded,
        'color': const Color(0xFFD97706),
        'skills': [
          {'name': 'Figma UI to Flutter Code', 'pct': 0.88, 'level': 'Advanced'},
          {'name': 'Clean & Readable Code Structure', 'pct': 0.84, 'level': 'Proficient'},
          {'name': 'Debugging & Performance Profiling', 'pct': 0.75, 'level': 'Intermediate'},
          {'name': 'Material Design 3 & Cupertinos', 'pct': 0.85, 'level': 'Proficient'},
        ],
      },
    ];

    return Column(
      children: skillCategories.map((cat) {
        final color = cat['color'] as Color;
        final skills = cat['skills'] as List<Map<String, dynamic>>;

        return Container(
          margin: const EdgeInsets.only(bottom: 20),
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: bgSurface,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: borderColor, width: 1.2),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(cat['icon'] as IconData, color: color, size: 20),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    cat['title'] as String,
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: isDark ? ghostWhite : const Color(0xFF1F2937),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              ...skills.map((s) => _buildSkillProgressRow(
                    name: s['name'] as String,
                    pct: s['pct'] as double,
                    level: s['level'] as String,
                    color: color,
                    isDark: isDark,
                  )),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildSkillProgressRow({
    required String name,
    required double pct,
    required String level,
    required Color color,
    required bool isDark,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  name,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: isDark ? ghostWhite : const Color(0xFF1F2937),
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  level,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                '${(pct * 100).toInt()}%',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                  color: isDark ? ghostWhite : const Color(0xFF1F2937),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: pct,
              minHeight: 8,
              backgroundColor: isDark ? const Color(0xFF121214) : wheat.withValues(alpha: 0.4),
              valueColor: AlwaysStoppedAnimation<Color>(color),
            ),
          ),
        ],
      ),
    );
  }

  // --- TAB 4: EXPERIENCE & TIMELINE ---
  Widget _buildExperienceTab(
      bool isDark, Color bgSurface, Color borderColor, bool isWide) {
    final timeline = [
      {
        'role': 'Junior Flutter Developer',
        'company': 'Freelance & Personal Projects',
        'period': '2024 — Present',
        'desc': 'Developing real-world mobile apps including E-Commerce, Weather Forecast, and Task Management systems with modern Flutter best practices.',
        'icon': Icons.phone_android_rounded,
        'color': deepGold,
      },
      {
        'role': 'Flutter & Mobile Development Trainee',
        'company': 'Self-Directed & Online Certifications',
        'period': '2023 — 2024',
        'desc': 'Mastered Dart fundamentals, widget tree architecture, state management patterns, and RESTful API integrations.',
        'icon': Icons.code_rounded,
        'color': const Color(0xFFB45309),
      },
      {
        'role': 'Bachelor of Technology (Computer Science)',
        'company': 'University Department of Technology',
        'period': '2020 — 2024',
        'desc': 'Studied core Computer Science subjects: Data Structures, Algorithms, DBMS, Object-Oriented Programming, and Software Engineering.',
        'icon': Icons.school_rounded,
        'color': const Color(0xFFD97706),
      },
    ];

    return Container(
      padding: const EdgeInsets.all(26),
      decoration: BoxDecoration(
        color: bgSurface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: borderColor, width: 1.2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: gold.withValues(alpha: 0.25),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.history_edu_rounded, color: deepGold, size: 20),
              ),
              const SizedBox(width: 12),
              Text(
                'Learning Journey & Education',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  color: isDark ? ghostWhite : const Color(0xFF1F2937),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          ...timeline.asMap().entries.map((entry) {
            final idx = entry.key;
            final item = entry.value;
            final isLast = idx == timeline.length - 1;
            final color = item['color'] as Color;

            return IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: color.withValues(alpha: 0.15),
                          shape: BoxShape.circle,
                          border: Border.all(color: color, width: 2),
                        ),
                        child: Icon(item['icon'] as IconData, color: color, size: 16),
                      ),
                      if (!isLast)
                        Expanded(
                          child: Container(
                            width: 2,
                            margin: const EdgeInsets.symmetric(vertical: 4),
                            color: wheat,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(width: 18),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(bottom: isLast ? 0 : 28),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  item['role'] as String,
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: isDark ? ghostWhite : const Color(0xFF1F2937),
                                  ),
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                decoration: BoxDecoration(
                                  color: wheat.withValues(alpha: 0.4),
                                  borderRadius: BorderRadius.circular(6),
                                  border: Border.all(color: wheat),
                                ),
                                child: Text(
                                  item['period'] as String,
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                    color: isDark ? ghostWhite : const Color(0xFF78350F),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 3),
                          Text(
                            item['company'] as String,
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: color,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            item['desc'] as String,
                            style: TextStyle(
                              fontSize: 13,
                              height: 1.5,
                              color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF6B7280),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  // --- FOOTER ---
  Widget _buildFooter(bool isDark) {
    return Column(
      children: [
        const Divider(
          color: wheat,
        ),
        const SizedBox(height: 14),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Designed & Crafted with ',
              style: TextStyle(
                fontSize: 12,
                color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF6B7280),
              ),
            ),
            const Icon(Icons.favorite_rounded, color: deepGold, size: 14),
            Text(
              ' by Sahil Pandey',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: isDark ? ghostWhite : const Color(0xFF1F2937),
              ),
            ),
          ],
        ),
      ],
    );
  }
}