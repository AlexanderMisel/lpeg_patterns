re = require('re')

arr_int = { 7, 9, 10, 5, 8, 4, 2, 1, 6, 3, 7, 9, 10, 5, 8, 4, 2 }
arr_ch = { '0', 'X', '9', '8', '7', '6', '5', '4', '3', '2', '1' }

defs = {
  parity = function(_, pos, p1, p2)
    local tbl = { p1:byte(1, 17) }
    local total = 0
    for i = 1, 17 do
      total = total + arr_int[i] * (tbl[i] - 48)
    end
    return arr_ch[total % 11] == p2
  end
}

idcard = re.compile([[
  idcard <- ({ prov %d^4 date %d^3 } { [0-9] / 'X' }) => parity !.
  prov   <- '1' [1-5] / '2' [1-3] / '3' [1-7] / '4' [1-6]
            / '5' [1-4] / '6' [1-5]
  date   <- year month day
  year   <- ('19' / '20') %d^2
  month  <- '0' [1-9] / '1' [0-2]
  day    <- '0' [1-9] / [12] %d / '3' [01]
]], defs)
