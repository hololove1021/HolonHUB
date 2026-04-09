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
        }
    }
};
