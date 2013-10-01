function jgit(varargin)
%JGIT Command line function and arg/opt parser for JGit4MATLAB.
%   Copyright (c) 2013 Mark Mikofski

%% initialize and/or return JGit constants
if nargin==0
    try
        JGit %#ok<NOPRT>
    catch ME
        rethrow(ME)
    end
    return
end
%% command/arguments
cmd = varargin{1}; % command
% arguments if any
try
    argopts = varargin(2:end);
catch
    argopts = {};
end
%% help
if any(strcmp(cmd,{'help','-h','--help'}))
    if isempty(argopts)
        jgit_help('help') % general help
    else
        jgit_help(argopts{1}) % specific subcommand help
    end
    return
end
%% version
if any(strcmp(cmd,{'version','-v','--version'}))
    JGit.VERSION
    return
end
%% update JGit jar-file
if any(strcmp(cmd,{'update','-u','--update'}))
    JGit.downloadJGitJar
    return
end
%% remove any equal signs from options
% Git doesn't care if equals signs are used (or not) with long options
if ~isempty(argopts)
    argopts = splitequalsigns(argopts);
end
%% parse subcommands
% brute force because not just parsing args/opts, also translating git
% subcommands, args & opts to JGit.
switch cmd
    case 'add'
        %% add
        parsed_argopts = {};
        % update
        update = strcmp('-u',argopts) | strcmp('--update',argopts);
        if any(update)
            parsed_argopts = {'update',true};
            argopts(update) = [];
        end
        % filter other options and/or double-hyphen
        argopts = filterOpts(argopts);
        % filepatterns
        assert(~isempty(argopts),'jgit:parseAdd','Specify file patterns to add.')
        if numel(argopts)>1
            parsed_argopts = [{argopts},parsed_argopts]; % cell string
        else
            parsed_argopts = [argopts,parsed_argopts]; % char
        end
    case 'branch'
        parsed_argopts = parseBranch(argopts);
    case 'checkout'
        parsed_argopts = parseCheckout(argopts);
    case 'clone'
        parsed_argopts = parseClone(argopts);
    case 'commit'
        parsed_argopts = parseCommit(argopts);
    case 'status'
        %% status
        parsed_argopts = {};
    otherwise
        error('jgit:noCommand', ...
            '"%s" is not a JGit command. See <a href="matlab: fprintf(''%s''),jgit help">%s</a>', ...
            cmd,'>> jgit help\n','jgit help.')
end
try
    JGit.(cmd)(parsed_argopts{:})
catch ME
    rethrow(ME)
end
% end
end
