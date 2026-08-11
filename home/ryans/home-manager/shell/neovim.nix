{
  inputs,
  lib,
  pkgs,
  ...
}: {
  imports = [
    inputs.nvf.homeManagerModules.default # make sure the NVF home manager module is imported.
  ];

  programs.nvf = {
    enable = true;
    settings = {
      vim.enableLuaLoader = true;

      # configure theme
      vim.theme = {
        enable = true;
        name = "rose-pine";
        style = "main";
      };

      vim.options = {
        shiftwidth = 2;
        tabstop = 2;
        expandtab = true;
      };

      # enable plugins
      vim.diagnostics.enable = true;
      vim.lsp.enable = true;

      vim.statusline.lualine.enable = true;
      vim.telescope.enable = true;
      vim.autocomplete.blink-cmp.enable = true;
      vim.utility.sleuth.enable = true;
      vim.utility.images.image-nvim.enable = true;
      vim.autopairs.nvim-autopairs.enable = true;
      vim.visuals.fidget-nvim.enable = true;
      vim.filetree.neo-tree.enable = true;
      vim.git.gitsigns.enable = true;

      # settings
      vim.diagnostics.config = {
        virtual_text = true;
        signs = true;
        update_in_insert = true;
      };

      vim.lsp = {
        formatOnSave = true;
        inlayHints.enable = true;
        lspkind.enable = true;
        lspconfig.enable = true;
      };

      vim.utility.images.image-nvim.setupOpts = {
        backend = "sixel";
      };

      vim.filetree.neo-tree.setupOpts = {
        enable_cursor_hijack = true;
        git_status_async = true;
        source_selector = {
          winbar = true;
          statusline = false;
        };
      };

      vim.languages = let
        mkLanguageConfig = enabledLanguages:
          builtins.listToAttrs ([
              # equivalent to setting the ff:
              {
                name = "enableTreesitter";
                value = true;
              } # vim.languages.enableTreesitter = true;
              {
                name = "enableFormat";
                value = true;
              } # vim.languages.enableFormat = true;
            ]
            ++ (
              # Map the following to make every value given equivalent to:
              # vim.languages.${lang}.enabled = true; (for each and every string passed in the array)
              map (x: {
                name = x;
                value = {enable = true;};
              })
              enabledLanguages
            ));
      in
        lib.mkMerge [
          {
            nix.lsp.servers = ["nixd"];
          }
          (mkLanguageConfig ["nix" "svelte" "rust" "python" "bash"])
        ];
    };
  };

  home.packages = [pkgs.imagemagick];

  home.sessionVariables.EDITOR = "nvim";
}
