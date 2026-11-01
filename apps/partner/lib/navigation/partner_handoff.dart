import 'package:flutter/material.dart';
import 'package:st_domain/st_domain.dart';
import 'package:st_shell/st_shell.dart';

/// Customer sign-up lives in the Customer app (AU-07, AU-08): the Partner
/// app's AU-12 "customer" choice shows this hand-off instead of a route.
Widget? partnerHandoffFor(String id) {
  if (id != 'AU-07' && id != 'AU-08') return null;
  return const StHandoffSheet(
    icon: Icons.restaurant_menu_rounded,
    title: StText('Order in the Customer app', 'কাস্টমার অ্যাপে অর্ডার করুন'),
    body: StText(
      'Customer accounts are created in the Smart Tiffin Customer app. This app is for suppliers and riders.',
      'কাস্টমার অ্যাকাউন্ট স্মার্ট টিফিন কাস্টমার অ্যাপে খোলা হয়। এই অ্যাপ সরবরাহকারী ও রাইডারদের জন্য।',
    ),
    openLabel: StText('Open the Customer app', 'কাস্টমার অ্যাপ খুলুন'),
  );
}
