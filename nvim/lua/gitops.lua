local telescope_pickers = require("telescope.pickers")
local telescope_finders = require("telescope.finders")
local telescope_config = require("telescope.config").values
local telescope_builtin = require("telescope.builtin")

local M = {}

local tabpage_data = {}
local next_file -- TODO move definition so I don't need a forward declaration
local previous_file -- TODO move definition so I don't need a forward declaration

-- workaround since TabClosed only provides tab number; does not work --
-- when the order changes, like https://github.com/neovim/neovim/issues/25844
-- but for tabs
local tab_number_to_tab_id = {}

vim.api.nvim_create_autocmd("TabClosed", {
    callback = function(args)
        local tab_id = assert(tab_number_to_tab_id[tonumber(args.file)])
        local tabdata = tabpage_data[tab_id]
        if not tabdata then
            return
        end

        for _, buffers in pairs(assert(tabdata.buffers)) do
            for _, buffer in pairs(buffers) do
                vim.api.nvim_buf_delete(buffer, {}) -- need to provide opts, suprisingly
            end
        end
        vim.api.nvim_buf_delete(tabdata.description_buffer, {})
        vim.api.nvim_buf_delete(tabdata.files_buffer, {})
        tabpage_data[tab_id] = nil
    end
})

-- returns a wait function
local system = function(...)
    local args = { ... }
    local system_object = vim.system(args, { text = true })
    return function()
        local result = system_object:wait(5000)
        assert(
            result.code == 0,
            string.format("error with command %s: %s", table.concat(args, " "), result.stderr)
        )
        return result.stdout
    end
end

-- wip
local find_commit_files = function(commit, opts)
    opts = opts or {}
    telescope_pickers.new(opts, {
        prompt_title = "Find Commit Files",
        finder = telescope_finders.new_oneshot_job({
            "git", "ls-tree", "-r", "--name-only", commit
        }, {}),
        sorter = telescope_config.file_sorter(opts),
        --[[
        attach_mappings = function(prompt_bufnr, map)
            telescope_actions.select_default:replace(function()
                telescope_actions.close(prompt_bufnr)
                vim.cmd("cd "
                    .. home_directory
                    .. "/"
                    .. telescope_action_state.get_selected_entry()[1]
                )
                telescope_builtin.find_files()
            end)
            return true
        end,
        ]]
    }):find()
end

-- returns the commit that added the current line, the path to the file it was
-- added on, and the original line number
local current_line_commit = function()
    local buffer_name = vim.api.nvim_buf_get_name(0)
    local file, revision = buffer_name:match("^([^:]+):([^:]+)$")
    file = file or buffer_name

    local current_line = tostring(vim.fn.line("."))
    local command = {
        "git",
        "blame",
        "-n",
        "-f",
        "-L" .. current_line .. "," .. current_line,
        revision
    }
    table.insert(command, file)

    local out = system(unpack(command))()
    return out:match("(%S+)%s+(%S+)%s+(%S+)")
end

