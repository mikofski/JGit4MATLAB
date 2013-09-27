classdef JGit < handle
    %JGIT A JGit wrapper for MATLAB
    %   JGIT, the first time it is called, downloads the latest version of
    %   "org.eclipse.jgit.jar", adds it to the MATLAB static Java class
    %   path and makes a backup of the existing "javaclasspath.txt" as
    %   "javaclasspath.JGitSaved". MATLAB must then be restarted for the
    %   changes to the MATLAB static Java class path to take effect.
    %
    %   For more information on MATLAB static Java class path see also
    %   <a href="http://www.mathworks.com/help/matlab/matlab_external/bringing-java-classes-and-methods-into-matlab-workspace.html#f111065">Bringing Java Classes into MATLAB Workspace: The Java Class Path: The Static Path</a>
    %
    %   JGIT has only class methods that call the corresponding command
    %   methods of the Git class in the org.eclipse.jgit.api package.
    %
    %   For more information on JGit and Git see also
    %   <a href="http://download.eclipse.org/jgit/docs/latest/apidocs/org/eclipse/jgit/api/Git.html">Class Git in org.eclipse.jgit.api package</a>
    %   <a href="http://eclipse.org/jgit/">JGit-eclipse</a>
    %   <a href="https://www.kernel.org/pub/software/scm/git/docs/">Git Manual</a>
    %   <a href="http://git-scm.com/">Git-SCM</a>
    %
    %   Usage:
    %       JGIT.METHOD(REQUIRED,PARAMETER,VALUES)
    %
    %   The most commonly used METHODS are:
    %   add        Add file contents to the index
    %   bisect     Find by binary search the change that introduced a bug
    %   branch     List, create, or delete branches
    %   checkout   Checkout a branch or paths to the working tree
    %   clone      Clone a repository into a new directory
    %   commit     Record changes to the repository
    %   diff       Show changes between commits, commit and working tree, etc
    %   fetch      Download objects and refs from another repository
    %   grep       Print lines matching a pattern
    %   init       Create an empty git repository or reinitialize an existing one
    %   log        Show commit logs
    %   merge      Join two or more development histories together
    %   mv         Move or rename a file, a directory, or a symlink
    %   pull       Fetch from and merge with another repository or a local branch
    %   push       Update remote refs along with associated objects
    %   rebase     Forward-port local commits to the updated upstream head
    %   reset      Reset current HEAD to the specified state
    %   rm         Remove files from the working tree and from the index
    %   show       Show various types of objects
    %   status     Show the working tree status
    %   tag        Create, list, delete or verify a tag object signed with GPG
    %
    %   See `help JGIT.METHOD` for more information on a specific METHOD.
    %
    %   See also ADD, BRANCH, CLONE, COMMIT, CONFIG, DIFF, INIT, LOG, STATUS,
    %   GETGITAPI, GETGITDIR, VALIDATEJAVACLASSPATH, DOWNLOADJGITJAR, GETEDITOR
    %
    %   Version 0.5 - Egret Release
    %   2013-09-25 Mark Mikofski
    %   <a href="http://poquitopicante.blogspot.com">poquitopicante.blogspot.com</a>
    
    %% constant properties
    properties (Constant)
        VALID = JGit.validateJavaClassPath
        EDITOR = JGit.getEDITOR % an editor
        GIT_DIR = '.git' % git repository folder
        JGIT = 'org.eclipse.jgit' % JGit package name
        PROGRESSMONITOR = 'com.mikofski.jgit4matlab.MATLABProgressMonitor'
        VERFILE = fullfile(fileparts(mfilename('fullpath')),'version') % file storing JGit package version
        VERSION = strtrim(fileread(JGit.VERFILE)) % JGit version string
    end
    %% static methods
    methods (Static)
        %% common methods
        add(files,gitDir)
        branch(cmd,newName,varargin)
        r = checkout(name,varargin)
        clone(uri,varargin)
        commit(varargin)
        diff(varargin)
        init(varargin)
        log(varargin)
        r = merge(include,varargin)
        pull(varargin)
        push(ref,varargin)
        status(gitDir,fid,amend)
        %% JGIT4MATLAB methods
        function gitAPI = getGitAPI(gitDir)
            %JGIT.GETGITAPI Get an instance of the JGit API Git Class.
            %   JGIT.GITAPIOBJ = GETGITAPI returns GITAPIOBJ, an instance of
            %   the JGit API Git Class for the Git repository in the current
            %   directory.
            %   GITAPIOBJ = GETGITAPI(GITDIR) returns GITAPIOBJ for the Git
            %   repository in which GITDIR is located. GITDIR can be any
            %   folder in the repository.
            %   Throws GIT:NOTGITREPO if there is no .git folder in GITDIR
            %   or any of its parent folder.
            %
            %   See also: JGIT, GETGITDIR
            %
            %   Version 0.5 - Egret Release
            %   2013-09-25 Mark Mikofski
            %   <a href="http://poquitopicante.blogspot.com">poquitopicante.blogspot.com</a>
            
            %% checkin inputs
            if nargin<1
                gitDir = pwd;
            end
            %% get gitDir
            gitDir = JGit.getGitDir(gitDir);
            assert(~isempty(gitDir),'jgit:notGitRepo', ...
                ['fatal: Not a git repository (or any of the parent', ...
                'directories): .git'])
            %% get Git API
            gitAPI = org.eclipse.jgit.api.Git.open(java.io.File(gitDir));
        end
        function gitDir = getGitDir(path)
            %JGIT.GETGITDIR Find the .git folder of the repository.
            %   GITDIR = JGIT.GETGITDIR(GITDIR) returns GITDIR, the .git folder
            %   for the Git repository in the current directory.
            %
            %   See also: JGIT, GETGITAPI
            %
            %   Version 0.5 - Egret Release
            %   2013-09-25 Mark Mikofski
            %   <a href="http://poquitopicante.blogspot.com">poquitopicante.blogspot.com</a>
            
            %% create full path to gitDir
            gitDir = fullfile(path,JGit.GIT_DIR);
            %% walk directory tree to find gitDir
            s = dir(gitDir);
            while isempty(s)
                parent = fileparts(path);
                if strcmpi(path,parent)
                    gitDir = [];
                    break
                end
                path = parent;
                gitDir = fullfile(path,JGit.GIT_DIR);
                s = dir(gitDir);
            end
        end
        function valid = validateJavaClassPath
            %JGIT.VALIDATEJAVACLASSPATH Validate MATLAB static Java class path.
            %   VALID = JGIT.VALIDATEJAVACLASSPATH returns true if the JGit
            %   package jar-file is in the @JGit folder and on the MATLAB
            %   static Java class path. Downloads current version of JGit
            %   and/or adds it to the MATLAB static Java class path if false.
            %
            %   See also: JGIT, DOWNLOADJGITJAR
            %
            %   Version 0.5 - Egret Release
            %   2013-09-25 Mark Mikofski
            %   <a href="http://poquitopicante.blogspot.com">poquitopicante.blogspot.com</a>
            
            %% check JGit package jar-file in @JGit folder
            valid = true;
            githome =  fileparts(mfilename('fullpath'));
            jgitjar = fullfile(githome,[JGit.JGIT,'.jar']);
            pmjar = fullfile(githome,[JGit.PROGRESSMONITOR,'.jar']);
            if exist(jgitjar,'file')~=2
                valid = false;
                fprintf('JGit jar-file doesn''t exist. Downloading ...\n');
                [f,status] = JGit.downloadJGitJar(jgitjar);
                if status==1
                    fprintf('Saved as:\n\t%s.\n... Done.\n\n',f);
                else
                    error('jgit:validateJavaClassPath:downloadError',status)
                end
            end
            %% check MATLAB static Java class path
            spath = javaclasspath('-static');
            if any(strcmp(spath,jgitjar)) && any(strcmp(spath,pmjar))
                %% Yes, jar-file is on MATLAB static Java class path
                % return false if jar-file has just been downloaded even if
                % already on MATLAB static Java class path
                valid = valid && true;
            else
                %% No, jar-file is not on MATLAB static Java class path
                % check for file called "javaclasspath.txt"
                valid = false;
                workhome = userpath;workhome = workhome(1:end-1);
                javapath = fullfile(workhome,'javaclasspath.txt');
                if exist(javapath,'file')~=2
                    %% no "javaclasspath.txt"
                    fprintf('"javaclasspath.txt" not detected. Writing ...\n');
                    try
                        fid = fopen(javapath,'wt');
                        fprintf(fid,'# JGit package\n%s\n',jgitjar);
                        fprintf(fid,'# JGit package\n%s\n',pmjar);
                        fclose(fid);
                        fprintf('... Done.\n\n');
                    catch ME
                        fclose(fid);
                        throw(ME)
                    end
                else
                    %% "javaclasspath.txt" already exists
                    try
                        fid = fopen(javapath,'r+t');
                        pathline = fgetl(fid);
                        foundJGit = strcmp(pathline,jgitjar);
                        foundPM = strcmp(pathline,pmjar);
                        while ~foundJGit || ~foundPM
                            if feof(fid)
                                copyfile(javapath,[javapath,'.JGitSaved'])
                                if ~foundJGit
                                    fprintf('JGit not on static Java class path. Writing ...\n');
                                    fprintf(fid,'\n# JGit package\n%s\n',jgitjar);
                                    fprintf('... Done.\n\n');
                                end
                                if ~foundPM
                                    fprintf('ProgressMonitor not on static Java class path. Writing ...\n');
                                    fprintf(fid,'\n# JGit package\n%s\n',pmjar);
                                    fprintf('... Done.\n\n');
                                end
                                break
                            end
                            pathline = fgetl(fid);
                            foundJGit = foundJGit || strcmp(pathline,jgitjar);
                            foundPM = foundPM || strcmp(pathline,pmjar);
                        end
                        fclose(fid);
                    catch ME
                        fclose(fid);
                        throw(ME)
                    end
                end
            end
            %% restart message
            assert(valid,'jgit:noJGit', ...
                ['\n\t**Please restart MATLAB.**\n\n', ...
                'JGit has been downloaded and/or added to the MATLAB Java static path,\n', ...
                'but you must restart MATLAB for the changes to take effect.\n\n', ...
                'For more information see:\n', ...
                '<a href="http://www.mathworks.com/help/matlab/matlab_external/', ...
                'bringing-java-classes-and-methods-into-matlab-workspace.html#f111065">', ...
                'Bringing Java Classes into MATLAB Workspace: The Java Class Path: The Static Path</a>'])
        end
