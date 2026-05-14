import 'dart:ui' as ui;
import 'package:flame/components.dart';
import 'map_component.dart';

class PlayerComponent extends PositionComponent {
  Vector2 _target;
  static const double _speed = 160.0; // px/sec
  bool _moving = false;

  PlayerComponent({required Vector2 startPosition})
      : _target = startPosition.clone(),
        super(
          size: Vector2(MapComponent.tileSize.toDouble(),
              MapComponent.tileSize.toDouble()),
          anchor: Anchor.center,
          position: startPosition,
        );

  void moveTo(Vector2 target) {
    if (!MapComponent.isWall(target.x, target.y)) {
      _target = target.clone();
      _moving = true;
    }
  }

  @override
  void update(double dt) {
    if (!_moving) return;
    final diff = _target - position;
    final dist = diff.length;
    if (dist < 2) {
      position = _target.clone();
      _moving = false;
      return;
    }
    final step = _speed * dt;
    if (step >= dist) {
      position = _target.clone();
      _moving = false;
    } else {
      position += diff.normalized() * step;
    }
  }

  @override
  void render(ui.Canvas canvas) {
    final cx = size.x / 2;
    final cy = size.y / 2;
    final r = size.x * 0.38;

    final path = ui.Path()
      ..moveTo(cx, cy - r)
      ..lineTo(cx + r, cy)
      ..lineTo(cx, cy + r)
      ..lineTo(cx - r, cy)
      ..close();

    canvas.drawPath(
      path,
      ui.Paint()..color = const ui.Color(0xFFF2D060).withValues(alpha: 0.9),
    );
    canvas.drawPath(
      path,
      ui.Paint()
        ..color = const ui.Color(0xFFC8960C)
        ..style = ui.PaintingStyle.stroke
        ..strokeWidth = 2,
    );

    // 이모지
    final pb = ui.ParagraphBuilder(
      ui.ParagraphStyle(fontSize: 18),
    )..addText('🧑');
    final paragraph = pb.build();
    paragraph.layout(const ui.ParagraphConstraints(width: 30));
    canvas.drawParagraph(
      paragraph,
      ui.Offset(cx - paragraph.longestLine / 2, cy - paragraph.height / 2),
    );

    if (_moving) {
      canvas.drawCircle(
        ui.Offset(cx, cy),
        r + 4,
        ui.Paint()
          ..color = const ui.Color(0xFFC8960C).withValues(alpha: 0.3)
          ..style = ui.PaintingStyle.stroke
          ..strokeWidth = 1.5,
      );
    }
  }
}
