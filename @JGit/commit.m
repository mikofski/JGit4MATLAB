function commit(varargin)
%JGIT.COMMIT Commit files to the repository.
%   JGIT.COMMIT(PARAMETER,VALUE,...) uses any combination of the following
%   PARAMETER, VALUE pairs.
%   'all' <logical> [false] Automatically stage files that have been modified or
%       deleted before commit.
%   'message' <char> [] Commit with the given message. An empty message will
%       start the editor given by GETENV(EDITOR) or JGIT.EDITOR.
%   'amend' <logical> [false] Amend the previous commit message.
%   'gitDir' <char> [PWD] Commit to repository in specified folder.
%
%   For more information see also
%   <a href="https://www.kernel.org/pub/software/scm/git/docs/git-commit.html">Git Commit Documentation</a>
%   <a href="http://download.eclipse.org/jgit/docs/latest/apidocs/org/eclipse/jgit/api/CommitCommand.html">JGit Git API Class CommitCommand</a>
%
%   Example:
%       JGIT.COMMIT('all',true,'message','initial dump')
%
%   See also JGIT, ADD
%
%   Copyright (c) 2013 Mark Mikofski

%% check inputs
p = inputParser;
p.addParamValue('all',false,@(x)validateattributes(x,{'logical'},{'scalar'}))
p.addParamValue('author','',@(x)validateattributes(x,{'cell'},{'numel',2}))
p.addParamValue('committer','',@(x)validateattributes(x,{'cell'},{'numel',2}))
p.addParamValue('message','',@(x)validateattributes(x,{'char'},{'row'}))
p.addParamValue('amend',false,@(x)validateattributes(x,{'logical'},{'scalar'}))
p.addParamValue('gitDir',pwd,@(x)validateattributes(x,{'char'},{'row'}))
p.parse(varargin{:})
gitDir = p.Results.gitDir;
gitAPI = JGit.getGitAPI(gitDir);
commitCMD = gitAPI.commit;
%% set all
if p.Results.all
    commitCMD.setAll(true);
end
%% set author and committer
if ~isempty(p.Results.author)
    commitCMD.setAuthor(p.Results.author{:});
end
if ~isempty(p.Results.committer)
    commitCMD.setCommitter(p.Results.committer{:});
end
%% amend commit
amendcommit = '';
if p.Results.amend
    commitCMD.setAmend(true);
    logCMD = gitAPI.log;
    repo = gitAPI.getRepository;
    HEAD = repo.resolve('HEAD');
    revCommit = logCMD.add(HEAD).setMaxCount(1).call;
    % use `add()` instead of `all()` since it has problems with peeled tags
    % see https://bugs.eclipse.org/bugs/show_bug.cgi?id=402025
    % revCommit = logCMD.all.setMaxCount(1).call;
    amendcommit = char(revCommit.next.getFullMessage);
end
%% commit message
if ~isempty(p.Results.message)
    commitCMD.setMessage(p.Results.message);
else
    COMMIT_MSG = tempname;
    try
        fid = fopen(COMMIT_MSG,'wt');
        if ~isempty(amendcommit)
            fprintf(fid,amendcommit);
        end
        fprintf(fid,['\n# Please enter the commit message for your changes. Lines starting\n', ...
            '# with ''#'' will be ignored, and an empty message aborts the commit.\n']);
        JGit.status(gitDir,fid,p.Results.amend)
        fclose(fid);
    catch ME
        fclose(fid);
        throw(ME)
    end
    editor = getenv('EDITOR');
    if isempty(editor)
        editor = JGit.EDITOR;
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
        msg = strtrim([msglines{:}]);
        if numel(msg)==1 && strcmp(msg,sprintf('\n'))
            fprintf(2,'Aborting commit due to empty commit message.\n\n');
        else
            commitCMD.setMessage(msg);
        end
    end
end
%% call
commitCMD.call;
end
