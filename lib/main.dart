import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'game/widgets/game_screen.dart';

// ─── Colors ───────────────────────────────────────────────────────────────────
const kBg = Color(0xFF1A0A0A);
const kCard = Color(0xFF2D1010);
const kGold = Color(0xFFC8960C);
const kPaleGold = Color(0xFFF2D060);
const kRed = Color(0xFFCC2222);
const kText = Color(0xFFF5E6C8);
const kBronze = Color(0xFF8B6914);

// ─── Data ─────────────────────────────────────────────────────────────────────
class AgentCharacter {
  final String name;
  final String emoji;
  final String role;
  final Map<String, int> stats;
  final String specialty;
  final String status;

  const AgentCharacter({
    required this.name,
    required this.emoji,
    required this.role,
    required this.stats,
    required this.specialty,
    required this.status,
  });
}

final List<AgentCharacter> characters = [
  AgentCharacter(
    name: '조조',
    emoji: '👑',
    role: '매니저',
    stats: {'지략': 82, '통솔': 95, '무력': 60, '정치': 90, '창의': 75},
    specialty: '전체 조율 및 전략 수립',
    status: '온라인',
  ),
  AgentCharacter(
    name: '사마의',
    emoji: '🧠',
    role: '기획자',
    stats: {'지략': 98, '통솔': 70, '무력': 45, '정치': 88, '창의': 85},
    specialty: '요구사항 분석 및 스펙 정의',
    status: '온라인',
  ),
  AgentCharacter(
    name: '견희',
    emoji: '🌸',
    role: '디자이너',
    stats: {'지략': 75, '통솔': 60, '무력': 40, '정치': 65, '창의': 98},
    specialty: 'UI/UX 및 비주얼 디자인',
    status: '온라인',
  ),
  AgentCharacter(
    name: '장료',
    emoji: '⚔️',
    role: '개발자',
    stats: {'지략': 70, '통솔': 75, '무력': 95, '정치': 50, '창의': 80},
    specialty: '코드 구현 및 빌드',
    status: '온라인',
  ),
];

// ─── Theme ────────────────────────────────────────────────────────────────────
ThemeData buildTheme() {
  return ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: kBg,
    colorScheme: const ColorScheme.dark(
      primary: kGold,
      secondary: kPaleGold,
      surface: kCard,
    ),
    textTheme: GoogleFonts.notoSerifKrTextTheme(
      const TextTheme(
        bodyMedium: TextStyle(color: kText),
        bodyLarge: TextStyle(color: kText),
      ),
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: kBg,
      foregroundColor: kPaleGold,
      elevation: 0,
      titleTextStyle: GoogleFonts.notoSerifKr(
        color: kPaleGold,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    ),
  );
}

// ─── Main ─────────────────────────────────────────────────────────────────────
void main() {
  runApp(const ClawKingdomApp());
}

class ClawKingdomApp extends StatelessWidget {
  const ClawKingdomApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ClawKingdom',
      theme: buildTheme(),
      home: const RootScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

// ─── Screen 1: Kingdom Main ───────────────────────────────────────────────────
class KingdomMainScreen extends StatefulWidget {
  const KingdomMainScreen({super.key});

