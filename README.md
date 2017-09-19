# im_pdf

## 概要

ImageMagickによるPDFファイルの作成

## 使用方法

### im_pdf.sh

画像ファイルからPDFファイルを作成します。

    $ im_pdf.sh input.png output.pdf

### その他

* 上記で紹介したツールの詳細については、「ツール名 --help」を参照してください。

## 動作環境

OS:

* Linux
* Cygwin

依存パッケージ または 依存コマンド:

* make (インストール目的のみ)
* realpath
* ImageMagick
* [common_sh](https://github.com/yuksiy/common_sh)

## インストール

ソースからインストールする場合:

    (Linux, Cygwin の場合)
    # make install

fil_pkg.plを使用してインストールする場合:

[fil_pkg.pl](https://github.com/yuksiy/fil_tools_pl/blob/master/README.md#fil_pkgpl) を参照してください。

## インストール後の設定

環境変数「PATH」にインストール先ディレクトリを追加してください。

## 最新版の入手先

<https://github.com/yuksiy/im_pdf>

## License

MIT License. See [LICENSE](https://github.com/yuksiy/im_pdf/blob/master/LICENSE) file.

## Copyright

Copyright (c) 2013-2017 Yukio Shiiya
