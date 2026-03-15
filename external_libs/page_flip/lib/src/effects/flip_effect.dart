import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/material.dart';

class PageFlipEffect extends CustomPainter {
  const PageFlipEffect({
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
    final double pos = isRightSwipe ? 1.0 - amount.value : amount.value;
    final double movX = isRightSwipe ? pos : (1.0 - pos) * 0.85;
    final double calcR = (movX < 0.20) ? radius * movX * 5 : radius;
    final double wHRatio = 1 - calcR;

    final double w = size.width;
    final double h = size.height;

    // Draw solid background underneath the page animation
    if (backgroundColor != null) {
      final double shadowXf = wHRatio - movX;
      final Rect pageRect = isRightSwipe 
          ? Rect.fromLTRB(w, 0.0, w * movX, h) 
          : Rect.fromLTRB(0.0, 0.0, w * shadowXf, h);
      canvas.drawRect(pageRect, Paint()..color = backgroundColor!);
    }

    // Image scaling logic (similar to original BoxFit.cover logic)
    final double imgW = image.width.toDouble();
    final double imgH = image.height.toDouble();
    final double screenRatio = w / h;
    final double imgRatio = imgW / imgH;

    double srcX = 0, srcY = 0, srcW = imgW, srcH = imgH;
    if (imgRatio > screenRatio) {
      srcW = imgH * screenRatio;
      srcX = (imgW - srcW) / 2;
    } else {
      srcH = imgW / screenRatio;
      srcY = (imgH - srcH) / 2;
    }

    final Paint ip = Paint()
      ..isAntiAlias = true
      ..filterQuality = FilterQuality.low; // Performance boost
    
    // Performance fix! 
    // Reduced from per-pixel slicing (1080+ loops) to fixed 64 hardware-accelerated texture slices.
    // 64 is more than enough for a smooth curve effect on mobile screens.
    const int numSlices = 64; 
    final double sliceWidth = w / numSlices;
    final double srcSliceWidth = srcW / numSlices;

    for (int i = 0; i < numSlices; i++) {
      final double x = i * sliceWidth;
      final double xf = x / w;
      
      final double baseValue = isRightSwipe 
          ? math.cos(math.pi / 0.5 * (xf + pos)) 
          : math.sin(math.pi / 0.5 * (xf - (1.0 - pos)));
      
      final double v = calcR * (baseValue + 1.1);
      final double xv = isRightSwipe 
          ? (xf * wHRatio) + movX 
          : (xf * wHRatio) - movX;
      
      final double sx = srcX + (xf * srcW);
      final Rect sr = Rect.fromLTWH(sx, srcY, srcSliceWidth, srcH);
      
      final double yv = (h * calcR * movX) / 2.0;
      final double ds = yv * v;
      
      // +1.2 prevents visual seams between slices
      final Rect dr = Rect.fromLTRB(
        xv * w, 
        -ds, 
        (xv * w) + (sliceWidth * wHRatio) + 1.2, 
        h + ds
      );
      
      canvas.drawImageRect(image, sr, dr, ip);
    }
  }

  @override
  bool shouldRepaint(covariant PageFlipEffect oldDelegate) => 
      oldDelegate.image != image || oldDelegate.amount.value != amount.value;
}
