local core = require("core")
local config = require("cp-image.static").config

local get_image_info = function(full_path)
	local dir_path = string.match(full_path, "^([%s%S]*)/[^.^/]+.[^.^/]+$")
	local image_type = string.match(full_path, "^[%s%S]*/[^.^/]+.([^.^/]+)$")
	local file_name = string.match(full_path, "^[%s%S]*/([^.^/]+).[^.^/]+$")
	return {
		dir_path = dir_path,
		image_type = image_type,
		file_name = file_name,
	}
end

local generate_image = function(cmd, full_path)
	local image_info = get_image_info(full_path)
	if not core.file.file_or_dir_exists(image_info.dir_path) then
		core.file.mkdir(image_info.dir_path)
	end
	vim.cmd(string.format("!" .. cmd(full_path, image_info.image_type)))
	vim.notify("paste image to " .. full_path, vim.log.levels.INFO)
end

return {
	get_image_info = get_image_info,
	generate_image = generate_image,
}
