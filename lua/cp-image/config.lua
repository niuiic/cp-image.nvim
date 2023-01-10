local config = {
	cmd = function(path, image_type)
		return string.format("xclip -selection clipboard -t image/%s -o > %s", image_type, path)
	end,
	---@diagnostic disable-next-line:unused-local
	text = function(relative_path, file_name, file_type, full_path)
		return string.format("![%s](%s)", file_name, relative_path)
	end,
	path = function(project_root)
		return project_root
	end,
	root_pattern = ".git",
}

return config
