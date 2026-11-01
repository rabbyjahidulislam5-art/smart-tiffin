import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:st_design_system/st_design_system.dart';
import 'package:st_domain/st_domain.dart';
import 'package:st_shell/st_shell.dart';

class RiderNavScreen extends ConsumerWidget {
  const RiderNavScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ctrl = ref.read(appProvider.notifier);
    final t = ref.watch(appProvider).t;
    final role = context.roleColor;
    return Theme(
      data: Theme.of(context).copyWith(extensions: [const StRoleTheme(role: StColors.rider)]),
      child: StScreen(
        title: t('Turn-by-Turn', 'টার্ন-বাই-টার্ন'),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AppReveal(
              index: 0,
              child: StCard(
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.asset(
                        meals[1].img,
                        width: 48,
                        height: 48,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(width: 48, height: 48, color: StColors.muted),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('#TK-911 · Tanvir Ahmed', style: TextStyle(fontWeight: FontWeight.w800)),
                          Text(t('House 12, Road 4 · Dhanmondi', 'বাড়ি ১২, রোড ৪ · ধানমন্ডি'), style: TextStyle(fontSize: 12, color: Theme.of(context).hintColor)),
                        ],
                      ),
                    ),
                    StChip(tone: StTone.info, child: Text(t('En route', 'পথে'))),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            AppReveal(
              index: 1,
              child: Container(
                height: 360,
                decoration: BoxDecoration(
                  color: Theme.of(context).brightness == Brightness.dark ? StColors.darkMuted : StColors.muted,
                  borderRadius: BorderRadius.circular(24),
                ),
                clipBehavior: Clip.antiAlias,
                child: Stack(
                  children: [
                    CustomPaint(size: Size.infinite, painter: _NavPainter(role)),
                    Align(
                      child: Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(color: role, shape: BoxShape.circle),
                        child: const Icon(Icons.navigation, color: Colors.white),
                      ),
                    ),
                    Positioned(
                      top: 16,
                      left: 16,
                      right: 16,
                      child: StCard(
                        child: Row(
                          children: [
                            Icon(Icons.turn_right, color: role, size: 28),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(t('Turn right onto Road 11', 'রোড ১১ এ ডানদিকে'), style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16)),
                                  Text('450 m · then destination on left', style: TextStyle(fontSize: 12, color: Theme.of(context).hintColor)),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 16,
                      left: 16,
                      right: 16,
                      child: StCard(
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('2.4 km', style: TextStyle(fontWeight: FontWeight.w800, color: role)),
                                Text('~11 min', style: TextStyle(fontWeight: FontWeight.w800, color: role)),
                              ],
                            ),
                            const SizedBox(height: 8),
                            StBtn(label: t('I have arrived', 'আমি পৌঁছেছি'), full: true, onTap: () => ctrl.go('R-03')),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            AppReveal(
              index: 2,
              child: StBtn(
                label: t('Open in Google Maps', 'গুগল ম্যাপে খুলুন'),
                full: true,
                variant: StBtnVariant.outline,
                icon: Icons.map_outlined,
                onTap: () => ctrl.toast(t('Opening Maps…', 'ম্যাপ খুলছে…')),
              ),
            ),
            const SizedBox(height: 8),
            AppReveal(
              index: 3,
              child: StBtn(
                label: t('Call customer', 'গ্রাহককে কল'),
                full: true,
                variant: StBtnVariant.soft,
                icon: Icons.phone,
                onTap: () => ctrl.showConfirm(
                  ConfirmOpts(
                    title: t('Call Tanvir?', 'তানভিরকে কল?'),
                    body: '+880 17•• (demo)',
                    ok: t('Call', 'কল'),
                    onOk: () => ctrl.toast(t('Calling…', 'কল হচ্ছে…')),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NavPainter extends CustomPainter {
  _NavPainter(this.color);
  final Color color;
  @override
  void paint(Canvas canvas, Size size) {
    final grid = Paint()
      ..color = color.withValues(alpha: 0.08)
      ..strokeWidth = 1;
    for (var i = 0; i < 10; i++) {
      canvas.drawLine(Offset(0, size.height * i / 10), Offset(size.width, size.height * i / 10), grid);
      canvas.drawLine(Offset(size.width * i / 10, 0), Offset(size.width * i / 10, size.height), grid);
    }
    final p = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round;
    final path = Path()
      ..moveTo(size.width * 0.2, size.height * 0.8)
      ..lineTo(size.width * 0.2, size.height * 0.5)
      ..lineTo(size.width * 0.7, size.height * 0.5)
      ..lineTo(size.width * 0.7, size.height * 0.25);
    canvas.drawPath(path, p);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
