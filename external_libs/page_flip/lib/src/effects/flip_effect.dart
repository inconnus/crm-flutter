import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/material.dart';

class PageFlipEffect extends CustomPainter {
  PageFlipEffect({
    required this.amount,
    required this.image,
    this.backgroundColor,
    this.radius = 0.18,
    required this.isRightSwipe,
  }) : super(repaint: amount);

  final Animation<double> amount;
  final ui.Image image;
  final Color? backgroundColor;
  final double radius;
  final bool isRightSwipe;

  @override
  void paint(ui.Canvas canvas, ui.Size size) {
    final pos = isRightSwipe ? 1.0 - amount.value : amount.value;
    final movX = isRightSwipe ? pos : (1.0 - pos) * 0.85;
    final calcR = (movX < 0.20) ? radius * movX * 5 : radius;
    final wHRatio = 1 - calcR;

    final w = size.width.toDouble();
    final h = size.height.toDouble();
    final c = canvas;



    final double imgW = image.width.toDouble();
    final double imgH = image.height.toDouble();

    final double screenRatio = w / h;
    final double imgRatio = imgW / imgH;

    double srcX = 0;
    double srcY = 0;
    double srcW = imgW;
    double srcH = imgH;

    if (imgRatio > screenRatio) {
      srcW = imgH * screenRatio;
      srcX = (imgW - srcW) / 2;
    } else {
      srcH = imgW / screenRatio;
      srcY = (imgH - srcH) / 2;
    }
    final shadowXf = (wHRatio - movX);
    final pageRect = isRightSwipe ? Rect.fromLTRB(w, 0.0, w * movX, h) : Rect.fromLTRB(0.0, 0.0, w * shadowXf, h);
    if (backgroundColor != null) {
      c.drawRect(pageRect, Paint()..color = backgroundColor!);
    }

    final ip = Paint();
    for (double x = 0; x < size.width; x++) {
      final xf = (x / w);
      final baseValue = isRightSwipe ? math.cos(math.pi / 0.5 * (xf + pos)) : math.sin(math.pi / 0.5 * (xf - (1.0 - pos)));
      final v = calcR * (baseValue + 1.1);
      final xv = isRightSwipe ? (xf * wHRatio) + movX : (xf * wHRatio) - movX;
      final sx = srcX + (xf * srcW);
      final scw = srcW / w;
      final sr = Rect.fromLTRB(sx, srcY, sx + scw, srcY + srcH);
      final yv = (h * calcR * movX) / 2.0;
      final ds = (yv * v);
      final dr = Rect.fromLTRB(xv * w, 0.0 - ds, (xv * w) + 1.1, h + ds);
      c.drawImageRect(image, sr, dr, ip);
    }
  }

  @override
  bool shouldRepaint(PageFlipEffect oldDelegate) {
    return oldDelegate.image != image || oldDelegate.amount.value != amount.value;
  }
}
