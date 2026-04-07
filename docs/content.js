window.HOLON_SITE_DATA = {
    meta: {
        brand: "Holon HUB",
        version: "v1.5.5",
        primaryTabs: 12,
        featureGroups: "40+",
        author: "holon_calm",
        robloxId: "najayou777",
        uiFoundation: "orion.lua",
        notesFolder: "FTAP_Notes/*.json",
        links: {
            discord: "https://discord.gg/EHBXqgZZYN",
            tiktok: "https://www.tiktok.com/@holoncalm",
            youtube: "https://www.youtube.com/@Holoncalm"
        },
        sourceFiles: [
            "hub-ar.lua",
            "hub-bn.lua",
            "hub-de.lua",
            "hub-en.lua",
            "hub-es.lua",
            "hub-fr.lua",
            "hub-jp.lua",
            "hub-ko.lua",
            "hub-ru.lua",
            "hub-tr.lua",
            "orion.lua"
        ],
        systemDefinitions: [
            {
                key: "chat",
                tags: ["Global / Server / Private", "DiscordWebhookURL", "Notifications"]
            },
            {
                key: "grab",
                tags: ["Super Throw", "Noclip Grab", "Line Extender"]
            },
            {
                key: "piano",
                tags: ["MusicKeyboard", "FTAP_Notes", "JSON autoplay"]
            },
            {
                key: "keyboard",
                tags: ["Teleport Z", "Anchor K", "Minimap"]
            },
            {
                key: "actions",
                tags: ["Bring All", "Loop Kill", "Blobman"]
            },
            {
                key: "settings",
                tags: ["Save / Load", "UI Colors", "orion.lua"]
            }
        ]
    },
    locales: {
        en: {
            langTag: "en",
            dir: "ltr",
            label: "English",
            nativeName: "English",
            sourceFile: "hub-en.lua",
            tabs: ["Main", "Mode Settings", "Player", "Defense", "Grab", "Aura", "Chat", "Piano", "Keyboard", "Actions", "Sub Features", "Decoy"],
            localeLabel: "Language",
            nav: {
                overview: "Overview",
                systems: "Systems",
                interface: "Interface",
                converter: "Converter",
                languages: "Languages"
            },
            hero: {
                eyebrow: "Prometheus / FTAP / Orion UI",
                subtitle: "Source-based multilingual build overview",
                lead: "A browsing-friendly website for Holon HUB v1.5.5, structured from the localized hub files and the shared Orion UI layer."
            },
            cta: {
                discord: "Join Discord",
                tiktok: "TikTok",
                youtube: "YouTube"
            },
            stats: {
                build: "Build",
                languages: "Languages",
                tabs: "Primary Tabs",
                groups: "Feature Groups"
            },
            snapshot: {
                kicker: "Source Stack",
                title: "Localized builds, shared foundation",
                body: "Structured from the multilingual `hub-*.lua` files and the Orion UI layer in `orion.lua`.",
                labels: {
                    source: "Source set",
                    locale: "Selected build",
                    channels: "Channels"
                }
            },
            overview: {
                kicker: "Source-Based Overview",
                title: "A landing page rebuilt from the Lua builds",
                body: "The Lua files describe a large Roblox hub with authentication, community links, combat and utility tabs, chat integration, piano automation, keyboard tools, decoy control, and saved UI presets. This page turns that structure into a clean website while keeping the real language builds visible."
            },
            detailLabels: {
                author: "Author",
                roblox: "Roblox ID",
                foundation: "UI foundation",
                notes: "Piano notes"
            },
            systems: {
                kicker: "Core Systems",
                title: "What the source files expose",
                body: "The cards below summarize the modules revealed by the tab and section names inside the source."
            },
            modules: {
                chat: {
                    title: "Chat Network",
                    text: "Global, server-only, and private chat with Discord-backed history, notifications, and ticker support."
                },
                grab: {
                    title: "Grab Systems",
                    text: "Includes super throw, spin grab, noclip grab, invisible grab, line extender, and animated line effects."
                },
                piano: {
                    title: "Piano Toolkit",
                    text: "Detects MusicKeyboard, follows players, loads JSON note files, and supports autoplay plus manual play."
                },
                keyboard: {
                    title: "Keyboard Tools",
                    text: "Teleport, anchor, silent aim, and a configurable minimap live in the keyboard-focused toolset."
                },
                actions: {
                    title: "Action Suite",
                    text: "Target actions cover bring flows, loop kill tools, blobman actions, and mass-fire routines."
                },
                settings: {
                    title: "Settings & UI",
                    text: "Stores presets, colors, UI transparency, background IDs, and runtime configuration states."
                }
            },
            interface: {
                kicker: "Locale Preview",
                title: "Primary tab flow",
                body: "The order below comes directly from the selected locale file.",
                badge: "Selected source"
            },
            languages: {
                kicker: "Supported Locales",
                title: "10 language builds",
                body: "Each card below maps to a real `hub-*.lua` variant. Pick one to switch the page copy and tab preview.",
                switchLabel: "Use this locale"
            },
            converter: {
                kicker: "MIDI to JSON",
                title: "Browser converter from the Python workflow",
                body: "Upload a MIDI file and convert it into the same Holon HUB piano JSON shape used by the Python script: chord reduction plus minimum-interval filtering.",
                fileLabel: "MIDI file",
                intervalLabel: "Minimum interval (seconds)",
                modeLabel: "Chord mode",
                convert: "Convert MIDI",
                download: "Download JSON",
                hint: "Supported mapping range: C4 to A#5. Notes outside the mapped keyboard layout are ignored.",
                stats: {
                    file: "File",
                    detected: "Detected notes",
                    reduced: "After chord reduce",
                    filtered: "After interval filter",
                    duration: "Total duration",
                    output: "Output notes"
                },
                empty: "Converted JSON will appear here.",
                selectFile: "Select a MIDI file first.",
                invalidMidi: "The selected file could not be parsed as a standard MIDI file.",
                downloadName: "holon-midi.json"
            },
            footer: "Holon HUB v1.5.5 overview organized from hub-*.lua and orion.lua."
        },
        ja: {
            langTag: "ja",
            dir: "ltr",
            label: "Japanese",
            nativeName: "日本語",
            sourceFile: "hub-jp.lua",
            tabs: ["メイン", "モード設定", "プレイヤー", "無敵", "掴む", "オーラ", "チャット", "ピアノ", "キーボード", "アクション", "サブ機能", "デコイ"],
            localeLabel: "言語",
            nav: {
                overview: "概要",
                systems: "機能",
                interface: "タブ構成",
                converter: "変換",
                languages: "言語"
            },
            hero: {
                eyebrow: "Prometheus / FTAP / Orion UI",
                subtitle: "ソースベースの多言語ビルド概要",
                lead: "各 `hub-*.lua` と共有 UI 層の `orion.lua` をもとに、Holon HUB v1.5.5 の構成を見やすく整理したサイトです。"
            },
            cta: {
                discord: "Discord に参加",
                tiktok: "TikTok",
                youtube: "YouTube"
            },
            stats: {
                build: "ビルド",
                languages: "対応言語",
                tabs: "主要タブ",
                groups: "機能群"
            },
            snapshot: {
                kicker: "ソース構成",
                title: "多言語ビルドと共有基盤",
                body: "`hub-*.lua` の多言語ファイル群と、`orion.lua` の UI レイヤーをもとに構成しています。",
                labels: {
                    source: "参照ファイル",
                    locale: "選択中ビルド",
                    channels: "チャンネル"
                }
            },
            overview: {
                kicker: "ソース由来の概要",
                title: "Lua ビルドから再構成したランディング",
                body: "Lua 側には認証、コミュニティ導線、戦闘系と補助系のタブ、チャット連携、ピアノ自動演奏、キーボード支援、デコイ制御、UI 設定保存が含まれています。このページではその構造を保ったまま、Web で確認しやすい形にまとめています。"
            },
            detailLabels: {
                author: "作者",
                roblox: "Roblox ID",
                foundation: "UI 基盤",
                notes: "ピアノノート"
            },
            systems: {
                kicker: "主要システム",
                title: "ソースから見える機能構成",
                body: "下のカードは、タブ名とセクション名から読み取れるモジュールを要約したものです。"
            },
            modules: {
                chat: {
                    title: "チャット連携",
                    text: "全体、サーバー内、個人チャットに対応し、Discord ベースの履歴、通知、ティッカー表示を持っています。"
                },
                grab: {
                    title: "掴みシステム",
                    text: "スーパースロー、スピン、Noclip Grab、透明化、Line Extender、各種ライン演出が含まれます。"
                },
                piano: {
                    title: "ピアノ機能",
                    text: "MusicKeyboard を検出し、プレイヤー追従、JSON ノート読込、自動演奏と手動演奏に対応します。"
                },
                keyboard: {
                    title: "キーボード支援",
                    text: "テレポート、固定、サイレントエイム、設定可能なミニマップがキーボード系ツールとしてまとまっています。"
                },
                actions: {
                    title: "アクション群",
                    text: "Bring、Loop Kill、Blobman 系アクション、全体炎上処理などの対象操作をまとめています。"
                },
                settings: {
                    title: "設定と UI",
                    text: "プリセット保存、色、透明度、背景 ID、実行時設定の保存と復元を扱います。"
                }
            },
            interface: {
                kicker: "ロケール表示",
                title: "主要タブの流れ",
                body: "下の並びは、選択中ロケールの Lua ファイルに合わせています。",
                badge: "選択中ソース"
            },
            languages: {
                kicker: "対応ロケール",
                title: "10 言語ビルド",
                body: "各カードは実在する `hub-*.lua` ビルドに対応しています。選ぶとサイト文言とタブ表示が切り替わります。",
                switchLabel: "この言語に切替"
            },
            converter: {
                kicker: "MIDI → JSON",
                title: "Python 版の流れをブラウザで実行",
                body: "MIDI ファイルをアップロードすると、Python スクリプトと同じ Holon HUB ピアノ用 JSON 形式へ変換します。和音の整理と最小間隔フィルタにも対応しています。",
                fileLabel: "MIDI ファイル",
                intervalLabel: "最小間隔（秒）",
                modeLabel: "和音モード",
                convert: "MIDI を変換",
                download: "JSON を保存",
                hint: "対応マッピング範囲は C4 から A#5 です。対象外の音は無視されます。",
                stats: {
                    file: "ファイル",
                    detected: "検出ノート数",
                    reduced: "和音整理後",
                    filtered: "間隔フィルタ後",
                    duration: "総演奏時間",
                    output: "出力ノート数"
                },
                empty: "変換された JSON がここに表示されます。",
                selectFile: "先に MIDI ファイルを選択してください。",
                invalidMidi: "選択したファイルは標準 MIDI として解析できませんでした。",
                downloadName: "holon-midi.json"
            },
            footer: "Holon HUB v1.5.5 を `hub-*.lua` と `orion.lua` から整理した概要サイト。"
        },
        ar: {
            langTag: "ar",
            dir: "rtl",
            label: "Arabic",
            nativeName: "العربية",
            sourceFile: "hub-ar.lua",
            tabs: ["الرئيسية", "إعدادات الوضع", "اللاعب", "حماية", "الإمساك", "الهالة", "الدردشة", "البيانو", "لوحة المفاتيح", "الإجراءات", "وظائف فرعية", "الطعم"],
            localeLabel: "اللغة",
            nav: {
                overview: "نظرة عامة",
                systems: "الأنظمة",
                interface: "الواجهة",
                languages: "اللغات"
            },
            hero: {
                eyebrow: "Prometheus / FTAP / Orion UI",
                subtitle: "عرض متعدد اللغات مبني على المصدر",
                lead: "يعيد هذا الموقع تنظيم Holon HUB v1.5.5 اعتمادا على ملفات `hub-*.lua` المترجمة وطبقة الواجهة المشتركة `orion.lua`."
            },
            cta: {
                discord: "انضم إلى Discord",
                tiktok: "TikTok",
                youtube: "YouTube"
            },
            stats: {
                build: "الإصدار",
                languages: "اللغات",
                tabs: "التبويبات الرئيسية",
                groups: "مجموعات الميزات"
            },
            snapshot: {
                kicker: "هيكل المصدر",
                title: "بناءات مترجمة وأساس مشترك",
                body: "تم ترتيب الصفحة اعتمادا على ملفات `hub-*.lua` متعددة اللغات وطبقة Orion UI الموجودة في `orion.lua`.",
                labels: {
                    source: "مجموعة الملفات",
                    locale: "البناء المختار",
                    channels: "القنوات"
                }
            },
            overview: {
                kicker: "نظرة مبنية على المصدر",
                title: "صفحة تعريفية أعيد بناؤها من ملفات Lua",
                body: "تصف ملفات Lua منصة Roblox كبيرة تضم نظام تحقق وروابط مجتمعية وتبويبات قتالية وخدمية وتكامل دردشة وأتمتة بيانو وأدوات لوحة مفاتيح وتحكما بالطعم وحفظا لإعدادات الواجهة. هذه الصفحة تعرض هذا الهيكل بشكل أوضح على الويب."
            },
            detailLabels: {
                author: "المؤلف",
                roblox: "Roblox ID",
                foundation: "أساس الواجهة",
                notes: "نوتات البيانو"
            },
            systems: {
                kicker: "الأنظمة الأساسية",
                title: "ما تكشفه ملفات المصدر",
                body: "تلخص البطاقات التالية الوحدات الظاهرة من أسماء التبويبات والأقسام داخل المصدر."
            },
            modules: {
                chat: {
                    title: "شبكة الدردشة",
                    text: "دردشة عامة وداخل الخادم وخاصة مع سجل محفوظ عبر Discord وإشعارات وشريط رسائل."
                },
                grab: {
                    title: "أنظمة الإمساك",
                    text: "تتضمن الرمي القوي والدوران وNoclip Grab وInvisible Grab وLine Extender وتأثيرات الخطوط."
                },
                piano: {
                    title: "مجموعة البيانو",
                    text: "تكتشف MusicKeyboard وتتابع اللاعبين وتحمّل ملفات JSON وتدعم التشغيل التلقائي واليدوي."
                },
                keyboard: {
                    title: "أدوات لوحة المفاتيح",
                    text: "تشمل الانتقال والتثبيت والتصويب الصامت وخريطة مصغرة قابلة للضبط."
                },
                actions: {
                    title: "حزمة الإجراءات",
                    text: "تجمع أوامر bring وloop kill وإجراءات Blobman وروتينات الإحراق الجماعي."
                },
                settings: {
                    title: "الإعدادات والواجهة",
                    text: "تحفظ القوالب والألوان وشفافية الواجهة ومعرفات الخلفية وحالات الإعدادات."
                }
            },
            interface: {
                kicker: "معاينة اللغة",
                title: "تدفق التبويبات الرئيسية",
                body: "الترتيب التالي مأخوذ مباشرة من ملف اللغة المختار.",
                badge: "المصدر المختار"
            },
            languages: {
                kicker: "اللغات المدعومة",
                title: "10 بناءات لغوية",
                body: "كل بطاقة أدناه تمثل ملف `hub-*.lua` حقيقيا. اختر أيا منها لتبديل نص الصفحة ومعاينة التبويبات.",
                switchLabel: "استخدم هذه اللغة"
            },
            footer: "عرض Holon HUB v1.5.5 منظم انطلاقا من `hub-*.lua` و`orion.lua`."
        },
        bn: {
            langTag: "bn",
            dir: "ltr",
            label: "Bengali",
            nativeName: "বাংলা",
            sourceFile: "hub-bn.lua",
            tabs: ["মূল", "মোড সেটিংস", "প্লেয়ার", "প্রতিরক্ষা", "গ্র্যাব", "অরা", "চ্যাট", "পিয়ানো", "কীবোর্ড", "অ্যাকশন", "সাব ফিচার", "ডিকয়"],
            localeLabel: "ভাষা",
            nav: {
                overview: "সংক্ষিপ্তসার",
                systems: "সিস্টেম",
                interface: "ইন্টারফেস",
                languages: "ভাষাসমূহ"
            },
            hero: {
                eyebrow: "Prometheus / FTAP / Orion UI",
                subtitle: "সোর্সভিত্তিক বহুভাষিক বিল্ড ওভারভিউ",
                lead: "লোকালাইজড `hub-*.lua` বিল্ড আর শেয়ারড `orion.lua` স্তর থেকে Holon HUB v1.5.5-কে ওয়েবে দেখার মতো করে সাজানো হয়েছে।"
            },
            cta: {
                discord: "Discord এ যোগ দিন",
                tiktok: "TikTok",
                youtube: "YouTube"
            },
            stats: {
                build: "বিল্ড",
                languages: "ভাষা",
                tabs: "মূল ট্যাব",
                groups: "ফিচার গ্রুপ"
            },
            snapshot: {
                kicker: "সোর্স স্ট্যাক",
                title: "লোকালাইজড বিল্ড, এক শেয়ারড ভিত্তি",
                body: "`hub-*.lua` ফাইলগুলোর বহুভাষিক রূপ আর `orion.lua`-এর Orion UI স্তর থেকে এই পেজ গঠন করা হয়েছে।",
                labels: {
                    source: "সোর্স সেট",
                    locale: "নির্বাচিত বিল্ড",
                    channels: "চ্যানেল"
                }
            },
            overview: {
                kicker: "সোর্সভিত্তিক সংক্ষিপ্তসার",
                title: "Lua বিল্ড থেকে পুনর্গঠিত ল্যান্ডিং পেজ",
                body: "Lua ফাইলগুলোতে প্রমাণীকরণ, কমিউনিটি লিঙ্ক, কমব্যাট ও ইউটিলিটি ট্যাব, চ্যাট ইন্টিগ্রেশন, পিয়ানো অটোমেশন, কীবোর্ড টুল, ডিকয় কন্ট্রোল এবং UI প্রিসেট সেভ করার মতো বড় Roblox hub দেখা যায়। এই পেজ সেই গঠনকে ওয়েবে আরও পরিষ্কারভাবে দেখায়।"
            },
            detailLabels: {
                author: "লেখক",
                roblox: "Roblox ID",
                foundation: "UI ভিত্তি",
                notes: "পিয়ানো নোট"
            },
            systems: {
                kicker: "মূল সিস্টেম",
                title: "সোর্স ফাইল থেকে যা বোঝা যায়",
                body: "নিচের কার্ডগুলো সোর্সের ট্যাব আর সেকশন নাম থেকে ধরা পড়া মডিউলগুলোকে সংক্ষেপে দেখায়।"
            },
            modules: {
                chat: {
                    title: "চ্যাট নেটওয়ার্ক",
                    text: "গ্লোবাল, সার্ভার-অনলি আর প্রাইভেট চ্যাট; সাথে Discord-ভিত্তিক হিস্ট্রি, নোটিফিকেশন আর টিকার।"
                },
                grab: {
                    title: "গ্র্যাব সিস্টেম",
                    text: "সুপার থ্রো, স্পিন গ্র্যাব, নোক্লিপ গ্র্যাব, ইনভিজিবল গ্র্যাব, লাইন এক্সটেন্ডার আর লাইন এফেক্ট রয়েছে।"
                },
                piano: {
                    title: "পিয়ানো টুলকিট",
                    text: "MusicKeyboard শনাক্ত করে, প্লেয়ার ফলো করে, JSON নোট লোড করে, অটোপ্লে আর ম্যানুয়াল প্লে সমর্থন করে।"
                },
                keyboard: {
                    title: "কীবোর্ড টুল",
                    text: "টেলিপোর্ট, অ্যাঙ্কর, সাইলেন্ট এম আর কনফিগারযোগ্য মিনিম্যাপ কীবোর্ড-কেন্দ্রিক টুলে আছে।"
                },
                actions: {
                    title: "অ্যাকশন স্যুট",
                    text: "Bring, loop kill, Blobman action আর mass-fire রুটিনের মতো টার্গেট টুল এখানে আছে।"
                },
                settings: {
                    title: "সেটিংস ও UI",
                    text: "প্রিসেট, রং, UI স্বচ্ছতা, ব্যাকগ্রাউন্ড আইডি আর রানটাইম কনফিগারেশন স্টেট সংরক্ষণ করে।"
                }
            },
            interface: {
                kicker: "লোকেল প্রিভিউ",
                title: "মূল ট্যাবের ক্রম",
                body: "নিচের ক্রমটি সরাসরি নির্বাচিত ভাষার ফাইল থেকে নেওয়া হয়েছে।",
                badge: "নির্বাচিত সোর্স"
            },
            languages: {
                kicker: "সমর্থিত লোকেল",
                title: "১০টি ভাষার বিল্ড",
                body: "নিচের প্রতিটি কার্ড একটি বাস্তব `hub-*.lua` ভ্যারিয়েন্টকে দেখায়। যেকোনো একটি বেছে নিলে পেজের ভাষা আর ট্যাব প্রিভিউ বদলে যাবে।",
                switchLabel: "এই ভাষা ব্যবহার করুন"
            },
            footer: "`hub-*.lua` আর `orion.lua` থেকে সাজানো Holon HUB v1.5.5-এর সংক্ষিপ্ত ওয়েব ওভারভিউ।"
        },
        de: {
            langTag: "de",
            dir: "ltr",
            label: "German",
            nativeName: "Deutsch",
            sourceFile: "hub-de.lua",
            tabs: ["Start", "Modi", "Spieler", "Schutz", "Greifen", "Auren", "Chat", "Klavier", "Tastatur", "Aktionen", "Extras", "Köder"],
            localeLabel: "Sprache",
            nav: {
                overview: "Uberblick",
                systems: "Systeme",
                interface: "Oberflache",
                languages: "Sprachen"
            },
            hero: {
                eyebrow: "Prometheus / FTAP / Orion UI",
                subtitle: "Quellbasierte mehrsprachige Ubersicht",
                lead: "Diese Website ordnet Holon HUB v1.5.5 anhand der lokalisierten `hub-*.lua`-Builds und der gemeinsamen Basis in `orion.lua` neu."
            },
            cta: {
                discord: "Discord beitreten",
                tiktok: "TikTok",
                youtube: "YouTube"
            },
            stats: {
                build: "Build",
                languages: "Sprachen",
                tabs: "Haupt-Tabs",
                groups: "Funktionsgruppen"
            },
            snapshot: {
                kicker: "Quellstapel",
                title: "Lokalisierte Builds, gemeinsame Basis",
                body: "Zusammengestellt aus den mehrsprachigen `hub-*.lua`-Dateien und der Orion-UI-Schicht in `orion.lua`.",
                labels: {
                    source: "Quellensatz",
                    locale: "Gewahlter Build",
                    channels: "Kanale"
                }
            },
            overview: {
                kicker: "Quellbasierter Uberblick",
                title: "Eine Landingpage aus den Lua-Builds",
                body: "Die Lua-Dateien beschreiben einen grossen Roblox-Hub mit Authentifizierung, Community-Links, Kampf- und Utility-Tabs, Chat-Integration, Klavier-Automation, Tastatur-Tools, Kodersteuerung und gespeicherten UI-Presets. Diese Seite macht diese Struktur im Web leichter lesbar."
            },
            detailLabels: {
                author: "Autor",
                roblox: "Roblox ID",
                foundation: "UI-Basis",
                notes: "Klaviernoten"
            },
            systems: {
                kicker: "Kernsysteme",
                title: "Was die Quelldateien freilegen",
                body: "Die folgenden Karten fassen die Module zusammen, die durch die Tab- und Abschnittsnamen in den Quellen sichtbar werden."
            },
            modules: {
                chat: {
                    title: "Chat-Netz",
                    text: "Globaler, serverinterner und privater Chat mit Discord-Verlauf, Benachrichtigungen und Ticker-Unterstutzung."
                },
                grab: {
                    title: "Greifsysteme",
                    text: "Enthalt Super Throw, Spin Grab, Noclip Grab, Invisible Grab, Line Extender und animierte Linieneffekte."
                },
                piano: {
                    title: "Klavier-Toolkit",
                    text: "Erkennt MusicKeyboard, folgt Spielern, ladt JSON-Noten und unterstutzt Auto- sowie manuelles Spielen."
                },
                keyboard: {
                    title: "Tastatur-Werkzeuge",
                    text: "Teleport, Anchor, Silent Aim und eine konfigurierbare Minimap gehoren zum tastaturorientierten Toolset."
                },
                actions: {
                    title: "Aktions-Suite",
                    text: "Zielaktionen umfassen Bring-Flows, Loop-Kill-Tools, Blobman-Aktionen und Mass-Fire-Routinen."
                },
                settings: {
                    title: "Einstellungen & UI",
                    text: "Speichert Presets, Farben, UI-Transparenz, Hintergrund-IDs und Laufzeitkonfigurationen."
                }
            },
            interface: {
                kicker: "Locale-Vorschau",
                title: "Ablauf der Haupt-Tabs",
                body: "Die Reihenfolge unten stammt direkt aus der gewahlten Sprachdatei.",
                badge: "Gewahlte Quelle"
            },
            languages: {
                kicker: "Unterstutzte Locales",
                title: "10 Sprach-Builds",
                body: "Jede Karte unten entspricht einer echten `hub-*.lua`-Variante. Wahle eine davon, um Seitentext und Tab-Vorschau umzuschalten.",
                switchLabel: "Diese Sprache nutzen"
            },
            footer: "Holon HUB v1.5.5 Ubersicht, strukturiert aus `hub-*.lua` und `orion.lua`."
        },
        es: {
            langTag: "es",
            dir: "ltr",
            label: "Spanish",
            nativeName: "Español",
            sourceFile: "hub-es.lua",
            tabs: ["Principal", "Modos", "Jugador", "Defensa", "Agarre", "Aura", "Chat", "Piano", "Teclado", "Acciones", "Funciones extra", "Senuelo"],
            localeLabel: "Idioma",
            nav: {
                overview: "Resumen",
                systems: "Sistemas",
                interface: "Interfaz",
                languages: "Idiomas"
            },
            hero: {
                eyebrow: "Prometheus / FTAP / Orion UI",
                subtitle: "Resumen multilingue basado en el codigo",
                lead: "Este sitio reorganiza Holon HUB v1.5.5 a partir de los builds localizados `hub-*.lua` y de la capa compartida `orion.lua`."
            },
            cta: {
                discord: "Entrar a Discord",
                tiktok: "TikTok",
                youtube: "YouTube"
            },
            stats: {
                build: "Build",
                languages: "Idiomas",
                tabs: "Pestanas principales",
                groups: "Grupos de funciones"
            },
            snapshot: {
                kicker: "Pila de origen",
                title: "Builds localizados, base compartida",
                body: "Organizado a partir de los archivos multilingues `hub-*.lua` y de la capa Orion UI dentro de `orion.lua`.",
                labels: {
                    source: "Conjunto fuente",
                    locale: "Build seleccionado",
                    channels: "Canales"
                }
            },
            overview: {
                kicker: "Resumen desde el codigo",
                title: "Una landing reconstruida desde los builds Lua",
                body: "Los archivos Lua describen un hub grande de Roblox con autenticacion, enlaces de comunidad, pestanas de combate y utilidad, integracion de chat, automatizacion de piano, herramientas de teclado, control de decoy y guardado de presets de UI. Esta pagina convierte esa estructura en una web mas clara de recorrer."
            },
            detailLabels: {
                author: "Autor",
                roblox: "Roblox ID",
                foundation: "Base UI",
                notes: "Notas de piano"
            },
            systems: {
                kicker: "Sistemas centrales",
                title: "Lo que muestran los archivos fuente",
                body: "Las tarjetas de abajo resumen los modulos visibles en los nombres de pestanas y secciones del codigo."
            },
            modules: {
                chat: {
                    title: "Red de chat",
                    text: "Chat global, solo de servidor y privado con historial guardado en Discord, notificaciones y ticker."
                },
                grab: {
                    title: "Sistemas de agarre",
                    text: "Incluye super throw, spin grab, noclip grab, invisible grab, line extender y efectos de linea."
                },
                piano: {
                    title: "Kit de piano",
                    text: "Detecta MusicKeyboard, sigue jugadores, carga notas JSON y soporta autoplay y toque manual."
                },
                keyboard: {
                    title: "Herramientas de teclado",
                    text: "Teleport, anchor, silent aim y un minimapa configurable viven dentro del set orientado a teclado."
                },
                actions: {
                    title: "Suite de acciones",
                    text: "Las acciones de objetivo cubren bring, loop kill, herramientas Blobman y rutinas de fuego masivo."
                },
                settings: {
                    title: "Ajustes y UI",
                    text: "Guarda presets, colores, transparencia de UI, IDs de fondo y estados de configuracion."
                }
            },
            interface: {
                kicker: "Vista del locale",
                title: "Flujo de pestanas principales",
                body: "El orden de abajo viene directamente del archivo del idioma seleccionado.",
                badge: "Fuente elegida"
            },
            languages: {
                kicker: "Locales compatibles",
                title: "10 builds por idioma",
                body: "Cada tarjeta representa una variante real de `hub-*.lua`. Elige una para cambiar el texto de la pagina y la vista de pestanas.",
                switchLabel: "Usar este idioma"
            },
            footer: "Resumen de Holon HUB v1.5.5 organizado a partir de `hub-*.lua` y `orion.lua`."
        },
        fr: {
            langTag: "fr",
            dir: "ltr",
            label: "French",
            nativeName: "Français",
            sourceFile: "hub-fr.lua",
            tabs: ["Principal", "Modes", "Joueur", "Defense", "Saisie", "Aura", "Chat", "Piano", "Clavier", "Actions", "Fonctions secondaires", "Leurre"],
            localeLabel: "Langue",
            nav: {
                overview: "Apercu",
                systems: "Systemes",
                interface: "Interface",
                languages: "Langues"
            },
            hero: {
                eyebrow: "Prometheus / FTAP / Orion UI",
                subtitle: "Vue multilingue basee sur le code source",
                lead: "Ce site reorganise Holon HUB v1.5.5 a partir des builds localises `hub-*.lua` et de la couche partagee `orion.lua`."
            },
            cta: {
                discord: "Rejoindre Discord",
                tiktok: "TikTok",
                youtube: "YouTube"
            },
            stats: {
                build: "Build",
                languages: "Langues",
                tabs: "Onglets principaux",
                groups: "Groupes de fonctions"
            },
            snapshot: {
                kicker: "Pile source",
                title: "Builds localises, base partagee",
                body: "Organise a partir des fichiers multilingues `hub-*.lua` et de la couche Orion UI dans `orion.lua`.",
                labels: {
                    source: "Jeu de sources",
                    locale: "Build choisi",
                    channels: "Canaux"
                }
            },
            overview: {
                kicker: "Apercu depuis les sources",
                title: "Une landing page reconstruite depuis les builds Lua",
                body: "Les fichiers Lua decrivent un grand hub Roblox avec authentification, liens communautaires, onglets de combat et d'utilite, integration du chat, automatisation du piano, outils clavier, controle du leurre et sauvegarde des presets UI. Cette page rend cette structure plus lisible sur le web."
            },
            detailLabels: {
                author: "Auteur",
                roblox: "Roblox ID",
                foundation: "Base UI",
                notes: "Notes de piano"
            },
            systems: {
                kicker: "Systemes centraux",
                title: "Ce que montrent les fichiers source",
                body: "Les cartes ci-dessous resumment les modules visibles dans les noms d'onglets et de sections des sources."
            },
            modules: {
                chat: {
                    title: "Reseau de chat",
                    text: "Chat global, serveur et prive avec historique via Discord, notifications et bandeau de messages."
                },
                grab: {
                    title: "Systemes de saisie",
                    text: "Comprend super throw, spin grab, noclip grab, invisible grab, line extender et effets de ligne."
                },
                piano: {
                    title: "Boite a outils piano",
                    text: "Detecte MusicKeyboard, suit les joueurs, charge des notes JSON et gere l'autoplay ainsi que le jeu manuel."
                },
                keyboard: {
                    title: "Outils clavier",
                    text: "Teleport, anchor, silent aim et minimap configurable sont regroupes dans les outils clavier."
                },
                actions: {
                    title: "Suite d'actions",
                    text: "Les actions ciblent bring, loop kill, outils Blobman et routines de feu de masse."
                },
                settings: {
                    title: "Reglages et UI",
                    text: "Conserve les presets, les couleurs, la transparence UI, les IDs d'arriere-plan et l'etat des configurations."
                }
            },
            interface: {
                kicker: "Apercu de langue",
                title: "Flux des onglets principaux",
                body: "L'ordre ci-dessous provient directement du fichier de langue selectionne.",
                badge: "Source choisie"
            },
            languages: {
                kicker: "Locales prises en charge",
                title: "10 builds par langue",
                body: "Chaque carte correspond a une vraie variante `hub-*.lua`. Choisissez-en une pour changer le texte de la page et l'apercu des onglets.",
                switchLabel: "Utiliser cette langue"
            },
            footer: "Vue de Holon HUB v1.5.5 organisee a partir de `hub-*.lua` et `orion.lua`."
        },
        ko: {
            langTag: "ko",
            dir: "ltr",
            label: "Korean",
            nativeName: "한국어",
            sourceFile: "hub-ko.lua",
            tabs: ["메인", "모드 설정", "플레이어", "방어", "잡기", "오라", "채팅", "피아노", "키보드", "액션", "보조 기능", "디코이"],
            localeLabel: "언어",
            nav: {
                overview: "개요",
                systems: "시스템",
                interface: "인터페이스",
                languages: "언어"
            },
            hero: {
                eyebrow: "Prometheus / FTAP / Orion UI",
                subtitle: "소스 기반 다국어 빌드 개요",
                lead: "현지화된 `hub-*.lua` 빌드와 공용 UI 레이어 `orion.lua`를 바탕으로 Holon HUB v1.5.5를 웹에서 보기 쉽게 재구성했습니다."
            },
            cta: {
                discord: "Discord 참가",
                tiktok: "TikTok",
                youtube: "YouTube"
            },
            stats: {
                build: "빌드",
                languages: "언어",
                tabs: "주요 탭",
                groups: "기능 그룹"
            },
            snapshot: {
                kicker: "소스 스택",
                title: "로컬라이즈 빌드와 공용 기반",
                body: "다국어 `hub-*.lua` 파일들과 `orion.lua` 안의 Orion UI 레이어를 기준으로 페이지를 구성했습니다.",
                labels: {
                    source: "소스 세트",
                    locale: "선택된 빌드",
                    channels: "채널"
                }
            },
            overview: {
                kicker: "소스 기반 개요",
                title: "Lua 빌드에서 다시 만든 랜딩 페이지",
                body: "Lua 파일에는 인증, 커뮤니티 링크, 전투 및 유틸리티 탭, 채팅 연동, 피아노 자동화, 키보드 도구, 디코이 제어, UI 프리셋 저장이 담겨 있습니다. 이 페이지는 그 구조를 유지한 채 웹에서 더 읽기 쉽게 정리합니다."
            },
            detailLabels: {
                author: "작성자",
                roblox: "Roblox ID",
                foundation: "UI 기반",
                notes: "피아노 노트"
            },
            systems: {
                kicker: "핵심 시스템",
                title: "소스 파일이 보여주는 구성",
                body: "아래 카드는 소스의 탭 이름과 섹션 이름에서 드러나는 모듈을 요약합니다."
            },
            modules: {
                chat: {
                    title: "채팅 네트워크",
                    text: "전체, 서버 전용, 개인 채팅과 함께 Discord 기반 기록, 알림, 티커를 제공합니다."
                },
                grab: {
                    title: "잡기 시스템",
                    text: "슈퍼 스로우, 스핀 그랩, 노클립 그랩, 인비지블 그랩, 라인 확장과 다양한 라인 효과를 포함합니다."
                },
                piano: {
                    title: "피아노 툴킷",
                    text: "MusicKeyboard를 감지하고 플레이어를 따라가며 JSON 노트를 불러오고 자동 연주와 수동 연주를 지원합니다."
                },
                keyboard: {
                    title: "키보드 도구",
                    text: "텔레포트, 앵커, 사일런트 에임, 설정 가능한 미니맵이 키보드 중심 도구로 묶여 있습니다."
                },
                actions: {
                    title: "액션 모음",
                    text: "Bring, loop kill, Blobman 관련 기능, 전체 화염 루틴 같은 대상 조작이 포함됩니다."
                },
                settings: {
                    title: "설정과 UI",
                    text: "프리셋, 색상, UI 투명도, 배경 ID, 실행 중 설정 상태를 저장합니다."
                }
            },
            interface: {
                kicker: "로케일 미리보기",
                title: "주요 탭 흐름",
                body: "아래 순서는 선택한 언어 파일에서 직접 가져온 것입니다.",
                badge: "선택된 소스"
            },
            languages: {
                kicker: "지원 로케일",
                title: "10개 언어 빌드",
                body: "아래 각 카드는 실제 `hub-*.lua` 변형을 나타냅니다. 하나를 선택하면 페이지 문구와 탭 미리보기가 함께 바뀝니다.",
                switchLabel: "이 언어 사용"
            },
            footer: "`hub-*.lua`와 `orion.lua`를 바탕으로 정리한 Holon HUB v1.5.5 개요 사이트."
        },
        ru: {
            langTag: "ru",
            dir: "ltr",
            label: "Russian",
            nativeName: "Русский",
            sourceFile: "hub-ru.lua",
            tabs: ["Главная", "Настройки режима", "Игрок", "Защита", "Захват", "Аура", "Чат", "Пианино", "Клавиатура", "Действия", "Дополнительно", "Приманка"],
            localeLabel: "Язык",
            nav: {
                overview: "Обзор",
                systems: "Системы",
                interface: "Интерфейс",
                languages: "Языки"
            },
            hero: {
                eyebrow: "Prometheus / FTAP / Orion UI",
                subtitle: "Многоязычный обзор на основе исходников",
                lead: "Этот сайт переупорядочивает Holon HUB v1.5.5 на основе локализованных сборок `hub-*.lua` и общего UI-слоя `orion.lua`."
            },
            cta: {
                discord: "Войти в Discord",
                tiktok: "TikTok",
                youtube: "YouTube"
            },
            stats: {
                build: "Сборка",
                languages: "Языки",
                tabs: "Основные вкладки",
                groups: "Группы функций"
            },
            snapshot: {
                kicker: "Стек исходников",
                title: "Локализованные сборки и общая база",
                body: "Страница собрана из многоязычных файлов `hub-*.lua` и слоя Orion UI в `orion.lua`.",
                labels: {
                    source: "Набор файлов",
                    locale: "Выбранная сборка",
                    channels: "Каналы"
                }
            },
            overview: {
                kicker: "Обзор по исходникам",
                title: "Лендинг, собранный из Lua-сборок",
                body: "Lua-файлы описывают крупный Roblox hub с авторизацией, ссылками сообщества, боевыми и утилитарными вкладками, интеграцией чата, автоматизацией пианино, клавиатурными инструментами, управлением приманкой и сохранением UI-пресетов. Эта страница делает структуру удобнее для просмотра в браузере."
            },
            detailLabels: {
                author: "Автор",
                roblox: "Roblox ID",
                foundation: "UI-основа",
                notes: "Ноты пианино"
            },
            systems: {
                kicker: "Ключевые системы",
                title: "Что показывают исходные файлы",
                body: "Карточки ниже кратко описывают модули, которые видны по именам вкладок и секций в исходниках."
            },
            modules: {
                chat: {
                    title: "Сеть чата",
                    text: "Глобальный, серверный и приватный чат с историей через Discord, уведомлениями и бегущей строкой."
                },
                grab: {
                    title: "Системы захвата",
                    text: "Включают super throw, spin grab, noclip grab, invisible grab, line extender и эффекты линий."
                },
                piano: {
                    title: "Набор пианино",
                    text: "Определяет MusicKeyboard, следует за игроками, загружает JSON-ноты и поддерживает автоплей и ручную игру."
                },
                keyboard: {
                    title: "Инструменты клавиатуры",
                    text: "Teleport, anchor, silent aim и настраиваемая миникарта собраны в клавиатурном наборе."
                },
                actions: {
                    title: "Набор действий",
                    text: "Целевые действия включают bring, loop kill, инструменты Blobman и массовые огненные сценарии."
                },
                settings: {
                    title: "Настройки и UI",
                    text: "Сохраняет пресеты, цвета, прозрачность UI, фоновые ID и состояния конфигурации."
                }
            },
            interface: {
                kicker: "Просмотр локали",
                title: "Порядок основных вкладок",
                body: "Порядок ниже взят прямо из выбранного языкового файла.",
                badge: "Выбранный источник"
            },
            languages: {
                kicker: "Поддерживаемые локали",
                title: "10 языковых сборок",
                body: "Каждая карточка ниже соответствует реальному варианту `hub-*.lua`. Выберите одну, чтобы переключить текст страницы и просмотр вкладок.",
                switchLabel: "Использовать этот язык"
            },
            footer: "Обзор Holon HUB v1.5.5, организованный по `hub-*.lua` и `orion.lua`."
        },
        tr: {
            langTag: "tr",
            dir: "ltr",
            label: "Turkish",
            nativeName: "Türkçe",
            sourceFile: "hub-tr.lua",
            tabs: ["Ana", "Mod ayarlari", "Oyuncu", "Savunma", "Tutma", "Aura", "Sohbet", "Piyano", "Klavye", "Aksiyon", "Ek ozellikler", "Yem"],
            localeLabel: "Dil",
            nav: {
                overview: "Genel bakis",
                systems: "Sistemler",
                interface: "Arayuz",
                languages: "Diller"
            },
            hero: {
                eyebrow: "Prometheus / FTAP / Orion UI",
                subtitle: "Kaynak tabanli cok dilli yapi ozeti",
                lead: "Bu site, yerellestirilmis `hub-*.lua` yapilari ve ortak `orion.lua` katmani uzerinden Holon HUB v1.5.5'i web icin yeniden duzenler."
            },
            cta: {
                discord: "Discord'a katil",
                tiktok: "TikTok",
                youtube: "YouTube"
            },
            stats: {
                build: "Yapi",
                languages: "Diller",
                tabs: "Ana sekmeler",
                groups: "Ozellik gruplari"
            },
            snapshot: {
                kicker: "Kaynak yigini",
                title: "Yerellestirilmis yapilar, ortak temel",
                body: "Sayfa, cok dilli `hub-*.lua` dosyalari ve `orion.lua` icindeki Orion UI katmanindan duzenlenmistir.",
                labels: {
                    source: "Kaynak seti",
                    locale: "Secili yapi",
                    channels: "Kanallar"
                }
            },
            overview: {
                kicker: "Kaynak tabanli genel bakis",
                title: "Lua yapilarindan yeniden kurulan acilis sayfasi",
                body: "Lua dosyalari; dogrulama, topluluk baglantilari, savas ve yardimci sekmeler, sohbet entegrasyonu, piyano otomasyonu, klavye araclari, yem kontrolu ve UI onayar kayitlari olan buyuk bir Roblox hub'i anlatiyor. Bu sayfa o yapinin web uzerinde daha rahat incelenmesini saglar."
            },
            detailLabels: {
                author: "Yazar",
                roblox: "Roblox ID",
                foundation: "UI temeli",
                notes: "Piyano notalari"
            },
            systems: {
                kicker: "Temel sistemler",
                title: "Kaynak dosyalarin gosterdigi yapi",
                body: "Asagidaki kartlar, kaynaklardaki sekme ve bolum adlarindan gorunen modulleri ozetler."
            },
            modules: {
                chat: {
                    title: "Sohbet agi",
                    text: "Genel, sunucu ici ve ozel sohbet; Discord gecmisi, bildirimler ve kayan yazi destegi ile gelir."
                },
                grab: {
                    title: "Tutma sistemleri",
                    text: "Super throw, spin grab, noclip grab, invisible grab, line extender ve cizgi efektlerini icerir."
                },
                piano: {
                    title: "Piyano araclari",
                    text: "MusicKeyboard'u algilar, oyunculari takip eder, JSON notalari yukler ve otomatik ile manuel calmayi destekler."
                },
                keyboard: {
                    title: "Klavye araclari",
                    text: "Teleport, anchor, silent aim ve ayarlanabilir minimap klavye odakli araclarin icindedir."
                },
                actions: {
                    title: "Aksiyon paketi",
                    text: "Hedef aksiyonlari bring akislari, loop kill araclari, Blobman islemleri ve toplu ates rutinlerini kapsar."
                },
                settings: {
                    title: "Ayarlar ve UI",
                    text: "Onayarlar, renkler, UI seffafligi, arka plan ID'leri ve calisma sirasindaki ayarlari saklar."
                }
            },
            interface: {
                kicker: "Dil onizlemesi",
                title: "Ana sekme akisi",
                body: "Asagidaki sira, secilen dil dosyasindan dogrudan alinmistir.",
                badge: "Secilen kaynak"
            },
            languages: {
                kicker: "Desteklenen yereller",
                title: "10 dil yapisi",
                body: "Asagidaki her kart gercek bir `hub-*.lua` varyantini temsil eder. Birini secerek sayfa metnini ve sekme onizlemesini degistirebilirsiniz.",
                switchLabel: "Bu dili kullan"
            },
            footer: "`hub-*.lua` ve `orion.lua` temelinde duzenlenen Holon HUB v1.5.5 ozeti."
        }
    }
};
