local lib = require("cp-image.lib")
local config = require("cp-image.config")

local setup = function(new_config)
	config = vim.tbl_deep_extend("force", config, new_config or {})
end

local paste_image = function()
	local root_path = lib.find_root_path(config.root_pattern)
	local default_path = config.path(root_path)
	vim.ui.input({ prompt = "Image path: ", default = default_path }, function(input)
		if input == nil or input == default_path then
			return
		end
		local image_info = lib.get_image_info(input)
		if image_info.dir_path == nil or image_info.file_name == nil or image_info.image_type == nil then
			vim.notify("wrong path", vim.log.levels.ERROR)
			return
		end
		if string.find(input, root_path) == nil then
			vim.notify("wrong path", vim.log.levels.ERROR)
			return
		end
		lib.generate_image(config.cmd, input)
		local relative_path = string.sub(input, string.len(root_path) + 1)
		lib.insert_text(config.text(relative_path, image_info.file_name, input))
	end)
end

return {
	paste_image = paste_image,
	setup = setup,
}
