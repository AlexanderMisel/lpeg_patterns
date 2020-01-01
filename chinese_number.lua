re = require('re')

num_defs = {
  digits = {
    ['零'] = 0,  ['一'] = 1,  ['二'] = 2,  ['三'] = 3,  ['四'] = 4,
    ['五'] = 5,  ['六'] = 6,  ['七'] = 7,  ['八'] = 8,  ['九'] = 9
  },
  mults4 = { ['萬'] = 10000, ['億'] = 100000000, ['兆'] = 1e12, ['京'] = 1e16,
    ['垓'] = 1e20, ['秭'] = 1e24, ['穰'] = 1e28, ['溝'] = 1e32,
    ['澗'] = 1e36, ['正'] = 1e40, ['載'] = 1e44, ['極'] = 1e48 },
  sen   = function(v) return 1000 * v end,
  hyaku = function(v) return 100 * v end,
  juu   = function(v) return 10 * v end,
  add   = function (a, b) return a + b end,
  tmul   = function (a, b) return { a == '' and b or a*b, b, a } end,
  tadd  = function (a, b)
    local res = { 0, b[2], 0 }
    if a[2] > b[2] then
      res[1] = a[1] + b[1]
    elseif b[3] == '' then
      res[1] = a[1] * b[2]
    else
      res[1] = a[1] * b[2] + b[1]
    end
    return res
  end,
  elem1 = function (t) return t[1] end,
  one   = function () return 1 end,
  minus = function (v) return -v end
}

num = re.compile([[
  int_num     <- (zero -> digits / '負' pos_num -> minus / pos_num) !.
  pos_num     <- (digit_group+ ~> tadd -> elem1 small_num? / small_num) ~> add
  digit_group <- ((small_num / {''}) mult4) ~> tmul
  small_num   <- zero? four_digit ~> add
  four_digit  <- start_digit -> sen   '千' (zero two_digit / three_digit)? / three_digit
  three_digit <- start_digit -> hyaku '百' (zero one_digit / two_digit)? / two_digit
  two_digit   <- start_digit -> juu   '十' one_digit? / one_digit
  one_digit   <- nonzero
  zero        <- '零'
  start_digit <- nonzero / '' -> one
  mult4       <- ('萬'/'億'/'兆'/'京'/'垓'/'秭'/'穰'/'溝'/'澗'/'正'/'載'/'極') -> mults4
  nonzero     <- ('一'/'二'/'三'/'四'/'五'/'六'/'七'/'八'/'九') -> digits
]], num_defs)
