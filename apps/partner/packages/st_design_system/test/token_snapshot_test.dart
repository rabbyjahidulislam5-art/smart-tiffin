import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:st_design_system/st_design_system.dart';

// Snapshot of the token values (requirements 4.2, 4.3). Any change fails.
void main() {
  test('role accents', () {
    expect(StColors.customer, const Color(0xFFF97015));
    expect(StColors.supplier, const Color(0xFF21976B));
    expect(StColors.rider, const Color(0xFF2463EB));
    expect(StColors.admin, const Color(0xFF5048E5));
    expect(StColors.accounting, const Color(0xFF2B5A6B));
    expect(StColors.roleOf('accounting'), StColors.accounting);
    expect(StColors.roleOf('unknown'), StColors.customer);
  });

  test('status and neutral colours', () {
    expect(StColors.success, const Color(0xFF08744F));
    expect(StColors.warning, const Color(0xFF854A0E));
    expect(StColors.danger, const Color(0xFFB42318));
    expect(StColors.info, const Color(0xFF0369A1));
    expect(StColors.background, const Color(0xFFFBF9F7));
    expect(StColors.muted, const Color(0xFFF1EDEA));
    expect(StColors.mutedForeground, const Color(0xFF52616D));
    expect(StColors.darkMuted, const Color(0xFF2D2825));
    expect(StColors.darkMutedForeground, const Color(0xFFADA69F));
    expect(StColors.onAccent, const Color(0xFFFFFFFF));
  });

  test('motion durations and curves (balanced personality)', () {
    AppMotion.personality = MotionPersonality.balanced;
    expect(AppMotion.sm, const Duration(milliseconds: 150));
    expect(AppMotion.md, const Duration(milliseconds: 240));
    expect(AppMotion.lg, const Duration(milliseconds: 420));
    expect(AppMotion.xl, const Duration(milliseconds: 700));
    expect(AppMotion.enter, Curves.easeOutCubic);
    expect(AppMotion.exitCurve, Curves.easeInCubic);
    expect(AppMotion.standard, Curves.easeInOutCubic);
  });

  test('B2 tokens', () {
    expect([StSpace.xxs, StSpace.xs, StSpace.sm, StSpace.md, StSpace.lg, StSpace.xl, StSpace.xxl], [4, 8, 12, 16, 24, 32, 48]);
    expect([StRadius.sm, StRadius.field, StRadius.tile, StRadius.card, StRadius.sheet, StRadius.pill], [12, 16, 22, 24, 28, 99]);
    expect(StTiming.confirmationHold, const Duration(seconds: 4));
  });
}
