window.HOLON_PIANO_GUIDE = {
    locales: {
        ja: {
            title: "ピアノの使い方",
            subtitle: "曲ファイルの入れ方や実際の使い方を書ける、あとから編集用の専用ファイルです。",
            updatedLabel: "更新日",
            updatedAt: "2026-04-08",
            intro: "Holon HUB のピアノ機能について、導入手順、演奏方法、JSON の使い方、注意点などを自由に追記できます。画像は相対パスでも URL でも指定できます。",
            imageAltFallback: "ガイド画像",
            blocks: [
                {
                    type: "paragraph",
                    title: "曲ファイルの入れ方",
                    text: "使いたい曲の JSON ファイルをダウンロードして、iPhone / iPad ならファイルアプリ、PC ならファイル管理画面から、使っている各エクゼキューターの workspace 内にある `FTAP_Notes` フォルダへ入れてください。Holon HUB はその中の JSON を読み込みます。"
                },
                {
                    type: "steps",
                    title: "基本の流れ",
                    items: [
                        "Holon HUB を起動して Piano タブを開く。",
                        "Enable Piano Features を有効化する。",
                        "曲ファイルをダウンロードして、使っているエクゼキューターの workspace/FTAP_Notes に入れる。",
                        "Refresh Songs で曲一覧を更新する。",
                        "Select Song で曲を選び、Play Selected Song で再生する。",
                        "必要なら Follow Player を有効にして、ピアノ追従を使う。"
                    ]
                },
                {
                    type: "note",
                    title: "MIDI から作る場合",
                    text: "まだ JSON の曲ファイルがない場合は、このサイトの MIDI→JSON 変換を使って作成し、その JSON を `FTAP_Notes` に入れてください。"
                },
                {
                    type: "image",
                    title: "画像サンプル",
                    src: "",
                    alt: "ここにピアノのスクリーンショットを入れる",
                    caption: "ここにファイルアプリや FTAP_Notes フォルダの画像、Piano タブの画面などを入れられます。`src` にファイルパスか URL を入れてください。"
                },
                {
                    type: "code",
                    title: "JSON の例",
                    language: "json",
                    code: `[
  { "key": "Key1C", "delay": 0.15 },
  { "key": "Key1E", "delay": 0.20 },
  { "key": "Key1G", "delay": 0.18 }
]`
                }
            ]
        },
        en: {
            title: "How to Use Piano",
            subtitle: "This is a dedicated file you can edit later to explain how to add song files and how to use the piano.",
            updatedLabel: "Updated",
            updatedAt: "2026-04-08",
            intro: "You can freely add setup steps, play instructions, JSON notes, and warnings for the Holon HUB piano feature here. Images can use either relative paths or full URLs.",
            imageAltFallback: "Guide image",
            blocks: [
                {
                    type: "paragraph",
                    title: "How to Add Song Files",
                    text: "Download the JSON file for the song you want to use. On iPhone or iPad, use the Files app. On PC, use your file manager. Then place the file into the `FTAP_Notes` folder inside the workspace of the executor you use. Holon HUB reads the JSON files from that folder."
                },
                {
                    type: "steps",
                    title: "Basic Flow",
                    items: [
                        "Launch Holon HUB and open the Piano tab.",
                        "Enable `Enable Piano Features`.",
                        "Download a song file and put it in your executor's `workspace/FTAP_Notes` folder.",
                        "Use `Refresh Songs` to update the song list.",
                        "Choose a song with `Select Song`, then press `Play Selected Song`.",
                        "If needed, enable `Follow Player` to use piano follow mode."
                    ]
                },
                {
                    type: "note",
                    title: "If You Are Creating From MIDI",
                    text: "If you do not have a JSON song file yet, use the MIDI-to-JSON converter on this site, then place the generated JSON into `FTAP_Notes`."
                },
                {
                    type: "image",
                    title: "Image Sample",
                    src: "",
                    alt: "Place a piano screenshot here",
                    caption: "You can place images here for the Files app, the `FTAP_Notes` folder, or the Piano tab screen. Put a file path or URL into `src`."
                },
                {
                    type: "code",
                    title: "JSON Example",
                    language: "json",
                    code: `[
  { "key": "Key1C", "delay": 0.15 },
  { "key": "Key1E", "delay": 0.20 },
  { "key": "Key1G", "delay": 0.18 }
]`
                }
            ]
        },
        ar: {
            title: "كيفية استخدام البيانو",
            subtitle: "هذا ملف مخصص يمكنك تعديله لاحقا لشرح كيفية إضافة ملفات الأغاني وكيفية استخدام البيانو.",
            updatedLabel: "آخر تحديث",
            updatedAt: "2026-04-08",
            intro: "يمكنك إضافة خطوات الإعداد وطريقة العزف وملاحظات JSON والتنبيهات الخاصة بميزة البيانو في Holon HUB هنا بحرية. يمكن للصور أن تستخدم مسارات نسبية أو روابط URL كاملة.",
            imageAltFallback: "صورة الدليل",
            blocks: [
                {
                    type: "paragraph",
                    title: "كيفية إضافة ملفات الأغاني",
                    text: "قم بتنزيل ملف JSON للأغنية التي تريد استخدامها. على iPhone أو iPad استخدم تطبيق الملفات، وعلى الكمبيوتر استخدم مدير الملفات. ثم ضع الملف داخل مجلد `FTAP_Notes` الموجود في workspace الخاص بالإكزكيوتر الذي تستخدمه. يقوم Holon HUB بقراءة ملفات JSON من هذا المجلد."
                },
                {
                    type: "steps",
                    title: "الخطوات الأساسية",
                    items: [
                        "شغل Holon HUB وافتح تبويب Piano.",
                        "فعّل `Enable Piano Features`.",
                        "نزّل ملف الأغنية وضعه داخل مجلد `workspace/FTAP_Notes` الخاص بالإكزكيوتر.",
                        "استخدم `Refresh Songs` لتحديث قائمة الأغاني.",
                        "اختر أغنية من `Select Song` ثم اضغط `Play Selected Song`.",
                        "إذا احتجت، فعّل `Follow Player` لاستخدام وضع متابعة البيانو."
                    ]
                },
                {
                    type: "note",
                    title: "إذا كنت تنشئ الملف من MIDI",
                    text: "إذا لم يكن لديك ملف أغنية بصيغة JSON بعد، استخدم محول MIDI إلى JSON في هذا الموقع، ثم ضع ملف JSON الناتج داخل `FTAP_Notes`."
                },
                {
                    type: "image",
                    title: "مثال على الصورة",
                    src: "",
                    alt: "ضع لقطة شاشة للبيانو هنا",
                    caption: "يمكنك وضع صور هنا لتطبيق الملفات أو مجلد `FTAP_Notes` أو شاشة تبويب Piano. ضع مسار الملف أو الرابط داخل `src`."
                },
                {
                    type: "code",
                    title: "مثال JSON",
                    language: "json",
                    code: `[
  { "key": "Key1C", "delay": 0.15 },
  { "key": "Key1E", "delay": 0.20 },
  { "key": "Key1G", "delay": 0.18 }
]`
                }
            ]
        },
        bn: {
            title: "পিয়ানো ব্যবহার করার নিয়ম",
            subtitle: "গানের ফাইল কীভাবে যোগ করতে হয় এবং পিয়ানো কীভাবে ব্যবহার করতে হয় তা পরে সম্পাদনা করার জন্য এটি একটি আলাদা ফাইল।",
            updatedLabel: "আপডেট",
            updatedAt: "2026-04-08",
            intro: "Holon HUB-এর পিয়ানো ফিচারের সেটআপ ধাপ, বাজানোর নিয়ম, JSON নোট এবং সতর্কতা এখানে স্বাধীনভাবে যোগ করতে পারেন। ছবির জন্য relative path বা পূর্ণ URL দুটোই ব্যবহার করা যাবে।",
            imageAltFallback: "গাইড ছবি",
            blocks: [
                {
                    type: "paragraph",
                    title: "গানের ফাইল কীভাবে যোগ করবেন",
                    text: "যে গানটি ব্যবহার করতে চান তার JSON ফাইল ডাউনলোড করুন। iPhone বা iPad হলে Files অ্যাপ ব্যবহার করুন, আর PC হলে file manager ব্যবহার করুন। তারপর আপনার ব্যবহৃত executor-এর workspace-এর ভিতরের `FTAP_Notes` ফোল্ডারে ফাইলটি রাখুন। Holon HUB ওই ফোল্ডারের JSON ফাইল পড়ে।"
                },
                {
                    type: "steps",
                    title: "মৌলিক ধাপ",
                    items: [
                        "Holon HUB চালু করে Piano ট্যাব খুলুন।",
                        "`Enable Piano Features` চালু করুন।",
                        "গানের ফাইল ডাউনলোড করে executor-এর `workspace/FTAP_Notes` ফোল্ডারে রাখুন।",
                        "`Refresh Songs` ব্যবহার করে গানের তালিকা আপডেট করুন।",
                        "`Select Song` থেকে গান বেছে নিয়ে `Play Selected Song` চাপুন।",
                        "প্রয়োজন হলে `Follow Player` চালু করে piano follow mode ব্যবহার করুন।"
                    ]
                },
                {
                    type: "note",
                    title: "যদি MIDI থেকে তৈরি করেন",
                    text: "যদি এখনো JSON গানের ফাইল না থাকে, তাহলে এই সাইটের MIDI-to-JSON converter ব্যবহার করুন, তারপর তৈরি হওয়া JSON ফাইলটি `FTAP_Notes`-এ রাখুন।"
                },
                {
                    type: "image",
                    title: "ছবির উদাহরণ",
                    src: "",
                    alt: "এখানে পিয়ানোর স্ক্রিনশট দিন",
                    caption: "এখানে Files অ্যাপ, `FTAP_Notes` ফোল্ডার, বা Piano ট্যাবের স্ক্রিনের ছবি রাখতে পারেন। `src`-এ file path বা URL দিন।"
                },
                {
                    type: "code",
                    title: "JSON উদাহরণ",
                    language: "json",
                    code: `[
  { "key": "Key1C", "delay": 0.15 },
  { "key": "Key1E", "delay": 0.20 },
  { "key": "Key1G", "delay": 0.18 }
]`
                }
            ]
        },
        de: {
            title: "So verwendest du das Piano",
            subtitle: "Dies ist eine eigene Datei, die du spaeter bearbeiten kannst, um zu erklaeren, wie Song-Dateien hinzugefuegt werden und wie das Piano benutzt wird.",
            updatedLabel: "Aktualisiert",
            updatedAt: "2026-04-08",
            intro: "Hier kannst du frei Einrichtungs-Schritte, Spielanweisungen, JSON-Hinweise und Warnungen fuer die Piano-Funktion von Holon HUB eintragen. Bilder koennen relative Pfade oder komplette URLs verwenden.",
            imageAltFallback: "Guide-Bild",
            blocks: [
                {
                    type: "paragraph",
                    title: "So fuegst du Song-Dateien hinzu",
                    text: "Lade die JSON-Datei des Songs herunter, den du verwenden moechtest. Auf iPhone oder iPad verwendest du die Dateien-App, auf dem PC den Dateimanager. Lege die Datei dann in den Ordner `FTAP_Notes` innerhalb des workspace deines Executors. Holon HUB liest die JSON-Dateien aus diesem Ordner."
                },
                {
                    type: "steps",
                    title: "Grundablauf",
                    items: [
                        "Starte Holon HUB und oeffne den Piano-Tab.",
                        "Aktiviere `Enable Piano Features`.",
                        "Lade eine Song-Datei herunter und lege sie in den Ordner `workspace/FTAP_Notes` deines Executors.",
                        "Verwende `Refresh Songs`, um die Songliste zu aktualisieren.",
                        "Waehle mit `Select Song` ein Lied aus und druecke dann `Play Selected Song`.",
                        "Falls noetig, aktiviere `Follow Player`, um den Piano-Follow-Modus zu nutzen."
                    ]
                },
                {
                    type: "note",
                    title: "Wenn du aus MIDI erstellst",
                    text: "Wenn du noch keine JSON-Song-Datei hast, benutze den MIDI-zu-JSON-Konverter auf dieser Website und lege die erzeugte JSON-Datei danach in `FTAP_Notes` ab."
                },
                {
                    type: "image",
                    title: "Bildbeispiel",
                    src: "",
                    alt: "Hier einen Piano-Screenshot einfuegen",
                    caption: "Hier kannst du Bilder von der Dateien-App, dem Ordner `FTAP_Notes` oder dem Piano-Tab platzieren. Trage in `src` einen Dateipfad oder eine URL ein."
                },
                {
                    type: "code",
                    title: "JSON-Beispiel",
                    language: "json",
                    code: `[
  { "key": "Key1C", "delay": 0.15 },
  { "key": "Key1E", "delay": 0.20 },
  { "key": "Key1G", "delay": 0.18 }
]`
                }
            ]
        },
        es: {
            title: "Como usar el piano",
            subtitle: "Este es un archivo dedicado que puedes editar despues para explicar como agregar archivos de canciones y como usar el piano.",
            updatedLabel: "Actualizado",
            updatedAt: "2026-04-08",
            intro: "Aqui puedes agregar libremente pasos de configuracion, instrucciones para tocar, notas sobre JSON y advertencias para la funcion de piano de Holon HUB. Las imagenes pueden usar rutas relativas o URLs completas.",
            imageAltFallback: "Imagen de la guia",
            blocks: [
                {
                    type: "paragraph",
                    title: "Como agregar archivos de canciones",
                    text: "Descarga el archivo JSON de la cancion que quieras usar. En iPhone o iPad usa la app Archivos, y en PC usa tu administrador de archivos. Luego coloca el archivo dentro de la carpeta `FTAP_Notes` que esta en el workspace del executor que uses. Holon HUB lee los archivos JSON desde esa carpeta."
                },
                {
                    type: "steps",
                    title: "Flujo basico",
                    items: [
                        "Inicia Holon HUB y abre la pestana Piano.",
                        "Activa `Enable Piano Features`.",
                        "Descarga un archivo de cancion y colocalo en la carpeta `workspace/FTAP_Notes` de tu executor.",
                        "Usa `Refresh Songs` para actualizar la lista de canciones.",
                        "Elige una cancion con `Select Song` y luego pulsa `Play Selected Song`.",
                        "Si hace falta, activa `Follow Player` para usar el modo de seguimiento del piano."
                    ]
                },
                {
                    type: "note",
                    title: "Si lo creas desde MIDI",
                    text: "Si todavia no tienes un archivo de cancion en JSON, usa el convertidor de MIDI a JSON de este sitio y luego coloca el JSON generado dentro de `FTAP_Notes`."
                },
                {
                    type: "image",
                    title: "Ejemplo de imagen",
                    src: "",
                    alt: "Coloca aqui una captura del piano",
                    caption: "Aqui puedes colocar imagenes de la app Archivos, la carpeta `FTAP_Notes` o la pantalla de la pestana Piano. Pon una ruta de archivo o una URL en `src`."
                },
                {
                    type: "code",
                    title: "Ejemplo de JSON",
                    language: "json",
                    code: `[
  { "key": "Key1C", "delay": 0.15 },
  { "key": "Key1E", "delay": 0.20 },
  { "key": "Key1G", "delay": 0.18 }
]`
                }
            ]
        },
        fr: {
            title: "Comment utiliser le piano",
            subtitle: "Ceci est un fichier dedie que vous pourrez modifier plus tard pour expliquer comment ajouter des fichiers de morceaux et comment utiliser le piano.",
            updatedLabel: "Mise a jour",
            updatedAt: "2026-04-08",
            intro: "Vous pouvez ajouter librement ici les etapes d'installation, les instructions de jeu, les notes JSON et les avertissements pour la fonction piano de Holon HUB. Les images peuvent utiliser des chemins relatifs ou des URL completes.",
            imageAltFallback: "Image du guide",
            blocks: [
                {
                    type: "paragraph",
                    title: "Comment ajouter des fichiers de morceaux",
                    text: "Telechargez le fichier JSON du morceau que vous voulez utiliser. Sur iPhone ou iPad, utilisez l'app Fichiers, et sur PC, votre gestionnaire de fichiers. Placez ensuite le fichier dans le dossier `FTAP_Notes` situe dans le workspace de l'executor que vous utilisez. Holon HUB lit les fichiers JSON depuis ce dossier."
                },
                {
                    type: "steps",
                    title: "Flux de base",
                    items: [
                        "Lancez Holon HUB et ouvrez l'onglet Piano.",
                        "Activez `Enable Piano Features`.",
                        "Telechargez un fichier de morceau et placez-le dans le dossier `workspace/FTAP_Notes` de votre executor.",
                        "Utilisez `Refresh Songs` pour mettre a jour la liste des morceaux.",
                        "Choisissez un morceau avec `Select Song`, puis appuyez sur `Play Selected Song`.",
                        "Si besoin, activez `Follow Player` pour utiliser le mode de suivi du piano."
                    ]
                },
                {
                    type: "note",
                    title: "Si vous partez d'un MIDI",
                    text: "Si vous n'avez pas encore de fichier de morceau en JSON, utilisez le convertisseur MIDI vers JSON de ce site, puis placez le JSON genere dans `FTAP_Notes`."
                },
                {
                    type: "image",
                    title: "Exemple d'image",
                    src: "",
                    alt: "Placez ici une capture d'ecran du piano",
                    caption: "Vous pouvez placer ici des images de l'app Fichiers, du dossier `FTAP_Notes` ou de l'ecran de l'onglet Piano. Mettez un chemin de fichier ou une URL dans `src`."
                },
                {
                    type: "code",
                    title: "Exemple JSON",
                    language: "json",
                    code: `[
  { "key": "Key1C", "delay": 0.15 },
  { "key": "Key1E", "delay": 0.20 },
  { "key": "Key1G", "delay": 0.18 }
]`
                }
            ]
        },
        ko: {
            title: "피아노 사용 방법",
            subtitle: "곡 파일을 추가하는 방법과 피아노 사용법을 나중에 수정할 수 있도록 정리해 둔 전용 파일입니다.",
            updatedLabel: "업데이트",
            updatedAt: "2026-04-08",
            intro: "Holon HUB 피아노 기능의 설정 방법, 연주 방법, JSON 설명, 주의사항을 여기에서 자유롭게 추가할 수 있습니다. 이미지는 상대 경로나 전체 URL 모두 사용할 수 있습니다.",
            imageAltFallback: "가이드 이미지",
            blocks: [
                {
                    type: "paragraph",
                    title: "곡 파일 추가 방법",
                    text: "사용할 곡의 JSON 파일을 다운로드하세요. iPhone이나 iPad에서는 파일 앱을, PC에서는 파일 관리자를 사용하면 됩니다. 그다음 사용 중인 실행기의 workspace 안에 있는 `FTAP_Notes` 폴더에 파일을 넣으세요. Holon HUB는 그 폴더의 JSON 파일을 읽습니다."
                },
                {
                    type: "steps",
                    title: "기본 순서",
                    items: [
                        "Holon HUB를 실행하고 Piano 탭을 엽니다.",
                        "`Enable Piano Features`를 활성화합니다.",
                        "곡 파일을 다운로드해서 실행기의 `workspace/FTAP_Notes` 폴더에 넣습니다.",
                        "`Refresh Songs`로 곡 목록을 새로고침합니다.",
                        "`Select Song`에서 곡을 고른 뒤 `Play Selected Song`을 누릅니다.",
                        "필요하면 `Follow Player`를 켜서 피아노 추적 모드를 사용합니다."
                    ]
                },
                {
                    type: "note",
                    title: "MIDI에서 만드는 경우",
                    text: "아직 JSON 곡 파일이 없다면 이 사이트의 MIDI to JSON 변환기를 사용한 뒤, 생성된 JSON 파일을 `FTAP_Notes`에 넣으세요."
                },
                {
                    type: "image",
                    title: "이미지 예시",
                    src: "",
                    alt: "여기에 피아노 스크린샷 넣기",
                    caption: "여기에 파일 앱, `FTAP_Notes` 폴더, Piano 탭 화면 이미지를 넣을 수 있습니다. `src`에 파일 경로나 URL을 입력하세요."
                },
                {
                    type: "code",
                    title: "JSON 예시",
                    language: "json",
                    code: `[
  { "key": "Key1C", "delay": 0.15 },
  { "key": "Key1E", "delay": 0.20 },
  { "key": "Key1G", "delay": 0.18 }
]`
                }
            ]
        },
        ru: {
            title: "Как пользоваться пианино",
            subtitle: "Это отдельный файл, который можно позже редактировать, чтобы объяснить, как добавлять файлы песен и как пользоваться пианино.",
            updatedLabel: "Обновлено",
            updatedAt: "2026-04-08",
            intro: "Здесь можно свободно добавить шаги настройки, инструкции по игре, заметки по JSON и предупреждения для функции пианино в Holon HUB. Для изображений можно использовать относительные пути или полные URL.",
            imageAltFallback: "Изображение руководства",
            blocks: [
                {
                    type: "paragraph",
                    title: "Как добавить файлы песен",
                    text: "Скачайте JSON-файл песни, которую хотите использовать. На iPhone или iPad используйте приложение Files, а на ПК используйте файловый менеджер. Затем поместите файл в папку `FTAP_Notes` внутри workspace вашего executor. Holon HUB читает JSON-файлы из этой папки."
                },
                {
                    type: "steps",
                    title: "Основной порядок",
                    items: [
                        "Запустите Holon HUB и откройте вкладку Piano.",
                        "Включите `Enable Piano Features`.",
                        "Скачайте файл песни и поместите его в папку `workspace/FTAP_Notes` вашего executor.",
                        "Используйте `Refresh Songs`, чтобы обновить список песен.",
                        "Выберите песню через `Select Song`, затем нажмите `Play Selected Song`.",
                        "При необходимости включите `Follow Player`, чтобы использовать режим следования пианино."
                    ]
                },
                {
                    type: "note",
                    title: "Если создаете из MIDI",
                    text: "Если у вас еще нет JSON-файла песни, используйте конвертер MIDI в JSON на этом сайте, а затем поместите созданный JSON в `FTAP_Notes`."
                },
                {
                    type: "image",
                    title: "Пример изображения",
                    src: "",
                    alt: "Поместите сюда скриншот пианино",
                    caption: "Здесь можно разместить изображения приложения Files, папки `FTAP_Notes` или экрана вкладки Piano. Укажите путь к файлу или URL в `src`."
                },
                {
                    type: "code",
                    title: "Пример JSON",
                    language: "json",
                    code: `[
  { "key": "Key1C", "delay": 0.15 },
  { "key": "Key1E", "delay": 0.20 },
  { "key": "Key1G", "delay": 0.18 }
]`
                }
            ]
        },
        tr: {
            title: "Piyano nasil kullanilir",
            subtitle: "Bu, sarki dosyalarinin nasil eklenecegini ve piyanonun nasil kullanilacagini aciklamak icin daha sonra duzenleyebileceginiz ozel bir dosyadir.",
            updatedLabel: "Guncellendi",
            updatedAt: "2026-04-08",
            intro: "Holon HUB piyano ozelligi icin kurulum adimlari, calis talimatlari, JSON notlari ve uyari metinlerini buraya ozgurce ekleyebilirsiniz. Gorseller goreli yol ya da tam URL kullanabilir.",
            imageAltFallback: "Rehber gorseli",
            blocks: [
                {
                    type: "paragraph",
                    title: "Sarki dosyalari nasil eklenir",
                    text: "Kullanmak istediginiz sarkinin JSON dosyasini indirin. iPhone veya iPad'de Dosyalar uygulamasini, PC'de ise dosya yoneticisini kullanin. Ardindan dosyayi kullandiginiz executor'un workspace icindeki `FTAP_Notes` klasorune koyun. Holon HUB JSON dosyalarini bu klasorden okur."
                },
                {
                    type: "steps",
                    title: "Temel akis",
                    items: [
                        "Holon HUB'ı baslatin ve Piano sekmesini acin.",
                        "`Enable Piano Features` secenegini etkinlestirin.",
                        "Bir sarki dosyasi indirip executor'unuzun `workspace/FTAP_Notes` klasorune koyun.",
                        "Sarki listesini guncellemek icin `Refresh Songs` kullanin.",
                        "`Select Song` ile bir sarki secin, sonra `Play Selected Song` tusuna basin.",
                        "Gerekirse `Follow Player` secenegini acarak piyano takip modunu kullanin."
                    ]
                },
                {
                    type: "note",
                    title: "MIDI'den olusturuyorsaniz",
                    text: "Henuz bir JSON sarki dosyaniz yoksa, bu sitedeki MIDI'den JSON'a donusturucuyu kullanin ve olusturulan JSON dosyasini `FTAP_Notes` icine koyun."
                },
                {
                    type: "image",
                    title: "Gorsel ornegi",
                    src: "",
                    alt: "Buraya bir piyano ekran goruntusu koyun",
                    caption: "Buraya Dosyalar uygulamasi, `FTAP_Notes` klasoru veya Piano sekmesi ekraninin gorsellerini koyabilirsiniz. `src` alanina dosya yolu ya da URL girin."
                },
                {
                    type: "code",
                    title: "JSON ornegi",
                    language: "json",
                    code: `[
  { "key": "Key1C", "delay": 0.15 },
  { "key": "Key1E", "delay": 0.20 },
  { "key": "Key1G", "delay": 0.18 }
]`
                }
            ]
        }
    }
};
