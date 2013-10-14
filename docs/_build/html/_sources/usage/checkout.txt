.. _checkout:

Checkout
========
Checkout a branch or paths to the working tree ::

    jgit checkout [-f|--force] [<branch>]
    jgit checkout [-f|--force] [<commit>]
    jgit checkout [--set-upstream|-t|--track|--no-track] [-f|--force] [[-b|-B] <new_branch>] [<start_point>]
    jgit checkout [-f|--force|--ours|--theirs|-m] [<tree-ish>] [--] <paths>...
    jgit checkout [<tree-ish>] [--] [<paths>...]
    
Reference: `git-checkout <http://git-scm.com/docs/git-checkout>`_

Alias
-----
co ::

    jgit co -b newfeature

Examples
--------
Checkout branch. ::

    jgit checkout master

Checkout commit. NOTE: This will put you in a detached state. ::

    jgit checkout 971ae60

Checkout upstream branch as local. ::

    jgit checkout -b feature origin/feature

Revert changes in unstaged file. ::

    jgit checkout -- file
