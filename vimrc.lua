--
-- Ron's Neovim Configuration
--
-- This is sourced after vimrc by Neovim only
--

function has(module_name)
    if package.loaded[module_name] then return true end
    for _, searcher in ipairs(package.searchers or package.loaders) do
      local loader = searcher(module_name)
      if type(loader) == "function" then
        package.preload[module_name] = loader
        return true
      end
    end
    return false
end


vim.diagnostic.config ({
    virtual_text = false,
    float = { border = "rounded" },
})

vim.keymap.set("n", "<Leader>k", function()
    vim.diagnostic.open_float()
end)


--
-- barbar
--
if has("barbar") then
    require("barbar").setup({
        animation = false,
        focus_on_close = 'previous',
        highlight_inactive_file_icons = false,
        icons = {
            separator = { left = '', right = '' },
            separator_at_end = false,
        },
    })

    local map = vim.api.nvim_set_keymap
    local opts = { noremap = true, silent = true }
    map('n', '<tab>', '<Cmd>BufferNext<CR>', opts)
    map('n', '<s-tab>', '<Cmd>BufferPrevious<CR>', opts)
    map('n', '<leader>w', '<Cmd>BufferClose<CR>', opts)
end


--
-- nvim-tree
--
if has("nvim-tree") then
    vim.g.loaded_netrw = 1
    vim.g.loaded_netrwPlugin = 1
    require("nvim-tree").setup({
        view = {
            float = {
                enable = true,
                open_win_config = function() return {
                    relative = "editor",
                    border = "rounded",
                    width = 60,
                    height = vim.o.lines-3,
                    row = 0,
                    col = 0,
                } end,
            },
        },
        renderer = {
            full_name = true,
        },
        update_focused_file = {
            enable = true,
        },
        on_attach = function(bufnr)
            local function opts(desc)
                return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
            end
            local api = require "nvim-tree.api"
            api.config.mappings.default_on_attach(bufnr)
            vim.keymap.set('n', '?', api.tree.toggle_help, opts('Help'))
            vim.keymap.set('n', '<esc>', api.tree.close_in_this_tab, opts('Close'))
            vim.keymap.set('n', '<c-[>', api.tree.close_in_this_tab, opts('Close'))
        end,
    })
    vim.keymap.set("n", "<Leader>e", ":silent <cmd>NvimTreeFocus<cr>NvimTreeFindFile<cr>", { silent = true })

    -- Close Vim if the tree is the last window
    vim.api.nvim_create_autocmd("BufEnter", {
        group = vim.api.nvim_create_augroup("NvimTreeClose", {clear = true}),
        pattern = "NvimTree_*",
        callback = function()
            local layout = vim.api.nvim_call_function("winlayout", {})
            if layout[1] == "leaf" and vim.api.nvim_buf_get_option(vim.api.nvim_win_get_buf(layout[2]), "filetype") == "NvimTree" and layout[3] == nil then vim.cmd("confirm quit") end
        end
    })
end


--
-- Neovim LSP
--
vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(args)
        local client = vim.lsp.get_client_by_id(args.data.client_id)
        local buffer_number = args.buf
        local opts = { silent = true, buffer = buffer_number }
        vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
        vim.keymap.set({ "n", "i" }, "<c-_>", vim.lsp.buf.signature_help, opts)
        vim.keymap.set({ "n" }, "gd", vim.lsp.buf.definition, opts)
        vim.keymap.set({ "n" }, "gD", vim.lsp.buf.declaration, opts)
        vim.keymap.set({ "n" }, "gi", vim.lsp.buf.implementation, opts)
        vim.keymap.set({ "n" }, "fr", vim.lsp.buf.references, opts)
        vim.keymap.set({ "n" }, "fi", vim.lsp.buf.incoming_calls, opts)
        vim.keymap.set({ "n" }, "fo", vim.lsp.buf.outgoing_calls, opts)
        vim.keymap.set({ "n" }, "fs", vim.lsp.buf.document_symbol, opts)
        vim.keymap.set({ "n" }, "<leader>r", vim.lsp.buf.rename, opts)
        vim.keymap.set({ "n" }, "<leader>a", vim.lsp.buf.code_action, opts)
        vim.keymap.set({ "n" }, "<leader>lk", function()
            vim.lsp.stop_client(vim.lsp.get_active_clients())
        end, opts)
        vim.keymap.set({ "n" }, "<leader>lw", function()
            print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
        end, opts)
        setup_lsp_overloads(client, buffer_number)
    end,
})

vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = "rounded" })
vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, { border = "rounded" })

function setup_lsp_overloads(client, buffer_number)
    if not has('lsp-overloads') then return end
    if not client.server_capabilities.signatureHelpProvider then return end
    require('lsp-overloads').setup(client, {
        ui = {
            border = "rounded",
            focusable = false,
        },
        keymaps = {
            next_signature = "<c-n>",
            previous_signature = "<c-p>",
            next_parameter = "<c-l>",
            previous_parameter = "<c-h>",
            close_signature = "<c-k>"
        },
    })
    local opts = { silent = true, buffer = buffer_number }
    vim.keymap.set("n", "<c-k>", ":LspOverloadsSignature<CR>", opts)
    vim.keymap.set("i", "<c-k>", "<cmd>LspOverloadsSignature<CR>", opts)
end

if vim.fn.executable("OmniSharp") == 1 then
    vim.api.nvim_create_autocmd("FileType", {
        pattern = { "cs" },
        callback = function()
            vim.lsp.start({
                name = "omnisharp",
                cmd = { "OmniSharp", "-lsp" },
            })
        end,
    })
end

if vim.fn.executable("bash-language-server") == 1 then
    vim.api.nvim_create_autocmd("FileType", {
        pattern = { "sh", "bash" },
        callback = function()
            vim.lsp.start({
                name = "bash-language-server",
                cmd = { "bash-language-server", "start" },
            })
        end,
    })
end

if vim.fn.executable("serve-d") == 1 then
    vim.api.nvim_create_autocmd("FileType", {
        pattern = { "d" },
        callback = function()
            vim.lsp.start({
                name = "serve-d",
                cmd = { "serve-d" },
                -- cmd = { "serve-d", '--logfile', '/tmp/served.log', '--loglevel', 'all' },
                root_dir = vim.fs.dirname(vim.fs.find({'dub.json', 'dub.sdl', '.git'}, { upward = true })[1]),
            })
        end,
    })
end


--
-- cmp
--
if has("cmp") then
    local cmp = require("cmp")

    local completeopt = "menu,menuone,popup,noinsert"

    local preselect = cmp.PreselectMode.Item

    local window = {
        completion = {
            border = "rounded",
        },
        documentation = {
            border = "rounded",
        },
    }

    local mapping = {
        ['<c-space>'] = cmp.mapping(
            function(fallback)
                cmp.complete_common_string()
            end,
            { "i", "c" }
        ),
        ['<c-j>'] = cmp.mapping(
            function(fallback)
                if cmp.visible() then
                    cmp.select_next_item()
                else
                    cmp.complete_common_string()
                end
            end,
            { "i", "c" }
        ),
        ['<c-k>'] = cmp.mapping(
            function(fallback)
                if cmp.visible() then
                    cmp.select_prev_item()
                else
                    cmp.complete_common_string()
                end
            end,
            { "i", "c" }
        ),
        ['<cr>'] = cmp.mapping(
            function(fallback)
                if cmp.visible() and cmp.get_selected_entry() then
                    cmp.confirm()
                elseif cmp.visible() then
                    cmp.close()
                    fallback()
                else
                    fallback()
                end
            end,
            { "i", "c" }
        ),
        ['<c-[>'] = cmp.mapping(
            function(fallback)
                if cmp.visible() then
                    cmp.abort()
                    fallback()
                else
                    fallback()
                end
            end,
            { "i", "c" }
        ),
        ['<C-b>'] = cmp.mapping.scroll_docs(-4),
        ['<C-f>'] = cmp.mapping.scroll_docs(4),
    }

    local performance = {
    }

    cmp.setup({
        completeopt = completeopt,
        preselect = preselect,
        window = window,
        performance = performance,
        mapping = mapping,
        sources = cmp.config.sources({
            { name = 'nvim_lsp' },
            { name = 'vsnip' },
        }, {
            { name = 'nvim_lua' },
        }, {
            { name = 'buffer' },
        }),
        snippet = {
            expand = function(args)
                vim.fn["vsnip#anonymous"](args.body)
            end,
        },
    })

    cmp.setup.cmdline(':', {
        completeopt = completeopt,
        preselect = preselect,
        window = window,
        performance = performance,
        mapping = mapping,
        sources = cmp.config.sources({
            { name = 'cmdline' },
            { name = 'path', option = { trailing_slash = true } },
        }),
    })
end
