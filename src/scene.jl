module Scene

import ..Geom: Point, Vec, Ray, along, normalize, ×

export Camera, castray

struct Camera
    screen_center::Point
    basis::Tuple{Vec, Vec}
    position::Point

    function Camera(;position::Point, look_at::Point, focus_distance::Real, up::Vec, size)
        ray_to_screen = Ray(from=position, to=look_at)
        screen_center = along(ray_to_screen, focus_distance)

        right = ray_to_screen.direction × up |> normalize
        up = right × ray_to_screen.direction |> normalize
        basis = (right * size[1] / 2, -up * size[2] / 2)

        new(screen_center, basis, position)
    end
end

function castray(c::Camera, (x,y))
    target = c.screen_center + c.basis[1]*x + c.basis[2]*y
    Ray(from=c.position, to=target)
end

end
