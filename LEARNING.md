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
# Day 2: DevTools

## Widget Inspector

- The Inspector shows the widget tree while the app runs
- "Select Widget Mode" lets me tap something on screen and find it in the code
- `AuthBloc` and `SettingsBloc` sit above `MaterialApp`, so every screen can reach them
- `HomeBloc` sits under `HomePage`, so it only lives while the Home screen is open
- Explore icon: 24x24, padding 39.4 = (411 screen width / 4 tabs - 24) / 2

## BlocObserver: Hotel search log

| # | الحدث أو الحالة | وش صار |
|---|---|---|
| 1 | `EVENT <- HotelSearchStarted(Istanbul)` | ضغطت فندق في إسطنبول من الرئيسية، فانفتحت الصفحة والمدينة معبّاة |
| 2 | `STATE -> ([], Istanbul, 11-13, 11-15, 2, 1, initial)` | القيم الافتراضية، وقائمة المدن لسا فاضية |
| 3 | `STATE -> ([Istanbul, Cancún, ...], Istanbul, ...)` | وصلت قائمة المدن |
| 4 | `EVENT <- HotelCitySelected(Cancún)` | اخترت كانكون |
| 5 | `EVENT <- HotelCheckOutSelected(11-21)` | اخترت تاريخ المغادرة |
| 6 | `EVENT <- HotelGuestsRoomsChanged(4, 3)` | 4 ضيوف في 3 غرف |
| 7 | `EVENT <- HotelSearchSubmitted()` | ضغطت Search Hotels |
| 8 | `STATE -> (... loading ...)` | دائرة التحميل |
| 9 | `STATE -> (... success, [San Cora Cancún])` | لقى فندق واحد |

## What I learned

1. (اكتبي بكلماتك: ليش Event واحد طلّع حالتين في السطرين 2 و 3؟)

2. (اكتبي بكلماتك: كيف الـ log كشف إن تاريخ المغادرة تغيّر لحاله؟ ووش القاعدة اللي ورا هذا؟)

3. The printed State follows the order of `props`
4. `D/EGL_emulation` lines are emulator noise. Filter the Console with "flutter"