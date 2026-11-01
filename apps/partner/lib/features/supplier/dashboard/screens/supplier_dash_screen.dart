import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:st_design_system/st_design_system.dart';
import 'package:st_domain/st_domain.dart';
import 'package:st_shell/st_shell.dart';

class SupplierDashScreen extends ConsumerWidget {
  const SupplierDashScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = ref.watch(appProvider);
    final ctrl = ref.read(appProvider.notifier);
    final t = s.t;
    final role = context.roleColor;
    final pending = requests
        .where((r) =>
            !s.store.accepted.contains(r.id) &&
            !s.store.declined.contains(r.id))
        .length;
    final stages = [
      t('Prepped', 'প্রস্তুত'),
      t('Preparing', 'রান্না'),
      t('Packed', 'প্যাক')
    ];
    void toggleOnline(bool v) {
      if (v) {
        ctrl.patchStore((st) => st.copyWith(online: true));
      } else {
        ctrl.showConfirm(ConfirmOpts(
          title: t('Go offline?', 'অফলাইনে যাবেন?'),
          body: t('New orders stop. Accepted orders must still be cooked.',
              'নতুন অর্ডার বন্ধ হবে। গৃহীত অর্ডার রান্না করতে হবে।'),
          ok: t('Go offline', 'অফলাইন'),
          danger: true,
          onOk: () => ctrl.patchStore((st) => st.copyWith(online: false)),
        ));
      }
    }

