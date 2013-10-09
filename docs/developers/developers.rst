.. developers:

Developers
==========
:mod:`JGit4MATLAB` is composed of a single class, :class:`~JGit4MATLAB.JGit`,
and a collection of private functions called from :func:`jgit`.

The :class:`~JGit4MATLAB.JGit` class is a thin wrapper around the `JGit Git API
<http://download.eclipse.org/jgit/docs/latest/apidocs/>`_. It's sole purpose is
to port the JGit Git API Java classes and methods to MATLAB, and provide
whatever additional support needed for this task.

The :func:`jgit` function is meant to be used in the MATLAB command window. It
parses a subset of Git commands for the interface expected by the
:class:`~JGit4MATLAB.JGit` class. Ideally, no new functionality should be
introduced in the :func:`jgit` function; new functionality should be added to
the :class:`~JGit4MATLAB.JGit` class.

Developing new JGit methods
---------------------------
There are many JGit and Git features that have not been ported to JGit4MATLAB.
`JGit <www.eclipse.org/jgit/>`_ is rapidly changing project, so there are
always new features to add or modify.

Most of the :mod:`JGit4MATLAB` methods are derived from the JGit Porcelain Git
API Commands classes, which correspond to Git commands such as ``add``,
``branch``, ``checkout``, &c. Each command (or JGit class) is a method in the
:class:`JGit` class. The methods are in separate files so the interface must be
added to the main JGit file. The :class:`JGit` class and all of its methods are
located in a class folder called ``@JGit``.

Each :class:`JGit` class method corresponding to a JGit class or git command
takes ``varargin`` and uses the builtin MATLAB inputparser class.

Any Java constants and enumerations are derived up top. If necessary
``JavaMethod`` or ``JavaObject`` is used to reveal nested classes to MATLAB.

Whenever possible JGit defaults are used and JGit exceptions are not caught. As
much as possible, the :class:`JGit` class is meant to be a very thin wrapper.

Parsing new Git commands
------------------------
