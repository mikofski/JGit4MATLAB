JGit4MATLAB
===========
JGit4MATLAB is a wrapper for JGit in MATLAB. It is meant to be used from the
command line.

Installation
============
Download the full zip-file from [MATLAB Central File Exchange]
(http://www.mathworks.com/matlabcentral/fileexchange/), extract to your working
MATLAB folder, usually `C:\Users\<username>\Documents\MATLAB` and type `JGit`.
This will download the latest version of JGit and edit your Java class path file
called `javaclasspath.txt` that is also in your MATLAB working folder, making a
copy called `javaclasspath.txt.JGitSaved` of `javaclasspath.txt` if it already exists.

After this you must restart MATLAB for the changes to your MATLAB Java static
class path to take effect.

Usage
=====
In general usage is the same as in [Git](http://git-scm.com/docs/git-help) and
[`org.eclipse.jgit.api.Git`](http://download.eclipse.org/jgit/docs/latest/apidocs/).

Add
---
Stage files to git repo.

    JGit.add('file')
    JGit.add({'list','of','files'})

Commit
------
Commit files to git repo. Any combination of commands will work. If `getenv('EDITOR')`
is empty then `notepad` is used. An empty commit message throws a Java JGit exception.

    JGit.commit
    JGit.commit('all',true)
    JGit.commit('message','your commit message')
    JGit.commit('amend',true)
    JGit.commit('author',{'name','email'})
    JGit.commit('committer',{'name','email'})

Log
------
Return commit log. Any combination of commands will work. Commits are entered as strings which can be SHA1 of the commit, HEAD~N, where N is the number of commits from HEAD or as refs/heads/branch, where branch is the branch of the commit. You can use 'since' and 'until' independently or together. 'Since' shows commits newer than a given commit, and 'until' shows older commits. Commits are always shown from newest to oldest. Push the enter key to advance and q+enter to quit.

    JGit.log
    JGit.log('maxCount',number_of_commits_to_show)
    JGit.log('since','commit_to_start')
    JGit.log('until','commit_to_stop')
    JGit.log('skip',number_of_commits_to_skip)

Status
------
Return status of git repo. Staged files are links which will open them in the MATLAB editor.

    JGit.status

Other
-----
Create an `org.eclipse.jgit.api.Git` instance. With this you can do almost
anything. EG: `git.reset.setRef('HEAD').addPath('JGit.m').call` will unstage the
file `JGit.m` from the current commit.

    git = JGit.getGitAPI

TODO
====
There are many porcelain functions that would be quick to implement: `help`, `init`, `clone`,`reset`, `push`, `pull`, etc. All functions should call the getGitAPI class function. Then they can use that instance to do whatever. For other methods, use the appropriate org.eclipse.jgit package directly.

A GUI to mimic gitk and git-gui. GUI options for some porcelain commands like log might also be nice. A log GUI that shows a banch graph would be especially nice.

Contributions are welcome. Please make fork and send me your pull requests. I will add your name to the AUTHOR list to credit you for your contribution.
