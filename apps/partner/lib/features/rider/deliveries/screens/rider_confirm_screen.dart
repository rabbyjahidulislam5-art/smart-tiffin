import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:st_design_system/st_design_system.dart';
import 'package:st_shell/st_shell.dart';

class RiderConfirmScreen extends ConsumerStatefulWidget {
  const RiderConfirmScreen({super.key});
  @override
  ConsumerState<RiderConfirmScreen> createState() => _RiderConfirmScreenState();
}

class _RiderConfirmScreenState extends ConsumerState<RiderConfirmScreen> {
  String _method = 'handover';
  final _note = TextEditingController();
  bool _photo = false;

  @override
  void dispose() {
    _note.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ctrl = ref.read(appProvider.notifier);
    final t = ref.watch(appProvider).t;
    final role = context.roleColor;
    final options = [
      ('handover', t('Handed to customer', 'গ্রাহকের হাতে'), Icons.handshake_outlined),
      ('doorstep', t('Left at doorstep', 'দরজায় রেখেছি'), Icons.door_front_door_outlined),
      ('security', t('Left with security', 'সিকিউরিটিতে'), Icons.security_outlined),
    ];
    return Theme(
      data: Theme.of(context).copyWith(extensions: [const StRoleTheme(role: StColors.rider)]),
      child: StScreen(
        title: t('Confirm Delivery', 'ডেলিভারি নিশ্চিত'),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AppReveal(
              index: 0,
              child: StCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('#TK-911 · Tanvir Ahmed', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16)),
                    Text('House 42, Road 11, Block D · Banani', style: TextStyle(fontSize: 12, color: Theme.of(context).hintColor)),
                    const SizedBox(height: 8),
                    Text('2× Classic Bengali Homestyle Thali', style: TextStyle(fontSize: 13, color: Theme.of(context).hintColor)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            AppReveal(
              index: 1,
              child: Text(t('How was it delivered?', 'কীভাবে পৌঁছাল?'), style: const TextStyle(fontWeight: FontWeight.w700)),
            ),
            const SizedBox(height: 8),
            for (var i = 0; i < options.length; i++)
              AppReveal(
                index: i + 2,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: InkWell(
                    onTap: () => setState(() => _method = options[i].$1),
                    child: Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: _method == options[i].$1 ? role : Theme.of(context).dividerColor,
                          width: _method == options[i].$1 ? 2 : 1,
                        ),
                        color: _method == options[i].$1 ? role.withValues(alpha: 0.06) : null,
                      ),
                      child: Row(
                        children: [
                          Icon(options[i].$3, color: _method == options[i].$1 ? role : Theme.of(context).hintColor),
                          const SizedBox(width: 12),
                          Expanded(child: Text(options[i].$2, style: const TextStyle(fontWeight: FontWeight.w600))),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            if (_method != 'handover') ...[
              const SizedBox(height: 8),
              StField(
                label: t('Optional note', 'ঐচ্ছিক নোট'),
                controller: _note,
                placeholder: t('e.g. Hooked on door', 'যেমন দরজায় ঝুলিয়েছি'),
              ),
            ],
            const SizedBox(height: 8),
            AppReveal(
              index: 5,
              child: InkWell(
                onTap: () => setState(() {
                  _photo = true;
                  ctrl.toast(t('Photo attached (demo)', 'ছবি যোগ হয়েছে'));
                }),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Theme.of(context).dividerColor),
                  ),
                  child: Row(
                    children: [
                      Icon(_photo ? Icons.check_circle : Icons.photo_camera_outlined, color: _photo ? StColors.success : Theme.of(context).hintColor),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          _photo ? t('Photo attached', 'ছবি যোগ হয়েছে') : t('Photo proof (optional)', 'ছবির প্রমাণ (ঐচ্ছিক)'),
                          style: const TextStyle(fontWeight: FontWeight.w600),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            AppReveal(
              index: 6,
              child: StBtn(
                label: t('Mark as Delivered', 'ডেলিভারি সম্পন্ন'),
                full: true,
                size: StBtnSize.lg,
                icon: Icons.verified_outlined,
                onTap: () {
                  ctrl.patchStore((st) => st.copyWith(riderStep: 3));
                  ctrl.go('R-04');
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
