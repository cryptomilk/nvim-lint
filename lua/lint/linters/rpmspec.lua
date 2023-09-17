local parsers = {
  -- errors
  require('lint.parser').from_pattern(
    [[(%w+): (.*): line (%d+): (.*)]],
    { 'severity', 'file', 'lnum', 'message' },
    nil,
    { ['severity'] = vim.diagnostic.severity.ERROR, ['source'] = 'rpmspec' }
  ),

  -- warnings
  require('lint.parser').from_pattern(
    [[(%w+): (.*) in line (%d+):]],
    { 'severity', 'message', 'lnum' },
    nil,
    { ['severity'] = vim.diagnostic.severity.WARNING, ['source'] = 'rpmspec' }
  ),
}

return {
  cmd = 'rpmspec',
  stdin = false,
  args = { '-P' },
  append_fname = true,
  ignore_exitcode = true,
  stream = 'stderr',
  parser = function(output, bufnr)
    local diagnostics = {}
    for _, parser in ipairs(parsers) do
      local result = parser(output, bufnr)
      for _, diagnostic in ipairs(result) do
        table.insert(diagnostics, diagnostic)
      end
    end

    return diagnostics
  end,
}
