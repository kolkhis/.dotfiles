
fu! kolkhis#YankHighlight()
    if v:event['operator'] == 'y'
        if (!exists('g:yanked_text_matches'))
            let g:yanked_text_matches = []
        endif
        let g:yank_match_id = matchadd('IncSearch', ".\\%>'\\[\\_.*\\%<']..")
        let g:yank_window_id = winnr()
        call add(g:yanked_text_matches, [g:yank_match_id, g:yank_window_id])
        call timer_start(100, 'kolkhis#DelYankHighlight')
    endif
endf


fu! kolkhis#DelYankHighlight(timer_id)
    while !empty(g:yanked_text_matches)
        let l:match = remove(g:yanked_text_matches, 0)
        let l:match_id = l:match[0]
        let l:window_id = l:match[1]
        try
            call matchdelete(l:match_id, l:window_id)
        endtry
    endwhile
endf

"""""""""""""""""" MARKDOWN """""""""""""""""

function! kolkhis#AddUListItem(mode)
    " let mode = mode()
    let mode = a:mode
    let line = getline('.')
    if mode ==# 'n'
        if kolkhis#match_ul(line)
            if kolkhis#match_todo(line)
                silent! exe 's/^\(\s*\)\?\([-*] \|\d\{1,}\. \)\[.\] /\1'
            else
                silent! exe "norm! ^2x" 
            endif
        elseif kolkhis#match_ol(line)
            if kolkhis#match_todo(line)
                silent! exe 's/^\(\s*\)\?\(\* \|\d\{1,}\. \)\(\[.\]\) /\1- \3 '
            else
                silent! exe 's/^\(\s*\)\?\(\d\{1,}\. \)/\1- '
            endif
        else
            norm! I- 
        endif
    else
        if kolkhis#match_todo(line)
            norm! I
            silent! exe "'<,'>s/^\\(\\s*\\)\\?\\(\\* \\|\\d\\{1,}\\. \\)\\[.\\] /\\1- /"
        elseif kolkhis#match_ul(line)
            norm! I
            silent! exe "'<,'>s/^\\(\\s*\\)\\?[-*] /\\1/"
        elseif kolkhis#match_ol(line)
            norm! I
            silent! exe "'<,'>s/^\\(\\s*\\)\\?\\d\\. /\\1- /"
        else
            norm! I
            silent! exe "'<,'>s/^\\(\\s*\\)\\?\\(\\w\\)/\\1- \\2/"
        endif
    endif
endfunction

function! kolkhis#AddOListItem(mode)
    let mode = a:mode
    let line = getline('.')
    if mode ==# 'n'
        if kolkhis#match_ol(line)
            silent! exe "norm! ^3x"
        elseif kolkhis#match_ul(line)
            silent! exe "norm! ^2xI1. "
        else
            norm! I1. 
        endif
    else
        if kolkhis#match_ol(line)
            if kolkhis#match_todo(line)
                norm!  
                silent! exe 's/^\(\s*\)\?\(\d\{1,}\. \)\(\[.\]\) /\1/'
            else
                norm!  
                silent! exe "'<,'>s/^\\(\\s*\\)\\?\\d\\{1,}\\. /\\1/"
            endif
        elseif kolkhis#match_ul(line)
            norm! 
            silent! exe "'<,'>s/^\\(\\s*\\)\\?\\* /\\11. /"
        else
            norm! 
            silent! exe "'<,'>s/^\\(\\s*\\)\\?/\\11. /"
            if line("'<") != line("'>")
                " Automatically number the list items
                norm! '<jV'>gk
            endif
        endif
    endif
endfunction


" Check current markdown line for a TODO item (`* [ ]`, `* [x]`, `* [_]`)
" If the current line is an ordered list item, convert it into a TODO item.
function! kolkhis#AddMarkdownCheckbox(mode)
    let line = getline('.')
    let mode = a:mode
    if line ==# ''
        echo 'Problem encountered when parsing line'
        return
    endif
    if a:mode ==# 'n'
        if kolkhis#match_todo(line)
            silent! exe 's/^\(\s*\)\?\([-*] \|\d\{1,}\. \)\[.\] /\1\2/'
        elseif kolkhis#match_ul(line)
            silent! exe 's/^\(\s*\)\?\(\[-*]\) /\1\2 [ ] '
        elseif kolkhis#match_ol(line)
            silent! exe 's/^\(\s*\)\?\(\d\{1,}\.\) /\1\2 [ ] '
        else
            silent! norm! I* [ ] 
        endif
    else
        if kolkhis#match_todo(line)
            norm! I
            silent! exe "'<,'>s/^\\(\\s*\\)\\?\\(\\* \\|\\d\\{1,}\\. \\)\\[.\\] /\\1\\2/"
        elseif kolkhis#match_ul(line)
            norm! I
            silent! exe "'<,'>s/^\\(\\s*\\)\\?\\([-*]\\) /\\1\\2 [ ] "
        elseif kolkhis#match_ol(line)
            norm! I
            silent! exe "'<,'>s/^\\(\\s*\\)\\?\\(\\d\\{1,}\\.\\) /\\1\\2 [ ] "
        else
            norm! I
            silent! exe "'<,'>s/^\\(\\s*\\)\\?/\\1* [ ] /"
        endif
    endif
endfunction

function! kolkhis#match_ol(line)
    return match(a:line, '^\(\s*\)\?\d\{1,}\. ') != -1
endfunction

function! kolkhis#match_ul(line)
    return match(a:line, '^\(\s*\)\?[-*] ') != -1
endfunction

function! kolkhis#match_todo(line)
    return match(a:line, '^\(\s*\)\?\([-*]\|\d\{1,}\.\) \(\[.\]\)') != -1
endfunction

"""""""""""""""""" Netrw """""""""""""""""
fu! kolkhis#NetrwStartup()
  if expand('%') ==# ''
    exe 'e .'
  endif
