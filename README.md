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

Status
------
Return status of git repo.

    JGit.status
    
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
    JGit.commit('message','you commit message')
    JGit.commit('amend',true)
    JGit.commit('author',{'name','email'})
    JGit.commit('committer',{'name','email'})

Other
-----
Create an `org.eclipse.jgit.api.Git` instance. With this you can do almost
anything. EG: `git.reset.setRef('HEAD').addPath('JGit.m').call` will unstage the
file `JGit.m` from the current commit.

    git = JGit.getGitAPI
    