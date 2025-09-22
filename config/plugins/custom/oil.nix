{
  plugins.oil = {
    enable = true;
    settings = {
      view_options.show_hidden = true;
    };
  };
  keymaps = [
    {
      mode = "n";
      key = "<leader>-";
      action = "<cmd> lua require(\"oil\").toggle_float() <CR>";
    }
  ];
}
