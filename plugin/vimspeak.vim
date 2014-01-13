nnoremap <silent> j j:call SpeakLine()<cr>
nnoremap <silent> k k:call SpeakLine()<cr>

nnoremap <silent> h h:call SpeakChar()<cr>
nnoremap <silent> l l:call SpeakChar()<cr>

nnoremap <silent> e e:call SpeakWord()<cr>
nnoremap <silent> w w:call SpeakWord()<cr>
nnoremap <silent> b b:call SpeakWord()<cr>

" Play some sounds to help identify when we are entering/leaving insert mode.
let s:InsertEnterSound=findfile('sounds/InsertEnter.wav', &rtp)
let s:InsertLeaveSound=findfile('sounds/InsertLeave.wav', &rtp)
augroup ins_beep
    autocmd!
    autocmd InsertEnter * :call system('play -q ' . s:InsertEnterSound . ' &')
    autocmd InsertLeave * :call system('play -q ' . s:InsertLeaveSound . ' &')
" autocmd insertCharPre * :call system('play -q ' . s:InsertLeaveSound . ' &')
augroup END

function MhGetline(lnum)
    let cline = foldtextresult(a:lnum)
    if cline == ''
        let cline = getline(a:lnum)
    endif
    return cline
endfunction

function SpeakChar()
    let cline = MhGetline(".")
    if cline != ''
        let ccol = strpart(cline, col(".")-1, 1)
        if ccol == ' '
            let ccol = 'space'
        endif
    else
        let ccol = 'blank'
    endif
    let result = system('spd-say -e -r 100 -m all -S', ccol)
endfunction

function SpeakWord()
    let cword = expand("<cword>")
    if cword == ''
        let cword = 'blank'
    else
        let ccol = strpart(MhGetline("."), col(".")-1, 1)
        if match(ccol, '\k')==-1 
            call SpeakChar()
            return 0
        endif
    endif
    let result = system('spd-say -e -r 100 -m all -S', cword)
endfunction

function SpeakLine()
    let cline = MhGetline(".")
    if cline != ''
        " let ccol = strpart(cline, col(".")-1, 1)
    else
        let cline = 'blank'
    endif
    let result = system('spd-say -e -r 100 -m all -S', cline)
endfunction

