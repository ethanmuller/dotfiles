-- local shim = {}

-- print("running shim")

-- shim.setup = function()
-- 	local mason_registry = require("mason-registry")
-- 	local vue_language_server_path = mason_registry.get_package("vue-language-server"):get_install_path()
-- 		.. "/node_modules/@vue/language-server"

-- 	local lspconfig = require("lspconfig")

-- 	lspconfig.tsserver.setup({
-- 		init_options = {
-- 			plugins = {
-- 				{
-- 					name = "@vue/typescript-plugin",
-- 					location = vue_language_server_path,
-- 					languages = { "vue" },
-- 				},
-- 			},
-- 		},
-- 		filetypes = { "typescript", "javascript", "javascriptreact", "typescriptreact", "vue" },
-- 	})

-- 	lspconfig.volar.setup({})
-- end

-- return shim
