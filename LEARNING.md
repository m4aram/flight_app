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
5. ## Bonus: restoring a file with Git

- `git log --oneline` shows all commits, newest on top
- `git checkout <commit-id> -- <file>` brings back a file as it was in that commit
- Always move my work somewhere safe before restoring, because checkout overwrites the file
- # Day 3: Debugging

## Breakpoints

- A breakpoint (red dot) pauses the app at a specific line while it runs
- The app freezes, and I can see the value of every variable at that moment
- This lets me see a problem while it happens, before the user sees the result
- Breakpoints only work when running in Debug mode (the bug button), not Run

Example from today: I paused in `FlightSearchBloc._onSubmitted` and saw
`departure = null`. I predicted the result before continuing:
the app showed "Please choose a departure".

## The debugger buttons

| Key | Name | What it does |
|---|---|---|
| F8 | Step Over | Runs one line and stops at the next line in the same function |
| F7 | Step Into | Goes inside the function called on the current line |
| Shift + F8 | Step Out | Finishes the current function and goes back to the caller |
| F9 | Resume | Runs until the next breakpoint, even in another file |
| Ctrl + Shift + F8 | — | Shows all breakpoints, so I can delete them |

## Reading a stack trace (Frames)

- Frames = the chain of "who called who" until the current line
- Read it from the bottom (start) to the top (where I am now)
- Lines from my project look normal, library lines are dimmed
- When an error shows a long red stack trace: find the first line from `lib/`, start there

The full chain I saw for a flight search:

DataSource      flight_remote_data_source.dart:55   (data)
Repository      flight_repository_impl.dart:22      (data)
guard           result.dart:35                      (core)
UseCase         search_flights.dart:19              (domain)
Bloc            flight_search_bloc.dart:189         (presentation)

## Things I discovered while debugging

- `validate()` stops at the first `return`, so only the first missing field is reported
- A round trip is searched as two legs, so the DataSource breakpoint stops twice
- `Skipped 22738 frames` appeared because the app was paused, not because it was slow

## The Gradle error from setup

- Error: `Could not close incremental caches`
- Cause: my project is on drive E: and the Flutter packages are on drive C:.
  Kotlin's incremental compilation doesn't handle files on two different drives
- Fix: add `kotlin.incremental=false` to `android/gradle.properties`,
  then `flutter clean`
- Lesson: read the first red line of an error, not the last one
# Day 4: First tests

## The basics

- A test is code that checks my code, so I don't have to test by hand every time
- Testing pyramid: many Unit tests (fast), some Widget tests, few Integration tests (slow)
- AAA: Arrange (prepare input) → Act (run the function) → Assert (check the result)
- Test files live in `test/` with the same structure as `lib/`, and must end with `_test.dart`
- `flutter test` runs all tests. `+9` = 9 passed, `-1` = 1 failed

## Mistakes I made and learned from

- `expect(result, 'isNull')` is wrong: with quotes it's a String. `isNull` without quotes is the matcher
- `$minPasswordLength` works inside `validators.dart` but not in my test file. Write the final text: `8`
- When a test fails, read Expected vs Actual and ask: is the code wrong, or the test?
- Test descriptions must describe what the test checks, so a failure is easy to understand
- Test the boundaries: 7 and 8 characters, because bugs hide at the limit

## Why every test matters

Each test guards one case. If AI later removes `.trim()` by mistake,
the "spaces around the email" test fails and tells me right away.
## Day 5: Unit tests
- AAA: Arrange, Act, Assert
- Change one thing only in each test
- If a test fails: ask who is wrong, the code or the test?
- Test the edges (9 seats, same day, 4 characters)
- A failing test can mean I FOUND A BUG (email dots)
- Red → fix the code → Green, and old tests must stay green
## Day 6: Mocks (mockpagestail)
- Mock = fake object, I control what it answers
- when(...).thenAnswer / thenThrow = teach the mock
- verify(...).called(1) = it was called once
- verifyNever / verifyZeroInteractions = it was NOT called (security!)
- Arrange and Assert must change together
- Never ignore yellow warnings (deprecated / unused_import)
## Day 7: bloc_test
- blocTest = AAA for Blocs: build / act / expect
- expect = LIST of NEW states, in order (initial state not included)
- seed = start the Bloc from a ready state
- setUp inside blocTest = teach the mock for this test only
- verify = check what happened behind the scenes (verifyNever)
- registerFallbackValue = needed for any() with my own classes
- In expect: write fixed values, never copy logic from the code
- A test is the project's memory: it remembers rules (clear password)
## Day 8: Widget tests
- Widget test = a robot that opens the screen, taps, types and looks
- pumpWidget = open the screen
- find.text / find.byTooltip / find.byType / find.widgetWithText
- tap / enterText = act like the user
- pump = draw once (instant changes)
- pumpAndSettle = draw until nothing moves (waiting, animations)
- Check BEFORE and AFTER (findsNothing then findsOneWidget)
- Use LoginView (not LoginPage) to inject a Bloc with a mock
- - flutter test --coverage = which lines ran during tests
- Red = surely not tested. Green ≠ correct (email regex bug was green!)
- Coverage is per LINE: `if (x) return;` is green even if return never ran
- Don't chase 100%: boilerplate (props, toString) is not worth it
- tester.widget<T>() = get the widget to check its properties (onTap == null)
- Widget tests are ~20x slower than unit tests → test pyramid 
## Day 9: HTTP and Status Codes
- GET = read, POST = create, PUT = update, DELETE = delete
- Header = envelope (Content-Type, token), Body = the actual data
- Secrets (password, token) NEVER in the URL: it is saved in history, logs, WiFi
- 2xx ok | 3xx use your copy / go elsewhere | 4xx app's fault | 5xx server's fault
- 200 = ok, 201 = created (server gives the id), 304 = not modified (cache)
- 401 = "who are you?" (login again), 403 = "I know you, but no"
- Chrome F12 > Network = see method, status, headers of every request
- "It works" ≠ "It's right" (GET /login?password=... works, but it's wrong)