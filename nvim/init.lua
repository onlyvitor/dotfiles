-- =========================
-- BASIC SETTINGS
-- =========================
vim.g.mapleader = " "

vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.smartindent = true
vim.opt.wrap = false
vim.opt.termguicolors = true
vim.opt.scrolloff = 8
vim.opt.updatetime = 50
vim.opt.signcolumn = "yes"

-- =========================
-- BOOTSTRAP LAZY.NVIM
-- =========================
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    lazypath,
  })
end

vim.opt.rtp:prepend(lazypath)

-- =========================
-- PLUGINS
-- =========================
require("lazy").setup({

  -- LSP
  { "neovim/nvim-lspconfig" },

  -- LSP installer
  {
    "williamboman/mason.nvim",
    config = function()
      require("mason").setup()
    end,
  },

  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = { "williamboman/mason.nvim" },
    config = function()
      require("mason-lspconfig").setup({
        ensure_installed = { "clangd", "ts_ls" },
      })
    end,
  },

  -- Autocomplete
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
    },
  },

  -- Treesitter
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter.configs").setup({
        ensure_installed = {
          "c",
          "javascript",
          "typescript",
          "tsx",
        },
        highlight = { enable = true },
      })
    end,
  },

  -- File explorer
  {
    "nvim-tree/nvim-tree.lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("nvim-tree").setup({})
    end,
  },

  -- Telescope
  {
    "nvim-telescope/telescope.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
  },

  -- Statusline
  { "nvim-lualine/lualine.nvim" },

  -- Theme
  {
    "rebelot/kanagawa.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      vim.cmd("colorscheme kanagawa-wave")
    end,
  },

  -- Dashboard
  {
    "nvimdev/dashboard-nvim",
    event = "VimEnter",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("dashboard").setup({
        theme = "doom",
        config = {
          header = {
"===:@:.:-------:::.-*%@@@%............:.............=%@@%@%=-...........%#--%-@.",
"==-:+...:..............:--+.......................:--:.................::--%@==:",
"-==+-...%......:..........:::....................=-:..........:......*...---@-==",
"-==%--.:=@@@@@@@@@@@@@=:.....................::........:+@@%@@@@@@@@@-..:---@===",
"===@-#::@%#@@@#****#%@@@@@*..................*-.....+@@@@%@%*+*#%@@%%%%+*---@-==",
"===@.*@@#@#---------:--:*@@@@:..................:=+@@@*-:::---------+@@@@#--@===",
"==*@@@@@*------:..-......:-+@#:...................@+---=....-:::-------@@@@@@==-",
"#==@#@@----:....@@@@+.+@@@%--....................:-..%%@@:.@%%#:..:-----@@@-@-==",
"#+=@=@@--......#*+%#@@@*%.:.........................@%##*@@*+@-@.....:--@@*-@===",
"=%+@=#@+.......==@=%*%*:=%=-.........................=#+.*-:#@=@........@@-=@===",
"=@+@--@@........#--+.:.+-=@...........................:-*..#-#-:.......@@=-%@===",
"-@+@#-:@:........+:-:+:::+.............:..............:::=:-::-........@#:-@@===",
":#+@@-.-% ........-:..:.%...........:=-=-:.............=.:..*........:=-.:-@@===",
":++@@-...:..........#-*::......=.::=:**==-:=::-:.-.......+=...............%#@+=+",
"=+#@@#::::::................:+:::=.=*-+**+---::-:-::::...............::..:@-@+==",
"*+@@-@:::::-::::.....:::-::=-----=%-+-@*++#-*-:*-*:+-:#==::.....::-*:-:::.%=@++=",
"*=%@=@-::-+-=---+---@#%-==:--==-#-=-@--+*-*-=--*==-+#-=-*--==---%-:#--:+-@=+#=++",
"*-#@*@--*=+-#-%*-=#-*----=-=%=@-+-#-=-#=--@=-=*--#==-:+-:#==-#--=#--=%--#@#=#=**",
"",
"        GOD OF WHATSAPP 2        ",
          },
          center = {
            {
              icon = "",
              desc = "Find File",
              action = "Telescope find_files",
              key = "f",
            },
            {
              icon = "",
              desc = "New File",
              action = "ene | startinsert",
              key = "n",
            },
            {
              icon = "",
              desc = "Quit",
              action = "qa",
              key = "q",
            },
          },
            footer = {
              "Happy Coding!",
        },
      }
      })
      vim.o.background = "dark"
      vim.cmd("hi DashboardHeader guifg=#7aa2f7")
      vim.cmd("hi DashboardCenter guifg=#a9b1d6")
      vim.cmd("hi DashboardFooter guifg=#565f89")
        
    end,
  },

})

-- =========================
-- LSP CONFIG
-- =========================
local lspconfig = require("lspconfig")
local capabilities = require("cmp_nvim_lsp").default_capabilities()

lspconfig.clangd.setup({
  capabilities = capabilities,
})

lspconfig.tsserver.setup({
  capabilities = capabilities,
})

-- =========================
-- AUTOCOMPLETE
-- =========================
local cmp = require("cmp")

cmp.setup({
  sources = {
    { name = "nvim_lsp" },
    { name = "buffer" },
    { name = "path" },
  },

  mapping = {
    ["<CR>"] = cmp.mapping.confirm({ select = true }),
    ["<Tab>"] = cmp.mapping.select_next_item(),
    ["<S-Tab>"] = cmp.mapping.select_prev_item(),
  },
})
-- =========================
-- TELESCOPE KEYMAPS
-- =========================
local telescope = require("telescope.builtin")

vim.keymap.set("n", "<leader>ff", telescope.find_files)
vim.keymap.set("n", "<leader>fg", telescope.live_grep)
vim.keymap.set("n", "<leader>fb", telescope.buffers)

-- =========================
-- NVIM TREE KEYMAP
-- =========================
vim.keymap.set("n", "<leader>e", ":NvimTreeToggle<CR>")
-- =========================
-- STATUSLINE
-- =========================
require("lualine").setup()

-- =========================
-- COMPILE & RUN (C)
-- =========================
vim.keymap.set("n", "<leader>c", function()
  vim.cmd("split | terminal gcc % -Wall -Wextra -o %<")
end)

vim.keymap.set("n", "<leader>r", function()
  vim.cmd("split | terminal ./%<")
end)