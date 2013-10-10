.. _usage:

Usage
=====
There are two ways to use JGit4MATLAB. It can be used as a command similar to
`Git <http://git-scm.com/docs/git-help>`_. ::

    jgit <command> [<options>] [<args>...] -- [<args>...]

JGit4MATLAB parses a subset of Git commands, options and arguments. Use
``jgit help [<command>]`` to see what Git commands are available and to get
help for a particular command.

JGit4MATLAB can also be used by calling methods from the :class:`JGit` class, a
thin wrapper around the `JGit Git API
<http://download.eclipse.org/jgit/docs/latest/apidocs/>`_.::

    JGit.command(args,param,key,...)

Commands
--------
* :ref:`add`
* :ref:`branch`
* :ref:`checkout`
* :ref:`clone`
* :ref:`commit`
* :ref:`diff`
* :ref:`fetch`
* :ref:`init`
* :ref:`log`
* :ref:`merge`
* :ref:`pull`
* :ref:`push`
* :ref:`status`
