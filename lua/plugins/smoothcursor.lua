require("smoothcursor").setup({
      autostart = true,
      cursor = "", -- Customize the cursor icon
      linehl = nil, -- Highlight current line (optional)
      speed = 25, -- Animation speed; adjust as desired
      fancy = {
        enable = true,
        head = { cursor = "", texthl = "SmoothCursor" },
        body = {
          { cursor = "", texthl = "SmoothCursorRed" },
          { cursor = "", texthl = "SmoothCursorOrange" },
          { cursor = "●", texthl = "SmoothCursorYellow" },
        },
      },
    })
