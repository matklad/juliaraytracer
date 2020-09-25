module Rt

import ..Shape: AbstractShape, intersect, normalat
import ..Scene: Camera, castray
import ..Geom: along, Vec, ⋅

export render!, Item

struct Item
    shape::AbstractShape
    color::Vec
end

function render!(im::Matrix{Vec}, camera::Camera, items::Vector{Item})
    for i in CartesianIndices(im)
        ray = castray(camera, relcord(im, i))

        res = nothing
        for item in items
            t = intersect(item.shape, ray)
            isnothing(t) && continue
            if isnothing(res) || t < res[1]
                res = (t, item)
            end
        end

        isnothing(res) && continue

        (t, item) = res
        point = along(ray, t)
        normal = normalat(item.shape, point)

        diffuse = max(ray.direction ⋅ -normal, 0.0)
        @assert 0.0 <= diffuse <= 1.0

        im[i] = item.color * diffuse
    end
end


function normalize(x, dim)::Float64
    @assert 0 <= x <= dim
    halfdim = dim / 2
    res = (x - halfdim) / halfdim
    @assert -1 <= res <= 1
    res
end

function relcord(im::Matrix{Vec}, i)::Tuple{Float64, Float64}
    (width, height) = size(im)
    (x, y) = Tuple(i)
    (normalize(x, width), normalize(y, height))
end


end
