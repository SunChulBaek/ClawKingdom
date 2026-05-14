import 'dart:math' as math;
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
    color: const ui.Color(0xFF4A2080),
    mapPosition: Vector2(2.0, 2.0),
  ),
  NpcData(
    name: '견희',
    emoji: '🌸',
    role: '디자이너',
    color: const ui.Color(0xFFFF69B4),
    mapPosition: Vector2(13.0, 2.0),
  ),
  NpcData(
    name: '장료',
    emoji: '⚔️',
    role: '개발자',
    color: const ui.Color(0xFF2A4A2A),
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

    // Draw character sprite based on name
    switch (data.name) {
      case '조조':
        _drawJoJo(canvas, cx, cy);
        break;
      case '사마의':
        _drawSiMaYi(canvas, cx, cy);
        break;
      case '견희':
        _drawJianXi(canvas, cx, cy);
        break;
      case '장료':
        _drawZhangLiao(canvas, cx, cy);
        break;
      default:
        _drawDefaultCharacter(canvas, cx, cy);
    }

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

  // 조조 - 황금색 테마, 왕관, 진홍 갑옷, 망토
  void _drawJoJo(ui.Canvas canvas, double cx, double cy) {
    final ts = size.x;
    final scale = ts / 48.0;

    // Legs
    _rect(canvas, cx - 6 * scale, cy + 10 * scale, 10 * scale, 10 * scale,
        const ui.Color(0xFF5A0000));
    _rect(canvas, cx + 2 * scale, cy + 10 * scale, 10 * scale, 10 * scale,
        const ui.Color(0xFF5A0000));

    // Cape (behind body)
    final capePath = ui.Path()
      ..moveTo(cx - 10 * scale, cy - 5 * scale)
      ..lineTo(cx + 10 * scale, cy - 5 * scale)
      ..lineTo(cx + 14 * scale, cy + 18 * scale)
      ..lineTo(cx - 14 * scale, cy + 18 * scale)
      ..close();
    canvas.drawPath(capePath, ui.Paint()..color = const ui.Color(0xFF6B0000));
    // Cape gold trim
    canvas.drawLine(
      ui.Offset(cx - 14 * scale, cy + 18 * scale),
      ui.Offset(cx + 14 * scale, cy + 18 * scale),
      ui.Paint()
        ..color = const ui.Color(0xFFC8960C)
        ..strokeWidth = 1.5 * scale,
    );

    // Body (torso)
    _rect(canvas, cx - 9 * scale, cy - 5 * scale, 18 * scale, 15 * scale,
        const ui.Color(0xFF8B0000));
    // Armor gold chest line
    canvas.drawLine(
      ui.Offset(cx, cy - 5 * scale),
      ui.Offset(cx, cy + 10 * scale),
      ui.Paint()
        ..color = const ui.Color(0xFFC8960C)
        ..strokeWidth = 1.5 * scale,
    );
    canvas.drawLine(
      ui.Offset(cx - 9 * scale, cy + 2 * scale),
      ui.Offset(cx + 9 * scale, cy + 2 * scale),
      ui.Paint()
        ..color = const ui.Color(0xFFC8960C)
        ..strokeWidth = 1.0 * scale,
    );

    // Head
    canvas.drawCircle(ui.Offset(cx, cy - 12 * scale), 9 * scale,
        ui.Paint()..color = const ui.Color(0xFFF5C842));

    // Crown base
    _rect(canvas, cx - 9 * scale, cy - 21 * scale, 18 * scale, 6 * scale,
        const ui.Color(0xFFC8960C));
    // Crown spikes (3)
    for (int i = 0; i < 3; i++) {
      final bx = cx - 7 * scale + i * 7 * scale;
      final path = ui.Path()
        ..moveTo(bx, cy - 21 * scale)
        ..lineTo(bx + 3.5 * scale, cy - 26 * scale)
        ..lineTo(bx + 7 * scale, cy - 21 * scale)
        ..close();
      canvas.drawPath(path, ui.Paint()..color = const ui.Color(0xFFC8960C));
    }
    // Crown jewel (center)
    canvas.drawCircle(
      ui.Offset(cx, cy - 22 * scale),
      2 * scale,
      ui.Paint()..color = const ui.Color(0xFFCC2222),
    );
  }

  // 사마의 - 보라색 테마, 관모, 긴 도포, 두루마리
  void _drawSiMaYi(ui.Canvas canvas, double cx, double cy) {
    final ts = size.x;
    final scale = ts / 48.0;

    // Legs
    _rect(canvas, cx - 6 * scale, cy + 10 * scale, 10 * scale, 10 * scale,
        const ui.Color(0xFF3A1060));
    _rect(canvas, cx + 2 * scale, cy + 10 * scale, 10 * scale, 10 * scale,
        const ui.Color(0xFF3A1060));

    // Body (long robe with wide sleeves)
    _rect(canvas, cx - 10 * scale, cy - 5 * scale, 20 * scale, 15 * scale,
        const ui.Color(0xFF4A2080));
    // Wide sleeves
    _rect(canvas, cx - 18 * scale, cy - 3 * scale, 10 * scale, 8 * scale,
        const ui.Color(0xFF4A2080));
    _rect(canvas, cx + 8 * scale, cy - 3 * scale, 10 * scale, 8 * scale,
        const ui.Color(0xFF4A2080));
    // Robe decoration lines
    canvas.drawLine(
      ui.Offset(cx - 10 * scale, cy - 2 * scale),
      ui.Offset(cx + 10 * scale, cy - 2 * scale),
      ui.Paint()
        ..color = const ui.Color(0xFF8866CC)
        ..strokeWidth = 1.0 * scale,
    );
    canvas.drawLine(
      ui.Offset(cx, cy - 5 * scale),
      ui.Offset(cx, cy + 10 * scale),
      ui.Paint()
        ..color = const ui.Color(0xFF8866CC)
        ..strokeWidth = 1.0 * scale,
    );

    // Scroll in left hand
    _rect(canvas, cx - 22 * scale, cy - 2 * scale, 6 * scale, 10 * scale,
        const ui.Color(0xFFF5E6C8));
    canvas.drawLine(
      ui.Offset(cx - 22 * scale, cy - 2 * scale),
      ui.Offset(cx - 16 * scale, cy - 2 * scale),
      ui.Paint()
        ..color = const ui.Color(0xFF8B6914)
        ..strokeWidth = 1.0 * scale,
    );
    canvas.drawLine(
      ui.Offset(cx - 22 * scale, cy + 8 * scale),
      ui.Offset(cx - 16 * scale, cy + 8 * scale),
      ui.Paint()
        ..color = const ui.Color(0xFF8B6914)
        ..strokeWidth = 1.0 * scale,
    );

    // Head
    canvas.drawCircle(ui.Offset(cx, cy - 12 * scale), 9 * scale,
        ui.Paint()..color = const ui.Color(0xFFF0C8A0));

    // Hat (guan) base
    _rect(canvas, cx - 9 * scale, cy - 22 * scale, 18 * scale, 4 * scale,
        const ui.Color(0xFF4A2080));
    _rect(canvas, cx - 6 * scale, cy - 26 * scale, 12 * scale, 5 * scale,
        const ui.Color(0xFF4A2080));
    // Feather on hat
    canvas.drawLine(
      ui.Offset(cx + 6 * scale, cy - 26 * scale),
      ui.Offset(cx + 12 * scale, cy - 32 * scale),
      ui.Paint()
        ..color = const ui.Color(0xFFE8E8FF)
        ..strokeWidth = 1.5 * scale,
    );
  }

  // 견희 - 분홍/흰색 테마, 꽃 핀, 한복, 붓
  void _drawJianXi(ui.Canvas canvas, double cx, double cy) {
    final ts = size.x;
    final scale = ts / 48.0;

    // Legs
    _rect(canvas, cx - 5 * scale, cy + 10 * scale, 9 * scale, 10 * scale,
        const ui.Color(0xFFE8D8D8));
    _rect(canvas, cx + 2 * scale, cy + 10 * scale, 9 * scale, 10 * scale,
        const ui.Color(0xFFE8D8D8));

    // Body (hanbok)
    _rect(canvas, cx - 9 * scale, cy - 5 * scale, 18 * scale, 15 * scale,
        const ui.Color(0xFFF8F0F0));
    // Pink cuffs
    _rect(canvas, cx - 14 * scale, cy - 3 * scale, 7 * scale, 6 * scale,
        const ui.Color(0xFFFF69B4));
    _rect(canvas, cx + 7 * scale, cy - 3 * scale, 7 * scale, 6 * scale,
        const ui.Color(0xFFFF69B4));
    // Ribbon belt
    _rect(canvas, cx - 9 * scale, cy + 4 * scale, 18 * scale, 4 * scale,
        const ui.Color(0xFFFFB6C1));

    // Brush in right hand
    canvas.drawLine(
      ui.Offset(cx + 14 * scale, cy - 2 * scale),
      ui.Offset(cx + 10 * scale, cy + 8 * scale),
      ui.Paint()
        ..color = const ui.Color(0xFF3A1A1A)
        ..strokeWidth = 2.0 * scale,
    );
    // Brush tip
    canvas.drawCircle(
      ui.Offset(cx + 10 * scale, cy + 8 * scale),
      2 * scale,
      ui.Paint()..color = const ui.Color(0xFFF0F0F0),
    );

    // Head
    canvas.drawCircle(ui.Offset(cx, cy - 12 * scale), 9 * scale,
        ui.Paint()..color = const ui.Color(0xFFF5C0C0));
    // Hair
    _rect(canvas, cx - 9 * scale, cy - 21 * scale, 18 * scale, 10 * scale,
        const ui.Color(0xFF3A1A1A));

    // Flower pin
    for (int i = 0; i < 5; i++) {
      final angle = i * 2 * math.pi / 5;
      canvas.drawCircle(
        ui.Offset(
          cx + 4 * scale + 3 * scale * math.cos(angle),
          cy - 22 * scale + 3 * scale * math.sin(angle),
        ),
        2 * scale,
        ui.Paint()..color = const ui.Color(0xFFFF69B4),
      );
    }
    canvas.drawCircle(
      ui.Offset(cx + 4 * scale, cy - 22 * scale),
      2 * scale,
      ui.Paint()..color = const ui.Color(0xFFFF1493),
    );
  }

  // 장료 - 초록 갑옷 테마, 투구, 칼
  void _drawZhangLiao(ui.Canvas canvas, double cx, double cy) {
    final ts = size.x;
    final scale = ts / 48.0;

    // Legs
    _rect(canvas, cx - 6 * scale, cy + 10 * scale, 10 * scale, 10 * scale,
        const ui.Color(0xFF2A4A2A));
    _rect(canvas, cx + 2 * scale, cy + 10 * scale, 10 * scale, 10 * scale,
        const ui.Color(0xFF2A4A2A));

    // Body armor
    _rect(canvas, cx - 10 * scale, cy - 5 * scale, 20 * scale, 15 * scale,
        const ui.Color(0xFF2A4A2A));
    // Armor plate lines (vertical)
    for (double dx = -6.0; dx <= 6.0; dx += 4) {
      canvas.drawLine(
        ui.Offset(cx + dx * scale, cy - 5 * scale),
        ui.Offset(cx + dx * scale, cy + 10 * scale),
        ui.Paint()
          ..color = const ui.Color(0xFF1A3A1A)
          ..strokeWidth = 1.0 * scale,
      );
    }
    // Shoulder guards
    _rect(canvas, cx - 16 * scale, cy - 5 * scale, 8 * scale, 8 * scale,
        const ui.Color(0xFF3A5A3A));
    _rect(canvas, cx + 8 * scale, cy - 5 * scale, 8 * scale, 8 * scale,
        const ui.Color(0xFF3A5A3A));
    // Belt
    _rect(canvas, cx - 10 * scale, cy + 7 * scale, 20 * scale, 3 * scale,
        const ui.Color(0xFF8B6914));

    // Sword in left hand
    canvas.drawLine(
      ui.Offset(cx - 16 * scale, cy - 3 * scale),
      ui.Offset(cx - 16 * scale, cy + 12 * scale),
      ui.Paint()
        ..color = const ui.Color(0xFFC0C0C0)
        ..strokeWidth = 2.0 * scale,
    );
    // Guard
    canvas.drawLine(
      ui.Offset(cx - 19 * scale, cy + 2 * scale),
      ui.Offset(cx - 13 * scale, cy + 2 * scale),
      ui.Paint()
        ..color = const ui.Color(0xFF8B6914)
        ..strokeWidth = 2.0 * scale,
    );

    // Head (skin)
    canvas.drawCircle(ui.Offset(cx, cy - 12 * scale), 8 * scale,
        ui.Paint()..color = const ui.Color(0xFFE0B890));

    // Helmet
    final helmetPath = ui.Path()
      ..addArc(
        ui.Rect.fromCenter(
            center: ui.Offset(cx, cy - 12 * scale),
            width: 18 * scale,
            height: 18 * scale),
        math.pi,
        math.pi,
      )
      ..lineTo(cx + 9 * scale, cy - 8 * scale)
      ..lineTo(cx - 9 * scale, cy - 8 * scale)
      ..close();
    canvas.drawPath(helmetPath, ui.Paint()..color = const ui.Color(0xFF2A4A2A));
    // Helmet brim
    _rect(canvas, cx - 10 * scale, cy - 8 * scale, 20 * scale, 3 * scale,
        const ui.Color(0xFF1A3A1A));
    // Helmet crest (gold)
    canvas.drawLine(
      ui.Offset(cx, cy - 20 * scale),
      ui.Offset(cx, cy - 14 * scale),
      ui.Paint()
        ..color = const ui.Color(0xFFC8960C)
        ..strokeWidth = 2.0 * scale,
    );
  }

  // Default (player soldier) character
  void _drawDefaultCharacter(ui.Canvas canvas, double cx, double cy) {
    final ts = size.x;
    final scale = ts / 48.0;

    // Legs
    _rect(canvas, cx - 5 * scale, cy + 10 * scale, 9 * scale, 10 * scale,
        const ui.Color(0xFF3A2010));
    _rect(canvas, cx + 2 * scale, cy + 10 * scale, 9 * scale, 10 * scale,
        const ui.Color(0xFF3A2010));

    // Body
    _rect(canvas, cx - 8 * scale, cy - 5 * scale, 16 * scale, 15 * scale,
        const ui.Color(0xFF5A3A1A));

    // Spear
    canvas.drawLine(
      ui.Offset(cx + 14 * scale, cy - 16 * scale),
      ui.Offset(cx + 14 * scale, cy + 14 * scale),
      ui.Paint()
        ..color = const ui.Color(0xFF8B6914)
        ..strokeWidth = 2.0 * scale,
    );
    // Spear tip
    final spearPath = ui.Path()
      ..moveTo(cx + 14 * scale, cy - 16 * scale)
      ..lineTo(cx + 11 * scale, cy - 10 * scale)
      ..lineTo(cx + 17 * scale, cy - 10 * scale)
      ..close();
    canvas.drawPath(
        spearPath, ui.Paint()..color = const ui.Color(0xFFC0C0C0));

    // Head
    canvas.drawCircle(ui.Offset(cx, cy - 12 * scale), 8 * scale,
        ui.Paint()..color = const ui.Color(0xFFE8C890));
    // Red headband
    _rect(canvas, cx - 8 * scale, cy - 14 * scale, 16 * scale, 4 * scale,
        const ui.Color(0xFFAA2222));
  }

  void _rect(ui.Canvas canvas, double x, double y, double w, double h,
      ui.Color color) {
    canvas.drawRect(
      ui.Rect.fromLTWH(x, y, w, h),
      ui.Paint()..color = color,
    );
  }

  @override
  void onTapDown(TapDownEvent event) {
    onTapped(data);
  }
}
