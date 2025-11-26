-- [[ Configure which-key ]]
-- Document existing keybindings and create groups

local wk = require("which-key")

-- Register key groups
wk.add({
    -- Leader key groups
    { "<leader>g", desc = "[G]it files (fzf)" },
    { "<leader>f", desc = "[F]iles (fzf)" },
    { "<leader>t", desc = "[T]ags in buffer (fzf)" },
    { "<leader>T", desc = "[T]ags in directory (fzf)" },
    { "<leader>b", desc = "[B]uffers (fzf)" },
    { "<leader>c", desc = "[C]ommits in file (fzf)" },
    { "<leader>C", desc = "[C]ommits all (fzf)" },
    { "<leader>/", desc = "Search pattern in files (fzf)" },
    { "<leader>h", desc = "[H]istory of files (fzf)" },
    { "<leader>e", desc = "Show diagnostic [E]rror" },
    { "<leader>q", desc = "Diagnostics [Q]uickfix list" },
    { "<leader>a", desc = "Swap next parameter" },
    { "<leader>A", desc = "Swap previous parameter" },

    -- Git hunk operations (from gitsigns)
    { "<leader>hp", desc = "[H]unk [P]review" },

    -- Backslash key groups (buffer management)
    { "<Bslash>[", desc = "Previous buffer" },
    { "<Bslash>]", desc = "Next buffer" },
    { "<Bslash>q", desc = "Close buffer" },
    { "<Bslash>o", desc = "Close [O]ther buffers" },
    { "<Bslash>t", desc = "Toggle file [T]ree" },

    -- Diagnostic navigation
    { "[d", desc = "Previous diagnostic" },
    { "]d", desc = "Next diagnostic" },

    -- Git hunk navigation (from gitsigns)
    { "[c", desc = "Previous git change" },
    { "]c", desc = "Next git change" },

    -- Function navigation (from treesitter)
    { "[m", desc = "Previous function start" },
    { "]m", desc = "Next function start" },
    { "[M", desc = "Previous function end" },
    { "]M", desc = "Next function end" },
    { "[[", desc = "Previous class start" },
    { "]]", desc = "Next class start" },
    { "[]", desc = "Previous class end" },
    { "][", desc = "Next class end" },

    -- Function keys
    { "<F2>", desc = "Trim whitespace" },
    { "<F3>", desc = "Toggle line numbers" },
    { "<F4>", desc = "Toggle wrap" },
    { "<F5>", desc = "Toggle spell check" },
    { "<F6>", desc = "Git blame" },

    -- Other useful bindings
    { "gm", desc = "Go to middle of line" },
    { "s", desc = "Leap forward" },
    { "S", desc = "Leap backward" },
    { "gs", desc = "Leap from windows" },

    -- LSP keybindings (will be set when LSP attaches)
    { "gd", group = "LSP: [G]oto [D]efinition" },
    { "gr", group = "LSP: [G]oto [R]eferences" },
    { "gI", group = "LSP: [G]oto [I]mplementation" },
    { "gD", group = "LSP: [G]oto [D]eclaration" },
    { "<leader>D", group = "LSP: Type [D]efinition" },
    { "<leader>ds", group = "LSP: [D]ocument [S]ymbols" },
    { "<leader>ws", group = "LSP: [W]orkspace [S]ymbols" },
    { "<leader>rn", group = "LSP: [R]e[n]ame" },
    { "<leader>ca", group = "LSP: [C]ode [A]ction" },
    { "K", group = "LSP: Hover Documentation" },
})