endf


fu! kolkhis#ToggleNetrw()
  if &filetype ==# 'netrw'
    execute 'Rex'
  else
    execute 'Ex'
  endif
endf



"""""""""""""""""" Case Toggles """""""""""""""""
function! kolkhis#ToggleCase()
  let cword = expand('<cword>')
  let lcase = cword =~? '\l'
  let ucase = cword =~? '\u'
  if lcase && !ucase
    execute "normal! viwU"
  elseif !lcase && ucase
    execute "normal! viwu"
  elseif lcase && ucase
    execute "normal! viwU"
  else
    return
  endif
endfunction



function! kolkhis#GetHelpCurrentWord()
  let l:cword = expand('<cword>')
  execute "help " . l:cword
endfunction



function! kolkhis#SetAleOptions()
    " ALE
    let g:ale_completion_enabled = 1  
    let g:ale_sign_info = "⑆" " ┉ 〇 ☼
    let g:ale_sign_error = "よ" " ♢ 〄
    let g:ale_sign_warning = "☺" " ω ∆  ⑇ ⑈ ⑉ 
    let g:ale_detail_to_floating_preview = 1
    let g:ale_completion_enabled = 1
    let g:ale_floating_preview = 1
    " Go
    let g:ale_go_langserver_executable = '/usr/bin/gopls'
    " Python
    let g:ale_python_pyright_executable = "pyright-langserver"
    let g:ale_python_auto_pipenv = 1
    let g:ale_python_auto_virtualenv = 1
    let g:ale_linters = {
                \ 'go': ['gopls', 'gometalinter', 'gofmt', 'gobuild'], 
                \ 'python': ['pyright']
                \ }
    let g:ale_fixers = {
                \ 'go': ['gopls'], 
                \ 'python3': ['pyright']
                \ }
endfunction


"""""""""""""""""" Plugin Config """""""""""""""""

function! kolkhis#SetVimGoOptions()
    " vim-go basic functionality
    let g:go_fmt_autosave = 1
    let g:go_gopls_enabled = 1
    let g:go_doc_popup_window = 1
    " highlights
    let g:go_highlight_types = 1
    let g:go_highlight_fields = 1
    let g:go_highlight_operators = 1
    let g:go_highlight_functions = 1
    let g:go_highlight_extra_types = 1
    let g:go_highlight_function_calls = 1
    let g:go_highlight_build_constraints = 1
    let g:go_highlight_diagnostic_errors = 1
    let g:go_highlight_diagnostic_watnings = 1
    let g:go_highlight_variable_assignments = 1
    let g:go_highlight_variable_declarations = 1
    let g:go_highlight_extra_types = 1
    let g:go_highlight_operators = 1
    let g:go_highlight_functions = 1
    let g:go_highlight_function_parameters = 1
    let g:go_highlight_function_calls = 1
    let g:go_highlight_types = 1
    let g:go_highlight_fields = 1
    let g:go_highlight_build_constraints = 1
    let g:go_highlight_generate_tags = 1
    let g:go_highlight_format_strings = 1
