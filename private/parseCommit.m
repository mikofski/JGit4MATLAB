function parsed_argopts = parseCommit(argopts)
%PARSECOMMIT Parse commit arguments and options.
%   Copyright (c) 2013 Mark Mikofski
parsed_argopts = {};
%% options
% all
allcommit = strcmp('-a',argopts) | strcmp('--all',argopts);
% amend
amend = strcmp('--amend',argopts);
% message
message = strcmp('-m',argopts) | strcmp('--message',argopts);
if any(message)
    msgContent = argopts(circshift(message,[0,1])); % store message content
end
% author
author = strcmp('--author',argopts);
if any(author)
    % store message content, split author name and email
    authorNameEmail = regexp(argopts(circshift(author,[0,1])),'(.+) <(.+)>','tokens');
    assert(~isempty(authorNameEmail),'jgit:parseCommit', ...
        'Specify an explicit author using the standard A U Thor <author@example.com> format.')
    authorNameEmail = authorNameEmail{1}; % extract the tokens, they are nested cells
end
%% pop argopts
argopts(allcommit | amend | message | circshift(message,[0,1]) | author | ...
    circshift(author,[0,1])) = [];
%% other options
% filter other options and/or double-hyphen
argopts = filterOpts(argopts);
%% parse
% no argument or option checks - jgit checks args/opts
% all
if any(allcommit)
    parsed_argopts = [parsed_argopts,'all',true];
end
% amend
if any(amend)
    parsed_argopts = [parsed_argopts,'amend',true];
end
% message
if any(message)
    parsed_argopts = [parsed_argopts,'message',msgContent];
end
% author
if any(author)
    parsed_argopts = [parsed_argopts,'author',authorNameEmail];
end
% only files on command line
if numel(argopts)>0
    parsed_argopts = [parsed_argopts,'only',{argopts}];
end