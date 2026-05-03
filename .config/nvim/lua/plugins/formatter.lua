return {
  {
    "stevearc/conform.nvim",
    opts = function()
      local opts = {
        default_format_opts = {
          timeout_ms = 3000,
          async = false,
          quiet = false,
          lsp_format = "fallback",
        },
        formatters_by_ft = {
          bash = { "shfmt" },
          css = { "prettier", "prettierd" },
          fish = { "fish_indent" },
          go = { "gofmt", "goimports" },
          json = { "prettier", "prettierd" },
          javascript = { "prettier", "prettierd" },
          html = { "prettier", "prettierd" },
          lua = { "stylua" },
          luau = { "stylua" },
          python = { "black" },
          rust = { "rustfmt" },
          sh = { "shfmt" },
          toml = { "taplo" },
        },
        -- The options you set here will be merged with the builtin formatters.
        -- You can also define any custom formatters here.
        formatters = {
          injected = { options = { ignore_errors = true } },
          -- # Example of using dprint only when a dprint.json file is present
          -- dprint = {
          --   condition = function(ctx)
          --     return vim.fs.find({ "dprint.json" }, { path = ctx.filename, upward = true })[1]
          --   end,
          -- },
          --
          -- # Example of using shfmt with extra args
          -- shfmt = {
          --   prepend_args = { "-i", "2", "-ci" },
          -- },
        },
      }
      return opts
    end,
  },
}
