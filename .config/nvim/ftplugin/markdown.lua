-- require("ascii-mermaid").setup()
vim.keymap.set("n", "<leader>mp", function()
  -- 1. Grab visual selection or current code block
  local bufnr = vim.api.nvim_get_current_buf()
  local cursor_row = vim.api.nvim_win_get_cursor(0)[1]
  local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)

  local in_mermaid = false
  local mermaid_code = {}

  for i, line in ipairs(lines) do
    if line:match("^```mermaid") and i <= cursor_row then
      in_mermaid = true
      mermaid_code = {}
    elseif in_mermaid and line:match("^```") then
      if i >= cursor_row then break end
      in_mermaid = false
    elseif in_mermaid then
      table.insert(mermaid_code, line)
    end
  end

  if #mermaid_code == 0 then
    vim.notify("Cursor is not inside a ```mermaid block", vim.log.levels.WARN)
    return
  end

  -- 2. Write to temp file and compile with mmdc
  local tmp_in = "/tmp/diagram.mmd"
  local tmp_out = "/tmp/diagram.png"
  local f = io.open(tmp_in, "w")
  f:write(table.concat(mermaid_code, "\n"))
  f:close()

  vim.fn.jobstart({ "mmdc", "-i", tmp_in, "-o", tmp_out, "-b", "transparent" }, {
    on_exit = function(_, code)
      if code == 0 then
        -- 3. Display preview using Snacks.image
        Snacks.image.open(tmp_out)
      else
        vim.notify("Mermaid compilation failed", vim.log.levels.ERROR)
      end
    end,
  })
end, { desc = "Preview Mermaid Diagram under cursor" })
