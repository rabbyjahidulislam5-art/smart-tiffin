import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:st_design_system/st_design_system.dart';
import 'package:st_shell/st_shell.dart';

class EditProfileScreen extends ConsumerStatefulWidget {
  const EditProfileScreen({super.key});
  @override
  ConsumerState<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  late final TextEditingController name;
  late final TextEditingController phone;

  @override
  void initState() {
    super.initState();
    name = TextEditingController(text: 'Tanvir Ahmed');
    phone = TextEditingController(text: '+880 17XXXXX401');
  }

  @override
  void dispose() {
    name.dispose();
    phone.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ctrl = ref.read(appProvider.notifier);
    final t = ref.watch(appProvider).t;
    return StScreen(
      title: t('Edit profile', 'প্রোফাইল সম্পাদনা'),
      footer: StBtn(
        label: t('Save changes', 'সংরক্ষণ'),
        full: true,
        size: StBtnSize.lg,
        icon: Icons.check_rounded,
        onTap: () {
          ctrl.toast(t('Profile updated', 'প্রোফাইল আপডেট'));
          ctrl.back();
        },
      ),
      child: Column(
        children: [
          AppReveal(
            index: 0,
            child: Column(
              children: [
                const StAvatar(name: 'Tanvir Ahmed', size: 80),
                const SizedBox(height: 8),
                StBtn(
                  label: t('Change photo', 'ছবি বদলান'),
                  variant: StBtnVariant.soft,
                  size: StBtnSize.sm,
                  icon: Icons.photo_camera_outlined,
                  onTap: () => ctrl.toast(t('Photo picker (sample)', 'ছবি নির্বাচন')),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          AppReveal(index: 1, child: StField(label: t('Full name', 'পূর্ণ নাম'), controller: name)),
          const SizedBox(height: 12),
          AppReveal(index: 2, child: StField(label: t('Phone', 'ফোন'), controller: phone, keyboardType: TextInputType.phone)),
          const SizedBox(height: 12),
          AppReveal(
            index: 3,
            child: StField(
              label: t('Email', 'ইমেইল'),
              placeholder: 'tanvir@example.com',
              enabled: false,
              hint: t('Verified — contact support to change', 'যাচাইকৃত — বদলাতে সাপোর্টে যোগাযোগ'),
            ),
          ),
          const SizedBox(height: 12),
          AppReveal(
            index: 4,
            child: StNote(child: Text(t('Your name shows on deliveries and support tickets.', 'ডেলিভারি ও সাপোর্ট টিকেটে নাম দেখা যায়।'))),
          ),
        ],
      ),
    );
  }
}
