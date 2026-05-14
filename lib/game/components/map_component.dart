import 'dart:ui' as ui;
import 'package:flame/components.dart';

/// 간단한 색상 블록 기반 타일 맵 (16×16 타일)
class MapComponent extends PositionComponent {
  static const int tileSize = 48;
  static const int cols = 16;
  static const int rows = 16;

  static const _tileColors = {
    0: ui.Color(0xFF1A0A0A),
    1: ui.Color(0xFF2D1010),
    2: ui.Color(0xFF3D2010),
    3: ui.Color(0xFF102030),
    4: ui.Color(0xFF201030),
    5: ui.Color(0xFF103020),
    6: ui.Color(0xFFC8960C),
  };

  static const List<List<int>> _mapData = [
    [1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1],
    [1, 3, 3, 3, 1, 0, 0, 0, 0, 0, 0, 1, 4, 4, 4, 1],
    [1, 3, 3, 3, 1, 0, 0, 0, 0, 0, 0, 1, 4, 4, 4, 1],
    [1, 3, 3, 3, 1, 0, 0, 0, 0, 0, 0, 1, 4, 4, 4, 1],
    [1, 1, 1, 1, 1, 0, 6, 0, 0, 6, 0, 1, 1, 1, 1, 1],
    [1, 0, 0, 0, 0, 0, 0, 2, 2, 0, 0, 0, 0, 0, 0, 1],
    [1, 0, 0, 0, 0, 0, 2, 2, 2, 2, 0, 0, 0, 0, 0, 1],
    [1, 0, 0, 0, 0, 6, 2, 2, 2, 2, 6, 0, 0, 0, 0, 1],
    [1, 0, 0, 0, 0, 6, 2, 2, 2, 2, 6, 0, 0, 0, 0, 1],
    [1, 0, 0, 0, 0, 0, 2, 2, 2, 2, 0, 0, 0, 0, 0, 1],
    [1, 0, 0, 0, 0, 0, 0, 2, 2, 0, 0, 0, 0, 0, 0, 1],
    [1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1],
    [1, 5, 5, 5, 5, 5, 0, 0, 0, 0, 5, 5, 5, 5, 5, 1],
    [1, 5, 5, 5, 5, 5, 0, 0, 0, 0, 5, 5, 5, 5, 5, 1],
    [1, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 1],
    [1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1],
  ];

  static Vector2 get mapPixelSize =>
      Vector2(cols * tileSize.toDouble(), rows * tileSize.toDouble());

  @override
  Future<void> onLoad() async {
    size = mapPixelSize;
  }

  @override
  void render(ui.Canvas canvas) {
    for (int row = 0; row < rows; row++) {
      for (int col = 0; col < cols; col++) {
        final tileType = _mapData[row][col];
        final color = _tileColors[tileType] ?? const ui.Color(0xFF1A0A0A);
        final rect = ui.Rect.fromLTWH(
          col * tileSize.toDouble(),
          row * tileSize.toDouble(),
          tileSize.toDouble(),
          tileSize.toDouble(),
        );
        canvas.drawRect(rect, ui.Paint()..color = color);
        canvas.drawRect(
          rect,
          ui.Paint()
            ..color = const ui.Color(0xFF2A1A0A).withValues(alpha: 0.4)
            ..style = ui.PaintingStyle.stroke
            ..strokeWidth = 0.5,
        );
      }
    }
    _drawRoomLabel(canvas, '왕좌실', 7.5, 7.5);
    _drawRoomLabel(canvas, '전략실', 2.0, 2.0);
    _drawRoomLabel(canvas, '창작실', 13.0, 2.0);
    _drawRoomLabel(canvas, '훈련장', 7.5, 13.5);
  }

  void _drawRoomLabel(
      ui.Canvas canvas, String text, double colCenter, double rowCenter) {
    final pb = ui.ParagraphBuilder(ui.ParagraphStyle(fontSize: 10))
      ..pushStyle(ui.TextStyle(
        color: const ui.Color(0xFFC8960C),
        fontSize: 10,
        fontWeight: ui.FontWeight.bold,
      ))
      ..addText(text);
    final paragraph = pb.build();
    paragraph.layout(const ui.ParagraphConstraints(width: 80));
    canvas.drawParagraph(
      paragraph,
      ui.Offset(
        colCenter * tileSize - paragraph.longestLine / 2,
        rowCenter * tileSize - paragraph.height / 2,
      ),
    );
  }

  /// 타일이 벽인지 확인
  static bool isWall(double x, double y) {
    final col = (x / tileSize).floor();
    final row = (y / tileSize).floor();
    if (row < 0 || row >= rows || col < 0 || col >= cols) return true;
    return _mapData[row][col] == 1;
  }
}
