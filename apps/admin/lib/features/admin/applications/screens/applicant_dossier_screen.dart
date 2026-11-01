import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:st_design_system/st_design_system.dart';
import 'package:st_domain/st_domain.dart';
import 'package:st_shell/st_shell.dart';

class ApplicantDossierScreen extends ConsumerWidget {
  const ApplicantDossierScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = ref.watch(appProvider);
    final ctrl = ref.read(appProvider.notifier);
    final t = s.t;
    final id = s.current.params['id'] ?? 'sultana';
    final a = allApplicantsOf(s.store).firstWhere((x) => x.id == id, orElse: () => allApplicantsOf(s.store).first);
    final st = appStatusOf(s.store, a.id);
    final thumb = a.kind == 'Rider' ? meals[4].img : meals[1].img;
    return Theme(
      data: Theme.of(context).copyWith(extensions: [const StRoleTheme(role: StColors.admin)]),
      child: StScreen(
        title: a.name,
        eyebrow: '${a.kind.toUpperCase()} APPLICATION',
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AppReveal(
              index: 0,
              child: StCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Image.asset(
                            thumb,
                            width: 56,
                            height: 56,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => StAvatar(name: a.owner, size: 56),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(a.owner, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16)),
                              Text('${a.area} · ${a.cap}', style: TextStyle(fontSize: 12, color: Theme.of(context).hintColor)),
                              StChip(tone: StTone.info, child: Text(a.tier)),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(t('Submitted', 'জমা'), style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Theme.of(context).hintColor)),
                    Text(a.ago),
                    const SizedBox(height: 12),
                    Text(t('Documents', 'কাগজপত্র'), style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Theme.of(context).hintColor)),
                    for (final e in a.docs.entries)
                      Padding(
                        padding: const EdgeInsets.only(top: 6),
                        child: Row(
                          children: [
                            Expanded(child: Text(e.key.toUpperCase(), style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13))),
                            StChip(
                              tone: e.value.toLowerCase().contains('pass') ||
                                      e.value.toLowerCase().contains('verif') ||
                                      e.value.toLowerCase().contains('ok') ||
                                      e.value.toLowerCase().contains('not required')
                                  ? StTone.success
                                  : StTone.warning,
                              child: Text(e.value),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            if (st == AppStatus.pending) ...[
              AppReveal(
                index: 1,
                child: StBtn(
                  label: t('Approve', 'অনুমোদন'),
                  full: true,
                  size: StBtnSize.lg,
                  icon: Icons.check_circle_outline,
                  onTap: () => ctrl.showConfirm(
                    ConfirmOpts(
                      title: t('Approve ${a.name}?', '${a.name} অনুমোদন?'),
                      body: t('They get dashboard access immediately. Recorded in the audit log.', 'তারা সাথে সাথে ড্যাশবোর্ডে প্রবেশ পাবে। অডিট লগে রেকর্ড হবে।'),
                      ok: t('Approve', 'অনুমোদন'),
                      onOk: () {
                        ctrl.patchStore((store) => store.copyWith(approved: [...store.approved, a.id]));
                        ctrl.toast(t('Approved · audit logged', 'অনুমোদিত · অডিট লগ'));
                        ctrl.back();
                      },
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              AppReveal(
                index: 2,
                child: StBtn(
                  label: t('Request more info', 'আরও তথ্য চাই'),
                  full: true,
                  variant: StBtnVariant.soft,
                  onTap: () {
                    ctrl.patchStore((store) => store.copyWith(info: {...store.info, a.id: t('Please re-upload hygiene certificate', 'হাইজিন সার্টিফিকেট আবার আপলোড করুন')}));
                    ctrl.toast(t('Info requested', 'তথ্য চাওয়া হয়েছে'));
                  },
                ),
              ),
              const SizedBox(height: 8),
              AppReveal(
                index: 3,
                child: StBtn(
                  label: t('Reject', 'প্রত্যাখ্যান'),
                  full: true,
                  variant: StBtnVariant.outline,
                  onTap: () => ctrl.showConfirm(
                    ConfirmOpts(
                      title: t('Reject application?', 'আবেদন প্রত্যাখ্যান?'),
                      ok: t('Reject', 'প্রত্যাখ্যান'),
                      danger: true,
                      onOk: () {
                        ctrl.patchStore((store) => store.copyWith(rejected: [...store.rejected, a.id]));
                        ctrl.toast(t('Rejected · audit logged', 'প্রত্যাখ্যান · অডিট লগ'));
                        ctrl.back();
                      },
                    ),
                  ),
                ),
              ),
            ] else
              AppReveal(index: 1, child: StNote(child: Text('${t('Status', 'স্ট্যাটাস')}: ${st.name}'))),
          ],
        ),
      ),
    );
  }
}
