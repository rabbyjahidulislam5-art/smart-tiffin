import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:st_design_system/st_design_system.dart';
import 'package:st_domain/st_domain.dart';
import 'package:st_shell/st_shell.dart';

class RiderHistoryScreen extends ConsumerWidget {
  const RiderHistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ctrl = ref.read(appProvider.notifier);
    final t = ref.watch(appProvider).t;
    final role = context.roleColor;
    final rows = [
      ('#TK-899', 'Tanvir Ahmed', 'Banani Block D', '৳50', '12:42', meals[1].img),
      ('#TK-898', 'Sabbir Hossain', 'Gulshan 2', '৳55', '12:18', meals[0].img),
      ('#TK-897', 'Mitu Akter', 'Mirpur 10', '৳45', '11:55', meals[2].img),
      ('#TK-896', 'Rafiul Islam', 'Uttara Sector 7', '৳60', '11:20', meals[4].img),
      ('#TK-895', 'Nusrat Jahan', 'Navana Tower', '৳55', '10:48', meals[2].img),
      ('#TK-894', 'Farhan Kabir', 'Dhanmondi 27', '৳50', '10:15', meals[1].img),
    ];
    return Theme(
      data: Theme.of(context).copyWith(extensions: [const StRoleTheme(role: StColors.rider)]),
      child: StScreen(
        title: t('Completed Today', 'আজ সম্পন্ন'),
        actions: [
          StIconBtn(icon: Icons.account_balance_wallet_outlined, label: 'Earnings', onTap: () => ctrl.go('R-08')),
        ],
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AppReveal(
              index: 0,
              child: StCard(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _Stat(
                      label: t('Trips', 'ট্রিপ'),
                      child: AppCountUp(value: 12, style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: role)),
                    ),
                    _Stat(
                      label: t('Earned', 'আয়'),
                      child: AppCountUp(
                        value: 650,
                        format: (v) => '৳${v.round()}',
                        style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: role),
                      ),
                    ),
                    _Stat(
                      label: t('On-time', 'সময়মতো'),
                      child: Text('100%', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: StColors.success)),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            AppReveal(
              index: 1,
              child: Text(t('Deliveries', 'ডেলিভারি'), style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15)),
            ),
            const SizedBox(height: 8),
            for (var i = 0; i < rows.length; i++)
              AppReveal(
                index: i + 2,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: StCard(
                    onTap: () => ctrl.go('R-04'),
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(14),
                          child: Image.asset(
                            rows[i].$6,
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
                              Text(rows[i].$1, style: TextStyle(fontSize: 12, color: Theme.of(context).hintColor, fontWeight: FontWeight.w700)),
                              Text(rows[i].$2, style: const TextStyle(fontWeight: FontWeight.w700), maxLines: 1, overflow: TextOverflow.ellipsis),
                              Text(rows[i].$3, style: TextStyle(fontSize: 12, color: Theme.of(context).hintColor)),
                            ],
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(rows[i].$4, style: TextStyle(fontWeight: FontWeight.w800, color: role)),
                            Text(rows[i].$5, style: TextStyle(fontSize: 12, color: Theme.of(context).hintColor)),
                          ],
                        ),
                      ],
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

class _Stat extends StatelessWidget {
  const _Stat({required this.label, required this.child});
  final String label;
  final Widget child;

  @override
  Widget build(BuildContext context) => Column(
        children: [
          child,
          const SizedBox(height: 2),
          Text(label, style: TextStyle(fontSize: 11, color: Theme.of(context).hintColor)),
        ],
      );
}
