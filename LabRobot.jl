using HorizonSideRobots
HSR=HorizonSideRobots

mutable struct Coordinates
    x::Int
    y::Int
end

mutable struct AbstractRobot 
    robot::Robot
    direct::HorizonSide
    coord::Coordinates
    right_c::Int
    left_c::Int
end

function around!(r)
    d = direction(r)
    while true
        if HSR.isborder(r,left)
            if !HSR.isborder(r,something)
                forward!(r)
            else
                count_turn!(r,right)
            end
        else
            count_turn!(r,left)
            forward!(r)
        end
        if is_start(r,d)
            break
        end
    end
end

function is_in_lab(r)
    if r.right_c<r.left_c
        print("YES")
    else
        print("NO")
    end
end

function direction(r)
    c = 0
    while !HSR.isborder(r, something) && !HSR.isborder(r, left)
        turn!(r, left)
    end
    return get_direct(r)
end

function forward!(robot) 
    move!(robot.robot, robot.direct)
    direction = get_direct(robot)
    HorizonSideRobots.move!(robot,direction)
end

function is_start(r,d) 
    return r.coord.x==r.coord.y==0 && get_direct(r)==d
end

function turn!(robot, direct)
    robot.direct = direct(robot.direct)
end

function count_turn!(robot,direct)
    if direct == left
        robot.left_c+=1
    elseif direct == right
        robot.right_c+=1
    end
    robot.direct = direct(robot.direct)
end

function HorizonSideRobots.move!(robot::AbstractRobot, side::HorizonSide)
    if side==Nord
        robot.coord.y += 1
    elseif side==Sud
        robot.coord.y -= 1
    elseif side==Ost
        robot.coord.x += 1
    else
        robot.coord.x -= 1
    end
end

HSR.isborder(robot,direct)=isborder(robot.robot,direct(robot.direct))

HSR.putmarker!(robot) = putmarker!(robot.robot)

HSR.ismarker(robot) = ismarker(robot.robot)

get_direct(robot::AbstractRobot) = robot.direct

get_coord(robot::AbstractRobot) = robot.coord

is_start(robot::AbstractRobot) = (robot.coord == Coordinates(0,0))

function inverse(side)
    if side == West
        return Ost
    elseif side == Sud
        return Nord
    elseif side == Ost
        return West
    else
        return Sud 
    end
end

function left(side)
    if side == Ost
        return Nord
    elseif side == Nord
        return West
    elseif side == West
        return Sud
    else
        return Ost
    end
end

function right(side)
    if side == Ost
        return Sud
    elseif side == Sud
        return West
    elseif side == West
        return Nord
    else 
        return Ost
    end
end
