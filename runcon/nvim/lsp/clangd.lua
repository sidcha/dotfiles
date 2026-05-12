-- Walk up from the current buffer to find a build/ directory containing
-- compile_commands.json; clangd is told to look there.
local function find_compile_commands_dir()
  local fname = vim.api.nvim_buf_get_name(0)
  local start = (fname ~= '' and vim.fs.dirname(fname)) or vim.uv.cwd()
  local root = vim.fs.root(start, function(_, path)
    return vim.uv.fs_stat(vim.fs.joinpath(path, 'build', 'compile_commands.json')) ~= nil
  end)
  return root and vim.fs.joinpath(root, 'build') or nil
end

return {
  cmd = function()
    local cmd = {
      'clangd',
      '--background-index',
      '--clang-tidy',
      '--header-insertion=iwyu',
      '--completion-style=detailed',
      '--function-arg-placeholders',
      '--fallback-style=llvm',
    }
    local dir = find_compile_commands_dir()
    if dir then
      table.insert(cmd, '--compile-commands-dir=' .. dir)
    end
    return cmd
  end,
  filetypes = { 'c', 'cpp', 'objc', 'objcpp', 'cuda' },
  root_markers = { 'compile_commands.json', 'compile_flags.txt', '.clangd', '.git' },
  init_options = {
    clangdFileStatus = true,
    usePlaceholders = true,
    completeUnimported = true,
    semanticHighlighting = true,
  },
}
