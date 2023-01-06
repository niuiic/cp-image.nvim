local lib = require("cp-image.lib")

local config = {
	cmd = function(path, image_type)
		return string.format("xclip -selection clipboard -t image/%s -o > %s", image_type, path)
	end,
	---@diagnostic disable-next-line:unused-local
	text = function(relative_path, file_name, full_path)
		return string.format("![%s](%s)", file_name, relative_path)
	end,
	prefix = "",
	root_pattern = ".git",
}

local setup = function(new_config)
	config = vim.tbl_deep_extend("force", config, new_config or {})
end

local paste_image = function()
	local root_path = lib.find_root_path(config.root_pattern)
	vim.ui.input({ prompt = "Path to image", default = root_path .. config.prefix }, function(input)
		if input == nil then
			vim.notify("wrong path", vim.log.levels.ERROR)
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
