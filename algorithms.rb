def calc(_t, pos, neg, p, s, ch)
  _p = nil
  n = nil
  q = nil
  r = nil

  h = []
  iter = 0

  posprint = ""
  negprint = ""
  chprint = ""

  if _t.zero?
    puts("Тип машины (T) = конъюнкция")

    _p = pos
    n = neg
  else
    puts("Тип машины (T) = дизъюнкция")

    _p = neg
    n = pos
  end

  pos.each do |el|
    posprint += "\t #{print_arr(el)} \n"
  end

  neg.each do |el|
    negprint += "\t #{print_arr(el)} \n"
  end

  ch.each do |el|
    chprint += "\t #{print_arr(el)} \n"
  end

  puts("Размер штрафа (p) = #{p}")
  puts("Точка остановки (s) = #{s}")
  puts("Положительные наблюдения(P) = [\n #{posprint}]")
  puts("Отрицательные наблюдения(N) = [\n #{negprint}]")
  puts("Характеристики (H) = [\n #{chprint}]")

  q = ch.map { |el| get_covered_error(el, n)[:cover] }
  r = ch.map { |el| get_covered_error(el, _p)[:error] }

  loop do
    k_key = -1
    mx = -1
    iter += 1

    if ch.length == 0
      str = "Не удалось найти лучшую характеристику, все характеристики закончились"

      puts(str)

      return str
    end

    ch.each_with_index do |el, i|
      num = q[i].length - p * r[i].length

      if num > mx
        mx = num
        k_key = i
      end
    end

    h.push(ch[k_key])

    for i in 0..n.length - 1 do
      for j in 0..q[k_key].length - 1 do
        n.slice!(i, 1) if n[i] == q[k_key][j]
      end
    end

    for i in 0.._p.length - 1 do
      for j in 0..r[k_key].length - 1 do
        _p.slice!(i, 1) if _p[i] == r[k_key][j]
      end
    end

    for i in 0..q.length - 1 do
      for j in 0..q[i].length - 1 do
        for k in 0..q[k_key].length - 1 do
          q[i].slice!(j, 1) if q[i][j] == q[k_key][k]
        end
      end
    end

    for i in 0..r.length - 1 do
      for j in 0..r[i].length - 1 do
        for k in 0..r[k_key].length - 1 do
          r[i].slice!(j, 1) if r[i][j] == r[k_key][k]
        end
      end
    end

    ch.slice!(k_key, 1)

    if n.length == 0 || h.length == S
      str = "Лучшая характеристика: \n"

      h.each do |el|
        str += "\t #{print_arr(el)} \n"
      end

      puts(str)
      return str
    end

    if iter > 1000
      puts("STOP. ")
      return
    end
  end
end

def get_covered_error(arrs, states)
  cover = []
  error = []

  states.each do |state|
    suc = true

    for i in 0..arrs.length - 1 do
      next if arrs[i].nil?

      if arrs[i] != state[i]
        suc = false
        break
      end
    end

    suc ? cover.push(state) : error.push(state)
  end

  {
    cover: cover,
    error: error
  }
end

def print_arr(arr)
  str = arr.join(',')
  str2 = ''

  str2 += '_' if arr[0].nil?

  for j in 0..str.length - 2 do
    if str[j] == str[j + 1] && str[j] == ','
      str2 += str[j] + '_'
    else
      str2 += str[j]
    end
  end

  if str[str.length - 1] == ','
    str2 += ',_'
  else
    str2 += str[str.length - 1]
  end

  str2
end

def convert_text_to_array(text)
  text_arr = text.split(";")

  text_arr = text_arr.map { |el| el.split(",") }

  text_arr.each do |row|
    row.each_with_index do |_el, i|
      row[i] = nil if row[i] == '-'
    end
  end

  text_arr
end
