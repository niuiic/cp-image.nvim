local cp_image = require("cp-image")

vim.api.nvim_create_user_command("PasteImage", function()
	cp_image.paste_image()
end, {})
