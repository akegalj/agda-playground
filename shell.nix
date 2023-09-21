let cornelis = import (fetchTarball "https://github.com/isovector/cornelis/archive/master.tar.gz");
    pkgs = import (fetchTarball "channel:nixpkgs-unstable") { overlays = [ cornelis.overlays.cornelis ]; };
    badwolf = pkgs.vimUtils.buildVimPlugin {
      name = "badwolf";
      src = pkgs.fetchFromGitHub {
        owner = "sjl";
        repo = "badwolf";
        rev = "682b521";
        sha256 = "Dl4zaGkeglURy7JQtThpaY/UrNIoxtkndjF/HJw7yAg=";
      };
    };
in with pkgs; mkShell {
  buildInputs = [
    (agda.withPackages (p: with p; [
      p.standard-library
    ]))
    (emacsWithPackages (p: with p; [
      emacsPackages.agda2-mode
    ]))
    pkgs.cornelis
    (neovim.override {
      configure = {
        customRC = builtins.readFile ../nixos-config/vimrc + ''
          let g:cornelis_use_global_binary = 1

          au BufRead,BufNewFile *.agda call AgdaFiletype()
          function! AgdaFiletype()
              nnoremap <buffer> <leader>l :CornelisLoad<CR>
              nnoremap <buffer> <leader>r :CornelisRefine<CR>
              nnoremap <buffer> <leader>d :CornelisMakeCase<CR>
              nnoremap <buffer> <leader>, :CornelisTypeContext<CR>
              nnoremap <buffer> <leader>. :CornelisTypeContextInfer<CR>
              nnoremap <buffer> <leader>n :CornelisSolve<CR>
              nnoremap <buffer> <leader>a :CornelisAuto<CR>
              nnoremap <buffer> gd        :CornelisGoToDefinition<CR>
              nnoremap <buffer> [/        :CornelisPrevGoal<CR>
              nnoremap <buffer> ]/        :CornelisNextGoal<CR>
              nnoremap <buffer> <C-A>     :CornelisInc<CR>
              nnoremap <buffer> <C-X>     :CornelisDec<CR>
          endfunction
        '';
        packages.myVimPackage = with vimPlugins; {
          # see examples below how to use custom packages
          start = [
            vimPlugins.cornelis
            # vim-which-key
            # nvim-hs-vim

            vim-nix
            vim-lastplace
            vim-ormolu
            vimwiki
            editorconfig-vim
            vim-textobj-user
            zenburn
            badwolf
            vim-colors-solarized
            ctrlp
          ];
        };
      };
    })
  ];
}