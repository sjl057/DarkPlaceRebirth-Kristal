---@class PaletteFX : FXBase
---@field base_pal number[][]
---@field live_pal number[][]
---@overload fun(imagedata:love.ImageData|string|Actor, line:integer, transformed:boolean?, priority:number?)
---@overload fun(base_pal:number[][], live_pal:number[][], transformed:boolean?, priority:number?)
local PaletteFX, super = Class(FXBase)

-- Should always be the same as the value in palette.glsl
PaletteFX.MAX_PALETTE_ENTRIES = 16

---@param imagedata love.ImageData|string|Actor
---@param line integer
---@overload fun(self:PaletteFX, base_pal: number[][], live_pal:number[][], transformed, priority)
function PaletteFX:init(imagedata, line, transformed, priority)
    super.init(self, priority or 0)

    self.shader = Assets.getShader("palette")

    if isClass(imagedata) and imagedata.includes and imagedata:includes(Actor) then
        ---@cast imagedata Actor
        imagedata = imagedata:getSpritePath().. "/palette"
    end
    local path
    if type(imagedata) == "string" then
        path = imagedata
        imagedata = Assets.getTextureData(path)
        if not imagedata then
            Kristal.Console:warn("Missing palette, expected to find at "..path)
        end
    end

    if type(imagedata) == "userdata" then
        ---@cast imagedata love.ImageData
        if imagedata:getHeight() > line then
            self.base_pal = {}
            
            self.live_pal = {}
            local r,g,b,a
            for x = 1, imagedata:getWidth() do
                r,g,b,a = imagedata:getPixel(x - 1, 0)
                table.insert(self.base_pal, {r,g,b,a})
                r,g,b,a = imagedata:getPixel(x - 1, line)
                table.insert(self.live_pal, {r,g,b,a})
            end
        else
            Kristal.Console:warn("Palette image "..(path and (path.." ") or "<unknown>") .. " doesn't have enough entries (expected at least "..line..", got "..(imagedata:getHeight()-1)..")")
        end
    else
        ---@cast imagedata -love.ImageData
        ---@cast imagedata -(string|Actor)
        ---@cast line -integer
        self.base_pal = imagedata
        self.live_pal = line
    end

    -- Pad end of palette tables
    if self.base_pal and self.live_pal then
        while #self.base_pal < self.MAX_PALETTE_ENTRIES do
            table.insert(self.base_pal, self.base_pal[1])
            table.insert(self.live_pal, self.live_pal[1])
        end
    end
end

function PaletteFX:isActive()
    return super.isActive(self) and self.base_pal and self.live_pal
end

function PaletteFX:draw(texture)
    local last_shader = love.graphics.getShader()
    love.graphics.setShader(self.shader)
	self.shader:send("base_palette", unpack(self.base_pal))
	self.shader:send("live_palette", unpack(self.live_pal))
    Draw.drawCanvas(texture)
    love.graphics.setShader(last_shader)
end

return PaletteFX