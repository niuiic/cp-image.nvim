local file_or_dir_exists = function(path)
	local file = io.open(path, "r")
	if file ~= nil then
		io.close(file)
		return true
	else
		return false
	end
end

local getPrevLevelPath = function(currentPath)
	local tmp = string.reverse(currentPath)
	local _, i = string.find(tmp, "/")
	return string.sub(currentPath, 1, string.len(currentPath) - i)
end

local find_root_path = function(pattern)
	pattern = pattern or ".git"
	local path = vim.fn.getcwd(-1, -1) .. "/"
	local pathBp = path
	while path ~= "" do
		local file, _ = io.open(path .. pattern)
		if file ~= nil then
			return path
		else
			path = getPrevLevelPath(path)
		end
	end
	return pathBp
end

local insert_text = function(content)
	local pos = vim.api.nvim_win_get_cursor(0)[2]
	local line = vim.api.nvim_get_current_line()
	local new_line = line:sub(0, pos) .. content .. line:sub(pos + 1)
	vim.api.nvim_set_current_line(new_line)
end

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
	if file_or_dir_exists(image_info.dir_path) ~= true then
		vim.cmd("!mkdir -p " .. image_info.dir_path)
	end
	vim.cmd(string.format("!" .. cmd(full_path, image_info.image_type)))
	vim.notify("paste image to " .. full_path, vim.log.levels.INFO)
end

return {
	insert_text = insert_text,
	get_image_info = get_image_info,
	generate_image = generate_image,
	find_root_path = find_root_path,
}
