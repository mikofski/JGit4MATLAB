JGit4MATLAB
===========

JGit4MATLAB is a wrapper for JGit in MATLAB. It is meant to be used from the
command line.

Installation
============
Download the full zip-file from [MATLAB Central File Exchange]
(http://www.mathworks.com/matlabcentral/fileexchange/), extract to your working
MATLAB folder, usually C:\Users\<username>\Documents\MATLAB and run JGit.status.
The first time it will download the latest version of JGit and edit your Java
class path file called "javaclasspath.txt" that is also in your MATLAB working
folder. After this you must restart MATLAB for the changes to your MATLAB Java
static class path to take effect.

Usage
=====
In general usage is the same as in Git and the org.eclipse.jgit.api.Git.

`JGit.status`
    Return status.

`JGit.add('file')`
`JGit.add({'list','of','files'})`
    Stage files.

`JGit.commit`
`JGit.commit('all',true)
`JGit.commit('message','you commit message')
`JGit.commit('amend',true)
`JGit.commit('author',{'name','email'})
`JGit.commit('committer',{'name','email'})
    Commit files.

`git = JGit.getGitAPI`
    Return org.eclipse.jgit.api.Git instance. With this you can do almost
anything. EG: `git.reset.setRef('HEAD').addPath('JGit.m').call` will unstage the
file 'JGit.m' from the current commit.