{
  plugins.typst-preview = {
    enable = true;
  };

  keymaps = [
    {
      mode = "n";
      key = "<leader>tp";
      action = "<cmd>TypstPreviewToggle<CR>";
      options.desc = "[T]ypst [P]review toggle";
    }
  ];
}
