local actor, super = Class(Actor, "sign")

function actor:init()
    super.init(self)

    -- Width and height for this actor, used to determine its center
    self.width = 20
    self.height = 20

    -- Hitbox for this actor in the overworld (optional, uses width and height by default)
    self.hitbox = {2, 10, 16, 10}

    -- Whether this actor flips horizontally (optional, values are "right" or "left", indicating the flip direction)
    self.flip = nil

    -- Path to this actor's sprites (defaults to "")
    self.path = ""
    -- This actor's default sprite or animation, relative to the path (defaults to "")
    self.default = "sign"
end

return actor