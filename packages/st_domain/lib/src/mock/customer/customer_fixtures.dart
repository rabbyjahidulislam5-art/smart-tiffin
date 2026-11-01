import '../../models/catalogue/st_img.dart';
import '../../models/customer/kitchen_review.dart';
import '../../models/customer/kitchen_summary.dart';
import '../../models/customer/menu_item.dart';
import '../../result/slot.dart';

/// Published kitchens (sample). Names and meals come from the legacy catalogue.
const publishedKitchens = <KitchenSummary>[
  KitchenSummary(id: 'maas-kitchen', nameEn: "Maa's Kitchen", nameBn: 'মায়ের কিচেন', img: StImg.biryani, verified: true, rating: 4.9, ratingCount: 140, slots: {Slot.lunch, Slot.dinner}, cuisine: 'biryani', dietary: {'halal'}, zones: {'Banani', 'Gulshan', 'Mohakhali'}, accepting: true),
  KitchenSummary(id: 'rinas-kitchen', nameEn: "Rina's Kitchen", nameBn: 'রিনার কিচেন', img: StImg.thali, verified: true, rating: 4.8, ratingCount: 212, slots: {Slot.lunch, Slot.dinner}, cuisine: 'bengali', dietary: {'halal', 'diet'}, zones: {'Banani', 'Gulshan', 'Dhanmondi'}, accepting: true),
  KitchenSummary(id: 'dhaka-tiffin', nameEn: 'Dhaka Tiffin Co.', nameBn: 'ঢাকা টিফিন কোং', img: StImg.beef, verified: false, rating: 4.8, ratingCount: 77, slots: {Slot.lunch}, cuisine: 'beef', dietary: {'halal'}, zones: {'Dhanmondi', 'Mohakhali'}, accepting: false),
  KitchenSummary(id: 'gulshan-bites', nameEn: 'Gulshan Home Bites', nameBn: 'গুলশান হোম বাইটস', img: StImg.khichuri, verified: true, rating: 4.6, ratingCount: 58, slots: {Slot.breakfast, Slot.lunch}, cuisine: 'bengali', dietary: {'diet'}, zones: {'Gulshan', 'Banani'}, accepting: true),
  KitchenSummary(id: 'uttara-diet', nameEn: 'Uttara Diet Kitchen', nameBn: 'উত্তরা ডায়েট কিচেন', img: StImg.roti, verified: true, rating: 4.5, ratingCount: 31, slots: {Slot.lunch, Slot.dinner}, cuisine: 'diet', dietary: {'diet'}, zones: {'Uttara'}, accepting: true),
];

/// Kitchens that exist but are not published (pending review): not viewable.
const unpublishedKitchenIds = {'sultana', 'ctg'};

/// Current menu items per kitchen (current price version).
const menuItems = <MenuItem>[
  MenuItem(id: 'mk-biryani', kitchenId: 'maas-kitchen', mealId: 'biryani', slot: Slot.lunch, priceMinor: 18000, available: true),
  MenuItem(id: 'mk-biryani-d', kitchenId: 'maas-kitchen', mealId: 'biryani', slot: Slot.dinner, priceMinor: 18000, available: true),
  MenuItem(id: 'rk-thali', kitchenId: 'rinas-kitchen', mealId: 'thali', slot: Slot.lunch, priceMinor: 18000, available: true),
  MenuItem(id: 'rk-khichuri', kitchenId: 'rinas-kitchen', mealId: 'khichuri', slot: Slot.lunch, priceMinor: 16000, available: true),
  MenuItem(id: 'rk-roti', kitchenId: 'rinas-kitchen', mealId: 'roti', slot: Slot.dinner, priceMinor: 20000, available: false),
  MenuItem(id: 'rk-thali-d', kitchenId: 'rinas-kitchen', mealId: 'thali', slot: Slot.dinner, priceMinor: 18000, available: true),
  MenuItem(id: 'dt-beef', kitchenId: 'dhaka-tiffin', mealId: 'beef', slot: Slot.lunch, priceMinor: 24000, available: true),
  MenuItem(id: 'gb-khichuri', kitchenId: 'gulshan-bites', mealId: 'khichuri', slot: Slot.breakfast, priceMinor: 14000, available: true),
  MenuItem(id: 'gb-thali', kitchenId: 'gulshan-bites', mealId: 'thali', slot: Slot.lunch, priceMinor: 17000, available: true),
  MenuItem(id: 'ud-khichuri', kitchenId: 'uttara-diet', mealId: 'khichuri', slot: Slot.lunch, priceMinor: 15000, available: true),
  MenuItem(id: 'ud-roti', kitchenId: 'uttara-diet', mealId: 'roti', slot: Slot.dinner, priceMinor: 19000, available: true),
];

MenuItem? menuItemById(String id) {
  for (final m in menuItems) {
    if (m.id == id) return m;
  }
  return null;
}

/// Service dates published by every kitchen; [mockToday] has passed its cutoff.
const publishedDates = ['2026-11-02', '2026-11-03', '2026-11-04', '2026-11-05', '2026-11-06', '2026-11-07'];

const reviewFixtures = <KitchenReview>[
  KitchenReview(author: 'Tanvir', rating: 5, textEn: 'Tastes like home, always on time.', textBn: 'ঘরের মতো স্বাদ, সবসময় সময়মতো।', ago: '2d'),
  KitchenReview(author: 'Nusrat', rating: 4, textEn: 'Good portions, a little spicy.', textBn: 'পরিমাণ ভালো, একটু ঝাল।', ago: '5d'),
  KitchenReview(author: 'Arif', rating: 5, textEn: 'Clean packing, fresh rice.', textBn: 'পরিষ্কার প্যাকিং, তাজা ভাত।', ago: '1w'),
  KitchenReview(author: 'Rumana', rating: 4, textEn: 'Dal could be thicker.', textBn: 'ডাল আরেকটু ঘন হতে পারে।', ago: '2w'),
  KitchenReview(author: 'Habib', rating: 5, textEn: 'Best office lunch in Gulshan.', textBn: 'গুলশানের সেরা অফিস লাঞ্চ।', ago: '3w'),
];
