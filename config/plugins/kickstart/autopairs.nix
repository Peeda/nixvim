{
  # Inserts matching pairs of parens, brackets, etc.
  # https://nix-community.github.io/nixvim/plugins/nvim-autopairs/index.html
  plugins.nvim-autopairs = {
    enable = true;
    luaConfig.post = ''
      local npairs = require("nvim-autopairs")
      local Rule = require('nvim-autopairs.rule')

      npairs.add_rule(Rule("$", "$"))
    '';
  };
}
