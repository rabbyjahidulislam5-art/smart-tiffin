import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:st_design_system/st_design_system.dart';
import 'package:st_domain/st_domain.dart';
import 'package:st_shell/st_shell.dart';

class UserDetailScreen extends ConsumerStatefulWidget {
  const UserDetailScreen({super.key});
  @override
  ConsumerState<UserDetailScreen> createState() => _UserDetailScreenState();
}

class _UserDetailScreenState extends ConsumerState<UserDetailScreen> {
  bool susp = false;

  @override
  Widget build(BuildContext context) {
    final s = ref.watch(appProvider);
    final ctrl = ref.read(appProvider.notifier);
    final t = s.t;
    final role = context.roleColor;
    final id = s.current.params['id'] ?? 'u2';
    final map = {
      'u1': (n: 'Nadia Islam', r: 'Admin', ph: '+880 17••', area: 'HQ · Dhaka', meals: 0, spend: 0),
      'u2': (n: 'Tanvir Ahmed', r: 'Customer', ph: '+880 17••', area: 'Banani Block D', meals: 48, spend: 8640),
      'u3': (n: "Rina's Kitchen", r: 'Cook', ph: '+880 18••', area: 'Moghbazar', meals: 312, spend: 0),
      'u4': (n: "Maa's Kitchen", r: 'Cook', ph: '+880 19••', area: 'Mirpur 10', meals: 198, spend: 0),
      'u5': (n: 'Rokon Talukder', r: 'Rider', ph: '+880 16••', area: 'Banani cluster', meals: 312, spend: 0),
      'u6': (n: 'Farhana Khan', r: 'Customer', ph: '+880 15••', area: 'Gulshan 1', meals: 22, spend: 3960),
    };
    final u = map[id] ?? map['u2']!;
    final isCook = u.r == 'Cook';
    final isRider = u.r == 'Rider';
    final isCustomer = u.r == 'Customer';
    return Theme(
      data: Theme.of(context).copyWith(extensions: [const StRoleTheme(role: StColors.admin)]),
      child: StScreen(
        title: u.n,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AppReveal(
              index: 0,
              child: StCard(
                child: Row(
                  children: [
                    StAvatar(name: u.n, size: 64),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(u.n, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 18)),
                          const SizedBox(height: 4),
                          StChip(tone: isCook ? StTone.warning : isRider ? StTone.info : StTone.muted, child: Text(u.r)),
                          Text('${u.ph} · ${u.area}', style: TextStyle(fontSize: 12, color: Theme.of(context).hintColor)),
                          if (susp) ...[
                            const SizedBox(height: 6),
                            StChip(tone: StTone.danger, child: Text(t('Suspended', 'স্থগিত'))),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            if (isCustomer || isCook || isRider)
              AppReveal(
                index: 1,
                child: Row(
                  children: [
                    Expanded(
                      child: StStat(
                        label: isCustomer ? t('Orders', 'অর্ডার') : isCook ? t('Meals cooked', 'রান্না') : t('Trips', 'ট্রিপ'),
                        value: '${u.meals}',
                        icon: isCustomer ? Icons.receipt_long : isCook ? Icons.soup_kitchen_outlined : Icons.two_wheeler,
                        sub: isCustomer
                            ? AppCountUp(value: u.spend, format: (v) => '৳${v.round()} spent', style: TextStyle(fontSize: 11, color: role, fontWeight: FontWeight.w700))
                            : Text(t('Lifetime month', 'এই মাস'), style: TextStyle(fontSize: 11, color: Theme.of(context).hintColor)),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: StStat(
                        label: t('Rating', 'রেটিং'),
                        value: isCustomer ? '—' : '4.9',
                        icon: Icons.star_outline,
                        onTap: () => ctrl.go('A-10'),
                      ),
                    ),
                  ],
                ),
              ),
            if (isCustomer || isCook) ...[
              const SizedBox(height: 12),
              AppReveal(
                index: 2,
                child: StCard(
                  onTap: () => ctrl.go('A-11', {'id': '#TK-911'}),
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(14),
                        child: Image.asset(
                          meals[1].img,
                          width: 52,
                          height: 52,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Container(width: 52, height: 52, color: StColors.muted),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(t('Latest order', 'সাম্প্রতিক অর্ডার'), style: TextStyle(fontSize: 11, color: Theme.of(context).hintColor)),
                            Text('#TK-911 · ${t(meals[1].en, meals[1].bn)}', style: const TextStyle(fontWeight: FontWeight.w700), maxLines: 1, overflow: TextOverflow.ellipsis),
                          ],
                        ),
                      ),
                      Icon(Icons.chevron_right, color: Theme.of(context).hintColor),
                    ],
                  ),
                ),
              ),
            ],
            const SizedBox(height: 12),
            AppReveal(
              index: 3,
              child: StList(
                children: [
                  StRowTile(icon: Icons.chat_bubble_outline, label: t('Message', 'বার্তা'), onTap: () => ctrl.go('SH-02', {'who': u.n})),
                  StRowTile(icon: Icons.receipt_long, label: t('Orders', 'অর্ডার'), onTap: () => ctrl.go('A-10')),
                  if (isCook) StRowTile(icon: Icons.verified_outlined, label: t('Verification docs', 'যাচাই কাগজ'), onTap: () => ctrl.go('A-07', {'id': 'sultana'})),
                  StRowTile(
                    icon: Icons.block,
                    label: susp ? t('Reactivate account', 'পুনরায় চালু') : t('Suspend account', 'অ্যাকাউন্ট স্থগিত'),
                    danger: true,
                    onTap: () => ctrl.showConfirm(
                      ConfirmOpts(
                        title: susp ? t('Reactivate?', 'পুনরায় চালু?') : t('Suspend ${u.n}?', '${u.n} স্থগিত?'),
                        body: t('Recorded in the audit log.', 'অডিট লগে রেকর্ড হবে।'),
                        ok: susp ? t('Reactivate', 'চালু') : t('Suspend', 'স্থগিত'),
                        danger: !susp,
                        onOk: () {
                          setState(() => susp = !susp);
                          ctrl.toast(t('Change recorded (sample)', 'পরিবর্তন রেকর্ড (নমুনা)'));
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
