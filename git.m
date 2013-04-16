classdef git < handle
    properties (Constant)
        EDITOR = 'notepad'
        F = @(method,args)feval([git.JGIT,'.',method],args{:})
        GIT_DIR = '.git'
        JGIT = 'org.eclipse.jgit'
    end
    methods (Static)
        function gitAPI = getGitAPI(gitDir)
            if nargin<1
                gitDir = pwd;
            end
            git.validateJavaClassPath
            gitDir = git.getGitDir(gitDir);
            assert(~isempty(gitDir),'git:notGitRepo', ...
                ['fatal: Not a git repository (or any of the parent', ...
                'directories): .git'])
            gitAPI = git.F('api.Git.open',{java.io.File(gitDir)});
        end
        function add(pathlist,gitDir)
            if nargin<2
                gitDir = pwd;
            end
            gitAPI = git.getGitAPI(gitDir);
            if iscellstr(pathlist)
                for n = 1:numel(pathlist)
                    gitAPI.add.addFilepattern(pathlist{n}).call;
                end
            elseif ischar(pathlist)
                gitAPI.add.addFilepattern(pathlist).call;
            end
        end
        function commit(varargin)
            p = inputParser;
            p.addParamValue('all',false,@(x)validateattributes(x,{'logical'},{'scalar'}))
            p.addParamValue('author','',@(x)validateattributes(x,{'cell'},{'numel',2}))
            p.addParamValue('committer','',@(x)validateattributes(x,{'cell'},{'numel',2}))
            p.addParamValue('message','',@(x)validateattributes(x,{'char'},{'row'}))
            p.addParamValue('amend',false,@(x)validateattributes(x,{'logical'},{'scalar'}))
            p.addParamValue('gitDir',pwd,@(x)validateattributes(x,{'char'},{'row'}))
            p.parse(varargin{:})
            gitDir = p.Results.gitDir;
            gitAPI = git.getGitAPI(gitDir);
            commitCMD = gitAPI.commit;
            if p.Results.all                
                commitCMD.setAll(true)
            end
            if ~isempty(p.Results.author)
                commitCMD.setAuthor(p.Results.author{:})
            end
            if ~isempty(p.Results.committer)
                commitCMD.setCommitter(p.Results.committer{:})
            end
            amendcommit = '';
            if p.Results.amend
                commitCMD.setAmend(true)
                logCMD = gitAPI.log;
                revCommit = logCMD.all.setMaxCount(1).call;
                amendcommit = char(revCommit.next.getFullMessage);
            end
            if ~isempty(p.Results.message)
                commitCMD.setMessage(p.Results.message)
            else
                COMMIT_MSG = tempname;
                try
                    fid = fopen(COMMIT_MSG,'wt');
                    if ~isempty(amendcommit)
                        fprintf(fid,amendcommit);
                    end
                    fprintf(fid,['\n# Please enter the commit message for your changes. Lines starting\n', ...
                        '# with ''#'' will be ignored, and an empty message aborts the commit.\n']);
                    git.status(gitDir,fid,p.Results.amend)
                    fclose(fid);
                catch ME
                    fclose(fid);
                    throw(ME)
                end
                editor = getenv('EDITOR');
                if isempty(editor)
                    editor = git.EDITOR;
                end
                status = system([editor,' ',COMMIT_MSG]);
                if ~status
                    try
                        fid = fopen(COMMIT_MSG,'rt');
                        msg = fread(fid,'*char')';
                        fclose(fid);
                        delete(COMMIT_MSG)
                    catch ME
                        fclose(fid);
                        throw(ME)
                    end
                    msglines = textscan(msg,'%s','Delimiter','\n','CommentStyle','#');
                    msglines = msglines{1};
                    msglines = [msglines,repmat({sprintf('\n')},numel(msglines),1)]';
                    msg = [msglines{:}];
                    commitCMD.setMessage(msg)
                end
            end
            commitCMD.call
        end
        function status(gitDir,fid,amend)
            if nargin<1
                gitDir = pwd;
            end
            if nargin<2
                fid = 1;
            end
            if nargin<3
                amend = false;
            end
            gitAPI = git.getGitAPI(gitDir);
            statusCall = gitAPI.status.call;
            fmtStr = '# On branch %s\n';
            fprintf(fid,fmtStr,char(gitAPI.getRepository.getBranch));
            if amend
                fprintf(fid,'#\n# Initial commit\n#\n');
            end
            if statusCall.isClean
                fprintf('nothing to commit, working directory clean\n')
            else
                added = statusCall.getAdded;
                changed = statusCall.getChanged;
                if ~added.isEmpty || ~changed.isEmpty
                    fprintf(fid,[ ...
                        '# Changes to be committed:\n', ...
                        '#   (use "git reset HEAD <file>..." to unstage)\n', ...
                        '#\n']);
                    if fid==1
                        fmtStr = '#       <a href="matlab: edit(''%s'')">modified:   %s</a>\n';
                    else
                        fmtStr = '#       modified:   %s\n';
                    end
                    for n = 1:changed.size
                        str = {changed.iterator.next};
                        if fid==1;str = {str{1},str{1}};end
                        fprintf(fid,fmtStr,str{:});
                    end
                    if fid==1
                        fmtStr = '#       <a href="matlab: edit(''%s'')">new file:   %s</a>\n';
                    else
                        fmtStr = '#       new file:   %s\n';
                    end
                    for n = 1:added.size
                        str = {added.iterator.next};
                        if fid==1;str = {str{1},str{1}};end
                        fprintf(fid,fmtStr,str{:});
                    end
                    fprintf(fid,'#\n');
                end
                modified = statusCall.getModified;
                if ~modified.isEmpty
                    fprintf(fid,[ ...
                        '# Changes not staged for commit:\n', ...
                        '#   (use "git add <file>..." to update what will be committed)\n', ...
                        '#   (use "git checkout -- <file>..." to discard changes in working directory)\n', ...
                        '#\n']);
                    fmtStr = '#       modified:   %s\n';
                    if fid==1,fid = 2;end
                    for n = 1:modified.size
                        fprintf(fid,fmtStr,modified.iterator.next);
                    end
                    if fid==2,fid = 1;end
                    fprintf(fid,'#\n');
                end
                untracked = statusCall.getUntracked;
                if ~untracked.isEmpty
                    fprintf(fid,[ ...
                        '#\n', ...
                        '# Untracked files:\n', ...
                        '#   (use "git add <file>..." to include in what will be committed)\n', ...
                        '#\n']);
                    fmtStr = '#       %s\n';
                    untracked = statusCall.getUntracked;
                    if fid==1,fid = 2;end
                    for n = 1:untracked.size
                        fprintf(2,fmtStr,untracked.iterator.next);
                    end
                    if fid==2,fid = 1;end
                    fprintf(fid,'#\n');
                end
                fprintf(fid,'# no changes added to commit (use "git add" and/or "git commit -a")\n');
            end
        end
        function gitDir = getGitDir(path)
            gitDir = fullfile(path,git.GIT_DIR);
            s = dir(gitDir);
            while isempty(s)
                parent = fileparts(path);
                if strcmpi(path,parent)
                    gitDir = [];
                    break
                end
                path = parent;
                gitDir = fullfile(path,git.GIT_DIR);
                s = dir(gitDir);
            end
        end
        function validateJavaClassPath
            spath = javaclasspath('-static');
            githome =  fileparts(mfilename('fullpath'));
            jgitjar = fullfile(githome,[git.JGIT,'.jar']);
            if any(strcmp(spath,jgitjar))
                return
            end
            fprintf(2,'JGit not detected.\n');
            if exist(jgitjar,'file')~=2
                fprintf(2,'JGit jar-file doesn''t exist. Downloading ...\n');
                [f,status] = git.downloadJGitJar;
                if status==1
                    fprintf(2,'\t%s.\nDone.\n',f);
                else
                    error('git:validateJavaClassPath:downloadError',status)
                end
            end
            workhome = userpath;workhome = workhome(1:end-1);
            javapath = fullfile(workhome,'javaclasspath.txt');
            if exist(javapath,'file')~=2
                fprintf(2,'"javaclasspath.txt" not detected. Writing ...\n');
                try
                    fid = fopen(javapath,'wt');
                    fprintf(fid,'# JGit package\n%s\n',jgitjar);
                    fclose(fid);
                    fprintf(2,'Done.\n\n\t**Please restart MATLAB.**\n\n');
                catch ME
                    fclose(fid);
                    throw(ME)
                end
            else
                try
                    fid = fopen(javapath,'r+t');
                    pathline = fgetl(fid);
                    while ~strcmp(pathline,jgitjar)
                        pathline = fgetl(fid);
                        if feof(fid)
                            fprintf(2,'JGit not on "javaclasspath.txt". Writing ...\n');
                            fprintf(fid,'# JGit package\n%s\n',jgitjar);
                            fclose(fid);
                            fprintf(2,'Done.\n\n\t**Please restart MATLAB.**\n\n');
                            break
                        end
                    end
                catch ME
                    fclose(fid);
                    close(h)
                    throw(ME)
                end
            end
        end
        function [f,status] = downloadJGitJar
            ver = '[0-9].[0-9].[0-9].[0-9]{12}';
            expr = ['<a href="(http://download.eclipse.org/jgit/maven/', ...
                'org/eclipse/jgit/',git.JGIT,'/',ver,'-r/',git.JGIT,'-', ...
                ver,'-r.jar)">',git.JGIT,'.jar</a>'];
            str = urlread('http://www.eclipse.org/jgit/download/');
            assert(~isempty(str),'git:downloadJGitJar:badURL', ...
                'Can''t read from jgit download page.')
            tokens = regexp(str,expr,'tokens');
            version = regexp(tokens{1}{1},ver,'match');
            fprintf('\tVersion: %s\n',version)
            [f,status] = urlwrite(tokens{1}{1},'org.eclipse.jgit.jar');
        end
    end
end
