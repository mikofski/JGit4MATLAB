.. _installation:

Installation
============
Download the full zip-file from `MATLAB Central File Exchange
<http://www.mathworks.com/matlabcentral/fileexchange/41348-jgit4matlab>`_,
extract somewhere on your MATLAB path and type ``jgit``. This will download the
latest version of JGit and edit your Java class path file called
``javaclasspath.txt`` located in your MATLAB `preference directory
<http://www.mathworks.com/help/matlab/ref/prefdir.html>`_, making a copy called
``javaclasspath.txt.JGitSaved`` of ``javaclasspath.txt`` if it already exists.

    **After this you must restart MATLAB for the changes to your MATLAB Java
    static class path to take effect.**

User Info
---------
Set your global gitconfig user name and email using the following::

    jgit setUserInfo '<John Doe>' <John.Doe@email.com>

You can retrieve your global gitconfig settings as well::

    [name,email] = JGit.getUserInfo

SSH
---
Create your SSH keys using `PuTTY gen
<http://www.chiark.greenend.org.uk/~sgtatham/putty/download.html>`_ and convert
them to OpenSSH format. If you set a passphrase, save it in
``%HOME%\.jsch-userinfo`` using the following::

    jgit saveSSHpassphrase <passphrase>
