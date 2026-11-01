import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:st_design_system/st_design_system.dart';
import 'package:st_shell/st_shell.dart';

class RiderHomeScreen extends ConsumerWidget {
  const RiderHomeScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = ref.watch(appProvider);
    final ctrl = ref.read(appProvider.notifier);
    final t = s.t;
    final role = context.roleColor;
    final steps = [
      (
        label: t('Assigned', 'নির্ধারিত'),
        sub: null as String?,
        icon: Icons.check_circle_outline
      ),
      (
        label: t('Picked up', 'নেওয়া'),
        sub: null as String?,
        icon: Icons.inventory_2_outlined
      ),
      (
        label: t('On route', 'পথে'),
        sub: null as String?,
        icon: Icons.navigation_outlined
      ),
      (
        label: t('Delivered', 'পৌঁছানো'),
        sub: null as String?,
        icon: Icons.check_circle_outline
      ),
    ];
    void duty(bool v) {
      if (v) {
        ctrl.patchStore((st) => st.copyWith(onDuty: true));
      } else {
        ctrl.showConfirm(ConfirmOpts(
          title: t('Go off duty?', 'অফ ডিউটি?'),
          body: t('Finish or hand back active deliveries first.',
              'আগে চলমান ডেলিভারি শেষ করুন।'),
          ok: t('Go off duty', 'অফ ডিউটি'),
          danger: true,
          onOk: () => ctrl.patchStore((st) => st.copyWith(onDuty: false)),
        ));
      }
    }

