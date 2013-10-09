.. _jgit:

.. module:: JGit4MATLAB

JGit
====
.. class:: JGit

The JGit class is a thin wrapper around the `JGit Git API
<http://download.eclipse.org/jgit/docs/latest/apidocs/>`_.

Properties
----------
All of :class:`JGit` properties are constant.

    .. attribute:: JGit.VALID

        State of :mod:`JGit4MATLAB`. True if state is valid. Calls
        :meth:`~JGit.validateJavaClassPath`.

    .. attribute:: JGit.EDITOR

        Editor used for commit messages. Calls
        :meth:`~JGit.getEDITOR`.

    .. attribute:: JGit.GIT_DIR

        Git repository folder, set to ``.git``. 

    .. attribute:: JGit.JGIT

        JGit package name, set to ``org.eclipse.jgit``.
        
    .. attribute:: JGit.PROGRESSMONITOR

        Java jar package with :mod:`MATLABProgressMonitor`, replaces ``\r``
        with ``\b`` in progress reports.

    .. attribute:: JGit.USERINFOSSHSESSIONFACTORY

        Java jar package with :mod:`UserInfoSshSessionFactory`, a custom
        SshSessionFactory, configures a CredentialProvider to provide SSH
        passphrase for Jsch, registers itself as the default SshSessionFactory
        instance.

    .. attribute:: JGit.VERFILE

        File storing JGit package version.

    .. attribute:: JGit.VERSION

        JGit version string.

    .. attribute:: JGit.USERHOME

        User home,  set to `org.eclipse.jgit.util.FS.DETECTED.userHome
        <http://download.eclipse.org/jgit/docs/latest/apidocs/org/eclipse/jgit/
        util/FS.html#DETECTED>`_

    .. attribute:: JGit.GITCONFIG

        Global git config file found in :attr:`USERHOME`, set to ``.gitconfig``.

    .. attribute:: JGit.JSCH_USERINFO

        Global Jsch userinfo file with SSH passphrase, set to ``.jsch-userinfo``

Methods
-------
All of :class:`~JGit` methods are static.

    .. method:: JGit.validateJavaClassPath

        Validate MATLAB static Java class path. Returns true if the JGit
        package jar-file is in the @JGit folder and on the MATLAB static Java
        class path. Downloads current version of JGit and/or adds it to the
        MATLAB static Java class path if false.