    return Theme(
      data: Theme.of(context)
          .copyWith(extensions: [const StRoleTheme(role: StColors.supplier)]),
      child: StScreen(
        title: t('Dashboard', 'ড্যাশবোর্ড'),
        eyebrow: s.store.online ? '● Kitchen live' : '○ Kitchen offline',
        back: false,
        actions: [
          StIconBtn(
              icon: Icons.notifications_none,
              label: 'Notifications',
              onTap: () => ctrl.go('SH-01')),
          const SizedBox(width: 8),
          GestureDetector(
              onTap: () => ctrl.go('S-10'),
              child: const StAvatar(name: 'Rina Kitchen', size: 40)),
        ],
        child:
            Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          AppReveal(
            index: 0,
            child: StCard(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                  Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Expanded(
                        child: InkWell(
                            onTap: () => ctrl.go('S-10'),
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(children: [
                                    Flexible(
                                        child: Text("Rina's Kitchen",
                                            style: const TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.w800))),
                                    Icon(Icons.verified, color: role, size: 20)
                                  ]),
                                  Text('Moghbazar Home Kitchen · ID #TK-K21',
                                      style: TextStyle(
                                          fontSize: 12,
                                          color: Theme.of(context).hintColor)),
                                ]))),
                    StChip(tone: StTone.role, child: const Text('CHEF MODE')),
                  ]),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                        color: role.withValues(alpha: 0.05),
                        borderRadius: BorderRadius.circular(16)),
                    child: Row(children: [
                      Container(
                          width: 10,
                          height: 10,
                          decoration: BoxDecoration(
                              color: s.store.online
                                  ? StColors.success
                                  : Theme.of(context).hintColor,
                              shape: BoxShape.circle)),
                      const SizedBox(width: 10),
                      Expanded(
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                            Text(
                                s.store.online
                                    ? t('Accepting Orders (Online)',
                                        'অর্ডার নিচ্ছে (অনলাইন)')
                                    : t('Not accepting orders', 'অর্ডার বন্ধ'),
                                style: const TextStyle(
                                    fontWeight: FontWeight.w700, fontSize: 14)),
                            Text(
                                t('Lunch & Dinner shifts',
                                    'লাঞ্চ ও ডিনার শিফট'),
                                style: TextStyle(fontSize: 11, color: role)),
                          ])),
                      StToggle(
                          value: s.store.online,
                          onChanged: toggleOnline,
                          label: 'Online'),
                    ]),
                  ),
                ])),
          ),
          const SizedBox(height: 12),
          AppReveal(
            index: 1,
            child: const QuickActions(kind: 'supplier'),
          ),
          const SizedBox(height: 12),
          AppReveal(
            index: 2,
            child: Row(children: [
              Expanded(
                  child: StStat(
                      label: t("Today's orders", 'আজকের অর্ডার'),
                      value: '24',
                      icon: Icons.shopping_bag_outlined,
                      onTap: () => ctrl.go('S-06'),
                      sub: Text('+6 vs yesterday',
                          style: TextStyle(
                              fontSize: 11,
                              color: StColors.success,
                              fontWeight: FontWeight.w700)))),
              const SizedBox(width: 12),
              Expanded(
                  child: StStat(
                      label: t('Earnings today', 'আজকের আয়'),
                      value: '৳4,320',
                      icon: Icons.account_balance_wallet_outlined,
                      onTap: () => ctrl.go('S-08'),
                      sub: StChip(
                          tone: StTone.warning,
                          child: Text(t(
                              'Settlement pending', 'নিষ্পত্তি অপেক্ষমাণ'))))),
            ]),
          ),
          const SizedBox(height: 12),
          AppReveal(
            index: 3,
            child: StCard(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                  InkWell(
                      onTap: () => ctrl.go('S-03'),
                      child: Row(children: [
                        Icon(Icons.soup_kitchen_outlined, color: role),
                        const SizedBox(width: 8),
                        Expanded(
                            child: Text(
                                t('Daily Cooking Requirements',
                                    'দৈনিক রান্নার চাহিদা'),
                                style: const TextStyle(
                                    fontWeight: FontWeight.w700))),
                        StChip(
                            tone: StTone.warning,
                            icon: Icons.timer_outlined,
                            child: Text(t('Lunch dispatch 42m', 'লাঞ্চ ৪২মি'))),
                      ])),
                  const SizedBox(height: 12),
                  InkWell(
                      onTap: () => ctrl.go('S-03'),
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                            color:
                                Theme.of(context).brightness == Brightness.dark
                                    ? StColors.darkMuted
                                    : StColors.muted,
                            borderRadius: BorderRadius.circular(16)),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                  t('LUNCH BATCH TARGET', 'লাঞ্চ ব্যাচ লক্ষ্য'),
                                  style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w700,
                                      color: Theme.of(context).hintColor)),
                              Text('45 ${t('Portions', 'পোর্শন')}',
                                  style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w800)),
                              const SizedBox(height: 8),
                              for (final row in [
                                ('Standard Bengali Thali', 28),
                                ('Diet Khichuri & Egg', 12),
                                ('Keto Desi Chicken', 5)
                              ])
                                Padding(
                                    padding: const EdgeInsets.only(bottom: 2),
                                    child: Row(children: [
                                      Expanded(
                                          child: Text('● ${row.$1}',
                                              style: const TextStyle(
                                                  fontSize: 12))),
                                      Text('${row.$2} pkts',
                                          style: const TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w700))
                                    ])),
                            ]),
                      )),
                  const SizedBox(height: 12),
                  Text(t('KITCHEN FLOW STAGE', 'রান্নার ধাপ'),
                      style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: Theme.of(context).hintColor)),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                        color: Theme.of(context).brightness == Brightness.dark
                            ? StColors.darkMuted
                            : StColors.muted,
                        borderRadius: BorderRadius.circular(16)),
                    child: Row(children: [
                      for (var i = 0; i < stages.length; i++)
                        Expanded(
                            child: Padding(
                          padding: const EdgeInsets.all(2),
                          child: Material(
                            color: s.store.stage == i
                                ? role
                                : (i < s.store.stage
                                    ? Theme.of(context).cardColor
                                    : Colors.transparent),
                            borderRadius: BorderRadius.circular(12),
                            child: InkWell(
                              borderRadius: BorderRadius.circular(12),
                              onTap: () {
                                if (i == 2) {
                                  ctrl.showConfirm(ConfirmOpts(
                                    title: t('Mark lunch batch packed?',
                                        'লাঞ্চ ব্যাচ প্যাকড?'),
                                    body: t(
                                        'Riders will be told the tiffins are sealed and ready.',
                                        'রাইডারদের জানানো হবে টিফিন প্রস্তুত।'),
                                    ok: t('Ready for handoff',
                                        'হস্তান্তরের জন্য প্রস্তুত'),
                                    onOk: () {
                                      ctrl.patchStore(
                                          (st) => st.copyWith(stage: 2));
                                      ctrl.toast(t('Ready for rider handoff',
                                          'রাইডার হস্তান্তরের জন্য প্রস্তুত'));
                                    },
                                  ));
                                } else {
                                  ctrl.patchStore(
                                      (st) => st.copyWith(stage: i));
                                }
                              },
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 10),
                                child: Text('${i + 1}. ${stages[i]}',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w700,
                                        color: s.store.stage == i
                                            ? Colors.white
                                            : (i < s.store.stage
                                                ? role
                                                : Theme.of(context)
                                                    .hintColor))),
                              ),
                            ),
                          ),
                        )),
                    ]),
                  ),
                  const SizedBox(height: 8),
                  Text(
                      t('Tap "Packed" when hot tiffins are sealed for rider handoff.',
                          'টিফিন সিল হলে "প্যাক" চাপুন।'),
                      style: TextStyle(fontSize: 11, color: StColors.warning)),
                ])),
          ),
          const SizedBox(height: 16),
          AppReveal(
            index: 4,
            child: StSection(
              title: t('Live Order Requests', 'লাইভ অর্ডার অনুরোধ'),
              action: '$pending ${t('Pending', 'অপেক্ষমাণ')}',
              onAction: () => ctrl.go('S-06'),
              child: Column(children: [
                if (!s.store.online)
                  StNote(
                      tone: StNoteTone.warning,
                      child: Text(t('You are offline — no new requests arrive.',
                          'আপনি অফলাইনে — নতুন অনুরোধ আসবে না।'))),
                for (final r
                    in requests.where((r) => !s.store.declined.contains(r.id)))
                  Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: _ReqCard(r: r)),
              ]),
            ),
          ),
          const SizedBox(height: 12),
          AppReveal(
            index: 5,
            child: StSection(
                title: t("Today's Menu & Stock", 'আজকের মেনু ও স্টক'),
                action: t('Edit Full', 'সম্পূর্ণ এডিট'),
                onAction: () => ctrl.go('S-04'),
                child: const StockList()),
          ),
        ]),
      ),
    );
  }
}