-- all buffers that should have the special keymaps must be created by this function
local make_buffer_with_content = function(name, content, opts)
    opts = opts or {}

    local buffer = vim.api.nvim_create_buf(false, true)
    assert(buffer ~= 0)
    vim.api.nvim_buf_set_name(buffer, name)

    local lines
    if type(content) == "string" then
        lines = vim.split(content, "\n")
    elseif type(content) == "table" then
        lines = content
    else
        error("invalid type for content")
    end
    -- trailing newline does not mean a new line in the output, so remove it
    if lines[#lines] == "" then
        lines[#lines] = nil
    end
    vim.api.nvim_buf_set_lines(buffer, 0, -1, true, lines)

    if opts.filename then
        vim.bo[buffer].filetype = assert(vim.filetype.match({
            filename = opts.filename or name,
            contents = lines,
        }))
    end

    -- TODO make these keymaps customizable, probably in init.lua
    vim.keymap.set("n", "<C-n>", next_file, { buffer = buffer })
    vim.keymap.set("n", "<C-e>", previous_file, { buffer = buffer })

    return buffer
end

local make_buffer = function(path, content, revision)
    return make_buffer_with_content(path .. ":" .. revision, content, {
        set_filetype = true,
        filename = path,
    })
end

-- returns a wait function
local get_file_contents = function(revision, path)
    return system("git", "show", revision .. ":" .. path)
end

local get_tabpage_files = function(tabdata)
    return vim.api.nvim_buf_get_lines(vim.api.nvim_win_get_buf(tabdata.files_window), 0, -1, true)
end

local tabpage_go_to_file_at_index = function(tabdata, file_index)
    assert(type(file_index) == "number")

    local file = get_tabpage_files(tabdata)[file_index]
    assert(file)

    tabdata.current_file_index = file_index

    if tabdata.buffers[file] == nil then
        -- TODO make setting the content on the buffer async
        local before_contents_wait = get_file_contents(tabdata.before_revision, file)
        local after_contents_wait = get_file_contents(tabdata.after_revision, file)
        local before_buffer = make_buffer(file, before_contents_wait(), tabdata.before_revision)
        local after_buffer = make_buffer(file, after_contents_wait(), tabdata.after_revision)
        tabdata.buffers[file] = { before = before_buffer, after = after_buffer }
    end

    local buffers = tabdata.buffers[file]
    vim.api.nvim_win_call(tabdata.before_window, function()
        vim.cmd.diffoff()
        vim.api.nvim_win_set_buf(0, buffers.before)
        vim.cmd.diffthis()
    end)
    vim.api.nvim_win_call(tabdata.after_window, function()
        vim.cmd.diffoff()
        vim.api.nvim_win_set_buf(0, buffers.after)
        vim.cmd.diffthis()
    end)
end

-- TODO deduplicate next_file and previous_file
next_file = function(tabpage)
    assert(tabpage == nil or type(tabpage) == "number")
    tabpage = tabpage or 0
    if tabpage == 0 then
        tabpage = vim.api.nvim_get_current_tabpage()
    end

    local tabdata = assert(tabpage_data[tabpage])
    if tabdata.current_file_index < #get_tabpage_files(tabdata) then
        tabpage_go_to_file_at_index(tabdata, tabdata.current_file_index + 1)
    end
end

previous_file = function(tabpage)
    assert(tabpage == nil or type(tabpage) == "number")
    tabpage = tabpage or 0
    if tabpage == 0 then
        tabpage = vim.api.nvim_get_current_tabpage()
    end

    local tabdata = assert(tabpage_data[tabpage])
    if tabdata.current_file_index > 1 then
        tabpage_go_to_file_at_index(tabdata, tabdata.current_file_index - 1)
    end
end

-- goal: write a function that "checks out" a commit (come up with right word?)
-- I want to see the commit message and body, time, author, all that
-- and I want to see the diff in the form of the full file (not just the diff), in regular editor context
-- can use gitsigns.show(revision)
-- can use git show rev:path to get the plain file contents
-- opens a new tab page with the commit
M.show_commit = function(revision, path, line_number)
    local before_revision = revision .. "~"

    local commit_info = system("git", "show", "--name-only", revision)

    local files = {}
    local description
    do
        local description_string, files_string = commit_info():match("^(.*)\n\n(.*)$")
        description = description_string
        assert(description)
        assert(files_string)
        for file in files_string:gmatch("%S+") do
            table.insert(files, file)
        end
    end

    local current_file_index
    for index, file in ipairs(files) do
        if file == path then
            current_file_index = index
            break
        end
    end
    assert(current_file_index)

    local description_buffer = make_buffer_with_content(revision, description)
    local files_buffer = make_buffer_with_content("FILES", files) -- TODO adjust name
    vim.bo[description_buffer].filetype = "git"

    vim.cmd("tab sbuffer " .. description_buffer)
    local description_window = vim.api.nvim_get_current_win()
    local window_height = vim.api.nvim_win_get_height(0)
    local before_window = vim.api.nvim_open_win(0, true, {
        split = "below",
        height = window_height - math.min(
            math.max(vim.api.nvim_buf_line_count(description_buffer), vim.api.nvim_buf_line_count(files_buffer)) + 1
        , window_height / 3),
    })
    local after_window = vim.api.nvim_open_win(0, true, { split = "right" })

    vim.api.nvim_set_current_win(description_window)
    local files_window = vim.api.nvim_open_win(files_buffer, false, { split = "right" })
    vim.api.nvim_set_current_win(after_window)

    local tabdata = {
        description_buffer = description_window,
        files_window = files_window,
        before_window = before_window,
        after_window = after_window,
        description_buffer = description_buffer,
        files_buffer = files_buffer,
        current_file_index = current_file_index,
        after_revision = revision,
        before_revision = before_revision,
        -- files (strings) are keys, values are tables like { before: buffer_id, after: buffer_id }
        buffers = {},
    }
    local tab_id = vim.api.nvim_get_current_tabpage()
    tabpage_data[tab_id] = tabdata
    tab_number_to_tab_id[vim.fn.tabpagenr()] = tab_id

    tabpage_go_to_file_at_index(tabdata, current_file_index)

    --[=[
    local find_files = function()
        telescope_pickers.new(opts, {
            prompt_title = "Find Commit Files",
            finder = telescope_finders.new_table(files),
            sorter = telescope_config.file_sorter(opts),
            --[[
            attach_mappings = function(prompt_bufnr, map)
                telescope_actions.select_default:replace(function()
                    telescope_actions.close(prompt_bufnr)
                    vim.cmd("cd "
                    .. home_directory
                    .. "/"
                    .. telescope_action_state.get_selected_entry()[1]
                )
                telescope_builtin.find_files()
            end)
            return true
        end,
        }):find()
    end
    ]=]

    if line_number then
        vim.cmd("keepjumps normal! " .. line_number .. "gg")
    end
end

M.show_current_line_commit = function()
    local change_revision, path, line_number = current_line_commit()
    M.show_commit(change_revision, path, line_number)
end

return M
