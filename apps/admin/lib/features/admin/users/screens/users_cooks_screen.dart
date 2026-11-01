import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:st_design_system/st_design_system.dart';
import 'package:st_domain/st_domain.dart';
import 'package:st_shell/st_shell.dart';

class UsersCooksScreen extends ConsumerStatefulWidget {
  const UsersCooksScreen({super.key});
  @override
  ConsumerState<UsersCooksScreen> createState() => _UsersCooksScreenState();
}

class _UsersCooksScreenState extends ConsumerState<UsersCooksScreen> {
  String q = '';
  String tab = 'all';

  @override
  Widget build(BuildContext context) {
    final ctrl = ref.read(appProvider.notifier);
    final t = ref.watch(appProvider).t;
    final users = [
      (id: 'u1', n: 'Nadia Islam', s: t('Admin', 'অ্যাডমিন'), k: 'admin', img: null as String?),
      (id: 'u2', n: 'Tanvir Ahmed', s: t('Customer · Banani', 'গ্রাহক · বনানী'), k: 'customer', img: meals[1].img),
      (id: 'u3', n: "Rina's Kitchen", s: t('Cook · Moghbazar', 'রাঁধুনি · মগবাজার'), k: 'cook', img: meals[2].img),
      (id: 'u4', n: "Maa's Kitchen", s: t('Cook · Mirpur', 'রাঁধুনি · মিরপুর'), k: 'cook', img: meals[0].img),
      (id: 'u5', n: 'Rokon Talukder', s: t('Rider · on duty', 'রাইডার · ডিউটিতে'), k: 'rider', img: meals[4].img),
      (id: 'u6', n: 'Farhana Khan', s: t('Customer · Gulshan', 'গ্রাহক · গুলশান'), k: 'customer', img: meals[3].img),
    ];
    final list = users.where((u) => tab == 'all' || u.k == tab).where((u) => q.isEmpty || u.n.toLowerCase().contains(q.toLowerCase())).toList();
    return Theme(
      data: Theme.of(context).copyWith(extensions: [const StRoleTheme(role: StColors.admin)]),
      child: StScreen(
        title: t('Users & Cooks', 'ইউজার ও রাঁধুনি'),
        back: false,
        actions: [StIconBtn(icon: Icons.badge_outlined, label: 'Onboarding', onTap: () => ctrl.go('A-06'))],
        child: Column(
          children: [
            AppReveal(
              index: 0,
              child: StCard(
                child: Row(
                  children: [
                    Expanded(child: Text(t('${users.length} accounts', '${users.length} অ্যাকাউন্ট'), style: const TextStyle(fontWeight: FontWeight.w800))),
                    StChip(tone: StTone.info, child: Text(t('2 cooks live', '২ রাঁধুনি লাইভ'))),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10),
            AppReveal(
              index: 1,
              child: StField(label: t('Search', 'খুঁজুন'), placeholder: t('Name…', 'নাম…'), onChanged: (v) => setState(() => q = v)),
            ),
            const SizedBox(height: 10),
            AppReveal(
              index: 2,
              child: StChipRow(
                options: [
                  (v: 'all', l: t('All', 'সব')),
                  (v: 'customer', l: t('Customers', 'গ্রাহক')),
                  (v: 'cook', l: t('Cooks', 'রাঁধুনি')),
                  (v: 'rider', l: t('Riders', 'রাইডার')),
                ],
                value: tab,
                onChanged: (v) => setState(() => tab = v),
              ),
            ),
            const SizedBox(height: 12),
            if (list.isEmpty)
              Padding(padding: const EdgeInsets.symmetric(vertical: 40), child: Text(t('No matches', 'মিল নেই'), style: TextStyle(color: Theme.of(context).hintColor)))
            else
              for (var i = 0; i < list.length; i++)
                AppReveal(
                  index: i + 3,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: StCard(
                      onTap: () => ctrl.go('A-09', {'id': list[i].id}),
                      child: Row(
                        children: [
                          if (list[i].img != null)
                            ClipRRect(
                              borderRadius: BorderRadius.circular(14),
                              child: Image.asset(
                                list[i].img!,
                                width: 48,
                                height: 48,
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) => StAvatar(name: list[i].n),
                              ),
                            )
                          else
                            StAvatar(name: list[i].n),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(list[i].n, style: const TextStyle(fontWeight: FontWeight.w800)),
                                Text(list[i].s, style: TextStyle(fontSize: 12, color: Theme.of(context).hintColor)),
                              ],
                            ),
                          ),
                          Icon(Icons.chevron_right, color: Theme.of(context).hintColor),
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
