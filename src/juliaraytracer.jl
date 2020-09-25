include("geom.jl")
include("shape.jl")
include("scene.jl")
include("ppm.jl")
include("rt.jl")

using .Geom, .Scene, .Shape, .Ppm, .Rt

function clamp(v::Float64)::UInt8
    round(max(0.0, min(v, 1.0)) * 255)
end

function tocolor(v::Vec)::Color
    Color(clamp(v.x), clamp(v.y), clamp(v.z))
end

function main()
    camera = Camera(
        position=Point(0, 0, -800),
        look_at=Point(0, 0, 0),
        focus_distance=800,
        up=Vec(0, 1, 0),
        size=(640,480)
    )

    item1 = Item(Sphere(Point(-40, 0, -40), 100), Vec(.80, .800, .250))
    item2 = Item(Sphere(Point(40, 0, 40), 100), Vec(.80, .100, .250))

    vim = fill(Vec(0.8, 0.5, 0), (800, 600))
    render!(vim, camera, [item1, item2])

    im = Image(Color(20, 20, 200), 800, 600)

    for i in eachindex(vim)
        im[i] = tocolor(vim[i])
    end

    show(stdout, MIME"image/ppm"(), im)
end


main()
