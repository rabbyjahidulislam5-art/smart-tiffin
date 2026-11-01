import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:st_design_system/st_design_system.dart';
import 'package:st_domain/st_domain.dart';
import 'package:st_shell/st_shell.dart';

class CustomerHomeScreen extends ConsumerStatefulWidget {
  const CustomerHomeScreen({super.key});
  @override
  ConsumerState<CustomerHomeScreen> createState() => _CustomerHomeScreenState();
}
class _CustomerHomeScreenState extends ConsumerState<CustomerHomeScreen> {
  String cat = 'all';
  @override
  Widget build(BuildContext context) {
    final s = ref.watch(appProvider);
    final ctrl = ref.read(appProvider.notifier);
    final t = s.t;
    final role = context.roleColor;
    final filtered = meals.where((m) => cat=='all' || m.cat==cat).toList();
    return StScreen(
      title: t('Home', 'হোম'),
      back: false,
      actions: [
        StIconBtn(icon: Icons.notifications_none, label: 'Notifications', dot: !s.store.readAll, onTap: () => ctrl.go('SH-01')),
        const SizedBox(width: 8),
        GestureDetector(onTap: () => ctrl.go('C-23'), child: const StAvatar(name: 'Tanvir Ahmed', size: 40)),
      ],
      child: AppReveal(
      index: 0,
      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        Align(alignment: Alignment.centerLeft, child: ActionChip(avatar: Icon(Icons.place, size: 16, color: role), label: const Text('Banani, Block D, Dhaka'), onPressed: () {
          ctrl.showSheet(Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            Text(t('Deliver to', 'ডেলিভারি ঠিকানা'), style: const TextStyle(fontWeight: FontWeight.w700)),
            for (final a in ['Banani, Block D, Dhaka', 'Gulshan 1 · Office', 'Dhanmondi 27 · Parents'])
              ListTile(leading: Icon(Icons.place, color: role), title: Text(a), onTap: () { ctrl.closeSheet(); ctrl.toast(t('Address selected', 'ঠিকানা নির্বাচিত')); }),
            StBtn(label: t('Add new address', 'নতুন ঠিকানা'), full: true, variant: StBtnVariant.soft, icon: Icons.add, onTap: () { ctrl.closeSheet(); ctrl.go('C-03'); }),
          ]));
        })),
        Text(t('Hello, Tanvir!', 'হ্যালো, তানভীর!') + ' 👋', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w800)),
        Text(t('Fresh homestyle meals for your day.', 'আপনার দিনের জন্য তাজা ঘরের খাবার।'), style: TextStyle(color: Theme.of(context).hintColor)),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(28), gradient: LinearGradient(colors: [role, StColors.warning]), boxShadow: [BoxShadow(color: role.withValues(alpha: 0.3), blurRadius: 16, offset: const Offset(0, 6))]),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            GestureDetector(onTap: () => ctrl.go('C-10'), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(t('ACTIVE PLAN', 'চলমান প্ল্যান'), style: const TextStyle(color: Colors.white70, fontSize: 10, fontWeight: FontWeight.w700, letterSpacing: 1)),
              Text(t('Monthly Homemade Package', 'মাসিক ঘরোয়া প্যাকেজ'), style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w800)),
              Text(t('Lunch + Dinner daily', 'প্রতিদিন লাঞ্চ + ডিনার'), style: const TextStyle(color: Colors.white70, fontSize: 12)),
            ])),
            const SizedBox(height: 12),
            Container(padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(16)), child: Column(children: [
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text(t('Subscription cycle', 'সাবস্ক্রিপশন চক্র'), style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600)), Text(t('18 days left', '১৮ দিন বাকি') + ' (12/30)', style: const TextStyle(color: Colors.white, fontSize: 12))]),
              const SizedBox(height: 8),
              ClipRRect(borderRadius: BorderRadius.circular(99), child: const LinearProgressIndicator(value: 0.4, minHeight: 6, backgroundColor: Colors.white24, color: Colors.white)),
            ])),
            const SizedBox(height: 12),
            Row(children: [
              Expanded(child: OutlinedButton.icon(onPressed: () {
                if (s.store.paused) {
                  ctrl.showConfirm(ConfirmOpts(title: t('Resume meals?', 'খাবার চালু করবেন?'), ok: t('Resume', 'চালু করুন'), onOk: () { ctrl.patchStore((st) => st.copyWith(paused: false)); ctrl.toast(t('Meals resumed', 'খাবার চালু হয়েছে')); }));
                } else { ctrl.go('C-14'); }
              }, icon: Icon(s.store.paused ? Icons.play_arrow : Icons.pause, color: Colors.white), label: Text(s.store.paused ? t('Resume', 'চালু') : t('Pause Meals', 'বিরতি দিন'), style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700)), style: OutlinedButton.styleFrom(side: const BorderSide(color: Colors.white38), minimumSize: const Size.fromHeight(44)))),
              const SizedBox(width: 8),
              Expanded(child: FilledButton.icon(onPressed: () => ctrl.go('C-13'), icon: Icon(Icons.calendar_month, color: role), label: Text(t('Plan Calendar', 'ক্যালেন্ডার'), style: TextStyle(color: role, fontWeight: FontWeight.w700)), style: FilledButton.styleFrom(backgroundColor: Colors.white, minimumSize: const Size.fromHeight(44)))),
            ]),
          ]),
        ),
        const SizedBox(height: 12),
        const QuickActions(kind: 'customer'),
        const SizedBox(height: 12),
        StCard(child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          Row(children: [StChip(tone: StTone.danger, child: const Text('● LIVE')), const SizedBox(width: 8), Text(t('Ongoing Delivery', 'চলমান ডেলিভারি'), style: const TextStyle(fontWeight: FontWeight.w700)), const Spacer(), Text('1:15 PM', style: TextStyle(color: role, fontWeight: FontWeight.w800))]),
          const SizedBox(height: 10),
          StTimeline(current: 2, steps: [
            (label: t('Placed', 'অর্ডার'), sub: '12:20', icon: Icons.check),
            (label: t('Cooked', 'রান্না'), sub: '12:45', icon: Icons.soup_kitchen),
            (label: t('On the way', 'পথে'), sub: t('Gulshan', 'গুলশান'), icon: Icons.two_wheeler),
            (label: t('Drop-off', 'পৌঁছানো'), sub: '1:15', icon: Icons.home),
          ]),
          const SizedBox(height: 10),
          StBtn(label: t('Track Delivery on Live Map', 'লাইভ ম্যাপে ট্র্যাক করুন'), full: true, size: StBtnSize.lg, icon: Icons.navigation, onTap: () => ctrl.go('C-18')),
        ])),
        const SizedBox(height: 16),
        StSection(title: t("Today's Special Menu", 'আজকের বিশেষ মেনু'), action: t('See All (14)', 'সব দেখুন (১৪)'), onAction: () => ctrl.go('C-04'), child: Column(children: [
          StChipRow(value: cat, onChanged: (v) => setState(() => cat = v), options: [(v:'all',l:t('All Items','সব')),(v:'thali',l:t('Bengali Thali','বাঙালি থালি')),(v:'diet',l:t('Diet & Keto','ডায়েট')),(v:'office',l:t('Office Lunch','অফিস লাঞ্চ'))]),
          const SizedBox(height: 10),
          SizedBox(height: 220, child: ListView.separated(scrollDirection: Axis.horizontal, itemCount: filtered.length, separatorBuilder: (_,__)=>const SizedBox(width: 12), itemBuilder: (_, i) {
            final m = filtered[i];
            return SizedBox(width: 220, child: StCard(padding: EdgeInsets.zero, onTap: () => ctrl.go('C-05', {'id': m.id}), child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
              ClipRRect(borderRadius: const BorderRadius.vertical(top: Radius.circular(24)), child: Image.asset(m.img, height: 110, fit: BoxFit.cover, errorBuilder: (_,__,___)=>Container(height:110,color:StColors.muted))),
              Padding(padding: const EdgeInsets.all(12), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(m.kitchen, style: TextStyle(fontSize: 11, color: Theme.of(context).hintColor)),
                Text(t(m.en, m.bn), maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.w700)),
                Text('BDT ${m.price}', style: const TextStyle(fontWeight: FontWeight.w800)),
              ])),
            ])));
          })),
        ])),
      ]),
    ),
    );
  }
}
