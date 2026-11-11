# Day 1: Flutter Analyze

## Breaking the code on purpose

File: `lib/features/home/presentation/widgets/category_card.dart`

| # | التغيير | وش قال المحلل | النوع | اسم القاعدة |
|---|---|---|---|---|
| 1 | أضفت `final test = 5;` | حطي const بدل final لأن القيمة ثابتة | info | `prefer_const_declarations` |
| 1 | أضفت `final test = 5;` | المتغير test ما انستخدم | warning | `unused_local_variable` |
| 2 | حذفت const من `SizedBox(height: 6)` | أضيفي const للـ constructor عشان الأداء | info | `prefer_const_constructors` |
| 3 | كتبت `AppColors.primery` | الاسم primery مش معرّف داخل AppColors | error | `undefined_getter` |
| 4 | حذفت import حق app_colors.dart | AppColors مش معرّف (3 مرات، لأنه مستخدم 3 مرات) | error | `undefined_identifier` |
| 5 | حذفت `required this.label` | المتغير label الـ final ما أخذ قيمة | error | `final_not_initialized_constructor` |
| 5 | حذفت `required this.label` | home_header.dart يرسل label والـ constructor ما يقبله (سطر 69 و 77) | error | `undefined_named_parameter` |

## What I learned

- Every analyzer line has the same shape: type - message - file:line:col - rule name
- One line of code can break more than one rule (#1)
- One cause can produce many errors: fix the root cause, start with the first error (#4)
- Changing a constructor breaks every file that uses it, so run `flutter analyze` after every AI edit (#5)
- `undefined_getter` = the class exists but the member doesn't. `undefined_identifier` = the name itself doesn't exist

## The difference between error, warning and info

(اكتبيها بكلماتك)