endfunction



function! kolkhis#SetLightlineOptions()
    let g:lightline = {
      \ 'colorscheme': 'wombat',
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ],
      \             [ 'gitbranch', 'readonly', 'filename', 'modified' ] ]
      \ },
      \ 'component_function': {
      \   'gitbranch': 'FugitiveHead'
      \ },
      \ }
endfunction

"""""""""""""""""" Colors """""""""""""""""
let s:comments = "#626983"
let s:strings = "#b0d181"
let s:dark_ocean_bg = "#0a0c14"
let s:light_ocean_bg = "#0f111a"
" exe 'hi Normal guifg=' . 'White' . ' guibg=' . s:dark_ocean_bg

function! kolkhis#SetColors()
  syntax enable
  hi clear
  set background=dark
  " Basic txt/bg
  hi Normal guifg=#B0C4DE guibg=#090B10
  hi Cursor guifg=#FFCC00 guibg=#FFCC00
  " syntax
  hi Constant guifg=#BB80B3
  hi String guifg=#4DB6AC
  hi Function guifg=#82AAFF
  hi Statement guifg=#89DDFF
  hi Comment guifg=#A1ACB3
  hi Type guifg=#FFCB6B
  hi PreProc guifg=#F07178
  " selection highlights
  hi Search guibg=#F07178 guifg=#000000
  hi Visual guifg=Black guibg=DarkRed
  hi IncSearch guifg=Black guibg=DarkRed
  " gutter/errors
  hi LineNr guifg=#546E7A
  hi Special guifg=#F78C6C
  hi Error guifg=#B70404 guibg=NONE
  hi WarningMsg guifg=#C07F00 guibg=NONE
  hi link ALEError Error 
  hi link ALEWarning WarningMsg
  hi link ALEWarningSign Error
  hi link ALEWarningLine WarningMsg
  hi link ALEWarningSignLineNr WarningMsg
  " highlights: XXX FIXME TODO
  hi TODO guifg=#19A7CE guibg=#27005D
  hi link FIXME TODO
  hi link XXX TODO

  " Status line
  let s:active_font_color = '#7286D3'
  let s:inactive_font_color = '#144272'
  let s:inactive_window = '#181D31'
  let s:active_window = '#0A2647'
  exe 'hi StatusLine guifg=' . s:active_window . ' guibg=' . s:active_font_color
  exe 'hi StatusLineNC guifg=' . s:inactive_window . ' guibg=' . s:inactive_font_color
  exe 'hi StatusLineTerm guifg=' . s:active_window . ' guibg=' . s:active_font_color

  " tabs
  exe 'hi TabLine guifg=' . s:inactive_font_color . ' guibg=' . s:inactive_window
  exe 'hi TabLineFill guifg=' . s:inactive_window . ' guibg=' . s:active_font_color
  exe 'hi TabLineSel guifg=' . s:active_font_color . ' guibg=' . s:active_window
  " vsplit
  let s:split_color = "#2B3A55"
  exe 'hi VertSplit guifg=' . s:split_color . ' guibg=' . "NONE"
  " other stuff
  hi MatchParen guifg=#C792EA guibg=#000000
  hi NonText guifg=#546E7A
  " highlighting
  hi helpHyperTextJump guifg=#82AAFF guibg=NONE
  hi helpHyperTextEntry guifg=#89DDFF guibg=NONE
  " netrw
  hi netrwDir guifg=#82AAFF guibg=NONE
  hi netrwClassify guifg=#89DDFF guibg=NONE
  hi netrwLink guifg=#F07178 guibg=NONE
  hi netrwSymLink guifg=#F07178 guibg=NONE
  hi netrwExe guifg=#C3E88D guibg=NONE
  hi netrwComment guifg=#A1ACB3 guibg=NONE
  hi netrwListstyle guifg=#BB80B3 guibg=NONE
  hi netrwCmdSep guifg=#C792EA guibg=NONE
  hi netrwVersion guifg=#80CBC4 guibg=NONE

  " folds
  hi Folded guifg=#A1ACB3 guibg=#263238
  hi FoldColumn guifg=#80CBC4 guibg=#263238
  hi SignColumn guifg=NONE guibg=#263238
  " popup menu
  hi Pmenu guifg=#546E7A guibg=#121212
  hi PmenuSel guifg=#80CBC4 guibg=#121212
  hi PmenuSbar guifg=#A1ACB3 guibg=#263238
  hi PmenuThumb guifg=#80CBC4 guibg=#121212
  " misc
  hi ModeMsg guifg=#80CBC4 guibg=NONE
  hi MoreMsg guifg=#82AAFF guibg=NONE
  hi QuickFixLine guifg=#FFFFFF guibg=#558EC0
  hi Terminal guifg=#A1ACB3 guibg=#1E272C
  hi Title guifg=#80CBC4 guibg=NONE
  hi WarningMsg guifg=#F07178 guibg=NONE

  " sh/bash highlights
  hi shTestOpr guifg=#FF6C22
  hi shDerefSimple guifg=#B15EFF
  hi shConditional guifg=#419197
  hi link shVariable shDerefSimple
  hi link shFor shDerefSimple
  hi link shLoop shConditional

  " Vimscript
  hi link vimIsCommand vimVar

  let s:comments = "#626983"
  let s:strings = "#b0d181"
  exe 'hi String guifg=' . s:strings
  exe 'hi Comment guifg=' . s:comments

  let s:dark_ocean_bg = "#0a0c14"
  let s:light_ocean_bg = "#0f111a"
  exe 'hi Normal guifg=' . 'White' . ' guibg=' . s:light_ocean_bg
  exe 'hi SignColumn guifg=' . 'White' . ' guibg=' . s:light_ocean_bg

  com! LightMode call kolkhis#LightMode()
  com! DarkMode call kolkhis#DarkMode()
  com! LM LightMode
  com! DM DarkMode
endfunction

fu! kolkhis#LightMode()
  exe 'hi String guifg=' . s:strings
  exe 'hi Comment guifg=' . s:comments
  exe 'hi Normal guifg=' . 'White' . ' guibg=' . s:light_ocean_bg
  exe 'hi SignColumn guifg=' . 'White' . ' guibg=' . s:light_ocean_bg
  exe 'highlight Normal guifg=' . 'White' . ' guibg=' . s:light_ocean_bg
  " Vimscript
  hi link vimIsCommand vimVar

  " netrw
  hi netrwDir guifg=#82AAFF guibg=NONE
  hi netrwClassify guifg=#89DDFF guibg=NONE
  hi netrwLink guifg=#F07178 guibg=NONE
  hi netrwSymLink guifg=#F07178 guibg=NONE
  hi netrwExe guifg=#C3E88D guibg=NONE
  hi netrwComment guifg=#A1ACB3 guibg=NONE
  hi netrwListstyle guifg=#BB80B3 guibg=NONE
  hi netrwCmdSep guifg=#C792EA guibg=NONE
  hi netrwVersion guifg=#80CBC4 guibg=NONE
endfu

fu! kolkhis#DarkMode()
  exe 'hi Normal guifg=' . 'White' . ' guibg=' . s:dark_ocean_bg
  exe 'hi SignColumn guifg=' . 'White' . ' guibg=' . s:dark_ocean_bg
  exe 'hi String guifg=' . s:strings
  exe 'hi Comment guifg=' . s:comments
  hi TODO guifg=#19A7CE guibg=#27005D
  " Vimscript
  hi link vimIsCommand vimVar
  " netrw
  hi netrwDir guifg=#82AAFF guibg=NONE
  hi netrwClassify guifg=#89DDFF guibg=NONE
  hi netrwLink guifg=#F07178 guibg=NONE
  hi netrwSymLink guifg=#F07178 guibg=NONE
  hi netrwExe guifg=#C3E88D guibg=NONE
  hi netrwComment guifg=#A1ACB3 guibg=NONE
  hi netrwListstyle guifg=#BB80B3 guibg=NONE
  hi netrwCmdSep guifg=#C792EA guibg=NONE
  hi netrwVersion guifg=#80CBC4 guibg=NONE
endfu
