import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:st_design_system/st_design_system.dart';
import 'package:st_domain/st_domain.dart';
import 'package:st_shell/st_shell.dart';

class ReportProblemScreen extends ConsumerStatefulWidget {
  const ReportProblemScreen({super.key});
  @override
  ConsumerState<ReportProblemScreen> createState() => _ReportProblemScreenState();
}

class _ReportProblemScreenState extends ConsumerState<ReportProblemScreen> {
  String topic = 'order';
  final note = TextEditingController();

  @override
  void dispose() {
    note.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final s = ref.watch(appProvider);
    final ctrl = ref.read(appProvider.notifier);
    final t = s.t;
    final role = context.roleColor;
    final refId = s.current.params['ref'];
    final topics = [
      ('order', t('Order / delivery', 'অর্ডার / ডেলিভারি'), Icons.local_shipping_outlined),
      ('pay', t('Payment / billing', 'পেমেন্ট / বিলিং'), Icons.payments_outlined),
      ('app', t('App bug', 'অ্যাপ বাগ'), Icons.bug_report_outlined),
      ('other', t('Other', 'অন্যান্য'), Icons.more_horiz),
    ];
    return StScreen(
      title: t('Report a problem', 'সমস্যা জানান'),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (refId != null) ...[
            AppReveal(index: 0, child: StNote(child: Text('${t('Reference', 'রেফারেন্স')}: $refId'))),
            const SizedBox(height: 12),
          ],
          AppReveal(
            index: 1,
            child: StCard(
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(14),
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
                    child: Text(
                      t('Attach meal or order context when it helps support reply faster.', 'খাবার বা অর্ডারের প্রসঙ্গ দিলে সাপোর্ট দ্রুত উত্তর দিতে পারে।'),
                      style: TextStyle(fontSize: 13, color: Theme.of(context).hintColor),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 14),
          AppReveal(index: 2, child: Text(t('Topic', 'বিষয়'), style: const TextStyle(fontWeight: FontWeight.w700))),
          const SizedBox(height: 8),
          for (var i = 0; i < topics.length; i++)
            AppReveal(
              index: i + 3,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: InkWell(
                  onTap: () => setState(() => topic = topics[i].$1),
                  child: Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: topic == topics[i].$1 ? role : Theme.of(context).dividerColor, width: topic == topics[i].$1 ? 2 : 1),
                      color: topic == topics[i].$1 ? role.withValues(alpha: 0.06) : null,
                    ),
                    child: Row(
                      children: [
                        Icon(topics[i].$3, color: topic == topics[i].$1 ? role : Theme.of(context).hintColor),
                        const SizedBox(width: 12),
                        Expanded(child: Text(topics[i].$2, style: const TextStyle(fontWeight: FontWeight.w600))),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          AppReveal(
            index: 7,
            child: StField(
              label: t('Describe the issue', 'সমস্যা লিখুন'),
              controller: note,
              maxLines: 4,
              placeholder: t('What happened?', 'কী হয়েছে?'),
            ),
          ),
          const SizedBox(height: 16),
          AppReveal(
            index: 8,
            child: StBtn(
              label: t('Submit ticket', 'টিকেট পাঠান'),
              full: true,
              size: StBtnSize.lg,
              icon: Icons.send_outlined,
              onTap: () {
                ctrl.toast(t('Ticket ST-T-884 opened', 'টিকেট ST-T-884 খোলা'));
                ctrl.go('SH-07');
              },
            ),
          ),
        ],
      ),
    );
  }
}
