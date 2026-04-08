window.HOLON_PIANO_GUIDE = {
    title: "ピアノの使い方",
    subtitle: "曲ファイルの入れ方や実際の使い方を書ける、あとから編集用の専用ファイルです。",
    updatedAt: "2026-04-08",
    intro: "Holon HUB のピアノ機能について、導入手順、演奏方法、JSON の使い方、注意点などを自由に追記できます。画像は相対パスでも URL でも指定できます。",
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
};
