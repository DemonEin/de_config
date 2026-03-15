local M = {}

local system = function(...)
    local system_object = vim.system({ ... }, { text = true })
    return function()
        local result = system_object:wait(5000)
        assert(result.code == 0, result.stderr)
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
    local current_line = tostring(vim.fn.line("."))
    local out = system("git",
        "blame",
        "-n",
        "-f",
        "-L" .. current_line .. "," .. current_line,
        vim.api.nvim_buf_get_name(0)
    )()
    return out:match("(%S+)%s+(%S+)%s+(%S+)")
end

local make_buffer_with_content = function(name, content, opts)
    opts = opts or {}

    local buffer = vim.api.nvim_create_buf(false, true)
    assert(buffer ~= 0)
    vim.api.nvim_buf_set_name(buffer, name)
    local bo = vim.bo[buffer]
    bo.bufhidden = "delete"

    local lines = vim.split(content, "\n")
    -- trailing newline does not mean a new line in the output, so remove it
    if lines[#lines] == "" then

        lines[#lines] = nil
    end
    vim.api.nvim_buf_set_lines(buffer, 0, -1, true, lines)

    if opts.filename then
        bo.filetype = assert(vim.filetype.match({
            filename = opts.filename or name,
            contents = lines,
        }))
    end

    return buffer
end

-- goal: write a function that "checks out" a commit (come up with right word?)
-- I want to see the commit message and body, time, author, all that
-- and I want to see the diff in the form of the full file (not just the diff), in regular editor context
-- can use gitsigns.show(revision)
-- can use git show rev:path to get the plain file contents
M.show_commit = function(revision, path, line_number)
    local get_file_contents = function(revision)
        return system("git", "show", revision .. ":" .. path)
    end

    local before_revision = revision .. "~"

    local before = get_file_contents(before_revision)
    local after = get_file_contents(revision)
    local description = system("git", "show", "--no-patch", revision)()

    before = before()
    after = after()

    local make_buffer = function(content, revision)
        return make_buffer_with_content(revision .. ":" .. path, content, {
            set_filetype = true,
            filename = path,
        })
    end

    local before_buffer = make_buffer(before, before_revision)
    local after_buffer = make_buffer(after, revision)
    local description_buffer = make_buffer_with_content(revision, description)
    vim.bo[description_buffer].filetype = "git"

    vim.cmd("tab sbuffer " .. description_buffer)
    local window_height = vim.api.nvim_win_get_height(0)
    vim.api.nvim_open_win(before_buffer, true, {
        split = "below",
        height = window_height - math.min(vim.api.nvim_buf_line_count(description_buffer), window_height / 3),
    })
    vim.cmd.diffthis()
    vim.api.nvim_open_win(after_buffer, true, { split = "right" })
    vim.cmd.diffthis()

    if line_number then
        vim.cmd("keepjumps normal! " .. line_number .. "gg")
    end
end

M.show_current_line_commit = function()
    local revision, path, line_number = current_line_commit()
    M.show_commit(revision, path, line_number)
end

return M
