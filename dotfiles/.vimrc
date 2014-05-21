let s:mandrawer_path=$HOME . "/projects/mandrawer"

function Rebuild_tags()
	echo "Building tags file..."
	call system(s:mandrawer_path . "/ctags.sh")		
	echo "Tags file created"
endfunction

syntax enable
filetype indent plugin on
set tabstop=4
set shiftwidth=4
map <F2> :call Rebuild_tags()<CR><CR>
set shell=/bin/sh

