local M = {}

function M.setup()
    local opts = function ()
        local metals_config = require("metals").bare_config()

        metals_config.settings = {
          showImplicitArguments = true,
          excludedPackages = { "akka.actor.typed.javadsl", "com.github.swagger.akka.javadsl", "codegen.templates" },
          inlayHints = {
               hintsInPatternMatch = { enable = false },
               implicitArguments = { enable = false },
               implicitConversions = { enable = false },
               inferredTypes = { enable = false },
               typeParameters = { enable = false },
            }
        }

        metals_config.init_options.statusBarProvider = "off"
        local Path = require("plenary.path")
        metals_config.find_root_dir = function(patterns, startpath)
            local root_dir = nil
            local path = Path:new(startpath)
            for _, parent in ipairs(path:parents()) do
                for _, pattern in ipairs(patterns) do
                    local target = Path:new(parent, pattern)
                    if target:exists() then
                        root_dir = parent
                    end
                end
            end
            return root_dir
        end

        metals_config.capabilities = require("cmp_nvim_lsp").default_capabilities()

        metals_config.on_attach = function(client, bufnr)
            require("metals").setup_dap()
            local commons = require("commons")
            commons.common_bindings(bufnr, {noremap = true, silent = false})
        end
        -- metals_config.settings = {
        --   testUserInterface = "Test Explorer",
        -- }

        vim.opt_global.completeopt = { "menuone", "noinsert", "noselect" }

        return metals_config
    end

    local nvim_metals_group = vim.api.nvim_create_augroup("nvim-metals", {clear = true})
    local file_pattern = {"scala", "sbt"}
    if (vim.env.COMET_DEV ~= nil) then
        file_pattern[3] = "java"
    end
    vim.api.nvim_create_autocmd("FileType", {
        pattern = file_pattern,
        callback = function()
            require("metals").initialize_or_attach(opts())
        end,
        group = nvim_metals_group,
    })

    local dap = require("dap")
    -- local dapui = require("dapui")
    dap.configurations.scala = {
      {
        type = "scala",
        request = "attach",
        name = "Debug Comet",
        hostName = "localhost",
        port = 5005,
        buildTarget = "comet-spark-spark3.5_2.12",
      }
    }

    -- dap.listeners.after.event_initialized["metals"] = function()
    --   dapui.open()
    -- end
    -- dap.listeners.before.event_terminated["metals"] = function()
    --   dapui.close()
    -- end
    -- dap.listeners.before.event_exited["metals"] = function()
    --   dapui.close()
    -- end
    -- 
    -- dapui.setup()
end

return M
