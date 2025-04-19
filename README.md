# Pinned.nvim

Plugin that allows you to yank text and send it to a separate pinned  buffer.

Use case:
- editing a function and you want to have its' previous version in front of
  your eyes
- editing a piece of text and you need context, but you don't want to switch to
  it too often

## Usage:

`require('pinned').show()` will display the pinned window. If you call it from
visual mode for the first time, it will also copy the selected text to the
internal buffer. `require('pinned').yank` works in visual mode, it copies the
selected text to the internal buffer.

Recommended keymaps:

```lua
vim.keymap.set("v", "<leader>rs", "<cmd>lua require('pinned').show()<cr>")
vim.keymap.set("v", "<leader>ry", "<cmd>lua require('pinned').yank()<cr>")
vim.keymap.set("n", "<leader>rs", "<cmd>lua require('pinned').show()<cr>")
```



