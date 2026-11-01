import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:st_design_system/st_design_system.dart';
import 'package:st_domain/st_domain.dart';
import 'package:st_shell/st_shell.dart';
import '../widgets/guest_nav.dart';

class GuestHomeScreen extends ConsumerStatefulWidget {
  const GuestHomeScreen({super.key});

  @override
  ConsumerState<GuestHomeScreen> createState() => _GuestHomeScreenState();
}

class _GuestHomeScreenState extends ConsumerState<GuestHomeScreen> {
  String cat = 'all';

  void protect(String id, [Map<String, String>? p]) =>
      showSignInPrompt(ref, intent: NavEntry(id, p ?? {})); // LC-10

  @override
  Widget build(BuildContext context) {
    final s = ref.watch(appProvider);
    final ctrl = ref.read(appProvider.notifier);
    final t = s.t;
    final role = context.roleColor;
    final list = meals.where((m) => cat == 'all' || m.cat == cat).toList();

    return StScreen(
      title: t('Welcome to Smart Tiffin', 'স্মার্ট টিফিনে স্বাগতম'),
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(t('Hungry? 👋', 'ক্ষুধা লেগেছে? 👋'),
                    style: const TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.w800,
                        height: 1.15)),
                const SizedBox(height: 4),
                Text(
                  t('Browse homestyle meals from Dhaka kitchens.',
                      'ঢাকার ঘরোয়া কিচেনের খাবার দেখুন।'),
                  style: TextStyle(
                      fontSize: 14,
                      color: Theme.of(context).hintColor,
                      height: 1.35),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          AppReveal(
            index: 1,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(28),
              child: Stack(
                children: [
                  Positioned.fill(
                    child: Image.asset(
                      StImg.heroTiffin,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) =>
                          const ColoredBox(color: StColors.customer),
                    ),
                  ),
                  Positioned.fill(
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            role.withValues(alpha: 0.92),
                            StColors.warning.withValues(alpha: 0.88),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          t('HOMEMADE · DELIVERED HOT', 'ঘরোয়া · গরম গরম'),
                          style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 1.4,
                              color: Colors.white.withValues(alpha: 0.85)),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          t('Lunch & dinner from Dhaka home kitchens',
                              'ঢাকার ঘরোয়া কিচেন থেকে লাঞ্চ ও ডিনার'),
                          style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                              height: 1.2),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          t('Plans from ৳180/meal · 12 service areas',
                              'প্ল্যান ৳১৮০/খাবার থেকে · ১২টি এলাকা'),
                          style: TextStyle(
                              fontSize: 12,
                              color: Colors.white.withValues(alpha: 0.9)),
                        ),
                        const SizedBox(height: 14),
                        Row(
                          children: [
                            Expanded(
                              child: Material(
                                color: Colors.white.withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(99),
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(99),
                                  onTap: () => ctrl.go('P-03'),
                                  child: SizedBox(
                                    height: 44,
                                    child: Center(
                                        child: Text(
                                            t('See plans', 'প্ল্যান দেখুন'),
                                            style: const TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w700,
                                                fontSize: 13))),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Material(
                                color: Theme.of(context).cardColor,
                                borderRadius: BorderRadius.circular(99),
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(99),
                                  onTap: () => ctrl.go('AU-12'),
                                  child: SizedBox(
                                    height: 44,
                                    child: Center(
                                        child: Text(
                                            t('Create account',
                                                'অ্যাকাউন্ট খুলুন'),
                                            style: TextStyle(
                                                color: role,
                                                fontWeight: FontWeight.w700,
                                                fontSize: 13))),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 14),
          AppReveal(index: 2, child: const QuickActions(kind: 'guest')),
          const SizedBox(height: 16),
          AppReveal(
            index: 3,
            child: StSection(
              title: t("Today's Special Menu", 'আজকের বিশেষ মেনু'),
              action: t('See all', 'সব দেখুন'),
              onAction: () => ctrl.go('P-02'),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  StChipRow(
                    options: [
                      (v: 'all', l: t('All Items', 'সব')),
                      (v: 'thali', l: t('Bengali Thali', 'বাঙালি থালি')),
                      (v: 'diet', l: t('Diet & Keto', 'ডায়েট')),
                      (v: 'office', l: t('Office Lunch', 'অফিস লাঞ্চ')),
                    ],
                    value: cat,
                    onChanged: (v) => setState(() => cat = v),
                  ),
                  const SizedBox(height: 12),
                  if (list.isEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 28),
                      child: Text(
                          t('No meals in this category',
                              'এই ক্যাটাগরিতে খাবার নেই'),
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Theme.of(context).hintColor)),
                    )
                  else
                    SizedBox(
                      height: 268,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: list.length,
                        separatorBuilder: (_, __) => const SizedBox(width: 12),
                        itemBuilder: (context, i) {
                          final m = list[i];
                          return AppReveal(
                            index: i,
                            child: SizedBox(
                              width: 240,
                              child: _MealTile(
                                  meal: m,
                                  onSubscribe: () =>
                                      protect('C-11', {'meal': m.id})),
                            ),
                          );
                        },
                      ),
                    ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          AppReveal(
            index: 4,
            child: StCard(
              onTap: () => protect('C-18'),
              child: Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                        color: role.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(16)),
                    child: Icon(Icons.navigation_outlined, color: role),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(t('Track my order', 'অর্ডার ট্র্যাক করুন'),
                            style: const TextStyle(
                                fontWeight: FontWeight.w700, fontSize: 14)),
                        Text(
                            t('Sign in to see live delivery',
                                'লাইভ ডেলিভারি দেখতে সাইন ইন করুন'),
                            style: TextStyle(
                                fontSize: 12,
                                color: Theme.of(context).hintColor)),
                      ],
                    ),
                  ),
                  Icon(Icons.chevron_right, color: Theme.of(context).hintColor),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          AppReveal(
            index: 5,
            child: StSection(
              title: t('Join Smart Tiffin', 'স্মার্ট টিফিনে যোগ দিন'),
              child: StList(
                children: [
                  StRowTile(
                    icon: Icons.soup_kitchen_outlined,
                    label: t('Cook with us', 'আমাদের সাথে রান্না করুন'),
                    sub: t('Earn from your home kitchen',
                        'ঘরের কিচেন থেকে আয় করুন'),
                    onTap: () => ctrl.go('P-04', {'r': 'supplier'}),
                  ),
                  StRowTile(
                    icon: Icons.two_wheeler_outlined,
                    label: t('Deliver with us', 'আমাদের সাথে ডেলিভারি করুন'),
                    sub: t(
                        'Flexible lunch & dinner shifts', 'লাঞ্চ ও ডিনার শিফট'),
                    onTap: () => ctrl.go('P-04', {'r': 'rider'}),
                  ),
                  StRowTile(
                    icon: Icons.info_outline,
                    label: t('How it works', 'কীভাবে কাজ করে'),
                    onTap: () => ctrl.go('P-04', {'r': 'customer'}),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}

class _MealTile extends ConsumerWidget {
  const _MealTile({required this.meal, required this.onSubscribe});

  final Meal meal;
  final VoidCallback onSubscribe;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = ref.watch(appProvider).t;
    final ctrl = ref.read(appProvider.notifier);
    final role = context.roleColor;

    void openDetail() {
      ctrl.showSheet(
        Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: Image.asset(meal.img,
                  height: 176,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) =>
                      Container(height: 176, color: StColors.muted)),
            ),
            const SizedBox(height: 10),
            Text(meal.kitchen,
                style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).hintColor)),
            Text(t(meal.en, meal.bn),
                style:
                    const TextStyle(fontWeight: FontWeight.w800, fontSize: 18)),
            const SizedBox(height: 4),
            Text(t(meal.desc, meal.descBn),
                style: TextStyle(
                    color: Theme.of(context).hintColor, height: 1.35)),
            const SizedBox(height: 10),
            Row(
              children: [
                Text('BDT ${meal.price}',
                    style: TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 16,
                        color: role)),
                const Spacer(),
                Icon(Icons.star_rounded, size: 16, color: StColors.warning),
                Text(' ${meal.rating} (${meal.reviews})',
                    style: const TextStyle(
                        fontSize: 12, fontWeight: FontWeight.w600)),
              ],
            ),
            if (meal.badge != null) ...[
              const SizedBox(height: 8),
              Align(
                  alignment: Alignment.centerLeft,
                  child: StChip(tone: StTone.role, child: Text(meal.badge!))),
            ],
            const SizedBox(height: 14),
            StBtn(
              label: t('Subscribe', 'সাবস্ক্রাইব'),
              full: true,
              size: StBtnSize.lg,
              icon: Icons.add,
              disabled: meal.soldOut,
              onTap: () {
                ctrl.closeSheet();
                onSubscribe();
              },
            ),
          ],
        ),
      );
    }

    return StCard(
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          GestureDetector(
            onTap: openDetail,
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(24)),
                  child: ColorFiltered(
                    colorFilter: meal.soldOut
                        ? const ColorFilter.matrix(<double>[
                            0.2126,
                            0.7152,
                            0.0722,
                            0,
                            0,
                            0.2126,
                            0.7152,
                            0.0722,
                            0,
                            0,
                            0.2126,
                            0.7152,
                            0.0722,
                            0,
                            0,
                            0,
                            0,
                            0,
                            1,
                            0,
                          ])
                        : const ColorFilter.mode(
                            Colors.transparent, BlendMode.dst),
                    child: Image.asset(
                      meal.img,
                      height: 144,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) =>
                          Container(height: 144, color: StColors.muted),
                    ),
                  ),
                ),
                Positioned(
                  right: 8,
                  bottom: 8,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color:
                          Theme.of(context).cardColor.withValues(alpha: 0.92),
                      borderRadius: BorderRadius.circular(99),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.star_rounded,
                            size: 12, color: StColors.warning),
                        Text(' ${meal.rating}',
                            style: const TextStyle(
                                fontSize: 11, fontWeight: FontWeight.w800)),
                      ],
                    ),
                  ),
                ),
                if (meal.badge != null && !meal.soldOut)
                  Positioned(
                    left: 8,
                    top: 8,
                    child: StChip(tone: StTone.role, child: Text(meal.badge!)),
                  ),
                if (meal.soldOut)
                  Positioned.fill(
                    child: Center(
                        child: StChip(
                            tone: StTone.danger,
                            child: Text(t('Sold out', 'শেষ')))),
                  ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 10, 14, 4),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(meal.kitchen,
                    style: TextStyle(
                        fontSize: 11,
                        color: Theme.of(context).hintColor,
                        fontWeight: FontWeight.w600)),
                Text(t(meal.en, meal.bn),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontWeight: FontWeight.w700)),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 4, 14, 14),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    'BDT ${meal.price}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontWeight: FontWeight.w800),
                  ),
                ),
                const SizedBox(width: 8),
                StBtn(
                  label: t('Subscribe', 'সাবস্ক্রাইব'),
                  size: StBtnSize.sm,
                  icon: Icons.add,
                  disabled: meal.soldOut,
                  onTap: onSubscribe,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
