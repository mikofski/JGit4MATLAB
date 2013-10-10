.. _add:

Add
===
Add file contents to the index ::

    jgit add [-u|--update] [<pathspec>...]

Reference: `git-add <http://git-scm.com/docs/git-add>`_

Examples
--------
Stage files to git repo. ::

    jgit add file1 file2 file3

Using class :ref:`jgit.add` method. ::

    JGit.add({'file1','file2,'file3'})
