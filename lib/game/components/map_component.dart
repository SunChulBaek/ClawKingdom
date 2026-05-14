import 'dart:math' as math;
import 'dart:ui' as ui;
import 'package:flame/components.dart';

/// 간단한 색상 블록 기반 타일 맵 (16×16 타일)
class MapComponent extends PositionComponent {
  static const int tileSize = 48;
  static const int cols = 16;
  static const int rows = 16;

  // Room floor colors
  static const _throneFloor = ui.Color(0xFF2A1500);
  static const _throneAccent = ui.Color(0xFFC8960C);
  static const _throneThrone = ui.Color(0xFF8B0000);
  static const _strategyFloor = ui.Color(0xFF0A1020);
  static const _strategyAccent = ui.Color(0xFF1A3A6A);
  static const _strategyMap = ui.Color(0xFF2244AA);
  static const _artFloor = ui.Color(0xFF1A0A1A);
  static const _artAccent = ui.Color(0xFF6A1A6A);
  static const _artPaint = ui.Color(0xFFAA44AA);
  static const _trainingFloor = ui.Color(0xFF0A1A0A);
  static const _trainingAccent = ui.Color(0xFF1A4A1A);
  static const _trainingSand = ui.Color(0xFF2A6A2A);
  static const _corridorFloor = ui.Color(0xFF1A0A0A);
  static const _wallColor = ui.Color(0xFF0A0505);
  static const _imperialGold = ui.Color(0xFFC8960C);

  // Tile types:
  // 0 = corridor, 1 = wall, 2 = throne floor, 3 = strategy floor, 4 = art floor, 5 = training floor, 6 = gold pillar
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

  ui.Color _tileColor(int type, int row, int col) {
    // Checkerboard subtle variation
    final checker = (row + col) % 2 == 0;
    switch (type) {
      case 1:
        return _wallColor;
      case 2:
        return checker
            ? _throneFloor.withValues(alpha: 1.0)
            : const ui.Color(0xFF200F00);
      case 3:
        return checker
            ? _strategyFloor.withValues(alpha: 1.0)
            : const ui.Color(0xFF060A14);
      case 4:
        return checker
            ? _artFloor.withValues(alpha: 1.0)
            : const ui.Color(0xFF120614);
      case 5:
        return checker
            ? _trainingFloor.withValues(alpha: 1.0)
            : const ui.Color(0xFF061006);
      case 6:
        return _imperialGold;
      case 0:
      default:
        return checker
            ? _corridorFloor
            : const ui.Color(0xFF140808);
    }
  }

  bool _isAdjacentToWall(int row, int col) {
    for (final dr in [-1, 0, 1]) {
      for (final dc in [-1, 0, 1]) {
        if (dr == 0 && dc == 0) continue;
        final nr = row + dr;
        final nc = col + dc;
        if (nr >= 0 && nr < rows && nc >= 0 && nc < cols) {
          if (_mapData[nr][nc] == 1) return true;
        }
      }
    }
    return false;
  }

  @override
  void render(ui.Canvas canvas) {
    final ts = tileSize.toDouble();

    // Draw base tiles
    for (int row = 0; row < rows; row++) {
      for (int col = 0; col < cols; col++) {
        final tileType = _mapData[row][col];
        final color = _tileColor(tileType, row, col);
        final rect = ui.Rect.fromLTWH(col * ts, row * ts, ts, ts);
        canvas.drawRect(rect, ui.Paint()..color = color);

        // Wall shadow overlay on floor tiles adjacent to walls
        if (tileType != 1 && _isAdjacentToWall(row, col)) {
          canvas.drawRect(
            rect,
            ui.Paint()..color = const ui.Color(0x33000000),
          );
        }

        // Subtle tile border
        canvas.drawRect(
          rect,
          ui.Paint()
            ..color = const ui.Color(0x1AC8960C)
            ..style = ui.PaintingStyle.stroke
            ..strokeWidth = 0.5,
        );
      }
    }

    // Draw room borders (Imperial Gold outline around each room)
    _drawRoomBorder(canvas, 1, 1, 4, 4, _strategyAccent); // strategy top-left
    _drawRoomBorder(canvas, 1, 12, 4, 15, _artAccent);    // art top-right
    _drawRoomBorder(canvas, 5, 5, 10, 10, _throneAccent); // throne center
    _drawRoomBorder(canvas, 12, 1, 14, 14, _trainingAccent); // training bottom

    // Decorative center tiles for each room
    _drawThroneSymbol(canvas, 7.5, 7.5);
    _drawBaguaSymbol(canvas, 2.0, 2.0);
    _drawBrushSymbol(canvas, 13.0, 2.0);
    _drawSwordSymbol(canvas, 7.5, 13.5);

    // Room labels
    _drawRoomLabel(canvas, '왕좌실', 7.5, 5.5);
    _drawRoomLabel(canvas, '전략실', 2.0, 1.3);
    _drawRoomLabel(canvas, '창작실', 13.0, 1.3);
    _drawRoomLabel(canvas, '훈련장', 7.5, 12.2);
  }

