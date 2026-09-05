{
  # Inserts matching pairs of parens, brackets, etc.
  # https://nix-community.github.io/nixvim/plugins/nvim-autopairs/index.html
  plugins.nvim-autopairs = {
    enable = true;
    luaConfig.post = ''
      local npairs = require("nvim-autopairs")
      local Rule = require('nvim-autopairs.rule')

      -- Math delimiters, so typing the closing `$` skips over the pair instead
      -- of inserting a new one.
      --
      -- NOTE: `cond.move_right()` can't be used here. It only returns nil
      -- (meaning "allow") for close brackets and for the quote characters
      -- `'`, `"` and `` ` ``; for anything else it returns false, which would
      -- leave the move blocked. `$` needs its own predicate.
      npairs.add_rule(
        Rule("$", "$", { "typst", "markdown", "quarto", "rmd", "tex", "latex", "plaintex" })
          :with_move(function(opts)
            return opts.next_char == opts.char
          end)
          :use_undo(true)
      )
    '';
  };
}
