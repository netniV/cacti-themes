#/bin/bash
if [[ "$1" == "" ]]; then
	echo "$0: <path to cacti folder>";
else
	if [[ ! -d "$1" ]]; then
		echo "Path is not to a directory";
		exit -1;
	fi

	if [[ ! -d "$1/include/themes/" ]]; then
		echo "Path is not to a cacti directory, could not find 'include/themes'";
		exit -2;
	fi

	src_folder=$(pwd)
	tar_folder=$(realpath "$1/include/themes")
	sym_folder=$(realpath --relative-to="$1/include/themes/" $src_folder)

	echo "src: $src_folder"
	echo "sym: $sym_folder";
	echo
	
	pushd "$1/include/themes" > /dev/nul 2>&1;
	
	cur_folder=$(pwd)
	if [[ $cur_folder != $tar_folder ]]; then
		echo "Expected: $tar_folder";
		echo "   Found: $cur_folder";
		exit -3;
	fi

	hasGit=0;
	if [[ -d .git ]]; then
		hasGit=1;
	fi;

	hasCactiThemes=0;
	if [[ -d cacti_themes ]]; then
		hasCactiThemes=1;
	fi

	find "$sym_folder" -maxdepth 1 -type d -exec ln -s "{}" \;
	if [[ hasCactiThemes -eq 0 ]]; then
		echo "Removing 'cacti-themes' ...";
		rm "cacti-themes";
	fi

	if [[ hasGit -eq 0 ]]; then
		echo "Removing '.git' ...";
		rm ".git";
	fi;
fi
