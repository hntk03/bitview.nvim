local bit = require("bit")

local M = {}

local popup_win = nil

function M.open()
  if popup_win and vim.api.nvim_win_is_valid(popup_win) then
    vim.api.nvim_win_close(popup_win, true)
    popup_win = nil
    return
  end

  local word = vim.fn.expand("<cword>")
  if not string.match(word, "^0[xX][A-Fa-f0-9]+$") then
    print("This word is not hex")
    return
  end

  local hex = string.sub(word, 3)
  local num = tonumber(hex, 16)

  local bits = {}
  repeat
    table.insert(bits, 1, bit.band(num, 1))
    num = bit.rshift(num, 1)
  until num == 0

  local index = {}
  local bitsDisp = {}
  local dispFormat = "%" .. #tostring(#bits - 1) .. "d"
  for i, value in ipairs(bits) do
    local idx = #bits - i

    table.insert(index, string.format(dispFormat, idx))
    table.insert(bitsDisp, string.format(dispFormat, value))
  end

  local indexStr = table.concat(index, " ")
  local bitsStr = table.concat(bitsDisp, " ")

  local buf = vim.api.nvim_create_buf(false, true)

  local labelFormat = "%-8s"
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, {
    string.format(labelFormat, "bitidx") .. indexStr,
    string.format(labelFormat, "bits") .. bitsStr,
    string.format(labelFormat, "hex") .. hex,
  })

  popup_win = vim.api.nvim_open_win(buf, false, {
    relative = "cursor",
    row = 1,
    col = -1,
    width = 60,
    height = 3,
    style = "minimal",
    border = "rounded",
  })
end
return M