class _ReqCard extends ConsumerWidget {
  const _ReqCard({required this.r});
  final OrderReq r;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = ref.watch(appProvider);
    final ctrl = ref.read(appProvider.notifier);
    final t = s.t;
    final accepted = s.store.accepted.contains(r.id);
    return StCard(
        child:
            Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      InkWell(
          onTap: () => ctrl.go('S-02', {'id': r.id}),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              Expanded(
                  child: Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      spacing: 6,
                      children: [
                    Text(r.name,
                        style: const TextStyle(
                            fontWeight: FontWeight.w700, fontSize: 14)),
                    StChip(child: Text('#${r.id}'))
                  ])),
              StChip(
                  tone: StTone.success,
                  icon: Icons.check_circle_outline,
                  child: Text('${r.pay} ${t('Paid', 'পরিশোধিত')}')),
            ]),
            const SizedBox(height: 4),
            Row(children: [
              Icon(Icons.place_outlined,
                  size: 12, color: Theme.of(context).hintColor),
              const SizedBox(width: 4),
              Flexible(
                  child: Text(r.area,
                      style: TextStyle(
                          fontSize: 12, color: Theme.of(context).hintColor)))
            ]),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? StColors.darkMuted
                      : StColors.muted,
                  borderRadius: BorderRadius.circular(16)),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(children: [
                      Expanded(
                          child: Text(r.item,
                              style: const TextStyle(
                                  fontWeight: FontWeight.w700, fontSize: 14))),
                      Text(r.qty,
                          style: TextStyle(
                              fontWeight: FontWeight.w700,
                              color: context.roleColor))
                    ]),
                    if (r.note != null)
                      Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Text(r.note!,
                              style: TextStyle(
                                  fontSize: 12, color: StColors.warning))),
                  ]),
            ),
          ])),
      const SizedBox(height: 10),
      Wrap(
        alignment: WrapAlignment.spaceBetween,
        crossAxisAlignment: WrapCrossAlignment.center,
        spacing: 8,
        runSpacing: 8,
        children: [
          Text('BDT ${r.amount}',
              style:
                  const TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
          if (accepted)
            StChip(
                tone: StTone.success,
                icon: Icons.check_circle,
                child: Text(t('Accepted', 'গৃহীত')))
          else ...[
            StBtn(
                label: t('Decline', 'না'),
                size: StBtnSize.sm,
                variant: StBtnVariant.outline,
                onTap: () => ctrl.showSheet(_DeclineSheet(id: r.id))),
            const SizedBox(width: 8),
            StBtn(
                label: t('Accept Order', 'গ্রহণ'),
                size: StBtnSize.sm,
                icon: Icons.check_circle_outline,
                onTap: () {
                  ctrl.patchStore(
                      (st) => st.copyWith(accepted: [...st.accepted, r.id]));
                  ctrl.toast(t(
                      '#${r.id} accepted · added to batch', '#${r.id} গৃহীত'));
                }),
          ],
        ],
      ),
    ]));
  }
}

class _DeclineSheet extends ConsumerStatefulWidget {
  const _DeclineSheet({required this.id});
  final String id;
  @override
  ConsumerState<_DeclineSheet> createState() => _DeclineSheetState();
}

