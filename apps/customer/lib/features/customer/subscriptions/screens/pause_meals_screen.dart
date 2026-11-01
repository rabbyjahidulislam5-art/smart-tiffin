import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:st_design_system/st_design_system.dart';
import 'package:st_domain/st_domain.dart';
import 'package:st_shell/st_shell.dart';

class PauseMealsScreen extends ConsumerStatefulWidget {
  const PauseMealsScreen({super.key});

  @override
  ConsumerState<PauseMealsScreen> createState() => _PauseMealsScreenState();
}

class _PauseMealsScreenState extends ConsumerState<PauseMealsScreen> {
  final from = TextEditingController(text: '2026-11-01');
  final to = TextEditingController(text: '2026-11-05');
  var reason = 'travel';

  @override
  void dispose() {
    from.dispose();
    to.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ctrl = ref.read(appProvider.notifier);
    final t = ref.watch(appProvider).t;
    final paused = ref.watch(appProvider).store.paused;

    return StScreen(
      title: t('Pause meals', 'খাবার বিরতি'),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AppReveal(
            index: 0,
            child: StCard(
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
                        Text(t('Monthly Homemade Package', 'মাসিক ঘরোয়া প্যাকেজ'), style: const TextStyle(fontWeight: FontWeight.w800)),
                        Text(
                          paused ? t('Currently paused', 'এখন বিরতিতে') : t('Active · 22 meals remaining', 'সক্রিয় · ২২ মিল বাকি'),
                          style: TextStyle(fontSize: 12, color: Theme.of(context).hintColor),
                        ),
                      ],
                    ),
                  ),
                  StChip(
                    tone: paused ? StTone.warning : StTone.success,
                    child: Text(paused ? t('Paused', 'বিরতি') : t('Active', 'সক্রিয়')),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          AppReveal(index: 1, child: StField(label: t('From', 'থেকে'), controller: from)),
          const SizedBox(height: 12),
          AppReveal(index: 2, child: StField(label: t('To', 'পর্যন্ত'), controller: to)),
          const SizedBox(height: 12),
          AppReveal(
            index: 3,
            child: StCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(t('Reason', 'কারণ'), style: const TextStyle(fontWeight: FontWeight.w700)),
                  const SizedBox(height: 8),
                  StSegmented(
                    options: [
                      (v: 'travel', l: t('Travel', 'ভ্রমণ')),
                      (v: 'sick', l: t('Sick', 'অসুস্থ')),
                      (v: 'other', l: t('Other', 'অন্য')),
                    ],
                    value: reason,
                    onChanged: (v) => setState(() => reason = v),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          AppReveal(index: 4, child: const StPolicy()),
          const SizedBox(height: 12),
          AppReveal(
            index: 5,
            child: StNote(
              child: Text(
                t('Paused days credit back to your plan. Cutoff is 8pm the night before.', 'বিরতির দিন প্ল্যানে ফেরত যায়। কাটঅফ আগের রাত ৮টা।'),
              ),
            ),
          ),
          const SizedBox(height: 16),
          AppReveal(
            index: 6,
            child: StBtn(
              label: paused ? t('Update pause', 'বিরতি আপডেট') : t('Confirm pause', 'বিরতি নিশ্চিত'),
              full: true,
              size: StBtnSize.lg,
              onTap: () {
                ctrl.showConfirm(
                  ConfirmOpts(
                    title: t('Pause meals?', 'খাবার বিরতি?'),
                    body: t('${from.text} → ${to.text}', '${from.text} → ${to.text}'),
                    ok: t('Pause', 'বিরতি'),
                    onOk: () {
                      ctrl.patchStore((st) => st.copyWith(paused: true));
                      ctrl.toast(t('Meals paused', 'খাবার বিরতিতে'));
                      ctrl.back();
                    },
                  ),
                );
              },
            ),
          ),
          if (paused) ...[
            const SizedBox(height: 8),
            AppReveal(
              index: 7,
              child: StBtn(
                label: t('Resume now', 'এখন চালু'),
                full: true,
                variant: StBtnVariant.outline,
                onTap: () {
                  ctrl.patchStore((st) => st.copyWith(paused: false));
                  ctrl.toast(t('Meals resumed', 'খাবার আবার চালু'));
                  ctrl.back();
                },
              ),
            ),
          ],
        ],
      ),
    );
  }
}
