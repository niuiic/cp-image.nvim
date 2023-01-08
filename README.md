# cp-image.nvim

Paste the image from the clipboard and insert the reference code.

## Usage

1. Take a screenshot or copy a image.
2. Run `:PasteImage`.
3. Input full path.
4. Confirm.
5. Done.

<img src="https://github.com/niuiic/assets/blob/main/cp-image.nvim/usage.gif" />

# Config

```lua
require("cp-image").setup(
	-- default config
	{
		-- how to generate the image from clipboard and place it
		-- image_type is the suffix of file name
		cmd = function(path, image_type)
			return string.format("xclip -selection clipboard -t image/%s -o > %s", image_type, path)
		end,
		---@diagnostic disable-next-line:unused-local
		-- text to insert
		-- relative_path is relative to the root path of the project
		text = function(relative_path, file_name, full_path)
			return string.format("![%s](%s)", file_name, relative_path)
		end,
		-- default directory path to store image
		path = function(project_root)
			return project_root
		end,
		-- used to search root path of the project
		-- if .git does not exist, current directory path would be used
		root_pattern = ".git",
	}
)
```
