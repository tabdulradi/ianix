{config, pkgs, ... }:

# http://stackoverflow.com/questions/7131670/make-bash-alias-that-takes-parameter
#
# Comment:
#
# If you are changing an alias to a function, sourceing your .bashrc will add
# the function but it won't unalias the old alias. Since aliases are higher
# precedent than functions, it will try to use the alias. You need to either
# close and reopen your shell, or else call unalias <name>. Perhaps I'll save
# someone the 5 minutes I just wasted.
#
# ---
#
# Comment:
#
# One time-saving trick I learned at Sun is to just do an exec bash: It will
# start a new shell, giving you a clean read of your configs, just as if you
# closed and reopened, but keeping that session's environment variable settings
# too.

# Note: this works with `exec zsh` too.

{
  programs.zsh = {
    enable = true;
    interactiveShellInit =
      ''
      ##################################################
      # Zsh specific
      ##################################################

      autoload -U colors && colors

      # # For pass command completion
      # #
      # # TODO: how to avoid hardcoding this?
      # source /nix/store/xzi9k0an1015c055gh8jirdpx7m0rpy0-password-store-1.4.2/etc/bash_completion.d/password-store

      # Set zsh to vi mode.
      bindkey -v

      ##################################################
      # Other
      ##################################################

      # This is required for fasd. It runs once per command executed.
      eval "$(fasd --init auto)"

      # Using a function because alias doesn't take parameters.
      rungcc() {
          gcc -o temp.out $1
          ./temp.out
          rm temp.out
      }

      # TODO: without this wrapper, attempting to switch to root with `su` doesn't work.
      # Additionally, after attempting to do so, `exit` wouldn't work either.
      if [ $(whoami) != "root" ]; then
          eval "$(gpg-agent --daemon)"
      fi

      ##################################################
      # Environment variables
      ##################################################

      # For vim-gnupg specifically, but gpg always wants this, see:
      # https://www.gnupg.org/documentation/manuals/gnupg-devel/Invoking-GPG_002dAGENT.html
      export GPG_TTY=$(tty)

      export NIXPKGS_ALLOW_UNFREE=1

      export EDITOR=vim

      # http://golang.org/doc/install
      export GOPATH=/home/traveller/code/go
      export PATH=$GOPATH/bin:$PATH # Add programs we compile to $PATH.
      export GOROOT=/nix/store/mrnlp871pmhlp9m5almm52faq3v8s3q5-go-1.2.1/share/go
      export PATH=$PATH:$GOROOT/bin

      # Don't create .pyc files.
      export PYTHONDONTWRITEBYTECODE=1
      '';
    promptInit =
      # Changes to the terminal's colorscheme affect how these colors actually appear.

      # http://stackoverflow.com/a/2534676
      # Surround color codes and non-printable characters with %{....%}.

      # NOTE: yellow is showing up as orange.

      # %~ is show whole path, using ~ for $HOME.
      ''
      PS1="%{$fg[cyan]%}[%~]%{$fg[blue]%}%n@%{$fg[blue]%}%m $%{$reset_color%} "
      '';
  };

  # You can bypass aliases by using backslash, eg \ls to run the unaliased ls
  environment.shellAliases = {

    ".."   = "cd ..";
    "..."  = "cd ../..";
    "...." = "cd ../../..";

    background-center = "feh --bg-center";
    background-max    = "feh --bg-max";
    background-fill   = "feh --bg-fill";

    cal= "cal -3 --monday";

    # for escoger
    #
    # about find
    #
    # -a is and
    # -o is or
    #
    # -prune means don't descend into it if it's a dir
    # -print means output
    #
    #
    # cd to a directory below you.
    ecd = "cd $(find * -name .git -a -type d -prune -o -type d -print | escoger)";
    # open file below you in vim
    ev = "vim $(find * -name .git -a -type d -prune -o -type f -print | escoger)";

    # Print absolute path to file.
    full = "readlink -f";

    # The first git message is special (I believe because it has no parent and
    # so is harder to change) so start project with an empty commit.
    #
    # Idea from here: http://stackoverflow.com/a/22233092
    gitinit = "git init; git commit --allow-empty -m 'Create repo.'";

    # Nix's gnupg makes a gpg2 executable.
    gpg = "gpg2";

    lock = "i3lock";

    # -A flag shows dotfiles other than . and ..
    #
    # Using   color   to  distinguish  file  types  is  disabled  both  by  default  and  with
    # --color=never.  With --color=auto, ls emits color codes only  when  standard  output  is
    # connected  to  a  terminal.  The LS_COLORS environment variable can change the settings.
    # Use the dircolors command to set it.
    #
    # LC_COLLATE=C shows dotfiles first, instead of mixed through the output.
    ls = "LC_COLLATE=C ls -A --color=auto";

    # Make a nice password.
    #
    # --symbols : include symbols and use at least one
    # first number : length of password
    # second number : number of passwords to generate
    mkpass = "pwgen --no-capitalize --symbols 14 1";

    # grep -I ignores binary files.
    mygrep = "grep -ri --binary-files=without-match --exclude-dir='active' --exclude-dir='old_code'";

    nim-search = "nix-env -qaP --description | grep -i";

    pingit = "ping www.google.com";

    version = "cat /etc/issue";

    voldown = "amixer set Master unmute 8%-";
    volup   = "amixer set Master unmute 8%+";

    # TODO: zsh gives "no matches found error if enabled on startup."
    # Run rot13 without args and then enter your text. From here:
    # http://www.commandlinefu.com/commands/view/1792/rot13-using-the-tr-command
    #
    # rot13 = "tr '[A-Za-z]' '[N-ZA-Mn-za-m]'";

    # TODO: zsh gives "no matches found error if enabled on startup."
    # Recursive General Linter. Print names of files with trailing whitespace.
    #
    # Discover trailing spaces:
    # http://stackoverflow.com/questions/11210126/bash-find-files-with-trailing-spaces-at-the-end-of-the-lines
    #
    # Skip binary files:
    # http://stackoverflow.com/questions/4767396/linux-command-how-to-find-only-text-files
    #
    # This is a good example of how horrible UNIX commands can get.
    # rglint = "find . -type f | xargs grep -EIl '*' | xargs grep -El '.* +$'";

    rss = "liferea";

    runghc = "echo 'Alias disabled'";
    runhaskell = "runhaskell -Wall";

    serve = "python -m SimpleHTTPServer";

    unixtime = "date +%s";

    # Custom fasd command to open a file with vim.
    v = "f -e vim";

    # -p[N]    Open N tab pages.  When N is omitted, open one tab page for each file.
    vim = "vim -p";

    yt = "youtube-dl --extract-audio --audio-format vorbis";
  };
}
