import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:st_design_system/st_design_system.dart';
import 'package:st_shell/st_shell.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future<void>.delayed(const Duration(milliseconds: 1400), () {
      if (!mounted) return;
      ref.read(appProvider.notifier).reset('AU-02');
    });
  }

  @override
  Widget build(BuildContext context) {
    final role = context.roleColor;
    return StScreen(
      title: '',
      back: false,
      states: false,
      child: SizedBox(
        height: MediaQuery.sizeOf(context).height * 0.7,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AppReveal(
              index: 0,
              child: StLogoMark(size: 96),
            ),
            const SizedBox(height: 16),
            AppReveal(
              index: 1,
              child: const Text('Smart Tiffin', style: TextStyle(fontSize: 28, fontWeight: FontWeight.w800)),
            ),
            const SizedBox(height: 6),
            AppReveal(
              index: 2,
              child: Text(
                'Homestyle meals, door to door',
                style: TextStyle(color: Theme.of(context).hintColor, fontWeight: FontWeight.w600),
              ),
            ),
            const SizedBox(height: 28),
            AppReveal(
              index: 3,
              child: SizedBox(
                width: 28,
                height: 28,
                child: CircularProgressIndicator(strokeWidth: 2.5, color: role),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