  void _drawRoomBorder(ui.Canvas canvas, int r1, int c1, int r2, int c2,
      ui.Color color) {
    final ts = tileSize.toDouble();
    final rect = ui.Rect.fromLTWH(
      c1 * ts,
      r1 * ts,
      (c2 - c1) * ts,
      (r2 - r1) * ts,
    );
    canvas.drawRect(
      rect,
      ui.Paint()
        ..color = color
        ..style = ui.PaintingStyle.stroke
        ..strokeWidth = 1.5,
    );
  }

  void _drawThroneSymbol(ui.Canvas canvas, double colCenter, double rowCenter) {
    final cx = colCenter * tileSize;
    final cy = rowCenter * tileSize;
    final paint = ui.Paint()
      ..color = _throneThrone.withValues(alpha: 0.6)
      ..style = ui.PaintingStyle.fill;
    // Throne back
    canvas.drawRect(ui.Rect.fromCenter(center: ui.Offset(cx, cy - 8), width: 24, height: 28), paint);
    // Throne seat
    canvas.drawRect(
      ui.Rect.fromCenter(center: ui.Offset(cx, cy + 8), width: 28, height: 10),
      ui.Paint()..color = _throneAccent.withValues(alpha: 0.5),
    );
  }

  void _drawBaguaSymbol(ui.Canvas canvas, double colCenter, double rowCenter) {
    final cx = colCenter * tileSize;
    final cy = rowCenter * tileSize;
    final paint = ui.Paint()
      ..color = _strategyMap.withValues(alpha: 0.5)
      ..style = ui.PaintingStyle.stroke
      ..strokeWidth = 1.5;
    canvas.drawCircle(ui.Offset(cx, cy), 12, paint);
    for (int i = 0; i < 8; i++) {
      final angle = i * math.pi / 4;
      canvas.drawLine(
        ui.Offset(cx + 6 * math.cos(angle), cy + 6 * math.sin(angle)),
        ui.Offset(cx + 12 * math.cos(angle), cy + 12 * math.sin(angle)),
        paint,
      );
    }
  }

  void _drawBrushSymbol(ui.Canvas canvas, double colCenter, double rowCenter) {
    final cx = colCenter * tileSize;
    final cy = rowCenter * tileSize;
    final handlePaint = ui.Paint()
      ..color = _artPaint.withValues(alpha: 0.6)
      ..strokeWidth = 3
      ..style = ui.PaintingStyle.stroke;
    canvas.drawLine(ui.Offset(cx - 8, cy - 12), ui.Offset(cx + 8, cy + 12), handlePaint);
    final tipPaint = ui.Paint()
      ..color = const ui.Color(0xFFF0F0F0).withValues(alpha: 0.7)
      ..style = ui.PaintingStyle.fill;
    final path = ui.Path()
      ..moveTo(cx + 8, cy + 12)
      ..lineTo(cx + 4, cy + 16)
      ..lineTo(cx + 12, cy + 14)
      ..close();
    canvas.drawPath(path, tipPaint);
  }

  void _drawSwordSymbol(ui.Canvas canvas, double colCenter, double rowCenter) {
    final cx = colCenter * tileSize;
    final cy = rowCenter * tileSize;
    final bladePaint = ui.Paint()
      ..color = const ui.Color(0xFFC0C0C0).withValues(alpha: 0.6)
      ..strokeWidth = 2
      ..style = ui.PaintingStyle.stroke;
    canvas.drawLine(ui.Offset(cx, cy - 16), ui.Offset(cx, cy + 10), bladePaint);
    final guardPaint = ui.Paint()
      ..color = _imperialGold.withValues(alpha: 0.6)
      ..strokeWidth = 2
      ..style = ui.PaintingStyle.stroke;
    canvas.drawLine(ui.Offset(cx - 10, cy + 4), ui.Offset(cx + 10, cy + 4), guardPaint);
  }

  void _drawRoomLabel(
      ui.Canvas canvas, String text, double colCenter, double rowCenter) {
    final pb = ui.ParagraphBuilder(ui.ParagraphStyle(fontSize: 10))
      ..pushStyle(ui.TextStyle(
        color: _imperialGold,
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
