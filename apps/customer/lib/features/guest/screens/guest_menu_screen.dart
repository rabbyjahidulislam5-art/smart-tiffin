import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:st_design_system/st_design_system.dart';
import 'package:st_domain/st_domain.dart';
import 'package:st_shell/st_shell.dart';
import '../widgets/guest_nav.dart';

class GuestMenuScreen extends ConsumerStatefulWidget {
  const GuestMenuScreen({super.key});

  @override
  ConsumerState<GuestMenuScreen> createState() => _GuestMenuScreenState();
}

class _GuestMenuScreenState extends ConsumerState<GuestMenuScreen> {
  late String tab;
  String q = '';
  String cat = 'all';

  @override
  void initState() {
    super.initState();
    tab = ref.read(appProvider).current.params['tab'] ?? 'meals';
  }

  void protect(String id, [Map<String, String>? p]) =>
      showSignInPrompt(ref, intent: NavEntry(id, p ?? {})); // LC-10

  void openMeal(Meal m) {
    final ctrl = ref.read(appProvider.notifier);
    final t = ref.read(appProvider).t;
    final role = context.roleColor;
    ctrl.showSheet(
      Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: Image.asset(
              m.img,
              height: 176,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(height: 176, color: StColors.muted),
            ),
          ),
          const SizedBox(height: 10),
          Text(m.kitchen, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Theme.of(context).hintColor)),
          Text(t(m.en, m.bn), style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 18)),
          const SizedBox(height: 4),
          Text(t(m.desc, m.descBn), style: TextStyle(color: Theme.of(context).hintColor, height: 1.35)),
          const SizedBox(height: 10),
          Row(
            children: [
              Text('BDT ${m.price}', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16, color: role)),
              const Spacer(),
              Icon(Icons.star_rounded, size: 16, color: StColors.warning),
              Text(' ${m.rating} (${m.reviews})', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
            ],
          ),
          if (m.badge != null) ...[
            const SizedBox(height: 8),
            Align(alignment: Alignment.centerLeft, child: StChip(tone: StTone.role, child: Text(m.badge!))),
          ],
          const SizedBox(height: 14),
          StBtn(
            label: t('Subscribe', 'সাবস্ক্রাইব'),
            full: true,
            size: StBtnSize.lg,
            icon: Icons.add,
            disabled: m.soldOut,
            onTap: () {
              ctrl.closeSheet();
              protect('C-11', {'meal': m.id});
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final s = ref.watch(appProvider);
    final ctrl = ref.read(appProvider.notifier);
    final t = s.t;
    final role = context.roleColor;
    final filtered = meals.where((m) {
      final hit = (m.en + m.bn + m.kitchen).toLowerCase().contains(q.toLowerCase());
      final catOk = cat == 'all' || m.cat == cat;
      return hit && catOk;
    }).toList();
    final kitchenNames = meals.map((m) => m.kitchen).toSet().toList();

    return StScreen(
      title: t('Menu & kitchens', 'মেনু ও কিচেন'),
      eyebrow: t('GUEST', 'অতিথি'),
      back: false,
      states: false,
      footer: const GuestNav(),
      actions: [
        StBtn(
          label: t('Sign in', 'সাইন ইন'),
          size: StBtnSize.sm,
          variant: StBtnVariant.soft,
          icon: Icons.login_rounded,
          onTap: () => ctrl.go('AU-03'),
        ),
      ],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AppReveal(
            index: 0,
            child: StSegmented(
              value: tab,
              onChanged: (v) => setState(() => tab = v),
              options: [
                (v: 'meals', l: t('Meals', 'খাবার')),
                (v: 'kitchens', l: t('Kitchens', 'কিচেন')),
              ],
            ),
          ),
          const SizedBox(height: 12),
          if (tab == 'meals') ...[
            AppReveal(
              index: 1,
              child: TextField(
                onChanged: (v) => setState(() => q = v),
                decoration: InputDecoration(
                  hintText: t('Search meals or kitchens', 'খাবার বা কিচেন খুঁজুন'),
                  prefixIcon: const Icon(Icons.search_rounded),
                  filled: true,
                  fillColor: Theme.of(context).brightness == Brightness.dark ? StColors.darkMuted : StColors.muted,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
                ),
              ),
            ),
            const SizedBox(height: 12),
            AppReveal(
              index: 2,
              child: StChipRow(
                options: [
                  (v: 'all', l: t('All', 'সব')),
                  (v: 'thali', l: t('Thali', 'থালি')),
                  (v: 'diet', l: t('Diet', 'ডায়েট')),
                  (v: 'office', l: t('Office', 'অফিস')),
                ],
                value: cat,
                onChanged: (v) => setState(() => cat = v),
              ),
            ),
            const SizedBox(height: 12),
            if (filtered.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 32),
                child: Text(
                  t('No meals match your search', 'কোনো খাবার পাওয়া যায়নি'),
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Theme.of(context).hintColor),
                ),
              )
            else
              for (var i = 0; i < filtered.length; i++)
                AppReveal(
                  index: i,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: StCard(
                      padding: EdgeInsets.zero,
                      onTap: () => openMeal(filtered[i]),
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: const BorderRadius.horizontal(left: Radius.circular(24)),
                            child: ColorFiltered(
                              colorFilter: filtered[i].soldOut
                                  ? const ColorFilter.matrix(<double>[
                                      0.2126, 0.7152, 0.0722, 0, 0,
                                      0.2126, 0.7152, 0.0722, 0, 0,
                                      0.2126, 0.7152, 0.0722, 0, 0,
                                      0, 0, 0, 1, 0,
                                    ])
                                  : const ColorFilter.mode(Colors.transparent, BlendMode.dst),
                              child: Image.asset(
                                filtered[i].img,
                                width: 96,
                                height: 96,
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) => Container(width: 96, height: 96, color: StColors.muted),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(filtered[i].kitchen, style: TextStyle(fontSize: 11, color: Theme.of(context).hintColor, fontWeight: FontWeight.w600)),
                                  Text(t(filtered[i].en, filtered[i].bn), style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 14), maxLines: 2, overflow: TextOverflow.ellipsis),
                                  const SizedBox(height: 4),
                                  Row(
                                    children: [
                                      Text('BDT ${filtered[i].price}', style: TextStyle(fontWeight: FontWeight.w800, color: role)),
                                      const Spacer(),
                                      Icon(Icons.star_rounded, size: 14, color: StColors.warning),
                                      Text(' ${filtered[i].rating}', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                                    ],
                                  ),
                                  if (filtered[i].soldOut)
                                    Text(t('Sold out today', 'আজ শেষ'), style: const TextStyle(fontSize: 11, color: StColors.danger, fontWeight: FontWeight.w700)),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
          ] else
            for (var i = 0; i < kitchenNames.length; i++)
              AppReveal(
                index: i,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Builder(
                    builder: (context) {
                      final name = kitchenNames[i];
                      final list = meals.where((m) => m.kitchen == name).toList();
                      final cover = list.first;
                      final best = list.map((m) => m.rating).reduce((a, b) => a > b ? a : b);
                      return StCard(
                        padding: EdgeInsets.zero,
                        onTap: () => protect('C-06', {'kitchen': name}),
                        child: Row(
                          children: [
                            ClipRRect(
                              borderRadius: const BorderRadius.horizontal(left: Radius.circular(24)),
                              child: Image.asset(
                                cover.img,
                                width: 88,
                                height: 88,
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) => Container(width: 88, height: 88, color: StColors.muted),
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(name, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15)),
                                    const SizedBox(height: 2),
                                    Text(
                                      '${list.length} ${t('meals', 'খাবার')} · ★$best',
                                      style: TextStyle(fontSize: 12, color: Theme.of(context).hintColor),
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      t('Sign in to open kitchen', 'কিচেন খুলতে সাইন ইন করুন'),
                                      style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: role),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 12),
                              child: Icon(Icons.chevron_right_rounded, color: Theme.of(context).hintColor),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}

