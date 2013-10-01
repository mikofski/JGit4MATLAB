function parsed_opts = parseOpts(options, dictionary)
%PARSEOPTS Parse OPTIONS according to a DICTIONARY.
%   DICTIONARY is an array of options definitions. Each row contains the
%   name of the option, the command-line options and a logical indicating
%   whether the option has an argument or is boolean.
%   PARSEOPTS returns a structure whose keys are the names of the parsed
%   options and whose values are a logical indicating whether the option
%   was given and its value if not boolean.
%
%   Example:
%       popts = parseOpts({'-a','-m','this is a commit message', ...
%           {'all',{'-a','--all'},true;'amend',{'--amend'},true; ...
%           'author',{'--author'},false;'message',{'-m','--message'},false}
%       struct
%           all:    true
%           amend:  false
%           author: false
%           message:'this is a commit message'
%   
%   Copyright (c) 2013 Mark Mikofski

% no arguments checks
Nopts = size(dictionary,1); % number of options
parsed_opts = cell2struct(dictionary(:,2:3),dictionary(:,1));
% loop over option definitions
for n = 1:Nopts
    optDef = dictionary(n,:); % option definition
    name = optDef{1};commands = optDef{2};isBool = optDef{3}; 
    % loop over commands
    parsed_opts(1).(name) = false;
    assert(~isempty(commands),'jgit:parseOpts')
    for cmd = commands
        parsed_opts(1).(name) = parsed_opts(1).(name) | strcmp(cmd,options);
    end
    % store value
    parsed_opts(2).(name) = [];
    if ~isBool && any(parsed_opts(1).(name))
        parsed_opts(2).(name) = options(circshift(parsed_opts(1).(name),[0,1]));
    end
end
end

