import 'dart:ui' as ui;
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'map_component.dart';

/// NPC 정보
class NpcData {
  final String name;
  final String emoji;
  final String role;
  final ui.Color color;
  final Vector2 mapPosition;

  const NpcData({
    required this.name,
    required this.emoji,
    required this.role,
    required this.color,
    required this.mapPosition,
  });
}

final npcList = [
  NpcData(
    name: '조조',
    emoji: '👑',
    role: '매니저',
    color: const ui.Color(0xFFC8960C),
    mapPosition: Vector2(7.5, 7.5),
  ),
  NpcData(
    name: '사마의',
    emoji: '🧠',
    role: '기획자',
    color: const ui.Color(0xFF4488CC),
    mapPosition: Vector2(2.0, 2.0),
  ),
  NpcData(
    name: '견희',
    emoji: '🌸',
    role: '디자이너',
    color: const ui.Color(0xFFCC44AA),
    mapPosition: Vector2(13.0, 2.0),
  ),
  NpcData(
    name: '장료',
    emoji: '⚔️',
    role: '개발자',
    color: const ui.Color(0xFF44CC44),
    mapPosition: Vector2(7.5, 13.5),
  ),
];

class NpcComponent extends PositionComponent with TapCallbacks {
  final NpcData data;
  final void Function(NpcData) onTapped;

  NpcComponent({required this.data, required this.onTapped})
      : super(
          size: Vector2(MapComponent.tileSize.toDouble(),
              MapComponent.tileSize.toDouble()),
          anchor: Anchor.center,
        );

  @override
  Future<void> onLoad() async {
    position = Vector2(
      data.mapPosition.x * MapComponent.tileSize,
      data.mapPosition.y * MapComponent.tileSize,
    );
  }

  @override
  void render(ui.Canvas canvas) {
    final cx = size.x / 2;
    final cy = size.y / 2;
    final r = size.x * 0.42;

    canvas.drawCircle(
      ui.Offset(cx, cy),
      r,
      ui.Paint()..color = data.color.withValues(alpha: 0.25),
    );
    canvas.drawCircle(
      ui.Offset(cx, cy),
      r,
      ui.Paint()
        ..color = data.color
        ..style = ui.PaintingStyle.stroke
        ..strokeWidth = 2,
    );

    // 이모지
    final pb = ui.ParagraphBuilder(
      ui.ParagraphStyle(fontSize: size.x * 0.55),
    )..addText(data.emoji);
    final paragraph = pb.build();
    paragraph.layout(ui.ParagraphConstraints(width: size.x));
    canvas.drawParagraph(
      paragraph,
      ui.Offset(cx - paragraph.longestLine / 2, cy - paragraph.height / 2),
    );

    // 이름 레이블
    final namePb = ui.ParagraphBuilder(
      ui.ParagraphStyle(fontSize: 10),
    )
      ..pushStyle(
        ui.TextStyle(
          color: data.color,
          fontSize: 10,
          fontWeight: ui.FontWeight.bold,
        ),
      )
      ..addText(data.name);
    final namePara = namePb.build();
    namePara.layout(ui.ParagraphConstraints(width: size.x + 20));
    canvas.drawParagraph(
      namePara,
      ui.Offset(cx - namePara.longestLine / 2, size.y + 2),
    );
  }

  @override
  void onTapDown(TapDownEvent event) {
    onTapped(data);
  }
}
