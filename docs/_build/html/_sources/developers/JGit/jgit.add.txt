.. _jgit.add:

JGit.add
========
.. currentmodule:: JGit4MATLAB

.. method:: JGit.add(files[, varargin])

    Add files to the index.
    
    :param files: Files or pathspecs to be added to the index.
    :type files: char or cell-string
    :param varargin: Parameter-value pairs of options and option arguments.
    :type varargin: comma-separated list of strings
    :param update: (Optional) Only stage tracked files. New files will not be staged.
    :type update: logical
    :param gitDir: (Optional) Add to index of the repository in specified folder.
    :type gitDir: char

See also
--------
:class:`JGit`, :meth:`JGit.commit`

References
----------
* `git-add <http://git-scm.com/docs/git-add>`_
* `org.eclipse.jgit.api.AddCommand <http://download.eclipse.org/jgit/docs/latest/apidocs/org/eclipse/jgit/api/AddCommand.html>`_

Examples
--------
Add ``myfile.m`` to index. ::

    JGit.add('myfile.m')

Add ``myclass.m`` and ``myfun.m``. ::

    JGit.add({'myclass.m','myfun.m'})
