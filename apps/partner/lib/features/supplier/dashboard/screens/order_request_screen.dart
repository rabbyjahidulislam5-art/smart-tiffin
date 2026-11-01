import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:st_design_system/st_design_system.dart';
import 'package:st_domain/st_domain.dart';
import 'package:st_shell/st_shell.dart';

class OrderRequestScreen extends ConsumerWidget {
  const OrderRequestScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = ref.watch(appProvider);
    final ctrl = ref.read(appProvider.notifier);
    final t = s.t;
    final r = requests.firstWhere((x) => x.id == (s.current.params['id'] ?? 'TK-911'), orElse: () => requests.first);
    final accepted = s.store.accepted.contains(r.id);
    final steps = [
      (label: t('Accepted', 'গৃহীত'), sub: null as String?, icon: Icons.check_circle_outline),
      (label: t('Cooking', 'রান্না'), sub: null as String?, icon: Icons.soup_kitchen_outlined),
      (label: t('Packed', 'প্যাক'), sub: null as String?, icon: Icons.inventory_2_outlined),
      (label: t('Picked up', 'নেওয়া'), sub: null as String?, icon: Icons.groups_outlined),
    ];
    return StScreen(
      title: '#${r.id} · ${r.name}',
      footer: accepted
          ? StBtn(label: t('Mark packed', 'প্যাকড চিহ্নিত'), full: true, size: StBtnSize.lg, icon: Icons.inventory_2_outlined, onTap: () {
              ctrl.patchStore((st) => st.copyWith(stage: 2));
              ctrl.toast(t('Marked packed — rider notified (sample)', 'প্যাকড — রাইডার জানানো হয়েছে (নমুনা)'));
            })
          : Row(children: [
              StBtn(label: t('Decline', 'না'), variant: StBtnVariant.outline, onTap: () => ctrl.showSheet(_DeclineInline(id: r.id))),
              const SizedBox(width: 8),
              Expanded(child: StBtn(label: t('Accept Order', 'গ্রহণ'), full: true, size: StBtnSize.lg, icon: Icons.check_circle_outline, onTap: () => ctrl.patchStore((st) => st.copyWith(accepted: [...st.accepted, r.id])))),
            ]),
      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          if (accepted) ...[StCard(child: StTimeline(steps: steps, current: s.store.stage >= 2 ? 2 : 1)), const SizedBox(height: 12)],
          AppReveal(
            index: 0,
            child: StCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Image.asset(
                          meals[
                                  r.item.toLowerCase().contains('khichuri')
                                      ? 2
                                      : r.item.toLowerCase().contains('beef')
                                          ? 4
                                          : r.item.toLowerCase().contains('biryani')
                                              ? 0
                                              : 1]
                              .img,
                          width: 72,
                          height: 72,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Container(width: 72, height: 72, color: StColors.muted),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text('${r.qty} ${r.item}', style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15)),
                      ),
                    ],
                  ),
                  if (r.note != null) ...[const SizedBox(height: 8), StNote(tone: StNoteTone.warning, child: Text(r.note!))],
                  const SizedBox(height: 8),
                  Row(children: [Text(t('Payment', 'পেমেন্ট')), const Spacer(), StChip(tone: StTone.success, child: Text('${r.pay} ${t('Paid', 'পরিশোধিত')}'))]), // layout-ok
                  Row(children: [Text(t('Total', 'মোট'), style: const TextStyle(fontWeight: FontWeight.w800)), const Spacer(), Text('BDT ${r.amount}', style: const TextStyle(fontWeight: FontWeight.w800))]), // layout-ok
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          AppReveal(
            index: 1,
            child: StList(children: [
          StRowTile(icon: Icons.place_outlined, label: r.area, sub: t('Delivery area', 'ডেলিভারি এলাকা')),
          StRowTile(icon: Icons.schedule, label: t('Lunch window 12:30–1:15', 'লাঞ্চ ১২:৩০–১:১৫')),
          StRowTile(icon: Icons.phone, label: t('Call customer', 'গ্রাহককে কল'), onTap: () => ctrl.showConfirm(ConfirmOpts(title: t('Call ${r.name}?', '${r.name}-কে কল?'), body: '+880 17•• (masked) · ${t('Sample — no real call', 'নমুনা — আসল কল নয়')}', ok: t('Call', 'কল'), onOk: () => ctrl.toast(t('Calling…', 'কল হচ্ছে…'))))),
          StRowTile(icon: Icons.chat_bubble_outline, label: t('Message rider', 'রাইডারকে বার্তা'), onTap: () => ctrl.go('SH-02', {'who': 'Rokon Talukder'})),
        ]),
          ),
        ]),
    );
  }
}

class _DeclineInline extends ConsumerStatefulWidget {
  const _DeclineInline({required this.id});
  final String id;
  @override
  ConsumerState<_DeclineInline> createState() => _DeclineInlineState();
}
class _DeclineInlineState extends ConsumerState<_DeclineInline> {
  String r = '';
  @override
  Widget build(BuildContext context) {
    final ctrl = ref.read(appProvider.notifier);
    final t = ref.watch(appProvider).t;
    final reasons = [t('Out of stock', 'স্টক নেই'), t('Kitchen at capacity', 'সক্ষমতা পূর্ণ'), t('Outside delivery zone', 'এলাকার বাইরে'), t('Other', 'অন্য')];
    return Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      Text('${t('Decline', 'প্রত্যাখ্যান')} #${widget.id}?', style: const TextStyle(fontWeight: FontWeight.w700)),
      for (final x in reasons)
        Padding(padding: const EdgeInsets.only(top: 8), child: OutlinedButton(onPressed: () => setState(() => r = x), child: Text(x))),
      const SizedBox(height: 8),
      StBtn(label: t('Decline order', 'প্রত্যাখ্যান'), full: true, variant: StBtnVariant.danger, disabled: r.isEmpty, reason: t('Choose a reason', 'কারণ বেছে নিন'), onTap: () {
        ctrl.patchStore((st) => st.copyWith(declined: [...st.declined, widget.id]));
        ctrl.closeSheet();
        ctrl.toast(t('Order declined — customer notified (sample)', 'অর্ডার প্রত্যাখ্যাত (নমুনা)'));
      }),
    ]);
  }
}