%         function setUserInfo(name, email)
%             file = java.io.File(fullfile(getenv('home'),'.gitconfig'));
%             gitconfig = org.eclipse.jgit.storage.file.FileBasedConfig(file, org.eclipse.jgit.util.FS.DETECTED);
%             gitconfig.setString('user',[],'name',name); % place your name in here
%             gitconfig.setString('user',[],'email',email); % place your email in here
%             gitconfig.save;
%         end
%         function getUserInfo()
%             file = java.io.File(fullfile(getenv('home'),'.gitconfig'));
%             gitconfig = org.eclipse.jgit.storage.file.FileBasedConfig(file, org.eclipse.jgit.util.FS.DETECTED);
%             name = gitconfig.getString('user',[],'name'); % get your name
%             email = gitconfig.getString('user',[],'email'); % get your email
%             fprintf('\nname: %s, email: %s\n',name,email)
%         end
        function [f,status] = setSSHpassphrase(passphrase)
            % write SSH passphrase
            f = fullfile(getenv('home'),'.jsch-userinfo','wt');
            fid = fopen(fullfile(getenv('home'),'.jsch-userinfo','wt'));
            try
                fprintf(fid,'%s\n',passphrase);
                fclose(fid);
            catch ME
                fclose(fid);
                throw(ME)
            end
            status = 1;
        end
        function [f,status] = downloadJGitJar(jgitjar)
            %JGIT.DOWNLOADJGITJAR Download the latest JGit jar file.
            %   [F,STATUS] = JGIT.DOWNLOADJGITJAR(JGITJAR) downloads JGit
            %   jar file using filename and path specified by JGITJAR.
            %   [F,STATUS] are the parameters returned by URLWRITE. Writes
            %   the version number in a file called 'version' in the @JGit
            %   folder if successful.
            %
            %   See also: JGIT, DOWNLOADJGITJAR, URLWRITE
            %
            %   Version 0.5 - Egret Release
            %   2013-09-25 Mark Mikofski
            %   <a href="http://poquitopicante.blogspot.com">poquitopicante.blogspot.com</a>
            
            %% inputs
            % use org.eclipse.jgit as default
            githome =  fileparts(mfilename('fullpath'));
            if nargin<1
                jgitjar = fullfile(githome,[JGit.JGIT,'.jar']);
            end
            % copy old org.eclipse.jgit with version info as backup
            if exist(jgitjar,'file')==2
                oldver = fullfile(githome,'older-versions');
                if exist(oldver,'dir')~=7
                    mkdir(oldver)
                end
                oldver = fullfile(oldver,[JGit.JGIT,'-',JGit.VERSION,'-r.jar']);
                copyfile(jgitjar,oldver)
            end
            %% get version number and jar download url from eclipse
            ver = '[0-9].[0-9].[0-9].[0-9]{12}'; % regex for version number
            expr = ['<a href="(https://repo.eclipse.org/content/groups/releases/', ...
                '/org/eclipse/jgit/',JGit.JGIT,'/',ver,'-r/',JGit.JGIT,'-', ...
                ver,'-r.jar)">',JGit.JGIT,'.jar</a>']; % regex for url
            str = urlread('http://www.eclipse.org/jgit/download/');
            assert(~isempty(str),'jgit:downloadJGitJar:badURL', ...
                'Can''t read from jgit download page.')
            tokens = regexp(str,expr,'tokens'); % download url
            assert(~isempty(tokens{1}),'Please report JGit download path has changed.')
            version = regexp(tokens{1}{1},ver,'match'); % version
            assert(~isempty(version{1}),'Please report JGit version format has changed.')
            fprintf('\tVersion: %s\n',version{1}) % display version to download
            [f,status] = urlwrite(tokens{1}{1},jgitjar); % download jar-file
            %% write version number to file if successful
            if status==1
                try
                    fid = fopen(JGit.VERFILE,'wt');
                    fprintf(fid,'%s\n',version{1});
                catch ME
                    fclose(fid);
                    throw(ME)
                end
                fclose(fid);
            end
        end
        function editor = getEDITOR
            %JGIT.GETEDITOR Get the default system editor.
            %   EDITOR = JGIT.GETEDITOR returns 'notepad' if pc, 'textedit'
            %   if mac and 'gedit' if linux.
            %
            %
            %   See also: JGIT, DOWNLOADJGITJAR, URLWRITE
            %
            %   Version 0.5 - Egret Release
            %   2013-09-25 Mark Mikofski
            %   <a href="http://poquitopicante.blogspot.com">poquitopicante.blogspot.com</a>
            
            %% get computer type
            comp = computer;
            switch comp
                case {'PCWIN','PCWIN64'}
                    %% PC
                    editor = 'notepad';
                case 'MACI64'
                    %% MAC
                    editor = 'textedit';
                case 'GLNXA64'
                    %% LINUX
                    editor = 'gedit';
                otherwise
                    %% Try is* if computer didn't work?
                    if ispc
                        %% PC
                        editor = 'notepad';
                    elseif ismac
                        %% MAC
                        editor = 'textedit';
                    elseif isunix
                        %% LINUX
                        editor = 'gedit';
                    else
                        %% no editor
                        error('jgit:noeditor','No editor found.')
                    end
            end
        end
    end
end
