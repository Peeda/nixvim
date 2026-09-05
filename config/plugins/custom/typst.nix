{
  # Typst buffer setup: a proper `$` textobject and prose-friendly options.
  #
  # `plugins.typst-preview` and the tinymist LSP live in ./tinymist.nix; the
  # typst treesitter grammar is pulled in by ../kickstart/treesitter.nix.
  autoCmd = [
    {
      event = [ "FileType" ];
      pattern = [ "typst" ];
      desc = "Typst: math textobject and prose options";
      group = "typst-setup";
      callback.__raw = ''
        function(args)
          local buf = args.buf

          -- [[ `a$` / `i$` over math ]]
          --
          -- mini.ai synthesises a fallback spec for any non-Latin identifier, so
          -- `ci$` half-works out of the box -- but that fallback leaves the
          -- opening `$` out of `a`, and being pattern-based it mispairs across
          -- adjacent runs like `$x$ and $y$` and over multi-line display math.
          --
          -- nvim-treesitter ships no textobjects query for typst, so drive this
          -- off the grammar directly. The node is `math`, with its two `$` as
          -- anonymous children.

          -- Symmetric pattern fallback for when the parser is unavailable.
          -- Unlike mini.ai's built-in one, `a` covers both delimiters.
          local fallback = { '%$()[^$]*()%$' }

          local function line_at(row)
            return vim.api.nvim_buf_get_lines(buf, row, row + 1, false)[1] or ""
          end

          -- Walk (row, col) forwards/backwards over blanks, staying inside the
          -- half-open range, so `$ x $` yields `x` rather than ` x `.
          local function trim_start(row, col, erow, ecol)
            while row < erow or (row == erow and col < ecol) do
              local line = line_at(row)
              if col >= #line then
                row, col = row + 1, 0
              elseif line:sub(col + 1, col + 1):match('%s') then
                col = col + 1
              else
                break
              end
            end
            return row, col
          end

          local function trim_end(row, col, srow, scol)
            while row > srow or (row == srow and col > scol) do
              if col == 0 then
                row = row - 1
                col = #line_at(row)
              elseif line_at(row):sub(col, col):match('%s') then
                col = col - 1
              else
                break
              end
            end
            return row, col
          end

          local function math_spec(ai_type, _, opts)
            local ok, parser = pcall(vim.treesitter.get_parser, buf, 'typst')
            if not ok or parser == nil then return fallback end

            local ok_query, query = pcall(vim.treesitter.query.parse, 'typst', '(math) @m')
            if not ok_query then return fallback end

            -- Only parse and scan the window mini.ai would search anyway.
            local cur = vim.api.nvim_win_get_cursor(0)[1] - 1
            local last = vim.api.nvim_buf_line_count(buf) - 1
            local from = math.max(0, cur - opts.n_lines)
            local to = math.min(last, cur + opts.n_lines)

            local trees = parser:parse({ from, to })
            if not trees then return fallback end

            local regions = {}
            for _, tree in ipairs(trees) do
              for _, node in query:iter_captures(tree:root(), buf, from, to + 1) do
                local srow, scol, erow, ecol = node:range()

                if ai_type == 'i' then
                  -- Step inside the `$` delimiters. Take them from the grammar
                  -- rather than assuming a byte width, then drop the padding.
                  local open, close
                  for child in node:iter_children() do
                    if child:type() == '$' then
                      open = open or child
                      close = child
                    end
                  end
                  if open == nil or close == nil or open:id() == close:id() then
                    goto continue
                  end

                  local _, _, orow, ocol = open:range()
                  local crow, ccol = close:range()
                  srow, scol = trim_start(orow, ocol, crow, ccol)
                  erow, ecol = trim_end(crow, ccol, srow, scol)

                  if srow == erow and scol >= ecol then goto continue end
                end

                -- 1-based with an inclusive end column, matching mini.ai's own
                -- treesitter spec. Node ranges are 0-based and end-exclusive,
                -- so the end column carries over as-is.
                table.insert(regions, {
                  from = { line = srow + 1, col = scol + 1 },
                  to = { line = erow + 1, col = ecol },
                })

                ::continue::
              end
            end

            if #regions == 0 then return fallback end
            return regions
          end

          -- Buffer-local, so no other filetype's `$` behaviour changes.
          vim.b[buf].miniai_config = { custom_textobjects = { ['$'] = math_spec } }

          -- [[ Prose options ]]
          vim.opt_local.linebreak = true
          vim.opt_local.breakindent = true
          -- Safe here: nvim-treesitter's typst highlights capture `(text) @spell`,
          -- so only prose is checked and math is left alone.
          vim.opt_local.spell = true
          -- The global 80-column ruler is meaningless for wrapped prose.
          vim.opt_local.colorcolumn = ""
        end
      '';
    }
  ];
}
