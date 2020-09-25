module Ppm

export Color, Image, blank

struct Color
    r::UInt8
    g::UInt8
    b::UInt8
end

struct Image <: AbstractMatrix{Color}
    data::Array{Color, 2}

    Image(color::Color, width, height) =
        new(fill(color, (width, height)))
end

Base.size(im::Image) = size(im.data)
Base.getindex(im::Image, i::Int) = im.data[i]
Base.getindex(im::Image, I::Vararg{Int, 2}) = im.data[I]
Base.setindex!(im::Image, v, i::Int) = im.data[i] = v
Base.setindex!(im::Image, v, I::Vararg{Int, 2}) = im.data[I] = v

const PPM = MIME"image/ppm"

function Base.show(io::IO, ::PPM, im::Image)
    (width, height) = size(im)
    print(io, "P3\n$width $height\n255\n")
    for row in eachcol(im.data)
        for color in row
            show(io, PPM(), color)
            print(io, " ")
        end
        print(io, "\n")
    end
end

Base.show(io::IO, ::PPM, color::Color) =
    print(io, "$(color.r) $(color.g) $(color.b)")

end