  @override
  State<KingdomMainScreen> createState() => _KingdomMainScreenState();
}

class _KingdomMainScreenState extends State<KingdomMainScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fade;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    )..forward();
    _fade = CurvedAnimation(parent: _controller, curve: Curves.easeIn);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FadeTransition(
        opacity: _fade,
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFF2A0808), kBg],
            ),
          ),
          child: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 40),
                // Title
                Text(
                  '⚔️ ClawKingdom ⚔️',
                  style: GoogleFonts.notoSerifKr(
                    color: kPaleGold,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  height: 2,
                  width: 200,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Colors.transparent, kGold, Colors.transparent],
                    ),
                    borderRadius: BorderRadius.circular(1),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'OpenClaw 에이전트 왕국',
                  style: GoogleFonts.notoSerifKr(
                    color: kText,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 60),
                // Decorative emblem
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: kBronze, width: 2),
                    color: kCard,
                  ),
                  child: const Center(
                    child: Text('👑', style: TextStyle(fontSize: 56)),
                  ),
                ),
                const SizedBox(height: 60),
                // Stats summary
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _StatBadge(label: '영웅', value: '${characters.length}명'),
                      _StatBadge(label: '상태', value: '전원 온라인'),
                      _StatBadge(label: '왕국', value: '번영'),
                    ],
                  ),
                ),
                const SizedBox(height: 48),
                // Enter button
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (_, __, ___) => const CharacterListScreen(),
                        transitionsBuilder: (_, anim, __, child) =>
                            FadeTransition(opacity: anim, child: child),
                        transitionDuration: const Duration(milliseconds: 300),
                      ),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 48, vertical: 16),
                    decoration: BoxDecoration(
                      border: Border.all(color: kGold, width: 1.5),
                      borderRadius: BorderRadius.circular(8),
                      color: kCard,
                    ),
                    child: Text(
                      '영웅 명부 보기',
                      style: GoogleFonts.notoSerifKr(
                        color: kPaleGold,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const Spacer(),
                Text(
                  'Powered by OpenClaw',
                  style: GoogleFonts.notoSerifKr(
                    color: kBronze,
                    fontSize: 11,
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _StatBadge extends StatelessWidget {
  final String label;
  final String value;

  const _StatBadge({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        border: Border.all(color: kBronze),
        borderRadius: BorderRadius.circular(8),
        color: kCard,
      ),
      child: Column(
        children: [
          Text(
            value,
            style: GoogleFonts.notoSerifKr(
              color: kPaleGold,
              fontSize: 13,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: GoogleFonts.notoSerifKr(
              color: kText,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Screen 2: Character List ─────────────────────────────────────────────────
class CharacterListScreen extends StatelessWidget {
  const CharacterListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('영웅 명부'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: kPaleGold),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
            childAspectRatio: 0.85,
          ),
          itemCount: characters.length,
          itemBuilder: (context, index) {
            return _CharacterCard(character: characters[index], index: index);
          },
        ),
      ),
    );
  }
}

class _CharacterCard extends StatefulWidget {
  final AgentCharacter character;
  final int index;

  const _CharacterCard({required this.character, required this.index});

  @override
  State<_CharacterCard> createState() => _CharacterCardState();
}

class _CharacterCardState extends State<_CharacterCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scale;
  late final Animation<double> _fade;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _scale = Tween<double>(begin: 0.85, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
    _fade = CurvedAnimation(parent: _controller, curve: Curves.easeIn);
    Future.delayed(Duration(milliseconds: 100 * widget.index), () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fade,
      child: ScaleTransition(
        scale: _scale,
        child: GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              PageRouteBuilder(
                pageBuilder: (_, __, ___) =>
                    CharacterDetailScreen(character: widget.character),
                transitionsBuilder: (_, anim, __, child) =>
                    FadeTransition(opacity: anim, child: child),
                transitionDuration: const Duration(milliseconds: 250),
              ),
            );
          },
          child: Container(
            decoration: BoxDecoration(
              color: kCard,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: kBronze),
            ),
            padding: const EdgeInsets.all(12),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Avatar
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: kGold, width: 2),
                    color: kBg,
                  ),
                  child: Center(
                    child: Text(
                      widget.character.emoji,
                      style: const TextStyle(fontSize: 30),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  widget.character.name,
                  style: GoogleFonts.notoSerifKr(
                    color: kPaleGold,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: kRed.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(color: kRed.withValues(alpha: 0.5)),
                  ),
                  child: Text(
                    widget.character.role,
                    style: GoogleFonts.notoSerifKr(
                      color: kText,
                      fontSize: 11,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                // Online badge
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: Colors.green,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      widget.character.status,
                      style: GoogleFonts.notoSerifKr(
                        color: Colors.green,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ─── Screen 3: Character Detail ───────────────────────────────────────────────
class CharacterDetailScreen extends StatefulWidget {
  final AgentCharacter character;

  const CharacterDetailScreen({super.key, required this.character});

  @override
  State<CharacterDetailScreen> createState() => _CharacterDetailScreenState();
}

class _CharacterDetailScreenState extends State<CharacterDetailScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    )..forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final char = widget.character;
    return Scaffold(
      appBar: AppBar(
        title: Text(char.name),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: kPaleGold),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Hero Avatar
            AnimatedBuilder(
              animation: _controller,
              builder: (_, __) => Transform.scale(
                scale: Curves.easeOut.transform(_controller.value),
                child: Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: kGold, width: 3),
                    color: kCard,
                    boxShadow: [
                      BoxShadow(
                        color: kGold.withValues(alpha: 0.3),
                        blurRadius: 20,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      char.emoji,
                      style: const TextStyle(fontSize: 56),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              char.name,
              style: GoogleFonts.notoSerifKr(
                color: kPaleGold,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 6),
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              decoration: BoxDecoration(
                color: kRed.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(4),
                border: Border.all(color: kRed.withValues(alpha: 0.6)),
              ),
              child: Text(
                char.role,
                style: GoogleFonts.notoSerifKr(
                  color: kText,
                  fontSize: 14,
                ),
              ),
            ),
            const SizedBox(height: 24),
            // Divider
            Container(
              height: 1,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.transparent, kBronze, Colors.transparent],
                ),
              ),
            ),
            const SizedBox(height: 24),
            // Specialty
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: kCard,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: kBronze),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '전문 분야',
                    style: GoogleFonts.notoSerifKr(
                      color: kGold,
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    char.specialty,
                    style: GoogleFonts.notoSerifKr(
                      color: kText,
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            // Stats
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: kCard,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: kBronze),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '능력치',
                    style: GoogleFonts.notoSerifKr(
                      color: kGold,
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ...char.stats.entries.map(
                    (e) => _StatBar(
                      label: e.key,
                      value: e.value,
                      controller: _controller,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            // Status
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 10,
                  height: 10,
                  decoration: const BoxDecoration(
                    color: Colors.green,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  '현재 상태: ${char.status}',
                  style: GoogleFonts.notoSerifKr(
                    color: Colors.green,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _StatBar extends StatelessWidget {
  final String label;
  final int value;
  final AnimationController controller;

  const _StatBar({
    required this.label,
    required this.value,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: GoogleFonts.notoSerifKr(
                  color: kText,
                  fontSize: 13,
                ),
              ),
              Text(
                '$value',
                style: GoogleFonts.notoSerifKr(
                  color: kPaleGold,
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: AnimatedBuilder(
              animation: controller,
              builder: (_, __) => LinearProgressIndicator(
                value: (value / 100) * controller.value,
                backgroundColor: kBg,
                valueColor: AlwaysStoppedAnimation<Color>(
                  value >= 90
                      ? kRed
                      : value >= 75
                          ? kGold
                          : kBronze,
                ),
                minHeight: 8,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Root Screen with Bottom NavBar ──────────────────────────────────────────
class RootScreen extends StatefulWidget {
  const RootScreen({super.key});

  @override
  State<RootScreen> createState() => _RootScreenState();
}

class _RootScreenState extends State<RootScreen> {
  int _currentIndex = 0;

  final _screens = const [
    KingdomMainScreen(),
    GameScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (i) => setState(() => _currentIndex = i),
        backgroundColor: kCard,
        selectedItemColor: kPaleGold,
        unselectedItemColor: kBronze,
        selectedLabelStyle: GoogleFonts.notoSerifKr(fontSize: 11),
        unselectedLabelStyle: GoogleFonts.notoSerifKr(fontSize: 11),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.groups),
            label: '영웅 명부',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.map),
            label: '왕국 맵',
          ),
        ],
      ),
    );
  }
}
