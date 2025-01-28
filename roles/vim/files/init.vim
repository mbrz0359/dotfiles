let mapleader=" "

call plug#begin('~/.config/nvim/plugged')
    Plug 'tpope/vim-commentary'
    Plug 'tpope/vim-surround'
    Plug 'tommcdo/vim-exchange'
    Plug 'NoahTheDuke/vim-just'
    Plug 'machakann/vim-highlightedyank'
call plug#end()

map mc <A-n>
map mx <A-x>
map mp <A-p>

set incsearch
set nu
set rnu
set scrolloff=5
set ignorecase

if has('ide')
    set ideajoin
    set ideamarks=true
    set idearefactormode=keep
    set NERDTree
    set quickscope

    sethandler <C-C> a:ide
    sethandler <C-V> a:ide
    sethandler <C-X> a:ide
    sethandler <C-S> a:ide

    sethandler <C-P> a:ide
    sethandler <C-T> a:ide

    sethandler <C-D> a:vim
    sethandler <C-U> a:vim

    sethandler <C-I> a:vim
    sethandler <C-O> a:vim

    map <Leader>o <Action>(OptimizeImports)
    map <Leader>r <Action>(ReformatCode)
    map <Leader>/ <Action>(FindInPath)
    map <Leader>t <Action>(RunClass)
    map <Leader>d <Action>(Debug)
    map <Leader>s <Action>(Stop)
    map <Leader>m <Action>(ExternalSystem.ProjectRefreshAction)
    map <Leader>n <Action>(GitNewBranchAction)
    map <Leader>, <Action>(ShowSettings)
    map <Leader>u <Action>(Vcs.UpdateProject)
    map <Leader>e <Action>(ExpressionTypeInfo)
    map <Leader>c <Action>(ActivateCommitToolWindow)
    map <Leader>p <Action>(ActivateProjectToolWindow)
    map <Leader>q <Action>(ActivateRunToolWindow)
    map \b <Action>(ToggleLineBreakpoint)
    map \r <Action>(RenameElement)
    map \m <Action>(Move)
    map \a <Action>(GotoAction)
    map \c <Action>(GotoClass)
    map \f <Action>(GotoFile)
    map \g <Action>(Git.Branches)
    map \x <Action>(Refactorings.QuickListPopupAction)
    map \s <Action>(SelectIn)
    map \q <Action>(QuickJavaDoc)
    map \z <Action>(Vcs.RollbackChangedLines)
    map gi <Action>(GotoImplementation)
    map ge <Action>(GotoNextError)
    map gE <Action>(GotoPreviousError)
    map gs <Action>(GotoSuperMethod)
    map gt <Action>(GotoTest)
    map tk :tabn<CR>
    map tj :tabp<CR>
    map [[ <Action>(MethodUp)
    map ]] <Action>(MethodDown)
    map <C-s> <Action>(SaveAll)
    map <C-w> <Action>(CloseContent)
endif

nmap S diw"0P
