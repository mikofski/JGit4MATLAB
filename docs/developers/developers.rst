.. developers:

Developers
==========
:mod:`JGit4MATLAB` is a BSD open source project for MATLAB hosted on Github.

https://github.com/mikofski/JGit4MATLAB

:mod:`JGit4MATLAB` is composed of a single class, :class:`~JGit4MATLAB.JGit`,
and a collection of private functions called from :func:`jgit`.

The :class:`~JGit4MATLAB.JGit` class is a thin wrapper around the `JGit Git API
<http://download.eclipse.org/jgit/docs/latest/apidocs/>`_. It's sole purpose is
to port the JGit Git API Java classes and methods to MATLAB and to provide
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
As new features are added to the :class:`JGit` class, new parsing functions
should be added to the private JGit4MATLAB folder and to the
:func:`jgit` function.

The parse functions are added to :func:`jgit` in a ``switch-case`` block, that
switches cases based on the command initially parsed from the command window.
Aliases may be added as extra cases, but make sure to set the cmd to the
fullname of the command or :class:`JGit` won't recognize it. Then call the
parsing function.

Parsing functions live in a private folder so that they will always be on the
same path as :func:`jgit` and :class:`JGit`. Each function is called
``parseXx.m`` in camelCase where ``Xx`` is the command. *EG: checkout is*
``parseCheckout.m``.

The parsing functions are passed all of the arguments and options, collectively
called ``argopts``, and return ``parsed_argopts``, which is a cell array
suitable for the corresponding method in :class:`JGit`.

Each parsing function has a dictionary of Git command line options. For
example, the dictionary for ``parseCheckout.m`` is as follows::

    %% options
    dictionary = { ...
        'force',{'-f','--force'},true; ...
        'newBranch',{'-b'},true; ...
        'forceNew',{'-B'},true; ...
        'ours',{'--ours'},true; ...
        'theirs',{'--theirs'},true; ...
        'set_upstream',{'--set-upstream'},true; ...
        'track',{'-t','--track'},true; ...
        'no_track',{'--no-track'},true};

The size of the dictionary is N x 3 for N options. The first column is a unique
name the option will be called only within the parsing function, the 2nd column
is a cell string of Git command options, and the 3rd column is a logical to
indicate if the option is logical, *IE: true or false*. The dictionary and
``argopts`` are first filtered through :func:`parseOpts` to determine if any of
the options in the dictionary are in ``argopts``. Identified options are
returned as ``options`` and popped from ``argopts``. Next :func:`filterOpts` is
used to scan for a double-hyphen, which is often used in Git to separate paths
from references. If :func:`filterOpts` second output argument is ``paths`` then
any ``argopts`` right of the double-hyphen, if present, are returned as
``paths`` and popped from ``argopts``. Otherwise ``argopts`` contains all of
arguments minus the double-hyphen if present. A warning is given by
:func:`filterOpts` if any options (preceded by single or double dash) are still
present in ``argopts`` after passing through :func:`parseOpts`. These are
options that were not in the dictionary.

Two helper functions in :func:`jgit` take care of equalsigns and integers in
options. :func:`splitEqualSigns` removes equalsigns which are sometimes used in
long options (preceded by double dash) to pass an option-argument, *EG:*
``--name=<name>``, but which Git doesn't care about. :func:`splitShortOptions`
takes care of clustered short options (preceded by single dash) and integer
option arguments, *EG:* ``git commit -am 'my message'`` *and*
``git tag -ln100``. If these helper functions are working you shouldn't have to
use them, but it's important to know that equalsigns are removed, separating
the option from its argument, clustered short options are separated, and
integer arguments are separated from their short options. If an interger
argument is given as an option, *IE:* ``git log -10`` then option is omitted,
there isn't an option anyway, and only the integer is returned in ``argopts``.
Since the rest of ``argopts`` are strings, it should be easy to find.

Every parsed command has an entry in :func:`jgit_help` which is prints thes
subset of git commands available, the command syntax and any other basic
relevant info. These are displayed whenever ``jgit help <command>`` is used and
should be relatively short.

Unittests
---------
There should be unittests for as many changes as possible, using the `MATLAB
Unittest framework
<http://www.mathworks.com/help/matlab/matlab-unit-test-framework.html>`_.

Documentation
-------------
These documents were created using `Sphinx <http://www.sphinx.org>`_ with the
`MATLAB Sphinx domain
<https://pypi.python.org/pypi/sphinxcontrib-matlabdomain/0.1dev-20130620>`_.
