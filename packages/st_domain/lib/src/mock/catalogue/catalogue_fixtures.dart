import '../../models/catalogue/applicant.dart';
import '../../models/catalogue/meal.dart';
import '../../models/catalogue/order_req.dart';
import '../../models/catalogue/plan.dart';
import '../../models/catalogue/st_img.dart';

/// Mock catalog from Zite `proto/data.ts` — sample only, no backend.
const meals = <Meal>[
  Meal(
    id: 'biryani',
    en: 'Classic Chicken Biryani & Egg',
    bn: 'চিকেন বিরিয়ানি ও ডিম',
    kitchen: "Maa's Kitchen",
    price: 180,
    rating: 4.9,
    reviews: 140,
    img: StImg.biryani,
    cat: 'thali',
    badge: 'Bestseller',
    desc: 'Basmati rice, tender chicken, potato, boiled egg.',
    descBn: 'বাসমতি চাল, নরম মুরগি, আলু, সেদ্ধ ডিম।',
    spice: 2,
  ),
  Meal(
    id: 'thali',
    en: 'Bengali Homestyle Thali',
    bn: 'বাঙালি ঘরোয়া থালি',
    kitchen: "Rina's Kitchen",
    price: 180,
    rating: 4.8,
    reviews: 212,
    img: StImg.thali,
    cat: 'thali',
    badge: 'Chef Special',
    desc: 'Rice, dal, fish curry, seasonal bhaji.',
    descBn: 'ভাত, ডাল, মাছের তরকারি, মৌসুমি ভাজি।',
    spice: 1,
  ),
  Meal(
    id: 'khichuri',
    en: 'Bhuna Khichuri & Egg Curry',
    bn: 'ভুনা খিচুড়ি ও ডিম কারি',
    kitchen: "Rina's Kitchen",
    price: 160,
    rating: 4.7,
    reviews: 96,
    img: StImg.khichuri,
    cat: 'diet',
    desc: 'Moong dal khichuri with egg curry.',
    descBn: 'মুগ ডালের খিচুড়ি ও ডিম কারি।',
    spice: 1,
  ),
  Meal(
    id: 'roti',
    en: 'Handmade Roti & Desi Chicken',
    bn: 'হাতে বানানো রুটি ও দেশি মুরগি',
    kitchen: "Rina's Kitchen",
    price: 200,
    rating: 4.6,
    reviews: 58,
    img: StImg.roti,
    cat: 'office',
    desc: '4 roti with desi chicken curry.',
    descBn: '৪টি রুটি ও দেশি মুরগির তরকারি।',
    soldOut: true,
    spice: 2,
  ),
  Meal(
    id: 'beef',
    en: 'Spicy Beef Kala Bhuna Box',
    bn: 'ঝাল গরুর কালা ভুনা বক্স',
    kitchen: 'Dhaka Tiffin Co.',
    price: 240,
    rating: 4.8,
    reviews: 77,
    img: StImg.beef,
    cat: 'office',
    badge: 'Halal',
    desc: 'Chittagong-style beef, rice, lemon.',
    descBn: 'চাটগাঁইয়া গরুর মাংস, ভাত, লেবু।',
    spice: 3,
  ),
];

const plans = <Plan>[
  Plan(id: 'weekly', en: 'Weekly Lunch', bn: 'সাপ্তাহিক লাঞ্চ', meals: '6 lunches', price: 1800),
  Plan(id: 'monthly-l', en: 'Monthly Lunch', bn: 'মাসিক লাঞ্চ', meals: '26 lunches', price: 3900),
  Plan(id: 'monthly-ld', en: 'Monthly Homemade Package', bn: 'মাসিক ঘরোয়া প্যাকেজ', meals: 'Lunch + Dinner daily', price: 7200),
  Plan(id: 'office', en: 'Office Lunch · 20 days', bn: 'অফিস লাঞ্চ · ২০ দিন', meals: '20 weekday lunches', price: 3400),
];

const requests = <OrderReq>[
  OrderReq(id: 'TK-911', name: 'Tanvir Ahmed', area: 'Banani Block D, Road 11', item: 'Classic Bengali Homestyle Thali', qty: '2×', note: 'Less chili, extra dal', pay: 'bKash', amount: 360),
  OrderReq(id: 'TK-912', name: 'Nusrat Jahan', area: 'Gulshan 1, Navana Tower', item: 'Diet Khichuri & Boiled Egg', qty: '1×', note: 'Standard lunch diet container', pay: 'Nagad', amount: 180),
  OrderReq(id: 'TK-913', name: 'Arifur Rahman', area: 'Dhanmondi 27', item: 'Spicy Beef Kala Bhuna Box', qty: '1×', note: 'Pack extra lemon slice & tissue', pay: 'bKash', amount: 240),
];

const applicants = <Applicant>[
  Applicant(id: 'sultana', kind: 'Cook', name: "Sultana's Gourmet Kitchen", owner: 'Sultana Begum', area: 'Mirpur-10', cap: '50 tiffins/day', tier: 'Corporate Lunch', ago: '2h', docs: {'nid': 'Verified', 'kitchen': 'Checked', 'hygiene': 'Pass'}),
  Applicant(id: 'ctg', kind: 'Cook', name: 'Chittagong Spices & Tiffin', owner: 'Kabir Hossain', area: 'Uttara Sec 4', cap: '85 tiffins/day', tier: 'Mezban Beef & Rice', ago: '5h', docs: {'nid': 'Verified', 'kitchen': 'Scheduled', 'hygiene': 'Pending'}),
  Applicant(id: 'rider-sabbir', kind: 'Rider', name: 'Sabbir Hasan', owner: 'Sabbir Hasan', area: 'Mohakhali', cap: 'Honda CB 125', tier: 'Lunch shift', ago: '1d', docs: {'nid': 'Verified', 'kitchen': 'License OK', 'hygiene': 'Pending'}),
  Applicant(id: 'rider-mitu', kind: 'Rider', name: 'Mitu Akter', owner: 'Mitu Akter', area: 'Dhanmondi', cap: 'Bicycle', tier: 'Dinner shift', ago: '3h', docs: {'nid': 'Verified', 'kitchen': 'Not required', 'hygiene': 'Pass'}),
];

Meal? mealById(String id) {
  for (final m in meals) {
    if (m.id == id) return m;
  }
  return meals.first;
}
