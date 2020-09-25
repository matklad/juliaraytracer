module Geom

export Point, Vec, ×, ⋅, norm, normalize, Ray, along

struct Point
    x::Float64
    y::Float64
    z::Float64
end

struct Vec
    x::Float64
    y::Float64
    z::Float64
end

Base.:-(v::Vec) = Vec(-v.x, -v.y, -v.z)

for op = (:+, :-)
    @eval begin
        Base.$op(v1::Vec, v2::Vec)::Vec =
            Vec($op(v1.x, v2.x), $op(v1.y, v2.y), $op(v1.z, v2.z))
    end
end

for op = (:*, :/)
    @eval begin
        Base.$op(v::Vec, s::Real) =
            Vec($op(v.x, s), $op(v.y, s), $op(v.z, s))

        Base.$op(s::Real, v::Vec) = $op(v, s)
    end
end

⋅(v1::Vec, v2::Vec) = v1.x * v2.x + v1.y * v2.y + v1.z * v2.z
×(v1::Vec, v2::Vec) = Vec(
    v1.y * v2.z - v1.z * v2.y,
    -(v1.x * v2.z - v1.z * v2.x),
    v1.x * v2.y - v1.y * v2.x
)
norm(v::Vec) = sqrt(v ⋅ v)
normalize(v::Vec) = v / norm(v)

tovec(p::Point) = Vec(p.x, p.y, p.z)
fromvec(v::Vec) = Point(v.x, v.y, v.z)

Base.:-(p1::Point, p2::Point)::Vec = tovec(p1) - tovec(p2)

for op = (:+, :-)
    @eval begin
        Base.$op(p::Point, v::Vec) = $op(tovec(p), v) |> fromvec
    end
end

struct Ray
    origin::Point
    direction::Vec

    Ray(;from::Point, to::Point) = new(from, normalize(to - from))
end

along(r::Ray, t::Real) = r.origin + t*r.direction

end
