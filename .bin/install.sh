SCRIPT_DIR=$(cd $(dirname $0); pwd)
DOTFILES_DIR=$(dirname ${SCRIPT_DIR})

if [ "$HOME" != `dirname ${DOTFILES_DIR}` ]; then
	echo "Error: dotfiles path is incorrect."
	exit 1
fi

backup_dotfiles() {
	#バックアップ用フォルダを作成
	BACKUP_DIR="$HOME/.dotfiles_backup"
	if [ ! -d "$BACKUP_DIR" ]; then
		mkdir $BACKUP_DIR
	else
		if [ -n "$(ls -A $BACKUP_DIR)" ]; then
				echo "Error: file already exists. → $BACKUP_DIR"
				exit 1
		fi
	fi

	for f in $DOTFILES_DIR/.??*; do
		#dotfilesとHOMEの両方にあるファイルをバックアップして削除
		FILE_PATH="$HOME/`basename $f`" 

		FILE=`basename $f`
		if [ $FILE == ".git" ] || [ $FILE == ".bin" ] || [ $FILE == ".gitignore" ] ;then
			continue
		fi

		#シンボリックリンク削除
		if [ -L $FILE_PATH ];then
			unlink $FILE_PATH 
			echo "unlink: $FILE_PATH" 
		fi
		#ファイルバックアップ
		if [ -e $FILE_PATH ];then
			mv $FILE_PATH $BACKUP_DIR/`basename $f`
			echo "mv: $f →  $BACKUP_DIR/`basename $f`"
		fi

		ln -s $f $FILE_PATH
		echo "ln: $f →  $FILE_PATH"
	done
}

backup_dotfiles
echo "===== done ====="