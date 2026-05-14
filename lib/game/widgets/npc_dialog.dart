import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../components/npc_component.dart';

const kBg = Color(0xFF1A0A0A);
const kCard = Color(0xFF2D1010);
const kGold = Color(0xFFC8960C);
const kPaleGold = Color(0xFFF2D060);
const kText = Color(0xFFF5E6C8);
const kBronze = Color(0xFF8B6914);

class NpcDialog extends StatefulWidget {
  final NpcData npc;
  final void Function(String task) onTaskSubmit;
  final VoidCallback onClose;

  const NpcDialog({
    super.key,
    required this.npc,
    required this.onTaskSubmit,
    required this.onClose,
  });

  @override
  State<NpcDialog> createState() => _NpcDialogState();
}

class _NpcDialogState extends State<NpcDialog> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: kCard,
        border: Border(top: BorderSide(color: kBronze, width: 1)),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // NPC 헤더
            Row(
              children: [
                Text(
                  widget.npc.emoji,
                  style: const TextStyle(fontSize: 28),
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.npc.name,
                      style: GoogleFonts.notoSerifKr(
                        color: kPaleGold,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      widget.npc.role,
                      style: GoogleFonts.notoSerifKr(
                        color: kText,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.close, color: kBronze, size: 20),
                  onPressed: widget.onClose,
                ),
              ],
            ),
            // 대화 버블
            Container(
              margin: const EdgeInsets.symmetric(vertical: 8),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: kBg,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: kBronze.withValues(alpha: 0.5)),
              ),
              child: Text(
                _getGreeting(widget.npc.name),
                style: GoogleFonts.notoSerifKr(
                  color: kText,
                  fontSize: 13,
                ),
              ),
            ),
            // 태스크 입력
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    style: GoogleFonts.notoSerifKr(
                      color: kText,
                      fontSize: 13,
                    ),
                    decoration: InputDecoration(
                      hintText: '태스크를 입력하세요...',
                      hintStyle: GoogleFonts.notoSerifKr(
                        color: kBronze,
                        fontSize: 13,
                      ),
                      filled: true,
                      fillColor: kBg,
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: kBronze),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: kGold),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                    ),
                    onSubmitted: (v) {
                      if (v.isNotEmpty) {
                        widget.onTaskSubmit(v);
                        _controller.clear();
                      }
                    },
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kGold,
                    foregroundColor: kBg,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                  onPressed: () {
                    final v = _controller.text.trim();
                    if (v.isNotEmpty) {
                      widget.onTaskSubmit(v);
                      _controller.clear();
                    }
                  },
                  child: Text(
                    '지시하기',
                    style: GoogleFonts.notoSerifKr(
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _getGreeting(String name) {
    switch (name) {
      case '조조':
        return '천하를 얻으려면 먼저 사람을 얻어야 한다. 무엇을 명하시겠소?';
      case '사마의':
        return '모든 계획은 치밀해야 하오. 분석이 필요한 것이 있소?';
      case '견희':
        return '아름다움이 왕국을 빛낸다오. 어떤 디자인이 필요하오?';
      case '장료':
        return '명령만 내리시오! 즉시 실행하겠소!';
      default:
        return '무엇을 도와드릴까요?';
    }
  }
}
