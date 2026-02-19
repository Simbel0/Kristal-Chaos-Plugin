local SwoonEffect, super = Class(ChaosEffect, "swoon_effect")

function SwoonEffect:init()
	super.init(self)
	self.duration = math.huge
end

function SwoonEffect:onEffectStart(in_battle)
	self.old_timescale = Game.battle.timescale
	Game.battle.timescale = 0
	self.timer = Timer()

	local battler = TableUtils.pick(Game.battle:getActiveParty())

	self.timer:script(function(wait)
		Game.battle.music:pause()
		local rect = Rectangle(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)
		rect:setColor(COLORS.black)
		rect:setLayer(9999)
		Game.stage:addChild(rect)
		local nikelogoofdoomanddespair = Sprite("roaringknight_slash", battler.x, battler.y)
		nikelogoofdoomanddespair:setOrigin(0.5)
		nikelogoofdoomanddespair:setScale(2)
		nikelogoofdoomanddespair:setLayer(9999+1)
		Game.stage:addChild(nikelogoofdoomanddespair)
		Assets.playSound("knight_cut", 4, 0.06)
	    Assets.playSound("knight_cut", 4, 0.1)
	    Assets.playSound("knight_cut", 4, 0.12)
	    Assets.playSound("knight_cut", 4, 0.18)
	    Assets.playSound("knight_cut", 4, 0.24)
	    
	    wait(2.5)

	    rect:remove()
	    nikelogoofdoomanddespair:remove()

	    battler:hurt(999, true, COLORS.red, {swoon=true})

	    Assets.stopSound("knight_cut")

	    Assets.playSound("impact")
	    Assets.playSound("closet_impact", 1, 1)
	    Assets.playSound("closet_impact", 1, 0.5)
	    Assets.playSound("bageldefeat", 0.8, 0.8)
	    Assets.playSound("damage")
	    Assets.playSound("glassbreak", 0.8, 0.4)
	    Assets.playSound("glassbreak", 0.6, 0.3)
	    
	    Game.stage:shake(10, 5)
	    battler:shake(10)

	    Game.battle.timescale = self.old_timescale
	    Game.battle.music:resume()
	    self:stopEffect()
	end)
end

function SwoonEffect:update()
	self.timer:update()
end

function SwoonEffect:canRunEffect()
	return Game.battle
end

return SwoonEffect