#!/bin/bash

# ==============================================================================
#   機能
#     ImageMagickを使用してPDFファイルを作成する
#   構文
#     USAGE 参照
#
#   Copyright (c) 2013-2017 Yukio Shiiya
#
#   This software is released under the MIT License.
#   https://opensource.org/licenses/MIT
# ==============================================================================

######################################################################
# 基本設定
######################################################################
trap "" 28				# TRAP SET
trap "POST_PROCESS;exit 1" 1 2 15	# TRAP SET

SCRIPT_FULL_NAME=`realpath $0`
SCRIPT_ROOT=`dirname ${SCRIPT_FULL_NAME}`
SCRIPT_NAME=`basename ${SCRIPT_FULL_NAME}`
PID=$$

######################################################################
# 関数定義
######################################################################
PRE_PROCESS() {
	mkdir -p "${SCRIPT_TMP_DIR}"
}

POST_PROCESS() {
	# 一時ディレクトリの削除
	if [ ! ${DEBUG} ];then
		rm -fr "${SCRIPT_TMP_DIR}"
	fi
}

CMD_V() {
	echo "+ $@"
	"$@"
	return
}

USAGE() {
	cat <<- EOF 1>&2
		Usage:
		    im_pdf.sh [OPTIONS ...] SRC_FILE[...] DEST_FILE
		
		    SRC_FILE  : Specify source image file.
		    DEST_FILE : Specify destination PDF file.
		
		OPTIONS:
		    -Y (yes)
		       Suppresses prompting to confirm you want to remove an existing
		       destination file.
		    -t TITLE
		       Specify title of destination file.
		       (default: ${TITLE})
		    --help
		       Display this help and exit.
	EOF
}

. yesno_function.sh

######################################################################
# 変数定義
######################################################################
# システム環境 依存変数

# プログラム内部変数
FLAG_OPT_YES=FALSE
TITLE="Untitled"

#DEBUG=TRUE
TMP_DIR="/tmp"
SCRIPT_TMP_DIR="${TMP_DIR}/${SCRIPT_NAME}.${PID}"

######################################################################
# メインルーチン
######################################################################

# オプションのチェック
CMD_ARG="`getopt -o Yt: -l help -- \"$@\" 2>&1`"
if [ $? -ne 0 ];then
	echo "-E ${CMD_ARG}" 1>&2
	USAGE;exit 1
fi
eval set -- "${CMD_ARG}"
while true ; do
	opt="$1"
	case "${opt}" in
	-Y)	FLAG_OPT_YES=TRUE ; shift 1;;
	-t)	TITLE="$2" ; shift 2;;
	--help)
		USAGE;exit 0
		;;
	--)
		shift 1;break
		;;
	esac
done

# 変数定義(オプションのチェック後)
PDF_FILE_TMP="${SCRIPT_TMP_DIR}/${TITLE}.pdf"

# SRC_FILE 引数のチェック
if [ $# -lt 1 ];then
	echo "-E Missing SRC_FILE argument" 1>&2
	USAGE;exit 1
fi

# DEST_FILE 引数のチェック・取得
if [ $# -lt 2 ];then
	echo "-E Missing DEST_FILE argument" 1>&2
	USAGE;exit 1
else
	DEST_FILE="${@:$#:$#}"
fi

# DEST_FILE 引数を破棄
eval set -- "${@:1:$#-1}"

# 作業開始前処理
PRE_PROCESS

# 処理開始メッセージの表示
echo
echo "-I PDF making has started."

# 既存の宛先ファイルの存在チェック
if [ -e "${DEST_FILE}" ];then
	echo "-W \"${DEST_FILE}\" file exist." 1>&2
	# YES オプションが指定されていない場合
	if [ "${FLAG_OPT_YES}" = "FALSE" ];then
		# 処理実行確認
		echo "-Q Remove?" 1>&2
		YESNO
		# NO の場合
		if [ $? -ne 0 ];then
			echo "-I Aborted."
			POST_PROCESS;exit 0
		fi
	fi
	# 既存の宛先ファイルの削除
	echo "-W Removing destination file..." 1>&2
	CMD_V rm -f "${DEST_FILE}"
	if [ $? -ne 0 ];then
		echo "-E Command has ended unsuccessfully." 1>&2
		POST_PROCESS;exit 1
	fi
fi

# PDFファイルの作成
#echo "-I Making PDF file..."
CMD_V convert "$@" "${PDF_FILE_TMP}"
if [ $? -ne 0 ];then
	echo "-E Command has ended unsuccessfully." 1>&2
	POST_PROCESS;exit 1
fi

CMD_V mv "${PDF_FILE_TMP}" "${DEST_FILE}"
if [ $? -ne 0 ];then
	echo "-E Command has ended unsuccessfully." 1>&2
	POST_PROCESS;exit 1
fi

# 処理終了メッセージの表示
echo
echo "-I PDF making has ended successfully."

# 作業終了後処理
POST_PROCESS;exit 0

