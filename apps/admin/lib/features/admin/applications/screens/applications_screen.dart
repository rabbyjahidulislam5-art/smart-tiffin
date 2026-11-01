import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:st_design_system/st_design_system.dart';
import 'package:st_domain/st_domain.dart';
import 'package:st_shell/st_shell.dart';

class ApplicationsScreen extends ConsumerStatefulWidget {
  const ApplicationsScreen({super.key});
  @override
  ConsumerState<ApplicationsScreen> createState() => _ApplicationsScreenState();
}

class _ApplicationsScreenState extends ConsumerState<ApplicationsScreen> {
  String tab = 'all';

  @override
  Widget build(BuildContext context) {
    final s = ref.watch(appProvider);
    final ctrl = ref.read(appProvider.notifier);
    final t = s.t;
    final role = context.roleColor;
    var list = allApplicantsOf(s.store);
    if (tab == 'cook') list = list.where((a) => a.kind == 'Cook').toList();
    if (tab == 'rider') list = list.where((a) => a.kind == 'Rider').toList();
    final pending = list.where((a) => appStatusOf(s.store, a.id) == AppStatus.pending).length;
    return Theme(
      data: Theme.of(context).copyWith(extensions: [const StRoleTheme(role: StColors.admin)]),
      child: StScreen(
        title: t('Applications', 'আবেদন'),
        child: Column(
          children: [
            AppReveal(
              index: 0,
              child: StCard(
                child: Row(
                  children: [
                    Expanded(child: Text(t('$pending awaiting review', '$pending পর্যালোচনায়'), style: const TextStyle(fontWeight: FontWeight.w800))),
                    StChip(tone: pending > 0 ? StTone.warning : StTone.success, child: Text('$pending')),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            AppReveal(
              index: 1,
              child: StSegmented(
                options: [
                  (v: 'all', l: t('All', 'সব')),
                  (v: 'cook', l: t('Cooks', 'রাঁধুনি')),
                  (v: 'rider', l: t('Riders', 'রাইডার')),
                ],
                value: tab,
                onChanged: (v) => setState(() => tab = v),
              ),
            ),
            const SizedBox(height: 12),
            for (var i = 0; i < list.length; i++)
              AppReveal(
                index: i + 2,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: StCard(
                    onTap: () => ctrl.go('A-07', {'id': list[i].id}),
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(14),
                          child: Image.asset(
                            list[i].kind == 'Rider' ? meals[4].img : meals[i % meals.length].img,
                            width: 48,
                            height: 48,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => Container(
                              width: 48,
                              height: 48,
                              color: role.withValues(alpha: 0.1),
                              child: Icon(list[i].kind == 'Rider' ? Icons.two_wheeler : Icons.soup_kitchen, color: role),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(list[i].name, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
                              Text('${list[i].kind} · ${list[i].area} · ${list[i].ago}', style: TextStyle(fontSize: 12, color: Theme.of(context).hintColor), maxLines: 1, overflow: TextOverflow.ellipsis),
                            ],
                          ),
                        ),
                        StChip(
                          tone: switch (appStatusOf(s.store, list[i].id)) {
                            AppStatus.approved => StTone.success,
                            AppStatus.rejected => StTone.danger,
                            AppStatus.info => StTone.warning,
                            _ => StTone.muted,
                          },
                          child: Text(appStatusOf(s.store, list[i].id).name),
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
