# Flight ✈️

تطبيق حجز طيران وفنادق مبني بـ **Flutter** على **Clean Architecture** وهيكلة **Feature-first** وإدارة الحالة بـ **Bloc**.

---

## التشغيل

المشروع فيه مجلد `lib` و `assets` فقط، فلازم تولّد مجلدات المنصات أول مرة:

```bash
cd flight_app
flutter create . --org com.example --platforms=android,ios
flutter pub get
flutter run
```

**تسجيل الدخول التجريبي:** أي إيميل صحيح + كلمة مرور من 8 أحرف أو أكثر، أو أنشئ حساب من صفحة Sign up.

> **تنبيه:** نصوص Terms of use و Privacy policy في `features/legal` نماذج مؤقتة. لازم تستبدلها بنصوص قانونية حقيقية قبل نشر التطبيق.

---

## هيكلة المشروع

```
lib/
├── main.dart                 # نقطة البداية: تهيئة DI ثم runApp
├── app.dart                  # MaterialApp.router + البلوكات العامة (Auth, Settings)
│
├── core/                     # كل شي مشترك وما يعرف شي عن الـ features
│   ├── constants/            # الألوان، النصوص، مسارات الصور، مفاتيح التخزين
│   ├── di/injection.dart     # get_it: يستدعي init لكل feature
│   ├── error/                # Exceptions (طبقة data) و Failures (domain/UI)
│   ├── router/               # go_router: كل المسارات + الـ bottom nav
│   ├── storage/              # تجريد SharedPreferences و SecureStorage
│   ├── theme/                # الثيم وأنماط النصوص
│   ├── usecase/              # العقد الأساسي UseCase<T, Params>
│   ├── utils/                # Result, guard, التواريخ, الـ validators
│   └── widgets/              # الأزرار، السحاب، الحقول، الـ app bar...
│
├── shared/                   # كيانات وبيانات تستخدمها أكثر من feature
│   ├── data/                 # CatalogLocalDataSource (فنادق + وجهات)
│   ├── domain/entities/      # Hotel, Destination
│   └── widgets/              # HotelCard, DestinationCard
│
└── features/
    ├── splash/               # أنيميشن الطائرة والسحاب
    ├── main_shell/           # الـ Bottom Navigation (4 تبويبات)
    ├── home/
    ├── explore/
    ├── flight_search/        # One-way / Round-trip / Multi-city + Passengers
    ├── hotels/               # Hotel Bookings
    ├── stories/              # Latest / Bookmarks
    ├── auth/                 # Login + جلسة المستخدم
    ├── account/              # صفحة الحساب + الإعدادات (اللغة، العملة، المنطقة)
    ├── profile/              # Personal Info + Personal Details
    └── payment/              # Preferred Payment Types
```

### داخل كل feature

```
feature_x/
├── data/
│   ├── datasources/   # من وين تجي البيانات (API / تخزين محلي)
│   ├── models/        # fromJson / toJson — يرث من الـ entity
│   └── repositories/  # تنفيذ الـ repository + تحويل Exception إلى Failure
├── domain/            # Dart خالص، بدون Flutter
│   ├── entities/
│   ├── repositories/  # abstract interface فقط
│   └── usecases/      # منطق العمل + التحقق من المدخلات
├── presentation/
│   ├── bloc/          # Events + States + Bloc
│   ├── pages/         # Page (يوفّر BlocProvider) + View (الواجهة)
│   └── widgets/
└── feature_x_injection.dart   # تسجيل اعتماديات الـ feature في get_it
```

**اتجاه الاعتماد:** `presentation → domain ← data`.
طبقة الـ domain ما تعتمد على أي طبقة ثانية.

---

## تدفّق البيانات

```
UI ──event──▶ Bloc ──▶ UseCase ──▶ Repository (interface)
                                         │
                                RepositoryImpl ──▶ DataSource
                                         │
UI ◀──state── Bloc ◀── Result<T> (Success | Failed(Failure))
```

- كل repository يرجّع `Result<T>` بدل ما يرمي exceptions.
- الدالة `guard()` في `core/utils/result.dart` تحوّل أي `AppException` إلى `Failure` مناسب.

---

## ربط Backend حقيقي

البيانات حالياً وهمية (mock). لربط API:

1. أنشئ class جديد ينفّذ نفس الـ interface، مثلاً `AuthRemoteDataSourceImpl implements AuthRemoteDataSource`.
2. غيّر سطر التسجيل في ملف الـ injection الخاص بالـ feature:

```dart
// features/auth/auth_injection.dart
..registerLazySingleton<AuthRemoteDataSource>(() => AuthRemoteDataSourceImpl(sl()))
```

ما تحتاج تعدّل أي شي في الـ domain أو الـ UI.

الملفات الوهمية:
| Feature | الملف |
|---|---|
| auth (login, sign up, reset password) | `FakeAuthRemoteDataSource` |
| explore (getaway ideas) | `GetawayLocalDataSourceImpl` |
| flight_search | `FakeFlightRemoteDataSource` |
| hotels / home / explore / stories | `CatalogLocalDataSourceImpl` |

---

## الصور

الصور في `assets/images/` **مؤقتة** (مولّدة). استبدلها بصور حقيقية **بنفس الأسماء**
(القائمة في `lib/core/constants/app_assets.dart`). إذا انحذفت صورة، التطبيق يعرض placeholder بدل ما يكرش.

---

## أنيميشن الـ Splash

`features/splash/presentation/widgets/splash_animation.dart`:

| الوقت | الحركة |
|---|---|
| 0% → 45% | السحاب العلوي ينزل من فوق الشاشة |
| 10% → 55% | السحاب السفلي ينزل ويستقر تحت |
| 15% → 40% | الطائرة تظهر في المنتصف |
| 25% → 50% | كلمة Flight تظهر |
| 55% → 95% | الطائرة تطير لليسار وتطلع من الشاشة |
| 100% | الانتقال إلى Home |

المدة الكاملة في `_duration` (3 ثواني).

---

## المكتبات

| المكتبة | الاستخدام |
|---|---|
| `flutter_bloc` + `equatable` | إدارة الحالة |
| `get_it` | Dependency Injection |
| `go_router` | التنقّل + Bottom Navigation |
| `shared_preferences` | الإعدادات، البروفايل، المفضلة |
| `flutter_secure_storage` | توكن الجلسة (مشفّر) |
