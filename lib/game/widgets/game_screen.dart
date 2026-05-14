import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../clawkingdom_game.dart';
import '../components/npc_component.dart';
import 'npc_dialog.dart';

const kBg = Color(0xFF1A0A0A);
const kCard = Color(0xFF2D1010);
const kGold = Color(0xFFC8960C);
const kPaleGold = Color(0xFFF2D060);
const kText = Color(0xFFF5E6C8);
const kBronze = Color(0xFF8B6914);

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  late final ClawKingdomGame _game;
  NpcData? _selectedNpc;
  List<String> _taskLog = [];

  @override
  void initState() {
    super.initState();
    _game = ClawKingdomGame();
    _game.onNpcTapped = (npc) {
      setState(() {
        _selectedNpc = npc;
      });
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBg,
      body: Column(
        children: [
          // HUD 상단 바
          Container(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
            decoration: const BoxDecoration(
              color: kCard,
              border: Border(bottom: BorderSide(color: Color(0xFF8B6914))),
            ),
            child: SafeArea(
              bottom: false,
              child: Row(
                children: [
                  Text(
                    '⚔️ ClawKingdom',
                    style: GoogleFonts.notoSerifKr(
                      color: kPaleGold,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  // 에이전트 상태 아이콘
                  for (final npc in npcList)
                    Padding(
                      padding: const EdgeInsets.only(left: 6),
                      child: GestureDetector(
                        onTap: () => setState(() => _selectedNpc = npc),
                        child: Container(
                          width: 30,
                          height: 30,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: npc.color.withValues(alpha: 0.2),
                            border: Border.all(color: npc.color, width: 1),
                          ),
                          child: Center(
                            child: Text(
                              npc.emoji,
                              style: const TextStyle(fontSize: 14),
                            ),
                          ),
                        ),
                      ),
                    ),
                  // 미니맵 (우상단)
                  const SizedBox(width: 8),
                  _MiniMap(taskLog: _taskLog),
                ],
              ),
            ),
          ),

          // 게임 화면
          Expanded(
            child: GameWidget(game: _game),
          ),

          // NPC 대화창 또는 채팅 로그 하단 바
          if (_selectedNpc != null)
            NpcDialog(
              npc: _selectedNpc!,
              onTaskSubmit: (task) {
                setState(() {
                  _taskLog.insert(0,
                      '[${_selectedNpc!.emoji} ${_selectedNpc!.name}] $task');
                  if (_taskLog.length > 10) _taskLog.removeLast();
                  _selectedNpc = null;
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      '${_selectedNpc?.name ?? ""} 에게 태스크를 전달했습니다!',
                      style: GoogleFonts.notoSerifKr(color: kText),
                    ),
                    backgroundColor: kCard,
                    duration: const Duration(seconds: 2),
                  ),
                );
              },
              onClose: () => setState(() => _selectedNpc = null),
            )
          else
            _ChatBar(taskLog: _taskLog),
        ],
      ),
    );
  }
}

class _ChatBar extends StatelessWidget {
  final List<String> taskLog;

  const _ChatBar({required this.taskLog});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: const BoxDecoration(
        color: kCard,
        border: Border(top: BorderSide(color: Color(0xFF8B6914))),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '🏯 왕국 로그',
            style: GoogleFonts.notoSerifKr(
              color: kBronze,
              fontSize: 11,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Expanded(
            child: taskLog.isEmpty
                ? Text(
                    'NPC를 터치하여 태스크를 지시하세요.',
                    style: GoogleFonts.notoSerifKr(
                      color: kBronze,
                      fontSize: 11,
                    ),
                  )
                : ListView.builder(
                    reverse: false,
                    itemCount: taskLog.length > 2 ? 2 : taskLog.length,
                    itemBuilder: (ctx, i) => Text(
                      taskLog[i],
                      style: GoogleFonts.notoSerifKr(
                        color: kText,
                        fontSize: 11,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}

class _MiniMap extends StatelessWidget {
  final List<String> taskLog;

  const _MiniMap({required this.taskLog});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: kBg,
        border: Border.all(color: kBronze),
        borderRadius: BorderRadius.circular(4),
      ),
      child: CustomPaint(
        painter: _MiniMapPainter(),
      ),
    );
  }
}

class _MiniMapPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // 간단한 미니맵 표시
    final bgPaint = Paint()..color = const Color(0xFF1A0A0A);
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), bgPaint);

    final cellW = size.width / 16;
    final cellH = size.height / 16;

    // 방들
    canvas.drawRect(
      Rect.fromLTWH(5 * cellW, 5 * cellH, 6 * cellW, 6 * cellH),
      Paint()..color = const Color(0xFF3D2010),
    );
    canvas.drawRect(
      Rect.fromLTWH(0, 0, 4 * cellW, 4 * cellH),
      Paint()..color = const Color(0xFF102030),
    );
    canvas.drawRect(
      Rect.fromLTWH(12 * cellW, 0, 4 * cellW, 4 * cellH),
      Paint()..color = const Color(0xFF201030),
    );
    canvas.drawRect(
      Rect.fromLTWH(0, 12 * cellH, 16 * cellW, 4 * cellH),
      Paint()..color = const Color(0xFF103020),
    );

    // NPC 점들
    for (final npc in npcList) {
      canvas.drawCircle(
        Offset(npc.mapPosition.x * cellW, npc.mapPosition.y * cellH),
        2,
        Paint()..color = npc.color,
      );
    }

    // 플레이어 점
    canvas.drawCircle(
      Offset(8 * cellW, 10 * cellH),
      2,
      Paint()..color = const Color(0xFFF2D060),
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
