.. _usage:

Usage
=====
There are two ways to use JGit4MATLAB. It can be used a command::

    jgit <command> [<options>] [<args>...] -- [<args>...]

similar to `Git <http://git-scm.com/docs/git-help>`_. JGit4MATLAB parses a
subset of Git commands, options and arguments. Use ``jgit help <command>`` to
see what Git commands are available.

JGit4MATLAB can also be used be calling methods from the class ``JGit``, a thin
wrapper around the `JGit Git API
<http://download.eclipse.org/jgit/docs/latest/apidocs/>`_.::

    JGit.command(args,param,key,...)

Commands
--------
* :ref:`add`
* branch
* checkout
* clone
* commit
* diff
* fetch
* init
* log
* merge
* pull
* push
* status
