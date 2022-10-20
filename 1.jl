using HorizonSideRobots

"Для каждой стороны света задаём единичный вектор (ось `y` направлена на юг.)"
D = [[0, -1], [-1, 0], [0, 1], [1, 0]]

"""
    `stumble(r, d)`
 — проверяет наличие препятствия в направлении `d`, в случае
отсутствия передвигает `r` и возвращает `true`, в обратном `false`.
"""
stumble(r, d) = !isborder(r, d) && (move!(r, d); true)

"""
    `dash(r, d[, n][, paint])`
 — заставить `r` *нестись* в заданном направлении `d`, пока тот не встретит
преграду и, если `n` задано, кол.-во шагов ≤ `n`. Если `paint = true`, ставит
на пути маркеры. Возвращает количество сделанных шагов.
"""
function dash(r::Robot, d::HorizonSide, n=Nothing; paint::Bool=false)::Int
	i = 0
	while n == Nothing || i < n
		i += Int((paint && putmarker!(r); stumble(r, d)) || break;)
	end
	return i
end

function go(r, p::Vector{Int})::Vector{Int}
	return [dash(r, p[1] ≥ 0 ? Ost : West, abs(p[1])) * sign(p[1]),
	        dash(r, p[2] ≥ 0 ? Sud : Nord, abs(p[2])) * sign(p[2])]
end

"Крест."
function cross(r::Robot)::Nothing
	p = [0, 0]
	for i = 1:4
		p += D[i] .* dash(r, HorizonSide(i-1), paint=true)
		p += go(r, [0, 0] - p)
	end
end

"Рамка."
function border(r::Robot)
	p = [0, 0]
	p[1] += dash(r, Ost)
	p[2] += dash(r, Sud)
	for i = 1:4
		dash(r, HorizonSide(i-1), paint=true)
	end
	go(r, [0, 0] - p)
end

"Заполнение всех клеток."
function fill(r::Robot)
	p = [0, 0]
	i = 1
	p[1] -= dash(r, West)
	p[2] -= dash(r, Nord)
	while true
		p += [dash(r, i%2==1 ? Ost : West, paint=true), (stumble(r, Sud) || break;)]
		i += 1
	end
end

"Лесенка."
function stairs(r::Robot)
	p = [0, 0]
	n = 0
	p += [dash(r, Ost), dash(r, Sud)]
	while true
		p += [-dash(r, West, paint=true), 0]
		p += [dash(r, Ost) - dash(r, West, n+=1), (-stumble(r, Nord)≠0 || break)]
		println(p)
	end
	go(r, [0, 0] - p)
end