class _DeclineSheetState extends ConsumerState<_DeclineSheet> {
  String r = '';
  @override
  Widget build(BuildContext context) {
    final ctrl = ref.read(appProvider.notifier);
    final t = ref.watch(appProvider).t;
    final reasons = [
      t('Out of stock', 'স্টক নেই'),
      t('Kitchen at capacity', 'সক্ষমতা পূর্ণ'),
      t('Outside delivery zone', 'এলাকার বাইরে'),
      t('Other', 'অন্য')
    ];
    return Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('${t('Decline', 'প্রত্যাখ্যান')} #${widget.id}?',
              style: const TextStyle(fontWeight: FontWeight.w700)),
          const SizedBox(height: 8),
          for (final x in reasons)
            Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: r == x ? StColors.danger : null,
                    side: BorderSide(
                        color: r == x
                            ? StColors.danger
                            : Theme.of(context).dividerColor),
                    backgroundColor:
                        r == x ? StColors.danger.withValues(alpha: 0.05) : null,
                    minimumSize: const Size.fromHeight(44),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16)),
                  ),
                  onPressed: () => setState(() => r = x),
                  child: Text(x,
                      style: const TextStyle(fontWeight: FontWeight.w700)),
                )),
          StBtn(
              label: t('Decline order', 'প্রত্যাখ্যান'),
              full: true,
              variant: StBtnVariant.danger,
              disabled: r.isEmpty,
              reason: t('Choose a reason', 'কারণ বেছে নিন'),
              onTap: () {
                ctrl.patchStore(
                    (st) => st.copyWith(declined: [...st.declined, widget.id]));
                ctrl.closeSheet();
                ctrl.toast(t('Order declined — customer notified (sample)',
                    'অর্ডার প্রত্যাখ্যাত (নমুনা)'));
              }),
        ]);
  }
}

class StockList extends ConsumerWidget {
  const StockList({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = ref.watch(appProvider);
    final ctrl = ref.read(appProvider.notifier);
    final t = s.t;
    final items = [
      (k: 'thali', m: meals[1], left: 8),
      (k: 'khichuri', m: meals[2], left: 14),
      (k: 'roti', m: meals[3], left: 0),
    ];
    return StCard(
        padding: const EdgeInsets.all(12),
        child: Column(children: [
          for (final it in items)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? StColors.darkMuted
                        : StColors.muted,
                    borderRadius: BorderRadius.circular(16)),
                child: Row(children: [
                  Expanded(
                      child: InkWell(
                          onTap: () => ctrl.go('S-05', {'id': it.m.id}),
                          child: Row(children: [
                            ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: ColorFiltered(
                                  colorFilter: s.store.stock[it.k] == true
                                      ? const ColorFilter.mode(
                                          Colors.transparent, BlendMode.dst)
                                      : const ColorFilter.matrix(<double>[
                                          0.2126,
                                          0.7152,
                                          0.0722,
                                          0,
                                          0,
                                          0.2126,
                                          0.7152,
                                          0.0722,
                                          0,
                                          0,
                                          0.2126,
                                          0.7152,
                                          0.0722,
                                          0,
                                          0,
                                          0,
                                          0,
                                          0,
                                          1,
                                          0
                                        ]),
                                  child: Image.asset(it.m.img,
                                      width: 48,
                                      height: 48,
                                      fit: BoxFit.cover,
                                      errorBuilder: (_, __, ___) => Container(
                                          width: 48,
                                          height: 48,
                                          color:
                                              Theme.of(context).dividerColor)),
                                )),
                            const SizedBox(width: 10),
                            Expanded(
                                child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                  Text(t(it.m.en, it.m.bn),
                                      style: TextStyle(
                                          fontWeight: FontWeight.w700,
                                          fontSize: 14,
                                          decoration:
                                              s.store.stock[it.k] == true
                                                  ? null
                                                  : TextDecoration.lineThrough,
                                          color: s.store.stock[it.k] == true
                                              ? null
                                              : Theme.of(context).hintColor)),
                                  Text(
                                      s.store.stock[it.k] == true
                                          ? 'BDT ${it.m.price} · ${it.left == 0 ? 10 : it.left} ${t('left', 'বাকি')}'
                                          : t('Sold out · Restock tomorrow',
                                              'শেষ · আগামীকাল'),
                                      style: TextStyle(
                                          fontSize: 12,
                                          color: s.store.stock[it.k] == true
                                              ? Theme.of(context).hintColor
                                              : StColors.danger)),
                                ])),
                          ]))),
                  StToggle(
                      value: s.store.stock[it.k] == true,
                      label: 'Available',
                      onChanged: (v) {
                        final next = Map<String, bool>.from(s.store.stock)
                          ..[it.k] = v;
                        ctrl.patchStore((st) => st.copyWith(stock: next));
                        ctrl.toast(v
                            ? t('Marked available', 'চালু')
                            : t('Marked sold out', 'শেষ চিহ্নিত'));
                      }),
                ]),
              ),
            ),
        ]));
  }
}
