module Shape

import ..Geom: Point, Ray, (⋅), Vec, normalize

export Sphere, intersect

function intersect
end

function normalat
end

abstract type AbstractShape end

struct Sphere <: AbstractShape
    center::Point
    radius::Float64
end

function intersect(s::Sphere, ray::Ray)::Union{Float64, Nothing}
    o = ray.origin - s.center
    k = ray.direction ⋅ o
    c = o ⋅ o - s.radius * s.radius

    D = k*k - c
    D >= 0 || return nothing

    t1 = -k - √D
    t1 > 0 && return t1

    t2 = -k + √D
    t2 > 0 && return t2

    nothing
end

normalat(s::Sphere, p::Point)::Vec =
    p - s.center |> normalize

end
