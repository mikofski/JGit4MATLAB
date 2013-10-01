function parsed_argopts = parseClone(argopts)
%PARSECLONE Parse clone arguments and options.
%   Copyright (c) 2013 Mark Mikofski
parsed_argopts = {};
%% options
% bare
bare = strcmp('--bare',argopts);
% remote name [origin]
origin = strcmp('-o',argopts) | strcmp('--origin',argopts);
if any(origin)
    remotename = argopts(circshift(origin,[0,1])); % store remote name
end
% branch
branch = strcmp('-b',argopts) | strcmp('--branch',argopts);
if any(branch)
    branchname = argopts(circshift(branch,[0,1])); % store branch name
end
% clone submodules recursively
recursive = strcmp('--recursive',argopts) | strcmp('--recurse-submodules',argopts);
% no checkout
noCheckout = strcmp('-n',argopts) | strcmp('--no-checkout',argopts);
% Git doesn't have anything like clone [all] branches &
% --[no-]single-branch is not the same thing
%% pop argopts
argopts(bare | origin | circshift(origin,[0,1]) | branch | ...
    circshift(branch,[0,1]) | recursive | noCheckout) = [];
%% other options
% filter other options and/or double-hyphen
argopts = filterOpts(argopts);
%% parse
% no argument or option checks - jgit checks args/opts
% bare
if any(bare)
    parsed_argopts = [parsed_argopts,'bare',true];
end
% branch
if any(branch)
    parsed_argopts = [parsed_argopts,'branch',branchname];
end
% name remote
if any(origin)
    parsed_argopts = [parsed_argopts,'remote',remotename];
end
% submodules
if any(recursive)
    parsed_argopts = [parsed_argopts,'cloneSubmodules',true];
end
% no-checkout
if any(noCheckout)
    parsed_argopts = [parsed_argopts,'noCheckout',true];
end
% uri-ish
assert(~isempty(argopts),'jgit:parseClone','Specify repository to clone.')
parsed_argopts = [argopts(1),parsed_argopts];
% start-point
if numel(argopts)>1
    parsed_argopts = [parsed_argopts,'directory',argopts(2)];
end
end