    return Theme(
      data: Theme.of(context)
          .copyWith(extensions: [const StRoleTheme(role: StColors.rider)]),
      child: StScreen(
        title: t('Active Deliveries', 'চলমান ডেলিভারি'),
        eyebrow: 'Smart Tiffin Dispatch',
        back: false,
        actions: [
          TextButton(
            onPressed: () => ctrl.go('R-05'),
            style: TextButton.styleFrom(
                backgroundColor: StColors.danger,
                foregroundColor: Colors.white,
                shape: const StadiumBorder(),
                padding: const EdgeInsets.symmetric(horizontal: 12)),
            child: const Text('SOS',
                style: TextStyle(fontWeight: FontWeight.w800, fontSize: 12)),
          ),
          const SizedBox(width: 8),
          StIconBtn(
              icon: Icons.notifications_none,
              label: 'Notifications',
              onTap: () => ctrl.go('SH-01')),
        ],
        child:
            Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          AppReveal(
            index: 0,
            child: StCard(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                  Wrap(
                    alignment: WrapAlignment.spaceBetween,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: s.store.onDuty
                              ? StColors.success.withValues(alpha: 0.15)
                              : (Theme.of(context).brightness == Brightness.dark
                                  ? StColors.darkMuted
                                  : StColors.muted),
                          borderRadius: BorderRadius.circular(99),
                        ),
                        child: Row(mainAxisSize: MainAxisSize.min, children: [
                          Container(
                              width: 8,
                              height: 8,
                              decoration: BoxDecoration(
                                  color: s.store.onDuty
                                      ? StColors.success
                                      : Theme.of(context).hintColor,
                                  shape: BoxShape.circle)),
                          const SizedBox(width: 6),
                          Text(
                              s.store.onDuty
                                  ? t('ON DUTY · ACCEPTING', 'ডিউটিতে')
                                  : t('OFF DUTY', 'অফ ডিউটি'),
                              style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w800,
                                  color: s.store.onDuty
                                      ? StColors.success
                                      : Theme.of(context).hintColor)),
                        ]),
                      ),
                      StToggle(
                          value: s.store.onDuty,
                          onChanged: duty,
                          label: 'Duty'),
                    ],
                  ),
                  const SizedBox(height: 12),
                  InkWell(
                    onTap: () => ctrl.go('R-09'),
                    child: Wrap(
                      alignment: WrapAlignment.spaceBetween,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      spacing: 12,
                      runSpacing: 8,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const StAvatar(name: 'Rokon Talukder'),
                            const SizedBox(width: 12),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Wrap(
                                  spacing: 6,
                                  crossAxisAlignment: WrapCrossAlignment.center,
                                  children: [
                                    const Text(
                                      'Rokon Talukder',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w700),
                                    ),
                                    StChip(
                                      tone: StTone.warning,
                                      child: const Text('4.9 ★'),
                                    ),
                                  ],
                                ),
                                Text(
                                  'DHAKA-METRO-HA-1234',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Theme.of(context).hintColor,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        InkWell(
                          onTap: () => ctrl.go('R-08'),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                t("TODAY'S EARNINGS", 'আজকের আয়'),
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w700,
                                  color: Theme.of(context).hintColor,
                                ),
                              ),
                              Text(
                                '৳650',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w800,
                                  color: role,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(children: [
                    Expanded(
                        child: InkWell(
                            onTap: () => ctrl.go('R-07'),
                            child: Container(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8),
                                decoration: BoxDecoration(
                                    color: role.withValues(alpha: 0.05),
                                    borderRadius: BorderRadius.circular(16)),
                                child: Text('✓ 12 ${t('Completed', 'সম্পন্ন')}',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w700,
                                        color: role))))),
                    const SizedBox(width: 8),
                    Expanded(
                        child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            decoration: BoxDecoration(
                                color: role.withValues(alpha: 0.05),
                                borderRadius: BorderRadius.circular(16)),
                            child: Text('2 ${t('In progress', 'চলমান')}',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
                                    color: role)))),
                  ]),
                  const SizedBox(height: 8),
                  Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    spacing: 4,
                    runSpacing: 4,
                    children: [
                      Icon(Icons.battery_full,
                          size: 14, color: Theme.of(context).hintColor),
                      Text(' 84%  ',
                          style: TextStyle(
                              fontSize: 11,
                              color: Theme.of(context).hintColor)),
                      InkWell(
                          onTap: () => ctrl
                              .patchStore((st) => st.copyWith(gps: !st.gps)),
                          child: Text(
                              '${s.store.gps ? 'GPS OK' : 'GPS lost'} (${t('tap to toggle', 'টগল')})',
                              style: TextStyle(
                                  fontSize: 11,
                                  color: Theme.of(context).hintColor,
                                  fontWeight: FontWeight.w600))),
                    ],
                  ),
                ])),
          ),
          const SizedBox(height: 12),
          AppReveal(
            index: 1,
            child: const QuickActions(kind: 'rider'),
          ),
          const SizedBox(height: 12),
          if (!s.store.onDuty)
            StCard(
                child: Column(children: [
              Icon(Icons.two_wheeler,
                  size: 40, color: Theme.of(context).hintColor),
              const SizedBox(height: 8),
              Text(t("You're off duty", 'আপনি অফ ডিউটিতে'),
                  style: const TextStyle(fontWeight: FontWeight.w700)),
              const SizedBox(height: 8),
              StBtn(
                  label: t('Go on duty', 'ডিউটিতে যান'),
                  onTap: () =>
                      ctrl.patchStore((st) => st.copyWith(onDuty: true))),
            ]))
          else if (s.store.riderStep >= 3)
            StCard(
                child: Column(children: [
              Icon(Icons.schedule, size: 40, color: role),
              const SizedBox(height: 8),
              Text(
                  t('Waiting for next assignment',
                      'পরবর্তী অ্যাসাইনমেন্টের অপেক্ষা'),
                  style: const TextStyle(fontWeight: FontWeight.w700)),
              const SizedBox(height: 8),
              StBtn(
                  label: t('View offer #TK-912', 'অফার দেখুন'),
                  onTap: () => ctrl.go('R-10')),
            ]))
          else ...[
            _MiniMap(tall: false),
            const SizedBox(height: 8),
            Row(children: [
              StBtn(
                  label: t('Recenter', 'কেন্দ্রে'),
                  variant: StBtnVariant.outline,
                  icon: Icons.my_location,
                  onTap: () => ctrl.toast(t('Recentered', 'কেন্দ্রে'))),
              const SizedBox(width: 8),
              Expanded(
                  child: StBtn(
                      label: t('Turn-by-Turn', 'নেভিগেশন'),
                      full: true,
                      icon: Icons.navigation,
                      onTap: () => ctrl.go('R-02'))),
            ]),
            const SizedBox(height: 12),
            StCard(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                  Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Expanded(
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                          Wrap(spacing: 6, children: [
                            StChip(
                                tone: StTone.danger,
                                child: const Text('PRIORITY · LUNCH')),
                            Text('#TK-911',
                                style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
                                    color: Theme.of(context).hintColor))
                          ]),
                          const SizedBox(height: 4),
                          Text(t('Lunch Delivery Window', 'লাঞ্চ ডেলিভারি'),
                              style: const TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w800)),
                          Text('12:30 PM – 1:15 PM',
                              style: TextStyle(
                                  fontSize: 12,
                                  color: Theme.of(context).hintColor)),
                        ])),
                    Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                            color: role.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(16)),
                        child: Column(children: [
                          Text(t('DUE', 'বাকি'),
                              style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w700,
                                  color: role)),
                          Text('18m',
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w800,
                                  color: role)),
                        ])),
                  ]),
                  const SizedBox(height: 12),
                  Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                          color: Theme.of(context).brightness == Brightness.dark
                              ? StColors.darkMuted
                              : StColors.muted,
                          borderRadius: BorderRadius.circular(16)),
                      child: Row(children: [
                        Icon(Icons.inventory_2_outlined, color: role),
                        const SizedBox(width: 8),
                        const Expanded(
                            child: Text('2× Classic Bengali Homestyle Thali',
                                style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 14))),
                        StChip(
                            tone: StTone.success, child: const Text('PREPAID')),
                      ])),
                  const SizedBox(height: 12),
                  Text(t('PICKED UP FROM', 'যেখান থেকে'),
                      style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: Theme.of(context).hintColor)),
                  const Text("Rina's Kitchen (Moghbazar)",
                      style: TextStyle(fontWeight: FontWeight.w700)),
                  Text('House 14, Road 3, Moghbazar',
                      style: TextStyle(
                          fontSize: 12, color: Theme.of(context).hintColor)),
                  const SizedBox(height: 12),
                  Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                          color: Theme.of(context).brightness == Brightness.dark
                              ? StColors.darkMuted
                              : StColors.muted,
                          borderRadius: BorderRadius.circular(16)),
                      child: Column(children: [
                        Row(children: [
                          Expanded(
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                Wrap(spacing: 6, children: [
                                  const Text('Tanvir Ahmed',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w700,
                                          fontSize: 14)),
                                  StChip(child: const Text('Sub #408'))
                                ]),
                                Text(t('Verified customer', 'যাচাইকৃত গ্রাহক'),
                                    style: TextStyle(
                                        fontSize: 12,
                                        color: Theme.of(context).hintColor)),
                              ])),
                          StIconBtn(
                              icon: Icons.chat_bubble_outline,
                              label: 'Chat',
                              onTap: () =>
                                  ctrl.go('SH-02', {'who': 'Tanvir Ahmed'})),
                          const SizedBox(width: 4),
                          StIconBtn(
                              icon: Icons.phone,
                              label: 'Call',
                              bg: StColors.success,
                              fg: Colors.white,
                              onTap: () => ctrl.showConfirm(ConfirmOpts(
                                  title: t('Call Tanvir?', 'তানভীরকে কল?'),
                                  body: '+880 17•• (masked)',
                                  ok: t('Call', 'কল'),
                                  onOk: () =>
                                      ctrl.toast(t('Calling…', 'কল হচ্ছে…'))))),
                        ]),
                        const SizedBox(height: 8),
                        Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                                color: Theme.of(context).cardColor,
                                borderRadius: BorderRadius.circular(16)),
                            child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Icon(Icons.place,
                                      size: 16, color: StColors.success),
                                  const SizedBox(width: 8),
                                  Expanded(
                                      child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                        const Text('House 42, Road 11, Block D',
                                            style: TextStyle(
                                                fontWeight: FontWeight.w700,
                                                fontSize: 14)),
                                        Text('Banani · Lift 4, Apt 4B',
                                            style: TextStyle(
                                                fontSize: 12,
                                                color: Theme.of(context)
                                                    .hintColor)),
                                      ])),
                                ])),
                        const SizedBox(height: 8),
                        StNote(
                            tone: StNoteTone.warning,
                            child: Text(
                                '${t('Note', 'নোট')}: ${t('Gate pass code #1204. Hook on doorstep or ring bell twice.', 'গেট কোড #১২০৪। দুবার বেল দিন।')}')),
                        Text(
                            '✓ ${t('Paid via bKash (৳0 due) · OTP not required', 'বিকাশে পরিশোধিত (৳০ বাকি)')}',
                            style: const TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                color: StColors.success)),
                      ])),
                  const SizedBox(height: 12),
                  Text(t('DELIVERY WORKFLOW', 'ডেলিভারি ধাপ'),
                      style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: Theme.of(context).hintColor)),
                  const SizedBox(height: 8),
                  StTimeline(steps: steps, current: s.store.riderStep),
                  const SizedBox(height: 12),
                  StBtn(
                    label: s.store.riderStep == 0
                        ? t('CONFIRM PICKUP', 'পিকআপ নিশ্চিত')
                        : t('ARRIVED & MARK DELIVERED', 'পৌঁছেছি ও ডেলিভারি'),
                    full: true,
                    size: StBtnSize.lg,
                    icon: s.store.riderStep == 0
                        ? Icons.inventory_2_outlined
                        : Icons.verified_outlined,
                    onTap: () {
                      if (s.store.riderStep == 0) {
                        ctrl.showConfirm(ConfirmOpts(
                          title: t("Confirm pickup from Rina's Kitchen?",
                              'পিকআপ নিশ্চিত?'),
                          body: t('Check 2× sealed tiffins.',
                              '২টি সিল করা টিফিন দেখুন।'),
                          ok: t('Picked up', 'নেওয়া হয়েছে'),
                          onOk: () => ctrl
                              .patchStore((st) => st.copyWith(riderStep: 2)),
                        ));
                      } else {
                        ctrl.go('R-03');
                      }
                    },
                  ),
                  const SizedBox(height: 8),
                  StBtn(
                      label: t('Report Heavy Traffic / Customer Delay',
                          'যানজট / দেরি জানান'),
                      full: true,
                      variant: StBtnVariant.soft,
                      icon: Icons.warning_amber_outlined,
                      onTap: () => ctrl.go('SH-06', {'ref': 'TK-911 · delay'})),
                ])),
          ],
          const SizedBox(height: 16),
          AppReveal(
            index: 2,
            child: StSection(
                title: t('Up Next in Queue (1)', 'পরবর্তী (১)'),
                child: StCard(
                    onTap: () => ctrl.go('R-06'),
                    child: Row(children: [
                      Icon(Icons.playlist_add, color: role),
                      const SizedBox(width: 12),
                      Expanded(
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                            const Text('#TK-912 · Nusrat Jahan',
                                style: TextStyle(
                                    fontWeight: FontWeight.w700, fontSize: 14)),
                            Text('Navana Tower, Gulshan 1 · Est. 1:30 PM',
                                style: TextStyle(
                                    fontSize: 12,
                                    color: Theme.of(context).hintColor)),
                          ])),
                      Icon(Icons.chevron_right,
                          color: Theme.of(context).hintColor),
                    ]))),
          ),
        ]),
      ),
    );
  }
}

