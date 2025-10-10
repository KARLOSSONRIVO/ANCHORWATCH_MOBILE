import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:crypto/crypto.dart';

/// Deterministic color mapping for tag strings.
/// Uses a small palette and a stable hash to pick a color per tag.
class TagColors {
  // Modern, vibrant palette (good contrast and variety)
  static const List<Color> _palette = [
    Color(0xFF0066FF), // Vivid Blue
    Color(0xFFFF6B6B), // Coral Red
    Color(0xFFFFB800), // Amber
    Color(0xFF6C5CE7), // Purple
    Color(0xFF00C2A8), // Teal
    Color(0xFFFF5DA2), // Pink
    Color(0xFF00A3FF), // Sky Blue
    Color(0xFF7ED321), // Lime Green
    Color(0xFFFA8231), // Orange
    Color(0xFF9B59B6), // Deep Violet
    Color(0xFF2ECC71), // Emerald
    Color(0xFFF39C12), // Bright Orange
  ];

  /// Returns a stable background color for a given tag string.
  /// Uses FNV-1a 32-bit hash for more even distribution.
  static Color getTagColor(String tag) {
    if (tag.isEmpty) return _palette.first;
    final normalized = tag.trim().toLowerCase();
    // Check overrides first
    if (_overrides.containsKey(normalized)) return _overrides[normalized]!;

    final digest = md5.convert(utf8.encode(normalized)).bytes;

    // Convert first 8 bytes of digest to a 64-bit integer
    int hashInt = 0;
    for (var i = 0; i < 8 && i < digest.length; i++) {
      hashInt = (hashInt << 8) | (digest[i] & 0xFF);
    }

    // Scramble using BigInt to avoid overflow and distribute indices
    final BigInt biHash = BigInt.from(hashInt);
    final BigInt biMult = BigInt.parse('11400714819323198485');
    final BigInt scrambled = (biHash * biMult).abs();

    // Build a larger, well-spaced palette on demand
    final palette = _buildSpacedPalette();
    final idx = (scrambled % BigInt.from(palette.length)).toInt();
    return palette[idx];
  }

  static List<Color> _buildSpacedPalette() {
    // Create a larger palette (48 entries) with well-spaced hues but
    // muted saturation and balanced lightness for a modern, professional look.
    const int n = 48;
    final List<Color> p = List<Color>.generate(n, (i) {
      final hue = (i * (360 / n)) % 360;
      // Softer saturation and slightly brighter lightness for eye-pleasing tones
      final sat = 0.28 + ((i % 6) / 6.0) * 0.12; // 0.28 - 0.40
      final light = 0.50 + ((i % 4) / 4.0) * 0.14; // 0.50 - 0.64
      return HSLColor.fromAHSL(1.0, hue.toDouble(), sat.clamp(0.25, 0.50), light.clamp(0.48, 0.72)).toColor();
    });

    return p;
  }

  // Optional manual overrides for specific important tags to ensure
  // branding-consistent, professional colors. Lowercase keys.
  static const Map<String, Color> _overrides = {
    'adoption': Color(0xFF6EA8FF), // soft blue
    'regulation': Color(0xFF7E7E86), // soft neutral
    'security': Color(0xFFD17A7A), // soft red
    'policy': Color(0xFF9C8FCF), // soft violet
    'research': Color(0xFF6FD0CC), // soft teal
    'defi': Color(0xFF00C2A8), // teal for DeFi
    'stablecoins': Color(0xFF0066FF), // vivid blue
    'markets': Color(0xFFFF6B6B), // coral red
    'analysis': Color(0xFF6C5CE7), // purple
    'bitcoin': Color(0xFFFFB800), // amber/orange
    'ethereum': Color(0xFF7ED321), // lime green
    'crypto': Color(0xFF9B59B6), // deep violet
    'blockchain': Color(0xFF2ECC71), // emerald
    'trading': Color(0xFFFA8231), // orange
    'investment': Color(0xFFFF5DA2), // pink
  };

  /// Returns a readable text color (either white or black) for the
  /// provided background color based on luminance.
  static Color getTextColorForBg(Color bg) {
    // Softer palette means slightly different contrast threshold
    final luminance = bg.computeLuminance();
    return luminance > 0.6 ? Colors.black : Colors.white;
  }
}