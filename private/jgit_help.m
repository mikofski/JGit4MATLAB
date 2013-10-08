function jgit_help(cmd)
%JGIT_HELP Display jgit help
%   Copyright (c) 2013 Mark Mikofski
switch cmd
    case 'add'
        fprintf([ ...
            'ADD - Add file contents to the index\n', ...
            'jgit add [-u|--update] [--] [<pathspec>...]\n', ...
            'Reference: <a href="http://git-scm.com/docs/git-add">git-add</a>\n'])
    case {'branch','br'}
        fprintf([ ...
            'BRANCH - List, create, move or delete branches\n', ...
            'jgit branch [-r|--remotes|-a|--all] [--list]\n', ...
            'jgit branch [--set-upstream|-t|--track|--no-track] [-f|--force] <branchname> [<start-point>]\n', ...
            'jgit branch (-m|--move|-M) [<oldbranch>] <newbranch>\n', ...
            'jgit branch (-d|--delete|-D) <branchname>...\n', ...
            'Reference: <a href="http://git-scm.com/docs/git-branch">git-branch</a>\n'])
    case {'checkout','co'}
        fprintf([ ...
            'CHECKOUT - Checkout a branch or paths to the working tree\n', ...
            'jgit checkout [-f|--force] [<branch>]\n', ...
            'jgit checkout [-f|--force] [<commit>]\n', ...
            'jgit checkout [--set-upstream|-t|--track|--no-track] [-f|--force] [[-b|-B] <new_branch>] [<start_point>]\n', ...
            'jgit checkout [-f|--force|--ours|--theirs|-m] [<tree-ish>] [--] <paths>...\n', ...
            'jgit checkout [<tree-ish>] [--] [<paths>...]\n', ...
            'Reference: <a href="http://git-scm.com/docs/git-checkout">git-checkout</a>\n'])
    case 'clone'
        fprintf([ ...
            'CLONE - Clone a repository into a new directory\n', ...
            'jgit clone [--bare] [-o|--origin <name>] [-b|--branch <name>] [--recursive|--recurse-submodules]\n', ...
            '[-n|--no-checkout] [--] <repository> [<directory>]\n', ...
            'Reference: <a href="http://git-scm.com/docs/git-clone">git-clone</a>\n'])
    case 'commit'
        fprintf([ ...
            'COMMIT - Record changes to the repository\n', ...
            'jgit commit [-a|--all] [--amend] [-m <msg>|--message=<msg>] [--author=<author>] [--] [<file>...]\n', ...
            'Reference: <a href="http://git-scm.com/docs/git-commit">git-commit</a>\n'])
    case {'diff','difftool'}
        fprintf([ ...
            'DIFF/DIFFTOOL - Show changes between commits, commit and working\n', ...
            '\ttree, etc, using common diff tools\n', ...
            'jgit diff [options] [<commit>] [-- <path>...]\n', ...
            'jgit diff [options] --cached [<commit>] [-- <path>...]\n', ...
            'jgit diff [options] <commit> <commit> [-- <path>...]\n', ...
            'jgit diff [options] <blob> <blob>\n', ...
            'Options:\n', ...
            '--name-status, --inter-hunk-context=<lines>, --no-prefix\n', ...
            '--src-prefix=<prefix>, --dst-prefix=<prefix>, \n', ...
            'Note:\nPaths must use "--" to separate paths from revisions, be relative to GITDIR\n', ...
            'and use "/" to delimit directories on all platforms.\n', ...
            'References: <a href="http://git-scm.com/docs/git-diff">git-diff</a> and ', ...
            '<a href="http://git-scm.com/docs/git-difftool">git-difftool</a>\n'])
    case 'fetch'
        fprintf([ ...
            'FETCH - Download objects and refs from another repository\n', ...
            'jgit fetch [--dry-run] [-p|--prune] [-t|-tags] [-n|--no-tags] [<repository> [<refspec>...]]\n', ...
            'Reference: <a href="http://git-scm.com/docs/git-fetch">git-fetch</a>\n'])
    case 'init'
        fprintf([ ...
            'INIT - Create an empty Git repository or reinitialize an existing one\n', ...
            'jgit init [--bare] [directory]\n', ...
            'Reference: <a href="http://git-scm.com/docs/git-init">git-init</a>\n'])
    case 'log'
        fprintf([ ...
            'LOG - Show commit logs\n', ...
            'jgit log [-<number>|-n <number>|--max-count=<number>]\n', ...
            '[--skip=<number>] [--all] [<revision range>] [[--] <path>...]\n', ...
            'Revision range:\n', ...
            '<since-rev>..<until-rev> is equivalent to ^<since-rev> <until-rev>\n', ...
            'Reference: <a href="http://git-scm.com/docs/git-log">git-log</a>\n'])
    case 'merge'
        fprintf([ ...
            'MERGE - Join two or more development histories together\n' ...
            'jgit merge [-n] [--stat] [--no-commit] [--squash] [--[no-]edit]\n', ...
            '[-s <strategy>] [-X <strategy-option>]\n', ...
            '[--[no-]rerere-autoupdate] [-m <msg>] [<commit>...]\n', ...
            'jgit merge <msg> HEAD <commit>...\n', ...
            'jgit merge --abort\n', ...
            'Reference: <a href="http://git-scm.com/docs/git-merge">git-merge</a>\n'])
    otherwise
        fprintf([ ...
            'usage: jgit [-v|--version|-h|--help|-u|--update]\n', ...
            '       jgit <command> [<args>]\n', ...
            '\n', ...
            'The available JGit commands are:\n', ...
            '   add        Add file contents to the index\n', ...
            '   branch     List, create, or delete branches\n', ...
            '   checkout   Checkout a branch or paths to the working tree\n', ...
            '   clone      Clone a repository into a new directory\n', ...
            '   commit     Record changes to the repository\n', ...
            '   diff       Show changes between commits, commit and working tree, etc\n', ...
            '   fetch      Download objects and refs from another repository\n', ...
            '   init       Create an empty JGit repository or reinitialize an existing one\n', ...
            '   log        Show commit logs\n', ...
            '   merge      Join two or more development histories together\n', ...
            '   pull       Fetch from and integrate with another repository or a local branch\n', ...
            '   push       Update remote refs along with associated objects\n', ...
            '   status     Show the working tree status\n', ...
            '\n', ...
            'See "jgit help <command>" to read about a specific subcommand.\n', ...
            'Reference: <a href="http://git-scm.com/docs">git-docs</a>\n'])
end
end
