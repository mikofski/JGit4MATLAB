.. _branch:

Branch
======
List, create, move or delete branches ::

    jgit branch [-r|--remotes|-a|--all] [--list]
    jgit branch [--set-upstream|-t|--track|--no-track] [-f|--force] <branchname> [<start-point>]
    jgit branch (-m|--move|-M) [<oldbranch>] <newbranch>
    jgit branch (-d|--delete|-D) <branchname>...

Reference: `git-branch <http://git-scm.com/docs/git-branch">`_

Alias
-----
br ::

    jgit br -a

Examples
--------
List all branches. ::

    jgit branch --all

Create new branch from a tag. ::

    jgit branch jgit4matlab-0.6 version-0.6

Create new tracking branch from remote upstream dev branch. ::

    jgit branch -t upstream_dev upstream/dev

Delete branch forcefully. ::

    jgit -D jgit4matlab-0.6

Rename branch. ::

    jgit -m upstream_dev dev