class _MiniMap extends ConsumerWidget {
  const _MiniMap({required this.tall});
  final bool tall;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = ref.watch(appProvider);
    final t = s.t;
    final role = context.roleColor;
    return Container(
      height: tall ? 420 : 208,
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.dark
            ? StColors.darkMuted
            : StColors.muted,
        borderRadius: BorderRadius.circular(24),
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(children: [
        CustomPaint(size: Size.infinite, painter: _RoutePainter(role)),
        Positioned(
            left: 12,
            top: 40,
            child: _Pin(
                label: "Rina's Kitchen",
                bg: Theme.of(context).colorScheme.onSurface,
                fg: Theme.of(context).colorScheme.surface)),
        Positioned(
            right: 12,
            top: 28,
            child: _Pin(
                label: 'Tanvir (Banani)',
                bg: StColors.success,
                fg: Colors.white)),
        Align(
            alignment: const Alignment(0, -0.1),
            child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                    color: role,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                          color: role.withValues(alpha: 0.25),
                          blurRadius: 8,
                          spreadRadius: 4)
                    ]),
                child: const Icon(Icons.two_wheeler,
                    color: Colors.white, size: 20))),
        Align(
            alignment: const Alignment(0, -0.45),
            child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                    color: role, borderRadius: BorderRadius.circular(99)),
                child: Text(t('2.4 km · ~11 min est.', '২.৪ কিমি · ~১১ মি'),
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.w700)))),
        Positioned(
            top: 8,
            left: 8,
            child:
                StChip(tone: StTone.muted, child: Text(t('Sample', 'নমুনা')))),
        if (!s.store.gps)
          Container(
              color: Theme.of(context)
                  .scaffoldBackgroundColor
                  .withValues(alpha: 0.7),
              alignment: Alignment.center,
              child: Text(t('GPS signal lost', 'জিপিএস সংকেত নেই'),
                  style: const TextStyle(
                      fontWeight: FontWeight.w700, color: StColors.danger))),
      ]),
    );
  }
}

class _Pin extends StatelessWidget {
  const _Pin({required this.label, required this.bg, required this.fg});
  final String label;
  final Color bg;
  final Color fg;
  @override
  Widget build(BuildContext context) => Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration:
          BoxDecoration(color: bg, borderRadius: BorderRadius.circular(99)),
      child: Text(label,
          style:
              TextStyle(color: fg, fontSize: 10, fontWeight: FontWeight.w700)));
}

class _RoutePainter extends CustomPainter {
  _RoutePainter(this.color);
  final Color color;
  @override
  void paint(Canvas canvas, Size size) {
    final p = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;
    final path = Path()
      ..moveTo(size.width * 0.15, size.height * 0.35)
      ..cubicTo(size.width * 0.3, size.height * 0.6, size.width * 0.45,
          size.height * 0.4, size.width * 0.55, size.height * 0.55)
      ..cubicTo(size.width * 0.7, size.height * 0.7, size.width * 0.8,
          size.height * 0.5, size.width * 0.85, size.height * 0.3);
    canvas.drawPath(path, p);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
