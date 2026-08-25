# novel_ui — ROADMAP

خطة التطوير الكاملة مبنية على أبحاث موثقة: تفكيك APK الرسمي، CSS إنتاجي من 6 منصات
منافسة (Webnovel/Wattpad/RoyalRoad/GoodNovel/ScribbleHub/Tapas/Kakaopage)، ودراسة
شيفرة shadcn_ui وforui وpana. آخر تحديث: 2026-08-25.

---

## ✅ ما تم إنجازه (v0.1.x)

- **نظام ثيمات كامل**: `NovelThemeData` (فاتح/داكن) + `toMaterialTheme()` + `NovelStrings` (EN/AR)
- **ثيمات رسمية مستخرجة**: `NovelColorScheme.webnovel` (توكنز CSS الإنتاج #4147E3) + `NovelPlatformPresets` (Wattpad `#FF500A` / GoodNovel `#EE3799` / RoyalRoad `#1976D2`)
- **أوراق القارئ الست الحقيقية** من `ReaderColorUtil` في الـAPK
- **مكونات (20+)**: كروت الكتب، الترتيب، الفصول، فتح بالعملات، التقييم، محاور المراجعة، التعليقات، شارات المعجبين، الكاروسيل، شاشة البحث، زر التصويت
- **قارئ كامل**: تمرير + صفحات حقيقية (TextPaginator)، تعليقات فقرات بفقاعات + درج جاهز، 6 أوراق، إعدادات
- **وصول (a11y)**: Semantics على التقييم (قابل للزيادة/النقصان)، الكروت، الفصول، التصويت
- **جودة**: `dart format` كامل، analyze نظيف، 12/12 اختبار، بناء ويب ناجح

---

## المرحلة 1 — عمق المكونات (الأولوية القصوى)

من مصفوفة الفجوات عبر المنصات — المكونات المشتركة التي تنقصنا:

| المكوّن | المصدر/المرجع | الجهد |
|---|---|---|
| `NovelPowerRankPodium` — منصة الترتيب (الأول كبير 150×200 + الثاني/الثالث) | GoodNovel Power Ranking | M |
| `NovelLatestUpdatesFeed` — تدفق حي: غلاف + عنوان + كل التصنيفات + آخر فصل | ScribbleHub (نادر وفريد) | M |
| `NovelReadingListPicker` — منتقي قوائم القراءة (زر + دائري) | Wattpad (توقيعهم المميز) | M |
| `NovelWaitOrPayTile` — عدّاد انتظار 24h لفتح الفصل مجاناً | Tapas `data-period-hr` | S |
| `NovelFiveAxisRating` — Overall/Style/Story/Character/Grammar | RoyalRoad (نفس محاورنا + Overall) | S |
| `NovelAchievementRow` — ميداليات 38×38 مع popover | RoyalRoad achievements | S |
| `NovelRateOnCard` — نجوم تقييم مباشرة على الكرت | ScribbleHub trending | S |
| ترقيم الترتيب الملوّن بالطبقات: أحمر/برتقالي/أخضر | Webnovel web `c_danger/c_warning/c_success` | ✅ منفذ |
| تدقيق تباين WCAG شامل (ثيمات + أوراق) | مبدأ impeccable | ✅ منفذ |
| احترام disableAnimations في القارئ | reduced-motion | ✅ منفذ |
| منشئات variants المسماة على NovelBookCard | نمط shadcn | ✅ منفذ |

## المرحلة 2 — ترقية المعمارية (نمط shadcn_ui/forui الموثق)

1. **✅ منفذ — ثيمات لكل مكوّن**: `NovelBookCardTheme`, `NovelChapterTileTheme`,
   `NovelCommentTileTheme`, `NovelRankListItemTheme`, `NovelSectionHeaderTheme` +
   سلسلة الحل:
   `widget.field ?? componentTheme.field ?? globalDefault`
2. **✅ منفذ: NovelThemeData كـThemeExtension** مسجل في `ThemeData.extensions`
   مع instance lerp يحرّك الانتقال فاتح↔داكن عبر Material
3. **Variants كـenums + مُنشئات مسماة** للمكونات المتعددة الأشكال:
   `NovelBookCard.grid(...) / .rail(...) / .row(...)` + `.raw(variant: ...)`
4. **حجم مزدوج desktop/touch** في الحل (نمط forui): md = 36px سطح مكتب / 44px لمس
5. `debugFillProperties` على كل مكوّن عام

## المرحلة 3 — الجودة والنشر (نموذج pana الـ160 نقطة)

| البند | الحالة |
|---|---|
| `dart format` صفر انحرافات (50 نقطة ثنائية) | ✅ منفذ |
| CHANGELOG بصيغة `## x.y.z` + `FEAT/FIX/BREAKING` | ✅ البداية منفذة |
| تغطية توثيق ≥20% من API العام | ✅ 41.4% موثقة + dart doc صفر تحذيرات |
| `screenshots:` في pubspec (لقطات المثال) | ✅ screenshots/library.png + cwebp مثبت للتحويل |
| روابط repository حقيقية | ✅ github.com/mohmaedeslam00116/novel_ui (عام، مرفوع) |
| `dart pub downgrade && analyze` نظيف | ✅ مُتحقق منه |
| **`pana` النهائي** | ✅ **160/160 — الدرجة الكاملة** (بعد ترقيع sandbox ويندوز محلياً + تثبيت libwebp) |

## المرحلة 4 — الاختبارات المرئية (golden tests)

- **✅ منفذ**: alchemist ^0.14.0 + `test/flutter_test_config.dart` +
  مصفوفة فاتح/داكن × LTR/RTL + صور مرجعية لكل مكوّن (book_card/chapter_tile/rating_badges)
- ⬜ سيناريو `textScaleFactor: 2.0` إضافي لكل مكوّن أساسي (تغطية a11y)
- ⬜ CI: `flutter test --tags golden` على ubuntu

## المرحلة 5 — ميزات القارئ المتقدمة (مفاتيح SettingDef المستخرجة)

- ✅ `SettingAutoScroll` → تمرير تلقائي بسرعة قابلة للضبط (زر Auto + شريط سرعة)
- ✅ `SettingBackImage` → خلفيات صور مخصصة + ستارة تعتيم للوضوح
- ✅ `SettingFancyWay` → أنماط التقليب: slide / cover (دوران منظوري) / instant
- ✅ `SettingArabicContentFont` → جسر `NovelFontManager` لتحميل الخطوط وقت التشغيل
- ✅ دانماكو الكوميكس → NovelDanmakuOverlay بممرات ذكية ومتحكم مستقل
- ✅ TTS → NovelTtsPanel بتمييز الفقرة الحالية + واجهة NovelTtsDriver ومحرك محاكاة

## المرحلة 6 — التوزيع

- ❌ **مستبعد بقرار صريح من المستخدم**: لا تُدرَج أيقونات تطبيق WebNovel
  المستخرجة (أو أي أصول لتطبيق آخر) داخل المكتبة أو أي حزمة منها — لأسباب
  تتعلق بحقوق الملكية. أيقونات المكتبة يجب أن تكون أصولاً مرخّصة أصلاً
  (Material Symbols، Lucide، أو تصميم خاص)
- حزمة `novel_reader_engine` منفصلة إن نما المحرك
- ⬜ النشر على pub.dev: `flutter pub publish` — كل شيء جاهز (160/160، مستودع عام، ترخيص MIT، لقطة شاشة). القرار النهائي للمستخدم متى ينشر.
- توثيق موقعي (widget.catalog) + فيديوهات قصيرة للمكونات

---

## قواعد ثابتة (من دراسة المكتبات الناضجة)

- **Enums للـvariants وليس فئات منفصلة** — `switch` شامل يضمن الاكتمال
- **حقول الويدجت nullable** — الافتراضيات في طبقة الثيم فقط
- **كل تغيير كاسر** في 0.x = رفع minor + سطر `BREAKING` مع الترحيل في CHANGELOG
- **لا نعتمد حزم مهجورة** (golden_toolkit, flutter_adaptive_scaffold)
- **التباين ≥4.5:1** على كل أوراق القراءة الست + قراءة عند تكبير النص 200%
