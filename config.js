module.exports = {
  brew: [
    // http://conqueringthecommandline.com/book/ack_ag
    "ack",
    "ag",
    "atool",
    // alternative to `cat`: https://github.com/sharkdp/bat
    "bat",
    // Install GNU core utilities (those that come with macOS are outdated)
    // Don’t forget to add `$(brew --prefix coreutils)/libexec/gnubin` to `$PATH`.
    "coreutils",
    "dos2unix",
    "diff-so-fancy",
    // Install GNU `find`, `locate`, `updatedb`, and `xargs`, `g`-prefixed
    "elinks",
    "exiftool",
    "ffmpeg",
    "findutils",
    // 'fortune',
    "fasd",
    "fzf",
    "readline", // ensure gawk gets good readline
    "gawk",
    // http://www.lcdf.org/gifsicle/ (because I'm a gif junky)
    "gifsicle",
    "git-extras",
    "gnupg",
    // Install GNU `sed`, overwriting the built-in `sed`
    // so we can do "sed -i 's/foo/bar/' file" instead of "sed -i '' 's/foo/bar/' file"
    "gnu-sed --with-default-names",
    // upgrade grep so we can get things like inverted match (-v)
    "grep --with-default-names",
    // better, more recent grep
    "homebrew/dupes/grep",
    // Because gkze says vtop is gross
    "htop",
    // https://github.com/jkbrzt/httpie
    "httpie",
    // jq is a sort of JSON grep
    "jq",
    "highlight",
    "imlib2",
    "libcaca",
    "lynx",

    // Mac App Store CLI: https://github.com/mas-cli/mas
    "mas",
    "mediainfo",
    // Install some other useful utilities like `sponge`
    "moreutils",
    "ncdu",
    "nmap",
    "openconnect",
    "ripgrep",
    "rbenv",
    "ranger",
    "peco",
    "poppler",
    "python",
    "python@2",
    "reattach-to-user-namespace",
    "rename",
    // better/more recent version of screen
    "homebrew/dupes/screen",
    "ripgrep",
    "swiftlint",
    "tig",
    "tmux",
    "transmission",
    "todo-txt",
    "tree",
    "ttyrec",
    // better, more recent vim
    "vim --with-override-system-vi",
    "watch",
    "w3m",
    // Install wget with IRI support
    "wget --enable-iri",
    // Need vim from brew to get copy to clipboard, not compiled by default in mac.
    "vim",
    "youtube-dl",
    "yank",
    "zsh-syntax-highlighting",
  ],
  cask: [
    "3hub",
    //'adium',
    //'amazon-cloud-drive',
    //'atom',
    //'box-sync',
    //'comicbooklover',
    //'diffmerge',
    "docker", // docker for mac
    //'dropbox',
    //'evernote',
    //'flux',
    //'gpg-suite',
    "hazel",
    "rekordbox",
    //'ireadfast',
    "iterm2",
    //'little-snitch',
    //'macbreakz',
    //'micro-snitch',
    "moom",
    "signal",
    "macvim",
    //'sizeup',
    //'sketchup',
    //'slack',
    //'the-unarchiver',
    //'torbrowser',
    "transmission",
    //'visual-studio-code',
    "vlc",
    //'xquartz'
  ],
  gem: [],
  npm: [
    "antic",
    "buzzphrase",
    "eslint",
    "instant-markdown-d",
    // 'generator-dockerize',
    // 'gulp',
    "npm-check-updates",
    "prettyjson",
    "prettier",
    "trash",
    "vtop",
    // ,'yo'
  ],
};
